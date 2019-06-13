require_relative "app.rb"

get "/aboutUs" do
	erb :aboutUs
end
get "/appointments/barbershop" do
	erb :appointments
end
get "/appointments/dayChoice" do
	erb :apptDayChoice
end
get "/appointments/stylistChoice" do
	@barbers = Barber.all
	erb :apptStylistChoice
end
get '/appointments/stylistAvailability' do
  erb :apptStylistAvailable
end
get '/appointments/haircut' do
	@hairtypes = Haircuts.all(hair: true)
	@beardtypes = Haircuts.all(hair: false)
	@extra = Extra.all
  erb :apptHaircut
end
get "/appointments/confirmAppt" do
	beardprice = 0
	hairprice = 0
	extraprice = 0
	if (params["hairtype"] != "N/A")
		hairtype = Haircuts.get(params["hairtype"])
		hairprice = hairtype.price
	end
	if (params["beardtype"] != "N/A")
		beardtype = Haircuts.get(params["beardtype"])
		beardprice = beardtype.price
	end
	if (params["extratype"] != "N/A")
		extratype = Extra.get(params["extratype"])
		extraprice = extratype.price
	end
	@cost = beardprice + hairprice + extraprice

	erb :apptFinalize
end