require 'rails_helper'

RSpec.describe "TasksController", type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project) }
  before { sign_in user }

  describe "POST /projects/:project_id/tasks (Создание)" do
    context "с валидными данными" do
      it "создает новую задачу и возвращает на страницу проекта" do
        expect {
          post project_tasks_path(project), params: { task: { title: "Сделать тесты", status: "to_do", description: "Нужно покрытие 100%" } }
        }.to change(Task, :count).by(1)
        expect(response).to redirect_to(project_path(project))
      end
    end

    context "с невалидными данными" do
      it "не создает задачу без названия" do
        expect {
          post project_tasks_path(project), params: { task: { title: "", status: "to_do" } }
        }.not_to change(Task, :count)
      end
    end
  end

  describe "PATCH /projects/:project_id/tasks/:id (Обновление)" do
    it "обновляет статус задачи (двигаем по канбану) и возвращает на страницу проекта" do
      patch project_task_path(project, task), params: { task: { status: "in_progress" } }
      task.reload
      expect(task.status).to eq("in_progress")
      expect(response).to redirect_to(project_path(project))
    end

    context "с невалидными данными" do
      it "не обновляет задачу и показывает алерт (sad path)" do
        patch project_task_path(project, task), params: { task: { title: "" } }
        expect(response).to redirect_to(project_path(project))
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "DELETE /projects/:project_id/tasks/:id (Удаление)" do
    let!(:task_to_delete) { create(:task, project: project) }

    it "удаляет задачу и возвращает на страницу проекта" do
      expect {
        delete project_task_path(project, task_to_delete)
      }.to change(Task, :count).by(-1)

      expect(response).to redirect_to(project_path(project))
    end
  end
end
