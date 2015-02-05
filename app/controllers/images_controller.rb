class ImagesController < ApplicationController
  respond_to :json

  def index
    respond_with Image.all
  end
end
