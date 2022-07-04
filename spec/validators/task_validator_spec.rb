# frozen_string_literal: true

describe TaskValidator, type: :service do
  subject(:validator_call) { described_class.call(params: params) }

  context 'for invalid name format' do
    let(:params) { { name: '' } }

    it 'result contains error' do
      expect(validator_call.first).to eq('Name must be filled')
    end
  end

  context 'for valid params' do
    let(:params) { { name: 'task' } }

    it 'result does not contain errors' do
      expect(validator_call.size.zero?).to be_truthy
    end
  end
end
