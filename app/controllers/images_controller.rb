class ImagesController < ApplicationController
  respond_to :json

  skip_before_filter :authenticate_user_from_token!, only: [:shortcode]

  def index
    respond_with Image.small.unseen_by(current_user).page
  end

  def favorites
    respond_with Image.small.faved_by(current_user).page
  end

  def shortcode
    headers['Access-Control-Allow-Origin'] = '*'
    image = Image.where(shortcode: params[:shortcode]).first
    if image
      respond_with image, status: :ok
    else
      respond_with Hash.new, status: :not_found
    end
  end
end
