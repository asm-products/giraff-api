class SessionsController < ApplicationController
  skip_before_filter :authenticate_user_from_token!

  def create
    @user = User.find_or_create_by(email: params[:email]) do |user|
      user.authentication_token = current_user_token
    end
    @user.update! authentication_token: current_user_token

    authenticate_user_from_token!

    render json: {
      authentication_token: @user.authentication_token
    }
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
end
