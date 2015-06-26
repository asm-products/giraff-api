FactoryGirl.define do
  factory :device do
    sequence(:uid) {|n| "device_#{n}"}
    kind "iphone"
    user
  end

  factory :twitter_post do    
  end

  factory :image do
    name {|n| "Caption #{n}" }
    original_source {|n| "http://i.imgur.com/#{n}.gif" }
    bytes { 1.megabyte }
    shortcode {|n| n.to_s }
    favorite_counter { 0 }
    pass_counter { 0 }
  end

  factory :user do
    sequence(:email) {|n| "email_#{n}@foo.bar"}
    sequence(:password) {|n| "password-#{n}"}

    factory :anonymous_user do
      anonymous true
      email nil
      password nil
    end
  end
end
