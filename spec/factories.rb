FactoryGirl.define do

  factory :image do
    name {|n| "Caption #{n}" }
    original_source {|n| "http://i.imgur.com/#{n}.gif" }
    bytes { 1.megabyte }
    shortcode {|n| n.to_s }
    favorite_counter { 0 }
    pass_counter { 0 }
  end

  factory :user do
    authentication_token {|n| "token-#{n}" }
  end
end
