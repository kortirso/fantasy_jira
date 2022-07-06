# frozen_string_literal: true

module Tasks
  class UpdateService
    prepend ApplicationService

    def call(task:, params:)
      case params[:state]
      when Task::IN_PROGRESS then task.start!
      when Task::COMPLETED then task.complete!
      when Task::CANCELED then task.cancel!
      end
    rescue AASM::InvalidTransition
      fail!('Invalid state transition')
    end
  end
end
