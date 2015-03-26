require 'open-uri'

task :tweet_reddit_gif => :environment do
	puts "tweeting"

	response = HTTParty.get('http://www.reddit.com/r/gifs.json')
	j = JSON.parse(response.body)

	# Parse and find a new one
	j["data"]["children"].each do |c|
		if c["data"]["url"].ends_with?(".gif") || c["data"]["url"].ends_with?(".gifv")
			posted = TwitterPost.find_by_rid(c["data"]["id"])
			puts "checking #{c["data"]["title"]}: #{c["data"]["url"]}"
			unless posted
				begin
					if c["data"]["url"].ends_with?(".gifv")
						# puts "after trim #{c["data"]["url"].chop}"
						tempFile = open(c["data"]["url"].chop) #tget rid of the 'v' at the end with chop
					else
						tempFile = open(c["data"]["url"])
					end
					puts "temp downloaded"
					mediaId = TWITTER.upload(tempFile)
					puts "file uploaded"
					TWITTER.update("#{c["data"]["title"]} via @choosefunapp best GIFs app #lol #funny #fun #app", :media_ids => mediaId)
				rescue
					puts "error tweeting gif" #usually the file size of the gif is too big for twitter or the title is too long.
					p = TwitterPost.new
					p.rid = c["data"]["id"]
					p.save
					next #move on to another that does work. 
				end

				p = TwitterPost.new
				p.rid = c["data"]["id"]
				p.save
				# break the loop
				break
			end
		end
	end
end