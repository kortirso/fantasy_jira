# frozen_string_literal: true

class Task < ApplicationRecord
  include AASM

  TODO = 'todo'
  IN_PROGRESS = 'in_progress'
  COMPLETED = 'completed'
  CANCELED = 'canceled'

  APPROVEMENTS_LIMIT = 2

  has_many :tasks_approvements, class_name: '::Tasks::Approvement', dependent: :destroy

  aasm column: 'state', enum: true, timestamps: true do
    state :todo, initial: true
    state :in_progress
    state :completed
    state :canceled

    event :start do
      transitions from: [:todo], to: :in_progress
    end

    event :complete do
      transitions from: [:in_progress], to: :completed, guard: :approved?
    end

    event :cancel do
      transitions from: [:in_progress], to: :canceled
    end
  end

  enum state: { TODO => 0, IN_PROGRESS => 1, COMPLETED => 2, CANCELED => 3 }

  def approved?
    tasks_approvements.size >= APPROVEMENTS_LIMIT
  end
end
