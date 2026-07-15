require 'rails_helper'

RSpec.describe "ProjectsController", type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  describe "Проверка доступа (авторизация)" do
    context "когда пользователь НЕ авторизован" do
      it "блокирует доступ и перенаправляет на страницу входа" do
        get projects_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "Действия авторизованного пользователя" do
    before { sign_in user }

    context "Чтение (GET)" do
      it "успешно открывает страницу списка проектов (index)" do
        get projects_path
        expect(response).to have_http_status(:success)
      end

      it "успешно открывает страницу конкретного проекта (show)" do
        get project_path(project)
        expect(response).to have_http_status(:success)
      end

      it "успешно открывает форму создания (new)" do
        get new_project_path
        expect(response).to have_http_status(:success)
      end
    end

    context "Запись и изменение (POST, PATCH, DELETE)" do
      it "создает новый проект (create)" do
        expect {
          post projects_path, params: { project: { title: "Новый проект", description: "Описание" } }
        }.to change(Project, :count).by(1)

        expect(response).to redirect_to(project_path(Project.last))
      end

      it "обновляет существующий проект (update)" do
        patch project_path(project), params: { project: { title: "Обновленное название" } }

        project.reload

        expect(project.title).to eq("Обновленное название")
        expect(response).to redirect_to(project_path(project))
      end

      it "удаляет проект (destroy)" do
        project_to_delete = create(:project, user: user)
        expect {
          delete project_path(project_to_delete)
        }.to change(Project, :count).by(-1)

        expect(response).to redirect_to(projects_path)
      end

      it "не обновляет проект при невалидных данных (sad path)" do
        patch project_path(project), params: { project: { title: "" } }
        # Ожидаем, что нас вернет на страницу проекта, а во flash появится сообщение об ошибке
        expect(response).to redirect_to(project_path(project))
        expect(flash[:alert]).to include("Ошибка")
      end

      context "с невалидными данными" do
        it "не создает проект и возвращает статус unprocessable_entity" do
          expect {
            post projects_path, params: { project: { title: "" } }
          }.not_to change(Project, :count)

          expect(response).to have_http_status(:unprocessable_content)
        end
      end
    end
  end
end
