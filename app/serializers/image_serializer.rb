class ImageSerializer < ActiveModel::Serializer
  attributes :original_source, :name, :shortcode, :id, :mp4_url, :gif_url

  def mp4_url
    self.mp4.url
  end

  def gif_url
    self.gif.url
  end

  # def original_source
  #   self.mp4.url
  # end
end
