require_relative '../spec_helper'

describe 'ValidatesType' do
  context 'supported types' do
    before do
      subject.test_attribute = value
    end

    describe 'Array' do
      drop_and_create_column_with_type(:string)

      subject { TypeValidationTest.set_accessor_and_long_validator(:array) }

      context 'field value is an Array' do
        let(:value) { [] }

        specify do
          expect(subject).to be_valid
        end
      end

      context 'field value is not an Array' do
        let(:value) { -1 }

        specify do
          expect(subject).to_not be_valid
        end

        specify do
          subject.validate
          expect(subject.errors).to_not be_empty
          expect(subject.errors.messages[:test_attribute][0]).to match(/is expected to be a Array and is not/)
        end
      end

      context 'passing in a custom message' do
        subject { TypeValidationTest.set_accessor_and_long_validator(:array, message: 'is not an Array!') }

        context 'when validation fails' do
          let(:value) { 1 }

          specify do
            subject.validate
            expect(subject.errors.messages[:test_attribute][0]).to match(/is not an Array!/)
          end
        end
      end
    end

    describe 'Boolean' do
      drop_and_create_column_with_type(:boolean)

      subject { TypeValidationTest.set_accessor_and_long_validator(:boolean) }

      context 'field value is a Boolean' do
        let(:value) { true }

        specify do
          expect(subject).to be_valid
        end
      end

      context 'field value is not a Boolean' do
        let(:value) { 'false' }

        specify do
          expect(subject).to_not be_valid
        end

        specify do
          subject.validate
          expect(subject.errors).to_not be_empty
          expect(subject.errors.messages[:test_attribute][0]).to match(/is expected to be a Boolean and is not/)
        end
      end

      context 'passing in a custom message' do
        subject { TypeValidationTest.set_accessor_and_long_validator(:boolean, message: 'is not a Boolean!') }

        context 'when validation fails' do
          let(:value) { 1 }

          specify do
            subject.validate
            expect(subject.errors.messages[:test_attribute][0]).to match(/is not a Boolean!/)
          end
        end
      end
    end

    describe 'Float' do
      drop_and_create_column_with_type(:float)

      subject { TypeValidationTest.set_accessor_and_long_validator(:float) }

      context 'field value is a Float' do
        let(:value) { 1.0 }

        specify do
          expect(subject).to be_valid
        end
      end

      context 'field value is not a Float' do
        let(:value) { 'banana' }

        specify do
          expect(subject).to_not be_valid
        end

        specify do
          subject.validate
          expect(subject.errors).to_not be_empty
          expect(subject.errors.messages[:test_attribute][0]).to match(/is expected to be a Float and is not/)
        end
      end

      context 'passing in a custom message' do
        subject { TypeValidationTest.set_accessor_and_long_validator(:float, message: 'is not a Float!') }

        context 'when validation fails' do
          let(:value) { 1 }

          specify do
            subject.validate
            expect(subject.errors.messages[:test_attribute][0]).to match(/is not a Float!/)
          end
        end
      end
    end

    describe 'Hash' do
      drop_and_create_column_with_type(:string)

      subject { TypeValidationTest.set_accessor_and_long_validator(:hash) }

      context 'field value is a Hash' do
        let(:value) { { :this => :here } }

        specify do
          expect(subject).to be_valid
        end
      end

      context 'field value is not a Hash' do
        let(:value) { 'banana' }

        specify do
          expect(subject).to_not be_valid
        end

        specify do
          subject.validate
          expect(subject.errors).to_not be_empty
          expect(subject.errors.messages[:test_attribute][0]).to match(/is expected to be a Hash and is not/)
        end
      end

      context 'passing in a custom message' do
        subject { TypeValidationTest.set_accessor_and_long_validator(:hash, message: 'is not a Hash!') }

        context 'when validation fails' do
          let(:value) { [] }

          specify do
            subject.validate
            expect(subject.errors.messages[:test_attribute][0]).to match(/is not a Hash!/)
          end
        end
      end
    end

    describe 'Integer' do
      drop_and_create_column_with_type(:integer)

      subject { TypeValidationTest.set_accessor_and_long_validator(:integer) }

      context 'field value is a Integer' do
        let(:value) { 1 }

        specify do
          expect(subject).to be_valid
        end
      end

      context 'field value is not a Integer' do
        let(:value) { 'banana' }

        specify do
          expect(subject).to_not be_valid
        end

        specify do
          subject.validate
          expect(subject.errors).to_not be_empty
          expect(subject.errors.messages[:test_attribute][0]).to match(/is expected to be a Integer and is not/)
        end
      end

      context 'passing in a custom message' do
        subject { TypeValidationTest.set_accessor_and_long_validator(:integer, message: 'is not a Integer!') }

        context 'when validation fails' do
          let(:value) { [] }

          specify do
            subject.validate
            expect(subject.errors.messages[:test_attribute][0]).to match(/is not a Integer!/)
          end
        end
      end
    end

    describe 'String' do
      drop_and_create_column_with_type(:string)

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

    describe 'Symbol' do
      drop_and_create_column_with_type(:string)

      subject { TypeValidationTest.set_accessor_and_long_validator(:symbol) }

      context 'field value is a Symbol' do
        let(:value) { :something }

        specify do
          expect(subject).to be_valid
        end
      end

      context 'field value is not a Symbol' do
        let(:value) { -1 }
        specify do
          expect(subject).to_not be_valid
        end

        specify do
          subject.validate
          expect(subject.errors).to_not be_empty
          expect(subject.errors.messages[:test_attribute][0]).to match(/is expected to be a Symbol and is not/)
        end
      end

      context 'passing in a custom message' do
        subject { TypeValidationTest.set_accessor_and_long_validator(:symbol, message: 'is not a Symbol!') }

        context 'when validation fails' do
          let(:value) { 1 }

          specify do
            subject.validate
            expect(subject.errors.messages[:test_attribute][0]).to match(/is not a Symbol!/)
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
          ValidatesType::UnsupportedType,
          "Unsupported type Foo given for validates_type.")
      end
    end
  end
end
