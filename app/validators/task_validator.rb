# frozen_string_literal: true

class TaskValidator < ApplicationValidator
  def initialize(contract: TaskContract)
    @contract = contract
  end
end
