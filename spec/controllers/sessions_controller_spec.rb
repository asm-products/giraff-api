require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe '#create' do
    
    context 'when the data is valid' do
      context 'when the user does not exist' do
        it 'creates a brand new user' do
          post :create, email: 'finn@ooo.com', password: 'testpass'

          expect(User.count).to eq(1)
          expect(assigns(:user).email).to eq('finn@ooo.com')
          expect(assigns(:user).authentication_token).to_not be_nil
          expect(response.status).to eql(200)
        end
      end

      context 'when the user is already registered' do
        before do
          @user = create(:user)
        end

        it 'does not create another user' do
          post :create, email: @user.email, password: @user.password

          expect(User.count).to eq(1)
          expect(assigns(:user).email).to eq(@user.email)
          expect(assigns(:user).authentication_token).to_not be_nil
          expect(response.status).to eql(200)
        end

        it 'updates authentication_token if user logs in correctly' do
          old_auth_token = @user.authentication_token

          post :create, email: @user.email, password: @user.password

          expect(old_auth_token).to_not eq(response.body["authentication_token"])
          expect(response.status).to eql(200)
        end
      end

      context 'when an anonymous user exists with this device' do
        before do
          @user = create(:anonymous_user)
          @device = create(:device, user: @user)
        end

        it 'updates the existent user' do
          post :create, email: 'email@test.com', password: 'mypassword', device_id: @device.uid

          expect(User.count).to eq(1)
          expect(assigns(:user).anonymous).to be_falsy
          expect(assigns(:user).email).to eq('email@test.com')
          expect(assigns(:user).authentication_token).to_not be_nil
          expect(response.status).to eql(200)
        end
      end
    end

    context 'when the data is invalid' do
      it 'does not log the user in without an email' do
        post :create, email: '', password: 'mypassword'

        expect(User.count).to eq(0)
        expect(response.status).to eql(401)
      end

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

  describe '#create_anonymous' do
    before do
      @device_attrs = attributes_for(:device)
    end
    
    context 'when the data is valid' do
      context 'when the user does not exist' do
        it 'creates a brand new anonymous user' do
          post :create_anonymous, device_id: @device_attrs[:uid], device_type: @device_attrs[:kind]

          expect(User.count).to eq(1)
          expect(assigns(:user).devices.count).to eq(1)
          expect(assigns(:user).anonymous).to be_truthy
          expect(assigns(:user).authentication_token).to_not be_nil
          expect(response.status).to eql(200)
        end
      end

      context 'when the user already exists' do
        before do
          @user = create(:anonymous_user)
          @device = create(:device, user: @user)
        end

        it 'does not create a new user' do
          post :create_anonymous, device_id: @device.uid, device_type: @device.kind

          expect(User.count).to eq(1)
          expect(assigns(:user).devices.count).to eq(1)
          expect(response.status).to eql(200)
        end

        it 'updates authentication_token if user logs in correctly' do
          old_auth_token = @user.authentication_token

          post :create_anonymous, device_id: @device.uid, device_type: @device.kind
          
          expect(old_auth_token).to_not eq(response.body["authentication_token"])
          expect(response.status).to eql(200)
        end
      end
    end

    context 'when the data is invalid' do
      it 'does not create an anonymous user without device id' do
        post :create_anonymous, device_type: @device_attrs[:kind]

        expect(User.count).to eq(0)
        expect(response.status).to eql(422)
        expect(response.body['errors']).to_not be_nil
      end
    end
  end

end
