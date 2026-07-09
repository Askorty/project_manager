class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project

  def create
    @task = @project.tasks.build(task_params)
    if @task.save
      redirect_to @project, notice: "Задача успешно добавлена!"
    else
      redirect_to @project, alert: "Ошибка: #{@task.errors.full_messages.join(', ')}"
    end
  end

  def update
    @task = @project.tasks.find(params[:id])

    if @task.update(task_params)
      redirect_to @project, notice: "Статус задачи обновлен."
    else
      redirect_to @project, alert: "Ошибка: #{@task.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    @task = @project.tasks.find(params[:id])
    @task.destroy
    redirect_to @project, notice: "Задача удалена."
  end

  private

  def set_project
    @project = current_user.projects.find(params[:project_id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status)
  end
end
