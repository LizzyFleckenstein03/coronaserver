coronaserver = {}

local modules = {"functions", "privs", "ranks", "playerlist", "commands", "teamchat", "chest_control"}

for _, m in pairs(modules) do
    dofile(minetest.get_modpath("coronaserver") .. "/" .. m .. ".lua")
end
