FactoryBot.define do
  factory :task do
    association :user
    title { 'テスト' }
    content { 'コンテンツ' }
    status { 0 }
  end
end
