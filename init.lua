coronaserver = {}

local modules = {"save", "advprivs", "ranks", "playerlist"}

for _, m in pairs(modules) do
    dofile(minetest.get_modpath("coronaserver") .. "/" .. m .. ".lua")
end
