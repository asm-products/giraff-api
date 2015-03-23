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
    context 'when there is a valid auth token header' do
      before do
        user = create(:user)
        request.headers['X-User-Token'] = user.authentication_token
      end

      context 'when receiving an external image' do
        it 'creates a brand new image' do
          image_data = valid_image_data
          image_data.delete(:file)

          post :create, image: image_data

          expect(Image.count).to eq(1)
          expect(response.status).to eql(201)
          expect(response.body['id']).to_not be_nil
          expect(response.body['errors']).to be_nil
        end
      end

      context 'when receiving an image file' do
        it 'creates a brand new image' do
          post :create, image: valid_image_data

          expect(Image.count).to eq(1)
          expect(response.status).to eql(201)
          expect(response.body['id']).to_not be_nil
          expect(response.body['errors']).to be_nil
        end
      end

      context 'when receiving incomplete params' do
        it 'does not create an image' do
          image_data = valid_image_data
          image_data[:file].delete(:content_type)

          post :create, image: image_data

          expect(Image.count).to eq(0)
          expect(response.status).to eql(422)
          expect(response.body['errors']).to_not be_nil
        end
      end
    end

    context 'when there is not a valid auth token header' do
      it 'does not create an image' do
        post :create, image: valid_image_data

        expect(Image.count).to eq(0)
        expect(response.status).to eql(401)
      end
    end
  end

  private
  def valid_image_data
    image = build(:image)

    {
      name: image.name,
      original_source: image.original_source,
      bytes: image.bytes,
      shortcode: image.shortcode,
      file: {
        filename: 'filename.gif',
        content: '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',
        content_type: 'image/gif'
      }
    }
  end
end
