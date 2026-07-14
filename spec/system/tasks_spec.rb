require 'rails_helper'

RSpec.describe "Работа с задачами (Канбан-доска)", type: :system do
  let(:user) { User.create!(email: "test@mail.com", password: "password123") }
  let!(:project) { Project.create!(title: "Канбан", description: "Для тестов", user: user) }

  before do
    driven_by(:rack_test)
    sign_in user
  end

  it "создает задачу и переводит её в работу" do
    visit project_path(project)

    # 1. Нажимаем на кнопку в правом верхнем углу
    # Используем click_on, так как он работает и для ссылок (<a>), и для кнопок (<button>)
    click_on "Создать задачу"

    # 2. Заполняем форму по точным лейблам со скриншота
    fill_in "Название", with: "Написать крутые тесты"
    fill_in "Описание задачи", with: "Проверить смену статуса"

    # 3. Нажимаем зеленую кнопку сохранения
    click_button "Сохранить задачу"

    # Убеждаемся, что задача успешно создалась и текст есть на экране
    expect(page).to have_content("Написать крутые тесты")

    # 4. Нажимаем фиолетовую кнопку перевода статуса в колонке "К выполнению"
    click_button "В работу"

    # Проверяем, что задача не исчезла после смены статуса
    expect(page).to have_content("Написать крутые тесты")
  end
end
