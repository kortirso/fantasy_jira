# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    sequence(:name) { |i| "name#{i}" }
  end
end
