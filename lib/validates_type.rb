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

      rescue NameError
        raise UnsupportedType, "Unsupported type #{ options[:type].to_s.camelize } given for validates_type."
      end

      private

      def symbol_class(symbol)
        @symbol_class ||= symbol.to_s.camelize.constantize
      end
    end

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
