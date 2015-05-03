module ActiveModel
  class TypeValidationTestClass
    include Validations

    # used for testing on: clause for validations
    def some_test_method
      validate
    end

    def self.set_accessor_and_long_validator(type, options = {})
      self.new.tap do |test_class|
        test_class._validators = {}
        test_class.class_eval { attr_accessor :attribute }
        test_class.class_eval { validates_type :attribute, type.to_sym, options }
      end
    end

    def self.set_accessor_and_validator(type, options = {})
      self.new.tap do |test_class|
        test_class._validators = {}
        test_class.class_eval { attr_accessor :attribute }
        test_class.class_eval { validates :attribute, type: { type: type }.merge(options) }
      end
    end
  end
end
