require_relative "app.rb"

#admin functions
#add barber
#delete barber
#Dashboard
#Data table
#Calendar

get "/admin/date" do
	erb :testDate
end

get "/aboutUs" do
	erb :aboutUs
end
get "/pricingPage" do
	erb :pricePage
end

get "/admin" do
	authenticate!
	if current_user.administrator 
	@barbers = Barber.all(shop_id: current_user.id)
	@all = Appointment.all(valid: 0)
	@all.each do |a|
		a.destroy
	end
	erb :homeDashboard
	#flash[:success] = "succesfully logged in"
	end
	#redirect "/login"
end

$barbers
$customers
$revenue
$totalCustomers
$totalRevenue
$startDate
$endDate

post "/admin/report" do
	if current_user.administrator
	@startDate = params["startDate"]
	@endDate = params["endDate"]
	$startDate = @startDate
	$endDate = @endDate
	first = @startDate.split('-')
	second = @endDate.split('-')
	@startYear = first[0]
	@startMonth = first[1]
	@startDay = first[2]
	@endYear = second[0]
	@endMonth = second[1]
	@endDay = second[2]

	@queues = Queueitem.all(:created.gte => Date.parse(@startDate)) & Queueitem.all(:created.lte => Date.parse(@endDate)) & Queueitem.all(:shop_id.eql => current_user.id)
	@barbers = Barber.all(shop_id: current_user.id)
	@totalRevenue = 0
	@customers = 0

	@barbersArray = Array.new
	@barberNameArray = Array.new
	@totalArray = Array.new
	@numberCustomers = Array.new
	@index = 0
	@index2 = 0

	@queues.each do |q|
		@totalRevenue += q.price
		@customers += 1
		if @barbersArray.include?(q.bid)
			@index = @barbersArray.index(q.bid)
			@totalArray[@index] += q.price
			@numberCustomers[@index] += 1
		else
			@barbersArray.push(q.bid)
			@tempBarber = Barber.get(q.bid)
			@barberNameArray.push(@tempBarber.name)
			@totalArray.push(q.price)
			@numberCustomers.push(1)
			@index2 += 1
		end
	end

	$barbers = @barberNameArray
	$customers = @numberCustomers
	$revenue = @totalArray
	$totalCustomers = @customers
	$totalRevenue = @totalRevenue

	@all = Appointment.all(valid: 0)
	@all.each do |a|
		a.destroy
	end
	erb :revenueReport
	end
end

get "/admin/downloadpdf" do
	Prawn::Document.generate('revenueReport.pdf') do
		pad_bottom(10) { text "Revenue Report", :size => 25}
		stroke_horizontal_rule
		pad(20) { text "Dates: #{$startDate} through #{$endDate}" }
		data = [ ["Barber Name", "Visitors", "Revenue"] ]
		table(data, :column_widths => [270, 135, 135], :row_colors => ["F0F0F0"])
		$barbers.each_index do |i|
			data = [["#{$barbers[i]}", "#{$customers[i]}", "$#{$revenue[i]}.00"]]
			table(data, :column_widths => [270, 135, 135])
		end
		data = [ ["Total Visitors: #{$totalCustomers}", "Total Revenue: $#{$totalRevenue}.00"] ]
		table(data, :column_widths => [135, 135], :position => :right)
		create_stamp("approved") do
			rotate(30, :origin => [-5, -5]) do
				stroke_color "FF3333"
				stroke_ellipse [0, 0], 29, 15
				stroke_color "000000"
				fill_color "993333"
				font("Times-Roman") do
					draw_text "Approved", :at => [-23, -3]
				end
				fill_color "000000"
			end
		end
		stamp "approved"
	end
	redirect "/admin"
end

post "/admin/new" do 
	if params["name"] != ""
		b = Barber.new
		b.name = params["name"]
		b.shop_id = current_user.id
		b.phone = params["phone"]
		b.insta = params["insta"]
		b.snap = params["snap"]
		b.twitter = params["twitter"]
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
	@barbers = Barber.all(shop_id: current_user.id)
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
		@barbers = Barber.all(shop_id: current_user.id)
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
		h.shop_id = current_user.id
		h.save
	elsif(type == "beard")
		h = Haircuts.new
		h.hair = false
		h.hair_type = name
		h.price = price
		h.shop_id= current_user.id
		h.save
	else
		e = Extra.new
		e.name = name
		e.price = price
		e.shop_id = current_user.id
		e.save
	end
	redirect "/admin/updateprice"
end

get "/admin/updateprice/deleteExtra/:id" do
	authenticate!
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
@haircuts = Haircuts.all(hair: true) & Haircuts.all(shop_id: current_user.id)

@beards = Haircuts.all(hair: false) & Haircuts.all(shop_id: current_user.id)
@extras = Extra.all(shop_id: current_user.id)

erb :priceUpdater
end
get "/admin/homeDashboard" do
	erb :homeDashboard
end

get "/admin/viewAppointments" do
	@appointments = Appointment.all(valid: 1)
	erb :viewAppointments
end

get "/admin/deleteAppointment/:id" do
	authenticate!
	if current_user.administrator
	app = Appointment.get(params[:id])
	app.destroy
	redirect "/admin/viewAppointments"
else
	redirect "/login"
end
end