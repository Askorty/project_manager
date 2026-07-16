# typed: true

class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_task, only: [ :update, :destroy ]

  def create
    @task = @project.tasks.build(task_params)
    if @task.save
      redirect_to @project, notice: "Задача успешно добавлена!"
    else
      redirect_to @project, alert: "Ошибка: #{@task.errors.full_messages.join(', ')}"
    end
  end

  def update
    @task.assign_attributes(task_params.except(:status))

    new_status = task_params[:status]
    status_valid = true

    if new_status.present? && @task.status != new_status
      status_valid = TaskStatusService.new(@task, new_status).call
    end

    if status_valid && @task.save
      redirect_to @project, notice: "Задача обновлена."
    else
      redirect_to @project, alert: "Ошибка: #{@task.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    @task.destroy
    redirect_to @project, notice: "Задача удалена."
  end

  private

  def set_project
    @project = T.must(current_user).projects.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status)
  end
end
