# frozen_string_literal: true

describe Task, type: :model do
  it 'factory should be valid' do
    task = build :task

    expect(task).to be_valid
  end

  describe 'associations' do
    it { is_expected.to have_many(:tasks_approvements).class_name('::Tasks::Approvement').dependent(:destroy) }
  end
end
