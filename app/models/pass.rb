class Pass < ActiveRecord::Base
  belongs_to :image
  belongs_to :user

  after_create :update_pass_counter

  def update_pass_counter
    image.update(pass_counter: image.pass_counter + 1) if image
  end
end
