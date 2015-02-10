class User < ActiveRecord::Base
  has_many :favorites
  has_many :passes

  devise :database_authenticatable, :registerable, :trackable

  validates :authentication_token, presence: true
end
