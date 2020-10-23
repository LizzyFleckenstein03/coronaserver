coronaserver = {}

local modules = {"functions", "privs", "ranks", "playerlist", "commands", "teamchat", "spirit"}

for _, m in pairs(modules) do
    dofile(minetest.get_modpath("coronaserver") .. "/" .. m .. ".lua")
end
