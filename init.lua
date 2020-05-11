coronaserver = {}

local modules = {"save", "privs", "ranks", "playerlist", "commands"}

for _, m in pairs(modules) do
    dofile(minetest.get_modpath("coronaserver") .. "/" .. m .. ".lua")
end
