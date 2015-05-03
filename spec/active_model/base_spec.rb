require_relative '../spec_helper'

describe 'ValidatesType' do
  context 'validates_type :attribute' do
    subject { ActiveModel::TypeValidationTestClass.set_accessor_and_long_validator(:string) }

    it 'adds a validator to the subject' do
      klass = subject.class
      expect(klass.validators).to_not be_empty
      expect(klass.validators).to include(ActiveModel::Validations::TypeValidator)
    end

    it 'adds the correct validator to the subject' do
      validator = subject.class.validators.find { |v| v.is_a?(ActiveModel::Validations::TypeValidator) }
      expect(validator.options[:type]).to eq(:string)
    end
  end

  context 'validates :attribute, type: { type: type }.merge(other_options)' do
    subject { ActiveModel::TypeValidationTestClass.set_accessor_and_validator(:string) }

    it 'adds a validator to the subject' do
      klass = subject.class
      expect(klass.validators).to_not be_empty
      expect(klass.validators).to include(ActiveModel::Validations::TypeValidator)
    end

    it 'adds the correct validator to the subject' do
      validator = subject.class.validators.find { |v| v.is_a?(ActiveModel::Validations::TypeValidator) }
      expect(validator.options[:type]).to eq(:string)
    end
  end
end
