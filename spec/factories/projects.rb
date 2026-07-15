FactoryBot.define do
  factory :project do
    title { Faker::App.name }
    description { Faker::Lorem.sentence }
    user
  end
end
