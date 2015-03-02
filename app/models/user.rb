class User < ActiveRecord::Base
  has_many :favorites
  has_many :favorite_images, source: :image, through: :favorites
  has_many :passes
  has_many :passed_images, source: :image, through: :passes

  devise :database_authenticatable, :registerable, :trackable

  validates :authentication_token, presence: true
  validates :password, on: :create, presence: true
end
