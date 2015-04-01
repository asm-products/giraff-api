class AddAttachmentMp4ToImages < ActiveRecord::Migration
  def change
    add_attachment :images, :mp4
  end
end
