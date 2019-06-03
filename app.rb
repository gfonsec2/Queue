require "sinatra"
require_relative "authentication.rb"
require_relative "admin_functions.rb"
require_relative "haircuts.rb"
require_relative "kiosk.rb"
require_relative "view.rb"


if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/app.db")
end
class Barber
	include DataMapper::Resource

	property :id, Serial
	property :name, Text
	property :total, Integer, :default => 0
	property :available, Boolean, :default => true
	property :money, Integer, :default => 0
	#fill in the rest
	def wait_list
		return Queueitem.all(bid: id) #gets list of customers 
	end
	
end

class Queueitem
	include DataMapper::Resource

	property :id, Serial
	property :name, Text
	property :price, Integer
	property :bid, Integer

	def barber 
		return Barber.get(bid)
	end
end

class Date
	include DataMapper::Resource

	property :id, Serial
	property :created_at, Date 
	property :money, Integer
end

class Haircuts
	include DataMapper::Resource

	property :id, Serial
	property :hair, Boolean 
	property :hair_type, Text
	property :price, Integer

end




DataMapper.finalize
User.auto_upgrade!
Barber.auto_upgrade!
Queueitem.auto_upgrade!
Date.auto_upgrade!
Haircuts.auto_upgrade!

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

if User.all(administrator: true).count == 0
	u = User.new
	u.email = "admin@admin.com"
	u.password = "admin"
	u.administrator = true
	u.save
end

if Haircuts.all.count == 0
	addhaircuts()
end


get "/" do
	redirect "/admin" 
end

