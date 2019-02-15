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
		redirect "/admin"
	else
		flash[:error] = "Must enter a name for new barber "
		redirect "/admin"
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
		redirect "/admin"
	else
	redirect "/login"
end
end

get "/admin/delete" do
	authenticate!
	if current_user.administrator 
		@barbers = Barber.all

		erb :deleteBarber

	else
	redirect "/login"
end
end

patch "/admin/haircuts" do
	authenticate!
	haircut = Haircuts.get(params[id])
end

get "/admin/datatable" do

end

get "/admin/updateprices" do

end

