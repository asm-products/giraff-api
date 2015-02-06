class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  acts_as_token_authenticatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_validation :downcase_unique_attributes
  validates_uniqueness_of :username

  def downcase_unique_attributes
    self.username = self.username.try(:downcase)
    self.email = self.email.try(:downcase)
  end
end
