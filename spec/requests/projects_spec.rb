require 'rails_helper'

RSpec.describe "ProjectsController", type: :request do
  # Создаем тестового пользователя
  let(:user) { User.create!(email: "test@mail.com", password: "password123") }

  describe "GET /projects (страница списка проектов)" do
    context "когда пользователь НЕ авторизован" do
      it "блокирует доступ и перенаправляет на страницу входа" do
        get projects_path

        # Ожидаем, что сервер ответит кодом 302 (Redirect) на страницу логина
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "когда пользователь авторизован" do
      it "успешно открывает страницу проектов" do
        # Имитируем вход пользователя в систему
        sign_in user

        get projects_path

        # Ожидаем, что сервер ответит кодом 200 (OK - успех)
        expect(response).to have_http_status(:success)
      end
    end
  end
end
