require 'open-uri'

task :tweet_reddit_gif => :environment do
	puts "tweeting"

	response = HTTParty.get('http://www.reddit.com/r/gifs.json')
	j = JSON.parse(response.body)

	# Parse and find a new one
	j["data"]["children"].each do |c|
		if c["data"]["url"].ends_with?(".gif")
			posted = TwitterPost.find_by_rid(c["data"]["id"])
			puts "checking #{c["data"]["title"]}: #{c["data"]["url"]}"
			unless posted
				tempFile = open(c["data"]["url"])
				mediaId = TWITTER.upload(tempFile)
				TWITTER.update(c["data"]["title"], :media_ids => mediaId)

				p = TwitterPost.new
				p.rid = c["data"]["id"]
				p.save
				# break the loop
				break
			end
		end
	end
end