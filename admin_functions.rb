require_relative "app.rb"

#admin functions
#add barber
#delete barber
#Dashboard
#Data table
#Calendar

require_relative "app.rb"

def current_barbershop 
	barbershop = Barbershop.get(u_id: current_user.id)
	return barbershop
end

get "/display" do

	return current_barbershop
end

get "/aboutUs" do
	erb :aboutUs
end

get "/pricingPage" do
	erb :pricePage
end

get "/admin" do
	authenticate!
if current_user.basic || current_user.pro 
	barbershops = current_user.barbershops
	if current_barbershop == nil
		redirect "/admin/registerBarbershop"
	end

	@barbers = Barber.all(shopID: current_barbershop.id)
	@all = Appointment.all(valid: 0, shopID: current_barbershop.id)
	@all.each do |a|
		a.destroy
	end
	erb :homeDashboard
	#flash[:success] = "succesfully logged in"	
else
	erb :pricing
	#redirect "/login"
end
end

post "/admin/new" do 
	if params["name"] != ""
		b = Barber.new
		b.name = params["name"]
		b.shopID = current_barbershop.id
		b.save
		redirect "/admin/addbarber"
	else
		flash[:error] = "Must enter a name for new barber "
		redirect "/admin/addbarber"
	end
end	

get "/admin/addbarber" do
	authenticate! 
	@barbers = Barber.all(shopID: current_barbershop.id)
	erb :addBarber
end

get "/admin/delete/:id" do
	authenticate!
		b = Barber.get(params[:id])
		b.destroy
		redirect "/admin/deletebarber"
end

get "/admin/deletebarber" do
	authenticate!

		@barbers = Barber.all
		erb :deleteBarber
end

get "/admin/updateprice/:id" do
	authenticate!
	haircut = Haircuts.get(params[:id])
	haircut.update(:price => params["price"])
	haircut.save
	redirect "/admin/updateprice"
end

get "/admin/updateprice/extra/:id" do
	authenticate!
	e = Extra.get(params[:id])
	e.update(:price => params["price"])
	e.save
	redirect "/admin/updateprice"
end

get "/admin/updateprice/delete/:id" do
	authenticate!
	if current_user.administrator
	haircut = Haircuts.get(params[:id])
	haircut.destroy
	redirect "/admin/updateprice"
else
	redirect "/login"
end
end

post "/admin/updateprice/add" do
	authenticate!
	type = params["type"]
	name = params["name"]
	price = params["price"]

	if(type == "hair")
		h = Haircuts.new
		h.hair = true
		h.hair_type = name
		h.price = price
		h.save
	elsif(type == "beard")
		h = Haircuts.new
		h.hair = false
		h.hair_type = name
		h.price = price
		h.save
	else
		e = Extra.new
		e.name = name
		e.price = price
		e.save
	end
	redirect "/admin/updateprice"
end

get "/admin/updateprice/deleteExtra/:id" do
	authenticate!
	extra = Extra.get(params[:id])
	extra.destroy
	redirect "/admin/updateprice"
end

get "/admin/updateprice" do
authenticate!
@haircuts = Haircuts.all(hair: true)

@beards = Haircuts.all(hair: false)
@extras = Extra.all

erb :priceUpdater
end
get "/admin/homeDashboard" do
	authenticate!
	erb :homeDashboard
end

get "/admin/registerBarbershop" do
	authenticate!
	erb :registerBarbershop
end

post "/addBarbershop" do
authenticate!
address = params["address"]
name = params["name"]
start = params["start"]
end1 = params["end"]
phone = params["phone"]
zip = params["zip"]

b = Barbershop.new

b.name = name
b.address = address
b.phone = phone
b.zipcode = zip
b.OpeningTime = start
b.ClosingTime = end1
b.uID = current_user.id

b.save

end

