class ImageSerializer < ActiveModel::Serializer
  attributes :original_source, :name, :shortcode, :id, :mp4_url, :gif_url

  def mp4_url
    object.mp4.url
  end

  def gif_url
    object.file.url
  end

  def original_source
    object.mp4.url
  end
end
