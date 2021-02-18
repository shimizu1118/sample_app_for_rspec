FactoryBot.define do
  factory :user do
    sequence(:email) { |n| 'a#{n}@a.a' }
    password { 'kazuya' }
    password_confirmation { 'kazuya' }
  end
end
