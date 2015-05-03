module ActiveModel
  class TypeValidationTestClass
    include Validations

    # Creates and returns a new instance of TypeValidationTestClass with
    # a "long" style validator:
    #
    # class TypeValidationTestClass
    #   attr_accessor :attribute
    #
    #   validates_type :attribute, :string
    # end
    #
    # @set_accessor_and_long_validator
    #   param: type <Symbol> - type which to validate against
    #   param: options<Hash *Optional*> - extra modifiers/custom messaging
    #   return: TypeValidationTestClass instance with set validator
    def self.set_accessor_and_long_validator(type, options = {})
      self.new.tap do |test_class|
        test_class._validators = {}
        test_class.class_eval { attr_accessor :attribute }
        test_class.class_eval { validates_type :attribute, type.to_sym, options }
      end
    end

    # Creates and returns a new instance of TypeValidationTestClass with
    # a "short" style validator:
    #
    # class TypeValidationTestClass
    #   attr_accessor :attribute
    #
    #   validates :attribute, type: { type: :string }
    # end
    #
    # @set_accessor_and_long_validator
    #   param: type <Symbol> - type which to validate against
    #   param: options<Hash *Optional*> - extra modifiers/custom messaging
    #   return: TypeValidationTestClass instance with set validator
    def self.set_accessor_and_validator(type, options = {})
      self.new.tap do |test_class|
        test_class._validators = {}
        test_class.class_eval { attr_accessor :attribute }
        test_class.class_eval { validates :attribute, type: { type: type }.merge(options) }
      end
    end
  end
end
