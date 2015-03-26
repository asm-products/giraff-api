require 'open-uri'

task :tweet_reddit_gif => :environment do
	puts "tweeting"

	response = HTTParty.get('http://www.reddit.com/r/gifs.json')
	j = JSON.parse(response.body)

	# Parse and find a new one
	j["data"]["children"].each do |c|
		posted = Post.find_by_rid(c["data"]["id"])
		puts "checking #{c["data"]["title"]}"
		unless posted
			puts "Hasnt been posted, posting.."
			# If its an image post it.
			if c["data"]["url"].ends_with?(".jpg") || c["data"]["url"].ends_with?(".png") || c["data"]["url"].ends_with?(".gif")
				tempFile = open(c["data"]["url"])
				mediaId = TWITTER.upload(tempFile)
				TWITTER.update(c["data"]["title"], :media_ids => mediaId)
			end
			p = Post.new
			p.rid = c["data"]["id"]
			p.save
			# break the loop
			break
		end
	end
end