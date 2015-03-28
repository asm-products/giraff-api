class FetchImageFromUrl
  include Sidekiq::Worker

  def perform(url, image_id)
    if image = Image.where(id: image_id).first
      image.file = url
      image.save!
    end
  end
end
