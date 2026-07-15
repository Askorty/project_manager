FactoryBot.define do
  factory :task do
    title { Faker::Lorem.words(number: 3).join(" ") }
    description { Faker::Lorem.paragraph }
    status { "To Do" }
    project
  end
end
