require_relative "app.rb"

get "/aboutUs" do
	erb :aboutUs
end
get "/appointments/barbershop" do
	app = Appointment.new
	app.save
	@appointment = app.id
	erb :apptBarberShop
end

post "/appointments/stylistChoice/:id" do
	@barbers = Barber.all
	currentAppt = Appointment.get(params[:id])
	@id = params[:id]
	currentAppt.shopName = params["barberShop"]
	currentAppt.save
	@shopName = currentAppt.shopName
	erb :apptStylistChoice
end

get "/appointments/stylistAvailability/:id/:bid" do
	currentAppt = Appointment.get(params[:id])
	currentAppt.barberID = params[:bid]
	currentAppt.save
	@id = params[:id]
	@barberName = Barber.get(currentAppt.barberID)
	erb :apptDayChoice
end

post "/appointments/haircuts/:id" do
	@hairtypes = Haircuts.all(hair: true)
	@beardtypes = Haircuts.all(hair: false)
	@extra = Extra.all
	currentAppt = Appointment.get(params[:id])
	currentAppt.day = params["weekDay"]
	currentAppt.time = params["time"]
	@id = params[:id]
	currentAppt.save
	@shopName = currentAppt.shopName
	erb :apptHaircut
end

post "/appointments/payment/:id" do
	currentAppt = Appointment.get(params[:id])
	currentAppt.hairID = params["hairtype"]
	currentAppt.beardID = params["beardtype"]
	currentAppt.extraID = params["extratype"]
	currentAppt.save
	@cost = 0
	if (params["hairtype"] != "0")
		@hairtype = Haircuts.get(currentAppt.hairID)
		@hairname = @hairtype.hair_type
		@cost += @hairtype.price
	end
	if (params["beardtype"] != "0")
		@beardtype = Haircuts.get(currentAppt.beardID)
		@beardname = @beardtype.hair_type
		@cost += @beardtype.price
	end
	if (params["extratype"] != "0")
		@extratype = Extra.get(currentAppt.extraID)
		@extraname = @extratype.name
		@cost += @extratype.price
	end
	currentAppt.cost = @cost
	currentAppt.save
	@id = params[:id]
	erb :apptFinalize
end

post "/appointments/confirmation/:id" do
	currentAppt = Appointment.get(params[:id])
	currentAppt.name = params["pname"]
	currentAppt.save
	@barber = Barber.get(currentAppt.barberID)
	@hairname = @beardname = @extraname = "None"
	if (currentAppt.hairID != 0)
		hairtype = Haircuts.get(currentAppt.hairID)
		@hairname = hairtype.hair_type
	end
	if (currentAppt.beardID != 0)
		beardtype = Haircuts.get(currentAppt.beardID)
		@beardname = beardtype.hair_type
	end
	if (currentAppt.extraID != 0)
		extratype = Extra.get(currentAppt.extraID)
		@extraname = extratype.name
	end
	@name = currentAppt.name
	@shopName = currentAppt.shopName
	@day = currentAppt.day
	@time = currentAppt.time
	@barberName = @barber.name
	@cost = currentAppt.cost
	erb :apptSuccessMessage
end