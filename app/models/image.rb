class Image < ActiveRecord::Base
  has_many :faves
  has_many :passes

  scope :unpassed_by, ->(user) {
    joins("left join passes p on p.image_id=images.id and p.user_id=#{User.sanitize(user.id)}").
    where('p.id is null')
  }
  scope :unfavorited_by, ->(user) {
    joins("left join favorites f on f.image_id=images.id and f.user_id=#{User.sanitize(user.id)}").
    where('f.id is null')
  }
  scope :unseen_by, ->(user) { unpassed_by(user).unfavorited_by(user) }
end
