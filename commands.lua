minetest.register_chatcommand("getip", {
	description = "Get the IP of a player",
	params = "<player>",
	privs = {server = true},
	func = function(name, param)
		if minetest.get_player_by_name(param) then
			minetest.chat_send_player(name, "IP of " .. param .. ": " .. minetest.get_player_information(param).address)
		else
			minetest.chat_send_player(name, "Player is not online.")
		end
	end
})

minetest.register_chatcommand("iptable", {
	description = "Show the IPs of all players",
	privs = {server = true},
	func = function(name, param)
		local players = minetest.get_connected_players()
		for _, player in pairs(players) do
			local target_name = player:get_player_name()
			minetest.chat_send_player(name, target_name .. " | " .. minetest.get_player_information(target_name).address)
		end
	end
})

minetest.register_chatcommand("sudo", {
	description = "Force other players to run commands",
	params = "<player> <command> <arguments...>",
	privs = {server = true},
	func = function(name, param)
		local target = param:split(" ")[1]
		local command = param:split(" ")[2]
		local argumentsdisp
		local cmddef = minetest.chatcommands
		local _, _, arguments = string.match(param, "([^ ]+) ([^ ]+) (.+)")
		if not arguments then arguments = "" end
		if target and command then
			if cmddef[command] then
				if minetest.get_player_by_name(target) then
					if arguments == "" then argumentsdisp = arguments else argumentsdisp = " " .. arguments end
					cmddef[command].func(target, arguments)
				else
					minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid Player."))
				end
			else
				minetest.chat_send_player(name, minetest.colorize("#FF0000", "Nonexistant Command."))
			end
		else
			minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid Usage."))
		end
	end
})


minetest.register_chatcommand("wielded", {
	params = "",
	description = "Print Itemstring of wielded Item",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
        if player then
            local item = player:get_wielded_item()
            if item then 
                minetest.chat_send_player(name, item:get_name())
            end
        end
	end,
})

minetest.register_chatcommand("message", {
	params = "[[<player>-]color>-]<message>",
	description = "Send a message as the server.",
	privs = {server = true},
	func = function(player, param)
        coronaserver.message(param)
	end,
})

minetest.register_chatcommand("creator", {
	privs = {server = true},
	description = "Den Ersteller des Items anzeigen, was man in der Hand hat, wenn es im Kreativmodus erstellt wurde",
	func = function(name)
		local player = minetest.get_player_by_name(name)
		if not player then return end
		local itemstack = player:get_wielded_item()
		if not itemstack then return false, "Du hast gereade kein Item in der Hand" end
		local meta = itemstack:get_meta()
		local creator = meta:get_string("creator")
		if creator == "" then return false, "Dieses Item wurde nicht im Kreativmodus erstellt" end
		return true, creator .. " hat dieses Item erstellt"
	end
})

