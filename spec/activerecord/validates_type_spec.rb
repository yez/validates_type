require_relative '../spec_helper'

describe 'ValidatesType' do
  context 'supported types' do
    before do
      subject.test_attribute = value
    end

    context 'validates_type :attribute, :type' do
      describe 'String' do

        subject { TypeValidationTest.set_accessor_and_long_validator(:string) }

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
            expect(subject.errors.messages[:test_attribute][0]).to match(/is expected to be a String and is not/)
          end
        end
      end

      context 'passing in a custom message' do
        subject { TypeValidationTest.set_accessor_and_long_validator(:string, message: 'is not a String!') }

        context 'when validation fails' do
          let(:value) { 1 }

          specify do
            subject.validate
            expect(subject.errors.messages[:test_attribute][0]).to match(/is not a String!/)
          end
        end
      end
    end

    context 'validates :attribute, type: { type: type }.merge(other_options)' do
      describe 'String' do

        subject { TypeValidationTest.set_accessor_and_validator(:string) }

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
            expect(subject.errors.messages[:test_attribute][0]).to match(/is expected to be a String and is not/)
          end
        end
      end

      context 'passing in a custom message' do
        subject { TypeValidationTest.set_accessor_and_validator(:string, message: 'is not a String!') }

        context 'when validation fails' do
          let(:value) { 1 }

          specify do
            subject.validate
            expect(subject.errors.messages[:test_attribute][0]).to match(/is not a String!/)
          end
        end
      end
    end
  end

  context 'unsupported types' do
    describe 'Foo' do
      specify do
        expect do
          subject = TypeValidationTest.set_accessor_and_long_validator(:foo)
          subject.valid?
        end.to raise_error(
          ActiveModel::Validations::UnsupportedType,
          "Unsupported type Foo given for validates_type.")
      end
    end
  end
end
