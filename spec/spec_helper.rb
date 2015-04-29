require 'active_model'
require_relative '../lib/validates_type'

class TypeValidationTestClass
  include ActiveModel::Validations

  def self.set_accessor_and_validator(attribute, type)
    klass = self
    klass.class_eval { attr_accessor attribute.to_sym }
    klass.class_eval { validates_type attribute.to_sym, type.to_sym }
    klass.new
  end
end
