FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "kazuya" }
    password_confirmation { "kazuya" }
  end
end
