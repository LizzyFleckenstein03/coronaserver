function coronaserver.message(message)
    if not message then 
        return 
    end
    local name = message:split('-')[1] 
	local color = message:split('-')[2]
	local msg = message:split('-')[3]
    if not msg then
        msg = color
        color = name
        name = nil
    end
    if not msg then 
        msg = color
        color = "#FFFFFF"
    end
    if not msg then
        return
    end
    print(name, color, msg)
    msg = minetest.colorize(color, msg)
    if name then
        minetest.chat_send_player(name, msg)
    else
        minetest.chat_send_all(msg)
    end
end


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
