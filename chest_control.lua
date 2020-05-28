coronaserver.savedata.suspect_items = coronaserver.savedata.suspect_items or {}
minetest.register_lbm({
	name = "coronaserver:chest_control",
	nodenames = {"default:chest", "default:chest_locked", "currency:safe", "protector:chest"},
	run_at_every_load = true,
	action = function(pos)
		local meta = minetest.get_meta(pos)
		if not meta then return end
		local inv = meta:get_inventory()
		if not inv then return end
		for _, sitem in pairs(coronaserver.savedata.suspect_items) do
			if inv:contains_item("main", sitem) then
				coronaserver.teamchat_message(nil, "Verdächtige Kiste bei Position " .. minetest.pos_to_string(pos))
			end
		end
	end
}) 
minetest.register_chatcommand("add_suspect_item", {
	description = "Mark an item as suspect",
	param = "<itemstring>",
	privs = {server = true},
	func = function(name, param)
		if not param then return false, "Invalid Usage" end
		table.insert(coronaserver.savedata.suspect_items, param)
		return true, param .. " added to suspect items"
	end
})
minetest.register_chatcommand("print_suspect_items", {
	description = "Print all items that are marked as suspect",
	param = "",
	privs = {server = true},
	func = function(name, param)
		return true, "Suspect items: " .. table.concat(coronaserver.savedata.suspect_items, ", ")
	end
})
minetest.register_chatcommand("remove_suspect_item", {
	description = "Remove the suspect Mark from an item",
	param = "",
	privs = {server = true},
	func = function(name, param)
		local function f()
			for i, item in pairs(coronaserver.savedata.suspect_items) do
				if item == param then
					table.remove(coronaserver.savedata.suspect_items, i)
					return 1 + f()
				end
			end
			return 0
		end
		return true, "Removed " .. tostring(f()) .. " from list"
	end
})
