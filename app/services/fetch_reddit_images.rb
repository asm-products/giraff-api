class FetchRedditImages
  ENDPOINT       = 'http://www.reddit.com/r/gifs.json'
  ACCEPTED_HOSTS = ['i.imgur.com']

  def images
    @images ||= fetch_images
  end

  def fetch_images
    filtered_images = filter_images get_raw_json['data']['children']
    build_images_hash filtered_images
  end

  private

  def filter_images(images_json)
    images_json.select do |i|
      i['data']['url'][/\.gif$/] && ACCEPTED_HOSTS.include?(i['data']['domain'])
    end
  end

  def build_images_hash(images_json)
    images_json.map { |i| { url: i['data']['url'], title: i['data']['title'] } }
  end

  def get_raw_json
    response = Faraday.get(ENDPOINT)
    JSON.parse(response.body)
  end

end
