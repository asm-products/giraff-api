class FetchRedditImages
  ENDPOINT       = 'http://www.reddit.com/r/gifs.json'
  ACCEPTED_HOSTS = ['i.imgur.com']

  def images
    @images ||= fetch_images
  end

  def fetch_images(pages=1, &blk)
    after = nil
    pages.times.each do
      json = get_raw_json(after)
      after = json['data']['after']

      filter_images(json['data']['children']).each do |i|
        blk.call(
          url: i['data']['url'],
          title: i['data']['title']
        )
      end
    end
  end

  private

  def filter_images(images_json)
    images_json.select do |i|
      i['data']['url'][/\.gif$/] && ACCEPTED_HOSTS.include?(i['data']['domain'])
    end
  end

  def build_images_hash(images_json)
    images_json.map { |i|  }
  end

  def get_raw_json(after=nil)
    response = Faraday.get(ENDPOINT, after: after)
    JSON.parse(response.body)
  end

end
