require 'data_mapper' # metagem, requires common plugins too.
#require_relative "app.rb"

# need install dm-sqlite-adapter
# if on heroku, use Postgres database
# if not use sqlite3 database I gave you
if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/app.db")
end

class User
    include DataMapper::Resource
    property :id, Serial
    property :email, String
    property :password, String
    property :created_at, DateTime
    property :administrator, Boolean, :default => false
    property :pro, Boolean, :default => false
    property :basic, Boolean, :default => false


    def login(password)
    	return self.password == password
    end
    
    def barbershops
        return Barbershop.all(uID: id)
    end

end



