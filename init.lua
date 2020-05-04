coronaserver = {}

local modules = {"save", "grantall", "birthday"}

for _, m in pairs(modules) do
    dofile(minetest.get_modpath("coronaserver") .. "/" .. m .. ".lua")
end
