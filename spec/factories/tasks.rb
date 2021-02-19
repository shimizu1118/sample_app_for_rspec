FactoryBot.define do
  factory :task do
    association :user
    sequence(:title, "title_1")
    content { "content" }
    status { "todo" }
    deadline { 1.week.from_now }
  end
end
