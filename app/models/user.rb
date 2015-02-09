class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :trackable

  validates :authentication_token, presence: true
end
