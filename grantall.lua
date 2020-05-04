coronaserver.savedata.grantall = coronaserver.savedata.grantall or {}

function coronaserver.update_privs(player)
	local name = player:get_player_name()
	local privs = minetest.get_player_privs(name)
	for _, priv in pairs(coronaserver.savedata.grantall) do
		privs[priv] = true
	end
	minetest.set_player_privs(name, privs)
end

minetest.register_on_joinplayer(coronaserver.update_privs)

minetest.register_chatcommand("grantall", {
	description = "Grant a privilegue to players when they join",
	param = "<priv>",
	privs = {privs = true},
	func = function(name, param)
		coronaserver.savedata.grantall[#coronaserver.savedata.grantall] = param
		local players = minetest.get_connected_players()
		for _, player in pairs(players) do
			coronaserver.update_privs(player)
		end
		coronaserver.save()
	end
})

