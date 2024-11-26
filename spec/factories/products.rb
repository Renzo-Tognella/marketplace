FactoryBot.define do
  factory :product do
    title { FFaker::Book.title }
    price { 100.50 }
    description { FFaker::Book.description }
    published { false }
    user_id { 1 }
  end
end
