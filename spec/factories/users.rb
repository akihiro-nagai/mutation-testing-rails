FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@test.com" }
    sequence(:password_digest) { |n| Digest::SHA256.hexdigest("password#{n}") }
  end
end
