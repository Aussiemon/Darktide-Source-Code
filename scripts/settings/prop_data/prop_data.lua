-- chunkname: @scripts/settings/prop_data/prop_data.lua

local prop_data = {}

local function _create_prop_data_entry(path)
	local data = require(path)
	local name = data.name

	prop_data[name] = data
end

_create_prop_data_entry("scripts/settings/prop_data/props/corruptor_body_prop_data")
_create_prop_data_entry("scripts/settings/prop_data/props/corruptor_pustule_prop_data")
_create_prop_data_entry("scripts/settings/prop_data/props/druglab_tank_prop_data")
_create_prop_data_entry("scripts/settings/prop_data/props/druglab_tank_shield_prop_data")
_create_prop_data_entry("scripts/settings/prop_data/props/filtration_tank_prop_data")
_create_prop_data_entry("scripts/settings/prop_data/props/hazard_prop_prop_data")
_create_prop_data_entry("scripts/settings/prop_data/props/hazard_sphere_prop_data")
_create_prop_data_entry("scripts/settings/prop_data/props/heresy_altar")
_create_prop_data_entry("scripts/settings/prop_data/props/ice_chunk_prop_data")
_create_prop_data_entry("scripts/settings/prop_data/props/icicle_prop_data")
_create_prop_data_entry("scripts/settings/prop_data/props/nurgle_totem")
_create_prop_data_entry("scripts/settings/prop_data/props/train_cogitator_prop_data")

return settings("PropData", prop_data)
