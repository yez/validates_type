require 'spec_helper'
require_relative '../lib/arguments'

describe ValidatesType::Arguments do

  let(:attribute_name) { :foo }
  let(:attribute_type) { :string }
  let(:options)        { { extra: :options } }

  subject { described_class.new(attribute_name, attribute_type, options) }

  describe '#to_validation_attributes' do
    context 'all pertinent attributes are present' do
      specify do
        expect(subject.to_validation_attributes).to eq([attribute_name, { type: attribute_type }.merge(options)])
      end
    end

    context 'attribute_type is nil' do
      let(:attribute_type) { nil }

      specify do
        expect(subject.to_validation_attributes).to eq([attribute_name, { type: attribute_type }.merge(options)])
      end
    end

    context 'attribute_name is nil' do
      let(:attribute_name) { nil }

      specify do
        expect(subject.to_validation_attributes).to eq([attribute_name, { type: attribute_type }.merge(options)])
      end
    end

    context 'options is nil' do
      let(:options) { nil }

      specify do
        expect(subject.to_validation_attributes).to eq([attribute_name, { type: attribute_type }])
      end
    end
  end

  describe '#type' do
    context 'type is given' do
      specify do
        expect(subject.send(:type)).to eq({ type: attribute_type })
      end
    end

    context 'type is nil' do
      let(:attribute_type) { nil }

      specify do
        expect(subject.send(:type)).to eq({ type: nil })
      end
    end
  end

  describe '#merged_options' do
    context 'options are present' do
      specify do
        expect(subject.send(:merged_options)).to eq({ type: attribute_type }.merge(options))
      end
    end

    context 'options is nil' do
      let(:options) { nil }

      specify do
        expect(subject.send(:merged_options)).to eq({ type: attribute_type })
      end
    end

    context 'options is a blank hash' do
      let(:options) { {} }

      specify do
        expect(subject.send(:merged_options)).to eq({ type: attribute_type })
      end
    end
  end
end
