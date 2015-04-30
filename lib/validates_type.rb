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

      def symbol_class(symbol)
        @symbol_class ||= symbol.to_s.camelize.constantize
      end
    end

    module ClassMethods
      def validates_type(attribute_name, attribute_type)
        validates_with TypeValidator, { attributes: [attribute_name], type: attribute_type }
      end
    end
  end
end
