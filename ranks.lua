local function ReverseTable(t)
    local reversedTable = {}
    local itemCount = #t
    for k, v in ipairs(t) do
        reversedTable[itemCount + 1 - k] = v
    end
    return reversedTable
end
coronaserver.ranks = {
	{
		name = "owner",
		color = "#FF2D8D",
		tag = "[OWNER]",
		privs = {},
	},
	{
		name = "admin",
		color = "#FF362D",
		tag = "[ADMIN]",
		privs = {},
	},
	{
		name = "hacker",
		color = "#000000",
		tag = "[HACKER]",
		privs = {},
	},
	{
		name = "developer",
		color = "#EBEE00",
		tag = "[DEVELOPER]",
		privs = {privs = true},
	},
	},
	{
		name = "moderator",
		color = "#001FFF",
		tag = "[MODERATOR]",
		privs = {server = true, ban = true, worldedit = true, vanish = true, ["rename"] = true},
	},
	{
		name = "supporter",
		color = "#EE6E00",
		tag = "[SUPPORTER]",
		privs = {kick = true},
	},
	{
        name = "teacher",
        color = "#16AE00",
        tag = "[TEACHER]",
        privs = {fly = true, teacher = true, creative = true, areas = true, student = false}
    },
	{
        name = "student",
        color = "#BBBBBB",
        tag = "[STUDENT]",
        privs = {student = true},
    }
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
minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	if coronaserver.get_rank(name).name == "student" and minetest.check_player_privs(name, {teacher = true}) then
		coronaserver.savedata.ranks[name] = "teacher"
		coronaserver.save()
	end
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
	description = "Einem Spieler einen Rang geben (owner|admin|moderator|developer|supporter|teacher|student)",
	privs = {privs = true},
	func = function(name, param)
		local target = param:split(" ")[1]
		local rank = param:split(" ")[2]
		local target_ref = minetest.get_player_by_name(target)
		local rank_ref = coronaserver.get_rank_by_name(rank)
		if not rank_ref then 
            minetest.chat_send_player(name, "Invalider Rang: " .. (rank or ""))
        else
			coronaserver.savedata.ranks[target] = rank
			local privs = {}
			for _, r in pairs(ReverseTable(coronaserver.ranks)) do
				for k, v in pairs(r.privs) do
					privs[k] = v
				end
				if r.name == rank then
					break
				end
			end
			minetest.set_player_privs(target, privs)
			minetest.chat_send_all(target .. " is now a " .. minetest.colorize(rank_ref.color, rank_ref.name))
			if target_ref then
				target_ref:set_nametag_attributes({color = rank_ref.color})
			end
		end
	end,
})
