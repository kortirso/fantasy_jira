# frozen_string_literal: true

class User < ApplicationRecord
  include ActiveModel::SecurePassword

  has_secure_password

  has_many :tasks_approvements, class_name: '::Tasks::Approvement', dependent: :destroy
end
