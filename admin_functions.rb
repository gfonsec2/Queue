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
	erb :admin, :layout => :admin_layout
	#flash[:success] = "succesfully logged in"
	end
	#redirect "/login"
end

post "/admin/addbarber" do 
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

get "/admin/new" do
	authenticate!
	if current_user.administrator 
	erb :new_barber, :layout => :admin_layout
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
		erb :deletebarber, :layout => :admin_layout
	else
	redirect "/login"
end
end

# post "/admin/haircuts"
# 	authenticate!
# end
