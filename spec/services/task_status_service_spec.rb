require 'rails_helper'

RSpec.describe TaskStatusService do
  let(:project) { create(:project) }
  let(:task) { create(:task, project: project, status: Task::STATUS_TO_DO) }

  describe '#call' do
    context 'когда статус To Do' do
      it 'разрешает переход в In Progress' do
        service = TaskStatusService.new(task, Task::STATUS_IN_PROGRESS)
        expect(service.call).to be true
        expect(task.status).to eq(Task::STATUS_IN_PROGRESS)
      end

      it 'запрещает переход сразу в Done' do
        service = TaskStatusService.new(task, Task::STATUS_DONE)
        expect(service.call).to be false
        expect(task.errors[:status]).to include("статус To Do можно изменить только на In Progress")
      end
    end

    context 'когда статус In Progress' do
      before { task.update_column(:status, Task::STATUS_IN_PROGRESS) }

      it 'разрешает переход в In Testing' do
        service = TaskStatusService.new(task, Task::STATUS_IN_TESTING)
        expect(service.call).to be true
      end

      it 'разрешает возврат в To Do' do
        service = TaskStatusService.new(task, Task::STATUS_TO_DO)
        expect(service.call).to be true
      end

      it 'запрещает переход в Rejected' do
        service = TaskStatusService.new(task, Task::STATUS_REJECTED)
        expect(service.call).to be false
      end
    end

    context 'когда статус In Testing' do
      before { task.update_column(:status, Task::STATUS_IN_TESTING) }

      it 'разрешает переход в Done' do
        service = TaskStatusService.new(task, Task::STATUS_DONE)
        expect(service.call).to be true
      end

      it 'разрешает переход в Rejected' do
        service = TaskStatusService.new(task, Task::STATUS_REJECTED)
        expect(service.call).to be true
      end

      it 'запрещает возврат в To Do' do
        service = TaskStatusService.new(task, Task::STATUS_TO_DO)
        expect(service.call).to be false
        expect(task.errors[:status]).to include("статус In Testing можно изменить только на Done или Rejected")
      end
    end

    context 'когда статус Rejected' do
      before { task.update_column(:status, Task::STATUS_REJECTED) }

      it 'разрешает возврат в In Progress' do
        service = TaskStatusService.new(task, Task::STATUS_IN_PROGRESS)
        expect(service.call).to be true
      end

      it 'запрещает переход сразу в Done' do
        service = TaskStatusService.new(task, Task::STATUS_DONE)
        expect(service.call).to be false
      end
    end

    context 'когда статус Done' do
      before { task.update_column(:status, Task::STATUS_DONE) }

      it 'запрещает любые изменения' do
        service = TaskStatusService.new(task, Task::STATUS_TO_DO)
        expect(service.call).to be false
      end
    end
  end
end
