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
      def initialize(options)
        merged_options = {
          message: "is expected to be a #{ symbol_class(options[:type]) } and is not."
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

        unless value_to_test.is_a?(expected_type)
          record.errors.add(attribute, options[:message])
        end
      end

      private

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
          array:   Array,
          boolean: Boolean,
          float:   Float,
          hash:    Hash,
          integer: Integer,
          string:  String,
          symbol:  Symbol,
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
      def validates_type(attribute_name, attribute_type, options = {})
        attributes = [attribute_name, { type: attribute_type }.merge(options)]
        validates_with TypeValidator, _merge_attributes(attributes)
      end
    end
  end
end
