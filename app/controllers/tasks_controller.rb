# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :find_tasks, only: %i[index], if: :format_json?

  def index
    respond_to do |format|
      format.html
      format.json do
        render json: { tasks: TaskSerializer.new(@tasks).serializable_hash }, status: :ok
      end
    end
  end

  def create
    service_call = Tasks::CreateService.call(
      params: task_params
    )
    if service_call.success?
      render json: { task: TaskSerializer.new(service_call.result).serializable_hash }, status: :ok
    else
      render json: { errors: service_call.errors }, status: :unprocessable_entity
    end
  end

  private

  def find_tasks
    @tasks = Task.order(created_at: :asc)
  end

  def task_params
    params.require(:task).permit(:name)
  end
end
