# frozen_string_literal: true

class Task < ApplicationRecord
  TODO = 'todo'
  IN_PROGRESS = 'in_progress'
  COMPLETED = 'completed'
  CANCELED = 'canceled'

  has_many :tasks_approvements, class_name: '::Tasks::Approvement', dependent: :destroy

  enum state: { TODO => 0, IN_PROGRESS => 1, COMPLETED => 2, CANCELED => 3 }
end
