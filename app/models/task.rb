# frozen_string_literal: true

class Task < ApplicationRecord
  has_many :tasks_approvements, class_name: '::Tasks::Approvement', dependent: :destroy
end
