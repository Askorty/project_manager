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

    click_on "Создать задачу"

    fill_in "Название", with: "Написать крутые тесты"
    fill_in "Описание задачи", with: "Проверить смену статуса"

    click_button "Сохранить задачу"

    expect(page).to have_content("Написать крутые тесты")

    click_button "В работу"

    expect(page).to have_content("Написать крутые тесты")
  end
end
