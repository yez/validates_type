require 'ruby-boolean'
require 'active_model'
require 'active_support/i18n'

I18n.load_path << File.dirname(__FILE__) + '/../locale/en.yml'

require_relative '../errors/unsupported_type'
require_relative './arguments'

module ActiveModel
  module Validations
    class TypeValidator < ActiveModel::EachValidator
      # Set default message for failure here
      #
      # @initialize
      #   param: options <Hash> - options hash of how to validate this attribute
      #                           including custom messaging due to failures, specifying
      #                           the type of the attribute to validate against, etc.
      #   return: result of ActiveModel::Validations::EachValidator initialize
      def initialize(options)
        merged_options = { message: :type }.merge(options)

        super(merged_options)
      end

      # Validate that the value is the type we expect
      #
      # @validate_each
      #   param: record <Object>    - subject containing attribute to validate
      #   param: attribute <Symbol> - name of attribute to validate
      #   param: value <Variable>   - value of attribute to validate
      #   return: nil
      def validate_each(record, attribute, value)
        value_to_test = type_before_coercion(record, attribute, value)
        expected_type = type_class(options[:type])

        add_errors_or_raise(options, record, attribute) unless value_to_test.is_a?(expected_type)
      end

      private

      # Helper method to either add messages to the errors object
      # or raise an exception in :strict mode
      #
      # @add_errors_or_raise
      #   param: options <Hash>     - options hash with strict flag or class
      #   param: record <Object>    - subject containg attribute to validate
      #   param: attribute <Symbol> - name of attribute under validation
      #   return: nil
      def add_errors_or_raise(options, record, attribute)
        error = options_error(options[:strict])

        raise error unless error.nil?

        record.errors.add(attribute, :type, { type: type_class(options[:type]) }.merge(message: options[:message]))
      end

      # Helper method to return the base expected error:
      # ActiveModel::StrictValidationFailed, a custom error, or nil
      #
      # @options_error
      #   param: strict_error <true or subclass of Exception> - either the flag
      #           to raise an error or the actual error to raise
      #   return: custom error, ActiveModel::StrictValidationFailed, or nil
      def options_error(strict_error)
        return if strict_error.nil?

        if strict_error == true
          ActiveModel::StrictValidationFailed
        elsif strict_error.ancestors.include?(Exception)
          strict_error
        end
      end

      # Helper method to get back a class constant from the given type option
      # If the type option is a class, it will be returned as is.
      # If it is not a class, the method will try to convert it to a class constant.
      #
      # ex:
      #   type_class(:string) -> String
      #   type_class(String)  -> String
      #   type_class(Custom)  -> Custom
      # @type_class
      #   param: type <Class, Symbol>
      #   return: <Class> class constant
      def type_class(type)
        @type_class ||= type.is_a?(Class) ? type : symbol_class(type)
      end

      # Helper method to convert a symbol into a class constant
      #
      # ex:
      #  symbol_class(:string)  -> String
      #  symbol_class(:boolean) -> Boolean
      #  symbol_class(:hash)    -> Hash
      #
      # @symbol_class
      #   param: symbol <Symbol> - symbol to turn into a class constant
      #   return: class constant of supported types or raises UnsupportedType
      def symbol_class(symbol)
        {
          array: Array,
          boolean: Boolean,
          float: Float,
          hash: Hash,
          integer: Integer,
          string: String,
          symbol: Symbol,
          time: Time,
          date: Date,
          big_decimal: BigDecimal,
        }[symbol] || fail(ValidatesType::UnsupportedType,
                          "Unsupported type #{ symbol.to_s.camelize } given for validates_type.")
      end

      # Helper method to circumvent active record's coercion
      #
      # @type_before_coercion
      #   param: record <Object> - subject of validation
      #   param: value <Variable> - current value of attribute
      #   return: the value of the attribute before active record's coercion
      #           or the current value
      def type_before_coercion(record, attribute, value)
        attribute_before_type_cast = "#{attribute}_before_type_cast"
        record.respond_to?(attribute_before_type_cast) ? record.public_send(attribute_before_type_cast) : value
      end
    end

    module ClassMethods
      # Validates the type of an attribute with supported types:
      #   - :array
      #   - :boolean
      #   - :float
      #   - :hash
      #   - :integer
      #   - :string
      #   - :symbol
      #   - :time
      #   - :date
      #   - :big_decimal
      #
      # Also validates the type of an attribute given a custom type class constant.
      #
      # class Foo
      #   include ActiveModel::Validations
      #
      #   attr_accessor :thing, :something, :custom_thing
      #
      #   validates_type :thing, :boolean
      #   validates_type :something, :array
      #   validates_type :custom_thing, Custom
      # end
      #
      # @validates_type
      #   param: attribute_name <Symbol> - name of attribute to validate
      #   param: attribute_type <Symbol, Class> - type of attribute to validate against
      #   param: options <Hash> - other common options to validate methods calls
      #                           i.e. message: 'my custom error message'
      #   return: nil
      def validates_type(attribute_name, attribute_type, options = {})
        args = ValidatesType::Arguments.new(attribute_name, attribute_type, options)
        validates_with TypeValidator, _merge_attributes(args.to_validation_attributes)
      end
    end
  end
end
