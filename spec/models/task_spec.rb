require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'валидации (проверка данных)' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }

    # Проверяем, что разрешены только конкретные статусы
    it { should validate_inclusion_of(:status).in_array([ "To Do", "In Progress", "In Testing", "Rejected", "Done" ]) }
  end

  describe 'ассоциации (связи)' do
    it { should belong_to(:project) }
  end

  describe 'правила перехода статусов' do
    let(:user) { User.create!(email: 'test@mail.com', password: 'password123') }
    let(:project) { Project.create!(title: 'Проект', description: 'Описание проекта', user: user) }

    # Теперь передаем description при создании задачи и используем твои строковые статусы!
    let(:task) { Task.create!(title: 'Задача', description: 'Текст задачи', status: 'To Do', project: project) }

    context 'когда статус To Do' do
      it 'разрешает переход в In Progress' do
        task.status = 'In Progress'
        expect(task).to be_valid
      end

      it 'запрещает переход сразу в Done' do
        task.status = 'Done'
        expect(task).not_to be_valid
      end
    end

    context 'когда статус In Progress' do
      before { task.update_column(:status, 'In Progress') }

      it 'разрешает переход в In Testing' do
        task.status = 'In Testing'
        expect(task).to be_valid
      end

      it 'разрешает возврат в To Do' do
        task.status = 'To Do'
        expect(task).to be_valid
      end

      it 'запрещает переход в Rejected' do
        task.status = 'Rejected'
        expect(task).not_to be_valid
      end
    end

    context 'когда статус Done' do
      before { task.update_column(:status, 'Done') }

      it 'запрещает любые изменения статуса' do
        task.status = 'To Do'
        expect(task).not_to be_valid

        task.status = 'In Progress'
        expect(task).not_to be_valid
      end
    end
  end
end
