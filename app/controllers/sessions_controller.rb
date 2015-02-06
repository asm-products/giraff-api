class SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)

    current_user.update_attribute(:authentication_token, nil)

    respond_to do |format|
      format.json {
        render :json => {
          :authentication_token => current_user.authentication_token
        }, :status => :ok
      }
    end
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
