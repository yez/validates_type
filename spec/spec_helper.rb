require 'active_model'
require 'pry'
require_relative '../lib/validates_type'

class TypeValidationTestClass
  include ActiveModel::Validations

  def self.set_accessor_and_validator(type)
    self.new.tap do |test_class|
      test_class._validators = {}
      test_class.class_eval { attr_accessor :attribute }
      test_class.class_eval { validates_type :attribute, type.to_sym }
    end
  end
end
