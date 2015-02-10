class ErrorsController < ActionController::Base
  def not_found
    render json: { error: "not-found" }, status: 404
  end

  def error
    render json: { error: "server-error" }, status: 500
  end
end
