require 'ruby-boolean'
require 'active_model'

module ActiveModel
  module Validations
    class TypeValidator < ActiveModel::EachValidator

      def initialize(options)
        super(options)
      end

      def validate_each(record, attribute, value)
        super
      end
    end

    module ClassMethods
      def validates_type(*attr_names)
        validates_with TypeValidator, _merge_attributes(attr_names)
      end
    end
  end
end
