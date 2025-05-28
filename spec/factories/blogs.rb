FactoryBot.define do
  factory :blog do
    association :category
    association :user

    sequence(:title) { |n| "Blog Title #{n}" }
    content { "This is a sample blog content." }
    status { "published" }

    # memo: うっかりデフォルト値を Time.current にしてしまうと、
    #       mutant で publish! のテストが通らなくなる
    published_at { nil }
  end
end
