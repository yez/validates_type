require 'ruby-boolean'
require 'active_model'

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
        merged_options = {
          :message => "is expected to be a #{ symbol_class(options[:type]) } and is not."
        }.merge(options)

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
        expected_type = symbol_class(options[:type])

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

        record.errors.add(attribute, options[:message])
      end

      # Helper method to return the base expected error:
      # ActiveModel::StrictValidationFailed, a custom error, or nil
      #
      # @options_error
      #   param: strict_error <true or subclass of Exception> - either the flag
      #           to raise an error or the actual error to raise
      #   return: custom error, ActiveModel::StrictValidationFailed, or nil
      def options_error(strict_error)
        if strict_error == true
          ActiveModel::StrictValidationFailed
        elsif strict_error.try(:ancestors).try(:include?, Exception)
          strict_error
        end
      end

      # Helper method to convert a symbol into a class constant
      #
      # ex:
      #  symbol_class(:string)  -> String
      #  symbol_class(:boolean) -> Boolean
      #  symbol_class(:hash)    -> Hash
      #
      # @symbol_class
      #   param: symbol <Symbol> - symbol to turn into a classconstant
      #   return: class constant of supported types or raises UnsupportedType
      def symbol_class(symbol)
        @symbol_class ||= {
          :array   => Array,
          :boolean => Boolean,
          :float   => Float,
          :hash    => Hash,
          :integer => Integer,
          :string  => String,
          :symbol  => Symbol,
        }[symbol] || fail(UnsupportedType,
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
        record.try(:"#{ attribute }_before_type_cast") || value
      end
    end

    # Error class to raise if unsupported value given to validates_url
    class UnsupportedType < StandardError; end

    module ClassMethods
      # Validates the type of an attribute with supported types:
      #   - :array
      #   - :boolean
      #   - :float
      #   - :hash
      #   - :integer
      #   - :string
      #   - :symbol
      #
      # class Foo
      #   include ActiveModel::Validations
      #
      #   attr_accessor :thing, :something
      #
      #   validates_type :thing, :boolean
      #   validates_type :something, :array
      # end
      #
      # @validates_type
      #   param: attribute_name <Symbol> - name of attribute to validate
      #   param: attribute_type <Symbol> - type of attribute to validate against
      #   param: options <Hash>          - other common options to validate methods calls
      #                                    i.e. message: 'my custom error message'
      #   return: nil
      def validates_type(attribute_name, attribute_type, options = {})
        attributes = [attribute_name, { :type => attribute_type }.merge(options)]
        validates_with TypeValidator, _merge_attributes(attributes)
      end
    end
  end
end
