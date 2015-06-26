require 'rails_helper'

RSpec.describe Device, type: :model do
  it { should belong_to :user }
  it { should validate_presence_of :uid }
end
