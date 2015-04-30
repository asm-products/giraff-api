FactoryGirl.define do
  factory :device do
    uid  {|n| "device_#{n}"}
    type "iphone"
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
  end
end
