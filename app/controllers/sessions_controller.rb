class SessionsController < ApplicationController
  skip_before_filter :authenticate_user_from_token!

  def create
    return invalid_login_attempt if params[:email].blank? || params[:password].blank?

    unless @user = User.find_by(email: params[:email])
      device = Device.find_by(uid: params[:device_id])

      if device
        @user = device.user
        @user.update(email: params[:email], password: params[:password], anonymous: false)
      else
        @user = User.create(email: params[:email], password: params[:password])
      end
    end
    return invalid_login_attempt unless @user.valid?

    if @user.valid_password?(params[:password])
      @user.update! authentication_token: @user.generate_auth_token
      sign_in @user, store: false
      
      render json: { authentication_token: @user.authentication_token }, status: :ok
      return
    end
    invalid_login_attempt
  end

  def create_anonymous
    device = Device.create_with(kind: params[:device_type]).find_or_create_by(uid: params[:device_id])
    return invalid_device_data(device) unless device.valid?
    @user = device.user

    unless @user
      @user = User.create(anonymous: true)
      @user.devices << device
    end
    return invalid_login_attempt unless @user.valid?

    if @user.save
      @user.update! authentication_token: @user.generate_auth_token
      sign_in @user, store: false

      render json: { authentication_token: @user.authentication_token }, status: :ok
      return
    end
    invalid_login_attempt
  end

  def fbcreate
    @user = User.create_with(fb_auth_token: params[:fb_auth_token]).find_or_create_by(email: params[:email])
    return invalid_login_attempt if params[:fb_auth_token].blank?

    sign_in @user, store: false
    
    render json: { authentication_token: @user.authentication_token }, status: :ok
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
    render json: { message: "Invalid email or password", errors: @user.try(:errors) }, status: :unauthorized
  end

  def invalid_device_data device
    render json: { message: "Invalid device data", errors: device.errors }, status: :unprocessable_entity
  end
end
