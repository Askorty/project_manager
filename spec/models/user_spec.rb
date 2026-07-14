require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'валидации (проверка данных)' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end

  describe 'ассоциации (связи)' do
    it { should have_many(:projects).dependent(:destroy) }
  end
end
