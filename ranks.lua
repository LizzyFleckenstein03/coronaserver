coronaserver.ranks = {
	{
		name = "evil",
		color = "#4E4E4E",
		tag = "[BÖSE]",
		privs = {shout = true},
	},
	{
        name = "student",
        color = "#BBBBBB",
        tag = "[SPIELER*IN]",
        privs = {student = true, interact = true, fast = true, spawn = true, home = true, zoom = true, pvp = true, iblocks = true},
    },
	{
        name = "vip",
        color = "#00E5FF",
        tag = "[VIP]",
        privs = {},
    },
	{
		name = "feuerwehr",
		color = "#000000",
		tag = "[FEUERWEHR]",
		privs = {},
	},
	{
		name = "psupporter",
		color = "#FF9C48",
		tag = "[PROBE-SUPPORTER]",
		privs = {team = true, student = false,},
	},
   	{
        name = "teacher",
        color = "#16AE00",
        tag = "[LEHRER*IN / PÄDAGOG*IN]",
        privs = {team = false, fly = true, teacher = true, creative = true, areas = true,  basic_privs = true, teleport = true, bring = true}
    },
	{
		name = "supporter",
		color = "#EE6E00",
		tag = "[SUPPORTER]",
		privs = {kick = true, team = true},
	},
	{
		name = "moderator",
		color = "#001FFF",
		tag = "[MODERATOR]",
		privs = {server = true, ban = true, worldedit = true, vanish = true, ["rename"] = true},
	},
	{
		name = "developer",
		color = "#EBEE00",
		tag = "[ENTWICKLER*IN]",
		privs = {privs = true},
	},
	{
		name = "admin",
		color = "#FF362D",
		tag = "[ADMIN]",
		privs = {},
	},
	{
		name = "owner",
		color = "#FF2D8D",
		tag = "[OWNER]",
		privs = {},
	},
}
coronaserver.savedata.ranks = coronaserver.savedata.ranks or {}
function coronaserver.get_rank(name)
    return coronaserver.get_rank_by_name(coronaserver.savedata.ranks[name] or "student")
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
function coronaserver.reload_name_tag(name)
	local player = minetest.get_player_by_name(name)
	if not player then return end
	player:set_nametag_attributes({color = coronaserver.get_rank(name).color})
end
minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	local rank = coronaserver.get_rank(name)
	local privs = minetest.get_player_privs(name)
	local rankname = rank.name
	if rankname == "hacker" then rankname = "student" end
	if rankname == "student" and privs.teacher then rankname = "teacher" end
	if privs.kick then privs.team = true end
	minetest.set_player_privs(name, privs)
	coronaserver.savedata.ranks[name] = (rankname == "student") and nil or rankname
    minetest.chat_send_all(coronaserver.get_player_name(name) .. "has joined the Server.")
	coronaserver.reload_name_tag(name)
end)
minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
    minetest.chat_send_all(coronaserver.get_player_name(name) .. "has left the Server.")
end)
minetest.register_on_chat_message(function(name, message)
    minetest.chat_send_all(coronaserver.get_player_name(name, {"<", ">"}) .. message)
    minetest.log("[CHAT] <" .. name .. "> " .. message)
    return true
end)
minetest.register_chatcommand("rank", {
	params = "<player> <rank>",
	description = "Einem Spieler einen Rang geben (owner|admin|moderator|developer|supporter|teacher|student)",
	privs = {privs = true},
	func = function(name, param)
		local target = param:split(" ")[1] or ""
		local rank = param:split(" ")[2] or ""
		local target_ref = minetest.get_player_by_name(target)
		local rank_ref = coronaserver.get_rank_by_name(rank)
		if not rank_ref then 
            minetest.chat_send_player(name, "Invalider Rang: " .. rank)
        else
			coronaserver.savedata.ranks[target] = rank
			local privs = {}
			for _, r in pairs(coronaserver.ranks) do
				for k, v in pairs(r.privs) do
					privs[k] = v
				end
				if r.name == rank then
					break
				end
			end
			minetest.set_player_privs(target, privs)
			minetest.chat_send_all(target .. "s Rang ist jetzt " .. minetest.colorize(rank_ref.color, rank_ref.name))
			coronaserver.reload_name_tag(target)
		end
	end,
})
minetest.register_privilege("team", "Team Member")
