# frozen_string_literal: true

describe Tasks::CreateService, type: :service do
  subject(:service_call) { described_class.call(params: params) }

  context 'for invalid params' do
    let(:params) { { name: '' } }

    it 'does not create Task' do
      expect { service_call }.not_to change(Task, :count)
    end

    it 'fails' do
      service = service_call

      expect(service.failure?).to be_truthy
    end
  end

  context 'for valid params' do
    let(:params) { { name: 'task' } }

    it 'creates Task' do
      expect { service_call }.to change(Task, :count).by(1)
    end

    it 'succeed' do
      service = service_call

      expect(service.success?).to be_truthy
    end
  end
end
