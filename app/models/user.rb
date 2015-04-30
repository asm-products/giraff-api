class User < ActiveRecord::Base
  has_many :favorites
  has_many :favorite_images, source: :image, through: :favorites
  has_many :passes
  has_many :passed_images, source: :image, through: :passes
  has_many :devices

  devise :database_authenticatable, :registerable, :trackable

  validates :authentication_token, presence: true
  validates :password, on: :create, presence: true, allow_nil: true

  before_validation :set_auth_token

  def generate_auth_token
    SecureRandom.uuid.gsub(/\-/,'')
  end

  private
    def set_auth_token
      return if authentication_token.present?
      self.authentication_token = generate_auth_token
    end

end
