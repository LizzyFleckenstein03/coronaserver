local spirit = false

function coronaserver.spirit(player)
	minetest.add_particlespawner({
		amount = 50,
		time = 2,
		minpos = {x = -0.1, y = 0, z = -0.1},
		maxpos = {x =  0.1, y = 1, z =  0.1},
		minvel = {x = -0.1, y = 0, z = -0.1},
		maxvel = {x =  0.1, y = 0, z = -0.1},
		minacc = {x = -0.1, y = 5, z = -0.1},
		maxacc = {x =  0.1, y = 7, z =  0.1},
		minexptime = 0.7,
		maxexptime = 1,
		minsize = 5,
		maxsize = 7,
		collisiondetection = true,
		vertical = false,
		texture = "fire_basic_flame.png",
		attached = player,
	})
end

minetest.register_on_joinplayer(function(player)
	if spirit then
		coronaserver.spirit(player)
	end
end)

minetest.register_chatcommand("spirit", {
	privs = {server = true},
	func = function()
		spirit = true
		for _, player in pairs(minetest.get_connected_players()) do
			coronaserver.spirit(player)
		end
	end
})
