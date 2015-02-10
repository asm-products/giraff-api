class PassesController < ApplicationController
  def create
    image = Image.find(params[:image_id])
    @pass = Pass.find_or_create_by(user: current_user, image: image)
    render nothing: true, status: :ok
  end
end
