require 'ruby-boolean'
require 'active_model'

module ActiveModel
  module Validations
    class TypeValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        klass = symbol_class(options[:type])
        unless value.is_a?(klass)
          record.errors.add(attribute, "is expected to be a #{ klass } and is not.")
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
      #   param: symbol <Symbol> - symbole to turn into a classconstant
      #   return: class constant of supported types or raises UnsupportedType
      def symbol_class(symbol)
        @symbol_class ||= {
          array: Array,
          boolean: Boolean,
          float: Float,
          hash: Hash,
          integer: Integer,
          string: String,
          symbol: Symbol
        }[symbol] || fail(UnsupportedType,
                          "Unsupported type #{ options[:type].to_s.camelize } given for validates_type.")
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
      def validates_type(attribute_name, attribute_type)
        validates_with TypeValidator, { attributes: [attribute_name], type: attribute_type }
      end
    end
  end
end
