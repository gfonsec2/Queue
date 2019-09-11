require_relative "app.rb"
require 'date'
get "/pop/:id" do
	c = Queueitem.get(params[:id])
	b = Barber.get(c.bid)
	shop = Barbershops.get(current_user.id)
	if c != nil
		b.money += c.price
		b.total +=1
		shop.revenue += c.price
		shop.customers += 1
		c.created = Time.now.strftime("%Y-%m-%d")
		c.save
	end
	b.save
	redirect "/viewA"
end

get "/pop2/:id" do
	c = Queueitem.get(params[:id])
	if c != nil
		c.destroy
	end
	redirect "/viewA"
end

get "/viewC" do
	@barbers = Barber.all(available: true) & Barber.all(shop_id: current_user.id)
	erb :customerQ
end
get "/viewA" do
	@barbers = Barber.all(available: true) & Barber.all(shop_id: current_user.id)
	erb :adminQ
end


get "/sign_in" do 
	@barbers = Barber.all(available: false)
	erb :in
end

get "/sign_in/:id" do
	b = Barber.get(params[:id])
	b.available = true
	b.save
	redirect "/sign_in"
	# redirect "/viewA"
end

get "/sign_out" do 
	@barbers = Barber.all(available: true)
	erb :out
end

get "/sign_out/:id" do
	b = Barber.get(params[:id])
	b.available = false
	b.save
	redirect "/sign_out"
	# redirect "/viewA"
end