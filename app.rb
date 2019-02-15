require "sinatra"
require_relative "authentication.rb"

def youtube_embed(youtube_url)
  if youtube_url[/youtu\.be\/([^\?]*)/]
    youtube_id = $1
  else
    # Regex from # http://stackoverflow.com/questions/3452546/javascript-regex-how-to-get-youtube-video-id-from-url/4811367#4811367
    youtube_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
    youtube_id = $5
  end

  %Q{<iframe title="YouTube video player" width="640" height="390" src="http://www.youtube.com/embed/#{ youtube_id }" frameborder="0" allowfullscreen></iframe>}
end

def admin_only! 
	if !current_user || !current_user.administrator
		redirect "/"
	end
end

def pro_only!
	if !current_user || !current_user.pro || !current_user.administrator
		redirect "/"
	end
end
class Video
	include DataMapper::Resource
	property :id, Serial
	property :title, Text
	property :video_url, Text

end
# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
User.auto_upgrade!
Video.auto_upgrade!




get "/" do
	erb :index
end


get "/videos" do
	if admin_only || pro_only do
	@videos = Video.all
	erb :videos
else
	if Video.all.pro == false 
end

end

post "/videos/create" do 
	#authenticate!
	if params["title"] && params["video_url"]
		v = Video.new
		v.title = params["title"]
		v.video_url = params["video_url"]
		v.save
		return "succesful"
	else
		return "missing information"
	end
end	

get "/videos/new" do
	#authenticate!
	erb :new_video
end
