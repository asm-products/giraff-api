class ImageSerializer < ActiveModel::Serializer
  attributes :original_source, :name, :shortcode, :id

  # def original_source
  #   self.mp4.url
  # end
end
