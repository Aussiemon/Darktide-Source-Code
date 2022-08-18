local prop_data = {}

local function _create_prop_data_entry(path)
	local data = require(path)
	local name = data.name

	fassert(name, "[PropData] Missing name field in %q.", path)

	prop_data[name] = data
end

_create_prop_data_entry("scripts/settings/prop_data/props/corruptor_body")
_create_prop_data_entry("scripts/settings/prop_data/props/corruptor_pustule")
_create_prop_data_entry("scripts/settings/prop_data/props/hazard_prop")
_create_prop_data_entry("scripts/settings/prop_data/props/hazard_sphere")

return settings("PropData", prop_data)
