FactoryBot.define do
  factory :post do
    title { Faker::Book.title }
    text { Faker::Lorem.paragraph }
    user
  end
end
