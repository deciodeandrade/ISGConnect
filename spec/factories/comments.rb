FactoryBot.define do
  factory :comment do
    name { "MyString" }
    text { "MyText" }
    post { nil }
  end
end
