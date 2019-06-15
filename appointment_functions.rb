require_relative "app.rb"

get "/aboutUs" do
	erb :aboutUs
end
get "/appointments/barbershop" do
	@barbers = Barber.all
	@hairtypes = Haircuts.all(hair: true)
	@beardtypes = Haircuts.all(hair: false)
	@extra = Extra.all
	erb :appointments
end
get "/appointments/dayChoice" do
	@hairname = @beardname = @extraname = "N/A"
	@shop = params["barberShop"]
	@day = params["dayChoice"]
	@customer = params["name"]
	@cost = 0
	if (params["hairtype"] != "N/A")
		@hairtype = Haircuts.get(params["hairtype"])
		@hairname = @hairtype.hair_type
		@cost += @hairtype.price
	end
	if (params["beardtype"] != "N/A")
		@beardtype = Haircuts.get(params["beardtype"])
		@beardname = @beardtype.hair_type
		@cost += @beardtype.price
	end
	if (params["extratype"] != "N/A")
		@extratype = Extra.get(params["extratype"])
		@extraname = @extratype.name
		@cost += @extratype.price
	end

	b = Barber.get(params["id"])
	n = params["name"]
	@barberName = b.name
	 

	#b.total += cost
	b.save

	q = Queueitem.new
	q.name = n
	q.bid = b.id
	q.price = @cost
	q.save
	@cus = q

	erb :apptDayChoice
end