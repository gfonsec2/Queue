require_relative "app.rb"

get "/kiosk" do
	@hairtypes = Haircuts.all(hair: true)
	@beardtypes = Haircuts.all(hair: false)
	@extra = Extra.all
	@barbers = Barber.all(available: true)
	erb :kiosk
end

get "/infomessage" do
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
	b = Barber.get(params["id"])
	n = params["name"]
	cost = beardprice + hairprice + extraprice
	#b.total += cost
	b.save
	q = Queueitem.new
	q.name = n
	q.bid = b.id
	q.price = cost
	q.save
	@cus = q
	erb :infoMessage
end
