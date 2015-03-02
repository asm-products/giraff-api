require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe '#create' do
    
    context 'when the data is valid' do
      it 'creates brand new user' do
        request.headers['X-User-Token'] = 'mathematical'
        post :create, email: 'finn@ooo.com', password: 'testpass'

        expect(User.count).to eq(1)
        expect(assigns(:user).email).to eq('finn@ooo.com')
        expect(assigns(:user).authentication_token).to eq('mathematical')
        expect(response.status).to eql(200)
      end

      it 'updates authentication_token if new user token is passed with existing email' do
        user = create(:user, password: 'testpass')

        request.headers['X-User-Token'] = 'mathematical'
        post :create, email: user.email, password: 'testpass'

        expect(User.count).to eq(1)
        expect(assigns(:user).authentication_token).to eq('mathematical')
        expect(response.status).to eql(200)
      end
    end

    context 'when the data is invalid' do
      it 'does not create an user without a password' do
        request.headers['X-User-Token'] = 'mathematical'
        post :create, email: 'finn@ooo.com'

        expect(User.count).to eq(0)
        expect(response.status).to eql(401)
      end

      it 'does not create an user without an authentication_token' do
        post :create, email: 'finn@ooo.com', password: 'testpass'

        expect(User.count).to eq(0)
        expect(response.status).to eql(401)
      end

      it 'fails to login with the wrong password' do
        user = create(:user)

        request.headers['X-User-Token'] = 'mathematical'
        post :create, email: user.email, password: "wrong #{user.password}"

        expect(response.status).to eql(401)
      end
    end
  end
end
