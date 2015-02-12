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

    if user
      sign_in user, store: false
    end
  end

  def append_info_to_payload(payload)
    super
    payload[:user_id] = current_user.id if current_user
    payload[:user_token] = request.headers['X-User-Token'] if request.headers['X-User-Token']
  end
end
