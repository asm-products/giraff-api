class RegistrationsController < Devise::RegistrationsController

  def create
    user = User.create(user_params)

    if user.save
      render :json => {user: UserSerializer.new(user, root: nil)}, status: :ok
    else
      render :json => {message: user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :username, :password)
    end
end
