require_relative "app.rb"

get "/registerBarbershop" do
	return "hello"
end

get "/upgradepro" do
	u = current_user
	u.pro = true
	u.save
	redirect "/admin"
end

get "/upgradebasic" do
	u = current_user
	u.basic = true
	u.save
	redirect "/admin"
end
