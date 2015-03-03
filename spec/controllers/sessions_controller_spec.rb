require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe '#create' do
    
    context 'when the data is valid' do
      it 'creates brand new user' do
        post :create, email: 'finn@ooo.com', password: 'testpass'

        expect(User.count).to eq(1)
        expect(assigns(:user).email).to eq('finn@ooo.com')
        expect(assigns(:user).authentication_token).to_not be_nil
        expect(response.status).to eql(200)
      end

      it 'updates authentication_token if user logs in correctly' do
        user = create(:user, password: 'testpass')
        old_auth_token = user.authentication_token

        post :create, email: user.email, password: 'testpass'

        expect(User.count).to eq(1)
        expect(old_auth_token).to_not eq(response.body["authentication_token"])
        expect(response.status).to eql(200)
      end
    end

    context 'when the data is invalid' do
      it 'does not create an user without a password' do
        post :create, email: 'finn@ooo.com', password: ''

        expect(User.count).to eq(0)
        expect(response.status).to eql(401)
      end

      it 'fails to login with the wrong password' do
        user = create(:user)

        post :create, email: user.email, password: "wrong #{user.password}"

        expect(response.status).to eql(401)
      end
    end
  end
end
