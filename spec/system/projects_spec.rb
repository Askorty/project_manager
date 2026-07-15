require 'rails_helper'

RSpec.describe "Пользовательский сценарий работы с проектами", type: :system do
  let(:user) { User.create!(email: "test@mail.com", password: "password123") }

  before do
    driven_by(:rack_test)
  end

  it "пользователь успешно входит в систему и создает проект" do
    visit new_user_session_path

    fill_in "Email", with: user.email
    fill_in "Пароль", with: user.password

    click_button "Войти"

    expect(page).to have_content("Вход в систему выполнен успешно.")

    visit projects_path

    click_link "Создать проект"

    fill_in "Название", with: "Мой крутой проект"
    fill_in "Описание", with: "Описание для проверки"

    click_button "Сохранить проект"

    expect(page).to have_content("Мой крутой проект")
  end
end
