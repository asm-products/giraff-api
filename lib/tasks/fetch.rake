namespace :fetch do
  desc "Pulls gifs from reddit and saves them to the database"
  task reddit_gifs: :environment do

    added_count = 0
    FetchRedditImages.new.fetch_images(20) do |gif|
      begin
        Image.create! name: gif[:title], original_source: gif[:url]
        added_count += 1
      rescue ActiveRecord::RecordInvalid
        p "#{gif[:url]} already in the database"
      end
    end

    p "#{added_count} Image(s) were added"
  end

end
