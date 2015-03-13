require 'rails_helper'

RSpec.describe ImagesController, type: :controller do
  describe '#index' do
    
    context 'when there is a valid auth token header' do
      it 'fetches an array of images' do
        user = create(:user)
        request.headers['X-User-Token'] = user.authentication_token

        get :index, format: :json

        expect(response.body.length).to_not eq(0)
        expect(response.status).to eql(200)
      end
    end

    context 'when there is not a valid auth token header' do
      it 'fetches an array of images' do
        get :index, format: :json

        expect(response.body.length).to_not eq(0)
        expect(response.status).to eql(401)
      end
    end
  end

  describe '#create' do
    context 'when the data is valid' do

    end

    context 'when the data is invalid' do

    end
  end
end
