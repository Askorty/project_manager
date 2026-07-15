require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'валидации' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end

  describe 'ассоциации' do
    it { should belong_to(:project) }
  end

  describe 'enum' do
    it do
      should define_enum_for(:status).with_values(
        Task::STATUS_TO_DO => "To Do",
        Task::STATUS_IN_PROGRESS => "In Progress",
        Task::STATUS_IN_TESTING => "In Testing",
        Task::STATUS_DONE => "Done",
        Task::STATUS_REJECTED => "Rejected"
      ).backed_by_column_of_type(:string)
    end
  end
end
