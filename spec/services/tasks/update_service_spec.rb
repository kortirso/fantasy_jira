# frozen_string_literal: true

describe Tasks::UpdateService, type: :service do
  subject(:service_call) { described_class.call(task: task, params: params) }

  context 'for start transition' do
    let!(:task) { create :task, state: Task::TODO }
    let(:params) { { state: Task::IN_PROGRESS } }

    it 'updates task' do
      service_call

      expect(task.reload.state).to eq Task::IN_PROGRESS
    end

    it 'succeed' do
      service = service_call

      expect(service.success?).to be_truthy
    end
  end

  context 'for complete transition' do
    let!(:task) { create :task, state: Task::IN_PROGRESS }
    let(:params) { { state: Task::COMPLETED } }

    context 'for not enough approvements' do
      it 'does not update task' do
        service_call

        expect(task.reload.state).to eq Task::IN_PROGRESS
      end

      it 'fails' do
        service = service_call

        expect(service.failure?).to be_truthy
      end
    end

    context 'for valid amount approvements' do
      before do
        create_list :tasks_approvement, 2, task: task
      end

      it 'updates task' do
        service_call

        expect(task.reload.state).to eq Task::COMPLETED
      end

      it 'succeed' do
        service = service_call

        expect(service.success?).to be_truthy
      end
    end
  end
end
