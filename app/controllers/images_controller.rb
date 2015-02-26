class ImagesController < ApplicationController
  respond_to :json

  skip_before_filter :authenticate_user_from_token!, only: [:shortcode]

  def index
    @all =  Image.unseen_by(current_user).super_hot.limit(180)
    @all << Image.unseen_by(current_user).least_seen.limit(90)
    @all << Image.unseen_by(current_user).rising.limit(90)
    respond_with  Kaminari.paginate_array(@all.uniq.shuffle).page(params[:page])
  end

  def favorites
    respond_with Image.faved_by(current_user).page(params[:page])
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
