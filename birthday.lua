coronaserver.savedata.birthday = coronaserver.savedata.birthday or {}
function coronaserver.flower_rain(name)
	local player = minetest.get_player_by_name(name)
	if not player then
		return
	end
	local pos = player:get_pos()
	minetest.add_particlespawner({
		amount = 50,
		time = 2,
		minpos = vector.add(pos, {x = -1, y = 2, z = -1}),
		maxpos = vector.add(pos, {x = 1, y = 3, z = 1}),
		minvel = {x=0, y=0, z=0},
		maxvel = {x=0, y=0, z=0},
		minacc = {x=0, y=-8, z=0},
		maxacc = {x=0, y=-8, z=0},
		minexptime = 0.7,
		maxexptime = 1,
		minsize = 5,
		maxsize = 10,
		collisiondetection = true,
		vertical = true,
		texture = "flowers_rose.png",
	})
	minetest.after(0.5, function() coronaserver.flower_rain(name) end)
end
minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	if coronaserver.savedata.birthday[name] == os.date("%d.%m") then
		minetest.chat_send_all(minetest.colorize("#FF20FF", name .. " hat heute Geburtstag!"))
		coronaserver.flower_rain(name)
		player:hud_add({
			hud_elem_type = "text",
			position      = {x = 1, y = 0},
			offset        = {x = -5, y = 5},
			text          = "Happy Birthday!",
			alignment     = {x = -1, y = 1},
			scale         = {x = 100, y = 100},
			number    = 0xFFF40A,
		})
	end
end)
minetest.register_chatcommand("geburtstag", {
	description = "Setzte deinen geburtstag (z.b. 07.09 wenn du am 7. September Geburtstag hast)",
	param = "TT.MM",
	func = function(name, param)
		coronaserver.savedata.birthday[name] = param
		coronaserver.save()
		minetest.chat_send_player(name, "Geburtstag auf den " .. param .. " gesetzt")
	end
})
