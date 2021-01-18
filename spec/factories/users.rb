require 'securerandom'
FactoryBot.define do
  factory :user do
    email { 'fake123@test.com' }
    password { "123" }
    api_key { SecureRandom.uuid }
  end
end
