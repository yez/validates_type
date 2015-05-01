ActiveRecord::Base.establish_connection(
    "adapter"   => "sqlite3",
    "database"  => ":memory:"
)

ActiveRecord::Schema.define do
  create_table :type_validation_tests do |t|
    t.string :test_attribute
  end
end

class TypeValidationTest < ActiveRecord::Base
  def self.set_accessor_and_validator(type, options = {})
    self.new.tap do |test_class|
      test_class._validators = {}
      test_class.class_eval { attr_accessor :test_attribute }
      test_class.class_eval { validates_type :test_attribute, type.to_sym, options }
    end
  end
end
