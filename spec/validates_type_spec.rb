require_relative './spec_helper'

describe 'ValidatesType' do

  describe 'String' do
    subject { TypeValidationTestClass.set_accessor_and_validator(value, :string) }

    context 'field value is a String' do
      specify do
        expect(subject).to be_valid
      end
    end

    context 'field value is not a String' do
      specify do
        expect(subject).to_not be_valid
      end
    end
  end

  describe 'Integer' do
    context 'field value is an Integer' do
      specify do
        expect(subject).to be_valid
      end
    end

    context 'field value is not an Integer' do
      specify do
        expect(subject).to_not be_valid
      end
    end
  end

  describe 'Float' do
    context 'field value is a Float' do
      specify do
        expect(subject).to be_valid
      end
    end

    context 'field value is not a Float' do
      specify do
        expect(subject).to_not be_valid
      end
    end
  end

  describe 'Boolean' do
    context 'field value is a Boolean' do
      specify do
        expect(subject).to be_valid
      end
    end

    context 'field value is not a Boolean' do
      specify do
        expect(subject).to_not be_valid
      end
    end
  end

  describe 'Hash' do
    context 'field value is a Hash' do
      specify do
        expect(subject).to be_valid
      end
    end

    context 'field value is not a Hash' do
      specify do
        expect(subject).to_not be_valid
      end
    end
  end

  describe 'Array' do
    context 'field value is an Array' do
      specify do
        expect(subject).to be_valid
      end
    end

    context 'field value is not an Array' do
      specify do
        expect(subject).to_not be_valid
      end
    end
  end

  describe 'Symbol' do
    context 'field value is a Symbol' do
      specify do
        expect(subject).to be_valid
      end
    end

    context 'field value is not a Symbol' do
      specify do
        expect(subject).to_not be_valid
      end
    end
  end
end
