namespace :fetch do
  desc "Pulls gifs from reddit and saves them to the database"
  task :reddit_gifs, [:pages] => :environment do |t, args|
    added_count = 0
    pages = (args[:pages] || 5).to_i
    puts "fetching #{pages} page(s)"
    FetchRedditImages.new.fetch_images(pages) do |gif|
      begin
        bytes = gif['content-length'].to_i
        if bytes > 0
          Image.create!(
            name: gif[:title],
            original_source: gif[:url],
            bytes: bytes
          )
          added_count += 1
        end
      rescue ActiveRecord::RecordInvalid
        p "#{gif[:url]} already in the database"
      end
    end

    p "#{added_count} Image(s) were added"
  end

end
