# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :find_tasks, if: :format_json?

  def index
    respond_to do |format|
      format.html
      format.json do
        render json: { tasks: @tasks }, status: :ok
      end
    end
  end

  private

  def find_tasks
    @tasks = Task.all
  end
end
