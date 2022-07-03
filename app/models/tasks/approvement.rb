# frozen_string_literal: true

module Tasks
  class Approvement < ApplicationRecord
    self.table_name = :tasks_approvements

    belongs_to :task
    belongs_to :user
  end
end
