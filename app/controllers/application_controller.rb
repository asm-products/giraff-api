class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  # protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }

  # skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!

  def authenticate_user_from_token!
    user_token = request.headers['X-User-Token'].presence
    user = user_token && User.find_or_create_by(authentication_token: user_token)

    puts "user: #{user.inspect}"

    if user
      sign_in user, store: false
    end
  end
end
