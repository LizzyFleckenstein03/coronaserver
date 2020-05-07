coronaserver.ranks = {
	{
		name = "owner",
		color = "#FF2D8D",
		tag = "[OWNER]",
	},
	{
		name = "admin",
		color = "#FF362D",
		tag = "[ADMIN]",
	},
	{
		name = "moderator",
		color = "#001FFF",
		tag = "[MODERATOR]",
	},
	{
		name = "supporter",
		color = "#EE6E00",
		tag = "[SUPPORTER]",
	},
	{
        name = "player",
        color = "#FFFFFF",
        tag = "[PLAYER]",
    }
}
coronaserver.savedata.ranks = coronaserver.savedata.ranks or {}
function coronaserver.get_rank(name)
    return coronaserver.get_rank_by_name(coronaserver.savedata.ranks[name] or "player")
end
function coronaserver.get_rank_by_name(rankname)
	for _, rank in pairs(coronaserver.ranks) do
		if rank.name == rankname then
			return rank
		end
	end
end
function coronaserver.get_player_name(name, brackets)
    local rank = coronaserver.get_rank(name)
    local rank_tag = minetest.colorize(rank.color, rank.tag)
	if not brackets then 
		brackets = {"",""}
	end
	return rank_tag .. brackets[1] .. name .. brackets[2] .. " "
end
minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
    minetest.chat_send_all(coronaserver.get_player_name(name) .. "has joined the Server.")
    player:set_nametag_attributes({color = coronaserver.get_rank(name).color})
end)
minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
    minetest.chat_send_all(coronaserver.get_player_name(name) .. "has left the Server.")
end)
minetest.register_on_chat_message(function(name, message)
    minetest.chat_send_all(coronaserver.get_player_name(name, {"<", ">"}) .. message)
    return true
end)
minetest.register_chatcommand("rank", {
	params = "<player> <rank>",
	description = "Einem Spieler einen Rang geben (owner|admin|moderator|supporter)",
	privs = {privs = true},
	func = function(admin, param)
		local name = param:split(' ')[1]
		local player = minetest.get_player_by_name(name)
        local rank = coronaserver.get_rank_by_name(param:split(' ')[2])
		if not rank then 
            minetest.chat_send_player(admin,"Invalid Rank.")
        else
			coronaserver.savedata.ranks[name] = rank.name
			coronaserver.save()
			if player then
				player:set_nametag_attributes({color = rank.color})
			end
			minetest.chat_send_all(name .. " ist jetzt ein " .. minetest.colorize(rank.color, rank.name))
		end
	end,
})
