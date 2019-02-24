require_relative "app.rb"

#admin functions
#add barber
#delete barber
#Dashboard
#Data table
#Calendar

get "/admin" do
	authenticate!
	if current_user.administrator 
	@barbers = Barber.all
	erb :homeDashboard
	#flash[:success] = "succesfully logged in"
	end
	#redirect "/login"
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
	if current_user.administrator 
	erb :addBarber
	else 
	redirect "/login"
	end
end

get "/admin/delete/:id" do
	authenticate!
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
	if current_user.administrator 
		@barbers = Barber.all

		erb :deleteBarber

	else
	redirect "/login"
end
end

get "/admin/updateprice/:id" do
	authenticate!
	haircut = Haircuts.get(params[:id])
	haircut.update(:price => params["price"])
	haircut.save
	redirect "/admin/updateprice"
end

get "/admin/datatable" do
	erb :datatable
end

get "/admin/Calendar" do
	erb :calendar
end
get "/admin/updateprice" do
@haircuts = Haircuts.all(hair: true)

@beards = Haircuts.all(hair: false)

erb :priceUpdater
end

