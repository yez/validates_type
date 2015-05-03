require_relative '../spec_helper'

describe 'ValidatesType' do
  %i[set_accessor_and_long_validator
     set_accessor_and_validator].each do |validate_version|
    context "#{ validate_version }" do
      context 'custom modifiers' do
        before do
          subject.attribute = value
        end

        describe 'message' do
          subject do
            ActiveModel::TypeValidationTestClass.send(validate_version,
              :string, message: 'is not a String!')
          end

          context 'when validation fails' do
            let(:value) { 1 }

            specify do
              subject.validate
              expect(subject.errors.messages[:attribute][0]).to match(/is not a String!/)
            end
          end
        end

        describe 'allow_nil' do
          subject do
            ActiveModel::TypeValidationTestClass.send(validate_version,
              :string, allow_nil: true)
          end

          context 'field value is nil' do
            let(:value) { nil }

            specify do
              expect(subject).to be_valid
            end
          end

          context 'field value is not nil' do
            context 'field value is the specified type' do
              let(:value) { 'I am a string'}

              specify do
                expect(subject).to be_valid
              end
            end

            context 'field value is not specified type' do
              let(:value) { -1 }

              specify do
                expect(subject).to_not be_valid
              end
            end
          end
        end

        describe 'allow_blank' do
           subject do
            ActiveModel::TypeValidationTestClass.send(validate_version,
              :integer, allow_blank: true)
            end

          context 'field value is nil' do
            let(:value) { nil }

            specify do
              expect(subject).to be_valid
            end
          end

          context 'field value is an empty string' do
            let(:value) { '' }

            specify do
              expect(subject).to be_valid
            end
          end

          context 'field value is not nil' do
            context 'field value is the specified type' do
              let(:value) { 1 }

              specify do
                expect(subject).to be_valid
              end
            end

            context 'field value is not specified type' do
              let(:value) { { foo: :bar } }

              specify do
                expect(subject).to_not be_valid
              end
            end
          end
        end

        describe 'strict' do
          subject do
            ActiveModel::TypeValidationTestClass.send(validate_version,
              :string, strict: true)
          end

          context 'field value is expected type' do
            let(:value) { 'I am a string' }

            specify do
              expect do
                subject.valid?
              end.to_not raise_error
            end
          end

          context 'field value is not expected type' do
            let(:value) { -1 }

            specify do
              expect do
                subject.valid?
              end.to raise_error(ActiveModel::StrictValidationFailed)
            end

            context 'with a custom error class' do
              class UhOhSpaghettios < StandardError; end
              subject do
                ActiveModel::TypeValidationTestClass.send(validate_version,
                  :string, strict: UhOhSpaghettios)
              end

              specify do
                expect do
                  subject.valid?
                end.to raise_error(UhOhSpaghettios)
              end
            end
          end
        end

        describe 'if' do
          subject do
            ActiveModel::TypeValidationTestClass.send(validate_version,
              :string, if: condition)
          end

          context 'field value is expected type' do
            let(:value) { 'I am a string' }

            context 'condition is true' do
              let(:condition) { ->{ true } }

              specify do
                expect(subject).to be_valid
              end
            end

            context 'condition is false' do
              let(:condition) { ->{ false } }

              specify do
                expect(subject).to be_valid
              end
            end
          end

          context 'field value is not expected type' do
            let(:value) { -1 }

            context 'condition is true' do
              let(:condition) { ->{ true } }

              specify do
                expect(subject).to_not be_valid
              end
            end

            context 'condition is false' do
              let(:condition) { ->{ false } }

              specify do
                expect(subject).to be_valid
              end
            end
          end
        end

        describe 'unless' do
          subject do
            ActiveModel::TypeValidationTestClass.send(validate_version,
              :string, unless: condition)
          end

          context 'field value is expected type' do
            let(:value) { 'I am a string' }

            context 'condition is true' do
              let(:condition) { ->{ true } }

              specify do
                expect(subject).to be_valid
              end
            end

            context 'condition is false' do
              let(:condition) { ->{ false } }

              specify do
                expect(subject).to be_valid
              end
            end
          end

          context 'field value is not expected type' do
            let(:value) { -1 }

            context 'condition is true' do
              let(:condition) { ->{ true } }

              specify do
                expect(subject).to be_valid
              end
            end

            context 'condition is false' do
              let(:condition) { ->{ false } }

              specify do
                expect(subject).to_not be_valid
              end
            end
          end
        end

        describe 'on' do
          let(:value) { nil }
          subject do
            ActiveModel::TypeValidationTestClass.send(validate_version,
              :string, on: :some_test_method)
          end

          before do
            allow(subject).to receive(:some_test_method) { subject.validate }
          end

          context 'on: criteria is met' do
            specify do
              expect(subject).to receive(:validate)
              subject.some_test_method
            end
          end

          context 'on: criteria is not met' do
            specify do
              expect(subject).to_not receive(:validate)
              subject.valid?
            end
          end
        end
      end
    end
  end
end
