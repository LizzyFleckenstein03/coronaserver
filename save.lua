function coronaserver.load()
	local file = io.open(minetest.get_worldpath() .. "/coronaserver", "r")
	if file then
		coronaserver.savedata = minetest.deserialize(file:read())
		file:close()
	else
		coronaserver.savedata = {}
	end
end
function coronaserver.save()
	local file = io.open(minetest.get_worldpath() .. "/coronaserver", "w")
	file:write(minetest.serialize(coronaserver.savedata))
	file:close()
end
coronaserver.load() 
minetest.register_on_shutdown(coronaserver.save)
