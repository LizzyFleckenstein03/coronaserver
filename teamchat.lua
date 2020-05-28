function coronaserver.teamchat_message(name, message)
	local msg = minetest.colorize("#08FF00", "(TEAMCHAT) ")
	if name then
		msg = msg .. coronaserver.get_player_name(name, {"<", ">"}) .. message
	else 
		msg = msg .. message
	end
	local players = minetest.get_connected_players()
	for _, player in pairs(players) do
		local name = player:get_player_name()
		if minetest.check_player_privs(name, {team = true}) then
			minetest.chat_send_player(name, msg)
		end
	end 
end


local teamchat_chatcommand_def = {
	param = "<nachricht>",
	description = "Etwas in dem Teamchat schreibem",
	privs = {team = true},
	func = coronaserver.teamchat_message
}

minetest.register_chatcommand("teamchat", teamchat_chatcommand_def)
minetest.register_chatcommand("t", teamchat_chatcommand_def)

minetest.register_on_mods_loaded(function()
	if not invis then return end
	local old_invis_toggle = invis.toggle
	function invis.toggle(player, toggle)
		old_invis_toggle(player, toggle)
		local name = type(player) == "userdata" and player:get_player_name() or player
		coronaserver.teamchat_message(nil, coronaserver.get_player_name(name) .. "ist jetzt" .. (invis.get(name) and "" or " nicht mehr") .. minetest.colorize("#00FFFC", " unsichtbar"))
		if not toggle then
			coronaserver.reload_name_tag(name)
		end
	end
end)
