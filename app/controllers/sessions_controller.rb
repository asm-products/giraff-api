class SessionsController < ApplicationController
  skip_before_filter :authenticate_user_from_token!

  def create
    @user = User.create_with(password: params[:password], authentication_token: current_user_token).find_or_create_by(email: params[:email])
    return invalid_login_attempt unless @user.valid?

    if @user.valid_password?(params[:password])
      @user.update! authentication_token: current_user_token
      authenticate_user_from_token!
      
      render json: { authentication_token: @user.authentication_token }, status: :ok
      return
    end
    invalid_login_attempt
  end

  def destroy
    respond_to do |format|
      format.json {
        if current_user
          current_user.update_attribute(:authentication_token, nil)
          signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
          render :json => {}, :status => :ok
        else
          render :json => {}, :status => :unprocessable_entity
        end
      }
    end
  end
 
  protected
  def invalid_login_attempt
    render json: { message: "Invalid email or password", errors: @user.errors }, status: :unauthorized
  end
end
