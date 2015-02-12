class FetchRedditImages
  def initialize(category = 'hot')
    @endpoint = case(category)
    when 'hot'
      'http://www.reddit.com/r/gifs.json'
    when 'top'
      'http://www.reddit.com/r/gifs/top.json?t=all'
    else
      raise 'Unsupported category'
    end
  end

  def fetch_images(pages=1, &blk)
    after = nil
    pages.times.each do
      json = get_raw_json(after)
      after = json['data']['after']

      extract_images(json['data']['children']) do |caption, url, shortcode|
        metadata = fetch_metadata(url)
        blk.call(metadata.merge(
          url: url,
          title: caption,
          shortcode: shortcode
        ))
      end
    end
  end

  private

  def extract_images(images_json, &blk)
    images_json.select do |i|
      if i['data']['url'] =~ /http\:\/\/(i\.)?imgur.com\/(\w+)\.gif/
        blk.call(i['data']['title'], "http://i.imgur.com/#{$2}.gif", $2)
      end
    end
  end

  def get_raw_json(after=nil)
    response = Faraday.get(@endpoint, after: after)
    JSON.parse(response.body)
  end

  def fetch_metadata(url)
    Faraday.head(url).headers.to_h
  end
end
