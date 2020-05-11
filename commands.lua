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
 
