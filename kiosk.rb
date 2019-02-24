require_relative "app.rb"

get "/kiosk" do
	@hairtypes = Haircuts.all(hair: true)
	@beardtypes = Haircuts.all(hair: false)
	@barbers = Barber.all(available: true)

	erb :kiosk
end

get "/infomessage" do
	beardprice = 0
	hairtype = Haircuts.get(params["hairtype"])
	if(params["beardtype"] == "N/A")

	else
		beardtype = Haircuts.get(params["beardtype"])
		beardprice = beardtype.price
	end
	b = Barber.get(params["id"])
	n = params["name"]
	cost = beardprice + hairtype.price
	 

	b.total += cost
	b.save

	q = Queueitem.new
	q.name = n
	q.bid = b.id
	q.price = cost
	q.save
	@cus = q

	erb :infoMessage
end
