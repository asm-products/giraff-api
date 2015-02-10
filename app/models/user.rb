class User < ActiveRecord::Base
  has_many :favorites

  devise :database_authenticatable, :registerable, :trackable

  validates :authentication_token, presence: true
end
