class ImagesController < ApplicationController
  respond_to :json

  def index
    respond_with Image.small.unseen_by(current_user).page
  end

  def favorites
    respond_with Image.small.faved_by(current_user).page
  end
end
