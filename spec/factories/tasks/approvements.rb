# frozen_string_literal: true

FactoryBot.define do
  factory :tasks_approvement, class: 'Tasks::Approvement' do
    association :task
    association :user
  end
end
