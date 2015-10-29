require_relative '../spec_helper'

describe 'ValidatesType' do
  context 'supported types' do
    before do
      subject.attribute = value
    end

    describe 'String' do
      subject { ActiveModel::TypeValidationTestClass.set_accessor_and_long_validator(:string) }

      context 'field value is a String' do
        let(:value) { 'some string' }

        specify do
          expect(subject).to be_valid
        end
      end

      context 'field value is not a String' do
        let(:value) { -1 }
        specify do
          expect(subject).to_not be_valid
        end

        specify do
          subject.validate
          expect(subject.errors).to_not be_empty
          expect(subject.errors.messages[:attribute][0]).to match(/is expected to be a String and is not/)
        end
      end
    end

    describe 'Integer' do

      subject { ActiveModel::TypeValidationTestClass.set_accessor_and_long_validator(:integer) }

      context 'field value is an Integer' do
        let(:value) { 20 }

        specify do
          expect(subject).to be_valid
        end
      end

      context 'field value is not an Integer' do
        let(:value) { {} }

        specify do
          expect(subject).to_not be_valid
        end

        specify do
          subject.validate
          expect(subject.errors).to_not be_empty
          expect(subject.errors.messages[:attribute][0]).to match(/is expected to be a Integer and is not/)
        end
      end
    end

    describe 'Float' do

      subject { ActiveModel::TypeValidationTestClass.set_accessor_and_long_validator(:float) }

      context 'field value is a Float' do
        let(:value) { 1.2 }

        specify do
          expect(subject).to be_valid
        end
      end

      context 'field value is not a Float' do
        let(:value) { 10 }
        specify do
          expect(subject).to_not be_valid
        end

        specify do
          subject.validate
          expect(subject.errors).to_not be_empty
          expect(subject.errors.messages[:attribute][0]).to match(/is expected to be a Float and is not/)
        end
      end
    end

    describe 'Boolean' do

      subject { ActiveModel::TypeValidationTestClass.set_accessor_and_long_validator(:boolean) }

      context 'field value is a Boolean' do
        let(:value) { true }

        specify do
          expect(subject).to be_valid
        end
      end

      context 'field value is not a Boolean' do
        let(:value) { 'true' }
        specify do
          expect(subject).to_not be_valid
        end

        specify do
          subject.validate
          expect(subject.errors).to_not be_empty
          expect(subject.errors.messages[:attribute][0]).to match(/is expected to be a Boolean and is not/)
        end
      end
    end

    describe 'Hash' do

      subject { ActiveModel::TypeValidationTestClass.set_accessor_and_long_validator(:hash) }

      context 'field value is a Hash' do
        let(:value) { {} }

        specify do
          expect(subject).to be_valid
        end
      end

      context 'field value is not a Hash' do
        let(:value) { [] }
        specify do
          expect(subject).to_not be_valid
        end

        specify do
          subject.validate
          expect(subject.errors).to_not be_empty
          expect(subject.errors.messages[:attribute][0]).to match(/is expected to be a Hash and is not/)
        end
      end
    end

    describe 'Array' do

      subject { ActiveModel::TypeValidationTestClass.set_accessor_and_long_validator(:array) }

      context 'field value is an Array' do
        let(:value) { [] }

        specify do
          expect(subject).to be_valid
        end
      end

      context 'field value is not an Array' do
        let(:value) { true }
        specify do
          expect(subject).to_not be_valid
        end

        specify do
          subject.validate
          expect(subject.errors).to_not be_empty
          expect(subject.errors.messages[:attribute][0]).to match(/is expected to be a Array and is not/)
        end
      end
    end

    describe 'Symbol' do

      subject { ActiveModel::TypeValidationTestClass.set_accessor_and_long_validator(:symbol) }

      context 'field value is a Symbol' do
        let(:value) { :foo }

        specify do
          expect(subject).to be_valid
        end
      end

      context 'field value is not a Symbol' do
        let(:value) { [] }
        specify do
          expect(subject).to_not be_valid
        end

        specify do
          subject.validate
          expect(subject.errors).to_not be_empty
          expect(subject.errors.messages[:attribute][0]).to match(/is expected to be a Symbol and is not/)
        end
      end
    end

    describe 'Date' do

      subject { ActiveModel::TypeValidationTestClass.set_accessor_and_long_validator(:date) }

      context 'field value is a Date' do
        let(:value) { Date.new }

        specify do
          expect(subject).to be_valid
        end
      end

      context 'field value is not a Date' do
        let(:value) { :foo }
        specify do
          expect(subject).to_not be_valid
        end

        specify do
          subject.validate
          expect(subject.errors).to_not be_empty
          expect(subject.errors.messages[:attribute][0]).to match(/is expected to be a Date and is not/)
        end
      end
    end

    describe 'Time' do

      subject { ActiveModel::TypeValidationTestClass.set_accessor_and_long_validator(:time) }

      context 'field value is a Time' do
        let(:value) { Time.new }

        specify do
          expect(subject).to be_valid
        end
      end

      context 'field value is not a Time' do
        let(:value) { 123456 }
        specify do
          expect(subject).to_not be_valid
        end

        specify do
          subject.validate
          expect(subject.errors).to_not be_empty
          expect(subject.errors.messages[:attribute][0]).to match(/is expected to be a Time and is not/)
        end
      end
    end

    describe 'BigDecimal' do

      subject { ActiveModel::TypeValidationTestClass.set_accessor_and_long_validator(:big_decimal) }

      context 'field value is a BigDecimal' do
        let(:value) { BigDecimal.new(1) }

        specify do
          expect(subject).to be_valid
        end
      end

      context 'field value is not a BigDecimal' do
        let(:value) { 123456 }
        specify do
          expect(subject).to_not be_valid
        end

        specify do
          subject.validate
          expect(subject.errors).to_not be_empty
          expect(subject.errors.messages[:attribute][0]).to match(/is expected to be a BigDecimal and is not/)
        end
      end
    end

    context 'passing in a custom message' do
      subject { ActiveModel::TypeValidationTestClass.set_accessor_and_long_validator(:string, message: 'is not a String!') }

      context 'when validation fails' do
        let(:value) { 1 }

        specify do
          subject.validate
          expect(subject.errors.messages[:attribute][0]).to match(/is not a String!/)
        end
      end
    end
  end

  context 'unsupported types' do
    describe 'Foo' do
      specify do
        expect do
          subject = ActiveModel::TypeValidationTestClass.set_accessor_and_long_validator(:foo)
          subject.valid?
        end.to raise_error(
          ValidatesType::UnsupportedType,
          "Unsupported type Foo given for validates_type.")
      end
    end
  end

  context 'custom class' do
    class Custom; end
    subject { ActiveModel::TypeValidationTestClass.set_accessor_and_long_validator(Custom) }

    before do
      subject.attribute = value
    end

    context 'field value is of type Custom' do
      let(:value) { Custom.new }

      specify do
        expect(subject).to be_valid
      end
    end

    context 'field value is not of type Custom' do
      let(:value) { -1 }

      specify do
        expect(subject).to_not be_valid
      end

      specify do
        subject.validate
        expect(subject.errors).to_not be_empty
        expect(subject.errors.messages[:attribute][0]).to match(/is expected to be a Custom and is not/)
      end
    end
  end
end
