require 'rails_helper'

RSpec.describe Image, type: :model do
  describe '#faved_by' do
    let(:user) { create(:user) }

    it 'ignores images with a more recent pass' do
      Timecop.freeze do
        passed = create(:image)
        faved = create(:image)

        Pass.create!(user: user, image: faved)
        Favorite.create!(user: user, image: passed)

        Timecop.travel(10.seconds.from_now)

        Pass.create!(user: user, image: passed)
        Favorite.create!(user: user, image: faved)

        expect(Image.faved_by(user)).to match_array([faved])
      end
    end
  end
end
