# frozen_string_literal: true

module Tasks
  class ApprovementsController < ApplicationController
    before_action :find_task, only: %i[create]

    def index
      tasks_approvements = Tasks::Approvement.group(:task_id).count
      render json: tasks_approvements, status: :ok
    end

    def create
      Tasks::Approvement.create_or_find_by(task: @task, user: current_user)
      render json: { @task.id => @task.tasks_approvements.size }, status: :ok
    end

    private

    def find_task
      @task = Task.find(params[:task_id])
    end
  end
end
