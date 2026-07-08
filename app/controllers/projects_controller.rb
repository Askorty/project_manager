class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [ :show, :edit, :update, :destroy ]
  def index
    @projects = current_user.projects
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.user_id = current_user.id
    if @project.save
      redirect_to @project
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
    # Метод пуст, так как Ruby on Rails автоматически отрендерит edit.html.erb
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: "Проект обновлен."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, status: :see_other
  end


  private
  def project_params
    params.require(:project).permit(:title, :description)
  end

  def set_project
    @project = current_user.projects.find(params[:id])
  end
end
