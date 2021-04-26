FactoryBot.define do
  sequence :login do |n|
    "jsmith#{n}"
  end

  factory :user do
    login { generate :login }
    name { "John Smith" }
    url { "http://example.com" }
    avatar_url { "http://example.com/avatar" }
    provider { "github" }
  end
end
