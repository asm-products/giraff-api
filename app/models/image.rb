# == Schema Information
#
# Table name: images
#
#  id              :uuid             not null, primary key
#  created_at      :datetime         not null
#  name            :string           not null
#  original_source :string           not null
#  state           :string           default("new")
#

class Image < ActiveRecord::Base
end
