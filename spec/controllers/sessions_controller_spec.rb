require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe '#create' do
    it 'creates brand new user' do
      request.headers['X-User-Token'] = 'mathematical'
      post :create, email: 'finn@ooo.com'

      expect(assigns(:user).email).to eq('finn@ooo.com')
      expect(assigns(:user).authentication_token).to eq('mathematical')
    end

    it 'updates authentication_token if new user token is passed with existing email' do
      user = create(:user)

      request.headers['X-User-Token'] = 'mathematical'
      post :create, email: user.email

      expect(User.count).to eq(1)
      expect(assigns(:user).authentication_token).to eq('mathematical')
    end
  end
end
