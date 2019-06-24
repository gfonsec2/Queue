require_relative "app.rb"

#admin functions
#add barber
#delete barber
#Dashboard
#Data table
#Calendar

require_relative "app.rb"

get "/aboutUs" do
	erb :aboutUs
end

get "/pricingPage" do
	erb :pricePage
end

get "/admin" do
	authenticate!
	authenticate2!
	if current_user.basic || current_user.pro 
	barbershops = current_user.barbershops
	if barbershops == nil
		redirect "/registerBarbershop"
	end
	@barbers = Barber.all
	@all = Appointment.all(valid: 0)
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
		b.save
		redirect "/admin/addbarber"
	else
		flash[:error] = "Must enter a name for new barber "
		redirect "/admin/addbarber"
	end
end	

get "/admin/addbarber" do
	authenticate!
	authenticate2!

	if current_user.administrator 
	@barbers = Barber.all
	erb :addBarber
	else 
	redirect "/login"
	end
end

get "/admin/delete/:id" do
	authenticate!
	authenticate2!
	if current_user.administrator 
		b = Barber.get(params[:id])
		b.destroy
		redirect "/admin/deletebarber"
	else
	redirect "/login"
	end
end

get "/admin/deletebarber" do
	authenticate!
	authenticate2!
	if current_user.administrator 
		@barbers = Barber.all
		erb :deleteBarber
	else
	redirect "/login"
end
end

get "/admin/updateprice/:id" do
	authenticate!
	authenticate2!
	haircut = Haircuts.get(params[:id])
	haircut.update(:price => params["price"])
	haircut.save
	redirect "/admin/updateprice"
end

get "/admin/updateprice/extra/:id" do
	authenticate!
	authenticate2!
	e = Extra.get(params[:id])
	e.update(:price => params["price"])
	e.save
	redirect "/admin/updateprice"
end

get "/admin/updateprice/delete/:id" do
	authenticate!
	authenticate2!
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
	authenticate2!
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
	authenticate2!
	if current_user.administrator
	extra = Extra.get(params[:id])
	extra.destroy
	redirect "/admin/updateprice"
	else
	redirect "/login"
	end
end

get "/admin/datatable" do
	erb :datatable
end

get "/admin/calendar" do
	erb :calendar
end
get "/admin/updateprice" do
	authenticate2!
@haircuts = Haircuts.all(hair: true)

@beards = Haircuts.all(hair: false)
@extras = Extra.all

erb :priceUpdater
end
get "/admin/homeDashboard" do
	erb :homeDashboard
end

