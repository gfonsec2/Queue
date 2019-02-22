require_relative "app.rb"

def addhaircuts
	u = Haircuts.new
	u.hair = true
	u.hair_type = "Regular Cut"
	u.price = 15
	u.save

	u1 = Haircuts.new
	u1.hair = true
	u1.hair_type = "Skin Haircut"
	u1.price = 15
	u1.save

	u2 = Haircuts.new
	u2.hair = true
	u2.hair_type = "Head Shave"
	u2.price = 15
	u2.save

	u3 = Haircuts.new
	u3.hair = true
	u3.hair_type = "Clean up"
	u3.price = 15
	u3.save

	u4 = Haircuts.new
	u4.hair = false
	u4.hair_type = "Beard clean up"
	u4.price = 15
	u4.save

	u5 = Haircuts.new
	u5.hair = false
	u5.hair_type = "Beard shave"
	u5.price = 15
	u5.save

	u6 = Haircuts.new
	u6.hair = false
	u6.hair_type = "Razer clean up"
	u6.price = 15
	u6.save
end