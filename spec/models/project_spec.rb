require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'валидации (проверка данных)' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end

  describe 'ассоциации (связи)' do
    it { should belong_to(:user) }
    it { should have_many(:tasks).dependent(:destroy) }
  end
end
