# frozen_string_literal: true

class TaskContract < ApplicationContract
  config.messages.namespace = :task

  schema do
    optional(:id)
    required(:name).filled(:string)
  end
end
