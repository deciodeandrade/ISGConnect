FactoryBot.define do
  factory :comment do
    name { Faker::Book.title }
    text { Faker::Lorem.paragraph}
    post
  end
end
