# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :find_tasks, only: %i[index], if: :format_json?
  before_action :find_task, only: %i[update]

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

  def update
    service_call = Tasks::UpdateService.call(
      task:   @task,
      params: task_update_params
    )
    render json: {
      task:   TaskSerializer.new(@task.reload).serializable_hash,
      errors: service_call.errors
    }, status: :ok
  end

  private

  def find_tasks
    @tasks = Task.order(created_at: :asc)
  end

  def find_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name)
  end

  def task_update_params
    params.require(:task).permit(:state)
  end
end
