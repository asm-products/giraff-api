class Image < ActiveRecord::Base
  has_many :favorites
  has_many :passes

  has_attached_file :file
  validates_attachment :file, content_type: { content_type: 'image/gif' }
  has_attached_file :mp4
  validates_attachment :mp4, content_type: { content_type: 'video/mp4' }
  validates :original_source, uniqueness: true
  validates :file_fingerprint, uniqueness: { allow_blank: true }

  scope :small, ->{ where('bytes < ?', 5.megabytes) }
  scope :medium, ->{ where('bytes < ?', 10.megabytes) }
  scope :unpassed_by, ->(user) {
    joins("left join passes p on p.image_id=images.id and p.user_id=#{User.sanitize(user.id)}").
    where('p.id is null')
  }
  scope :unfavorited_by, ->(user) {
    joins("left join favorites f on f.image_id=images.id and f.user_id=#{User.sanitize(user.id)}").
    where('f.id is null')
  }
  scope :unseen_by, ->(user) { unpassed_by(user).unfavorited_by(user) }

  scope :least_seen, -> { order('pass_counter, favorite_counter') }
  scope :super_hot,  -> { where('images.created_at > ?', 7.days.ago).order('favorite_counter desc') }
  scope :rising,     -> { where('images.created_at > ?', 24.hours.ago).order('favorite_counter desc') }

  before_save :set_shortcode, on: :create

  def self.faved_by(user)
    # Yep, this is a pretty gnarly query. Perhaps we should cache the current
    # fave/pass in another table. eg: judgements
    joins(:favorites).
      joins("left join passes p on p.image_id=images.id and p.user_id=#{User.sanitize(user.id)}").
      where(favorites: { user_id: user.id }).
      where('p is null or p.created_at < favorites.created_at')
  end

  def set_shortcode
    self.shortcode ||= SecureRandom.hex(4)
  end

end
