require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe '#favorite_images' do

    it 'returns favorited images' do
      faved_01 = create(:image)
      faved_02 = create(:image)

      Favorite.create!(user: user, image: faved_01)
      Favorite.create!(user: user, image: faved_02)

      expect(user.favorite_images).to match_array([faved_01, faved_02])
    end
  end

  describe '#passed_images' do

    it 'returns favorited images' do
      passed_01 = create(:image)
      passed_02 = create(:image)

      Pass.create!(user: user, image: passed_01)
      Pass.create!(user: user, image: passed_02)

      expect(user.passed_images).to match_array([passed_01, passed_02])
    end
  end
end
