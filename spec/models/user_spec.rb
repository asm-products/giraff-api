require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :devices }

  let(:user)     { create(:user) }
  let(:favorite) { Favorite.create!(user: user, image: create(:image)) }
  let(:pass)     { Pass.create!(user: user, image: create(:image)) }

  it 'should update favorite_counter' do
    expect(favorite.image.favorite_counter).to eq(1)
  end

  describe '#favorite_images' do

    it 'returns favorited images' do
      expect(user.favorite_images).to match_array([favorite.image])
    end

  end

  it 'should update pass_counter' do
    expect(pass.image.pass_counter).to eq(1)
  end

  describe '#passed_images' do

    it 'returns favorited images' do
      expect(user.passed_images).to match_array([pass.image])
    end

  end
end
