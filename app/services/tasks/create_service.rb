# frozen_string_literal: true

module Tasks
  class CreateService
    prepend ApplicationService

    def initialize(
      task_validator: TaskValidator
    )
      @task_validator = task_validator
    end

    def call(params:)
      @result = Task.new(params)

      validate_params(params)
      return if failure?

      @result.save
    end

    private

    def validate_params(params)
      fails!(@task_validator.call(params: params))
    end
  end
end
