class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :image

  after_create :update_favorite_counter

  def update_favorite_counter
    image.update(favorite_counter: image.favorite_counter + 1) if image
  end
end
