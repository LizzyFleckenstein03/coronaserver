coronaserver.savedata.grantall = coronaserver.savedata.grantall or {}
coronaserver.savedata.revokeall = coronaserver.savedata.revokeall or {}

function coronaserver.update_privs(player)
	local name = player:get_player_name()
	local privs = minetest.get_player_privs(name)
	for _, priv in pairs(coronaserver.savedata.grantall) do
		privs[priv] = true
	end
	for _, priv in pairs(coronaserver.savedata.revokeall) do
		privs[priv] = nil
	end
	minetest.set_player_privs(name, privs)
end

function coronaserver.update_privs_all()
	local players = minetest.get_connected_players()
	for _, player in pairs(players) do
		coronaserver.update_privs(player)
	end
end

minetest.register_on_joinplayer(coronaserver.update_privs)

minetest.register_chatcommand("grantall", {
	description = "Grant a privilegue to players when they join",
	param = "<priv>",
	privs = {privs = true},
	func = function(name, param)
		table.insert(coronaserver.savedata.grantall, param)
		coronaserver.update_privs_all()
	end
})

minetest.register_chatcommand("revokeall", {
	description = "Revoke a privilegue from players when they join",
	param = "<priv>",
	privs = {privs = true},
	func = function(name, param)
		table.insert(coronaserver.savedata.revokeall, param)
		coronaserver.update_privs_all()
	end
})


minetest.register_chatcommand("remove_from_allprivs", {
	description = "Remove a priv from /grantall or /revokeall",
	param = "<priv>",
	privs = {privs = true},
	func = function(name, param)
		local function rmpriv(tab)
			for i, priv in pairs(tab) do
				if priv == param then
					table.remove(tab, i)
					return rmpriv(tab)
				end
			end
		end
		rmpriv(coronaserver.savedata.revokeall)
		rmpriv(coronaserver.savedata.grantall)
	end
})

minetest.register_chatcommand("show_allprivs", {
	description = "Show list of /grantall and /revokall ",
	param = "<priv>",
	privs = {privs = true},
	func = function(name, param)
		minetest.chat_send_player(name, "/grantall: " .. table.concat(coronaserver.savedata.grantall, ", "))
		minetest.chat_send_player(name, "/revokeall: " .. table.concat(coronaserver.savedata.revokeall, ", "))
	end
})

