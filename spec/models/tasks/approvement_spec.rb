# frozen_string_literal: true

describe Tasks::Approvement, type: :model do
  it 'factory should be valid' do
    tasks_approvement = build :tasks_approvement

    expect(tasks_approvement).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:task) }
    it { is_expected.to belong_to(:user) }
  end
end
