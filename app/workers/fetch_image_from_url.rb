class FetchImageFromUrl
  include Sidekiq::Worker

  def perform(url, image_id)
    if image = Image.where(id: image_id).first
      extension = File.extname(URI.parse(url).path)
      if extension == '.gif'
        image.file = url
      elsif extension == '.mp4'
        image.mp4 = url
      end
      image.save!
    end
  end
end
