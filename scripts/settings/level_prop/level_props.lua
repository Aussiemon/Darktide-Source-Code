local props = {}

local function _create_prop_entry(path)
	local prop_data = require(path)
	local prop_name = prop_data.name
	props[prop_name] = prop_data
end

_create_prop_entry("scripts/settings/level_prop/props/corruptor_pustule")
_create_prop_entry("scripts/settings/level_prop/props/door_controlpanel_01")
_create_prop_entry("scripts/settings/level_prop/props/door_controlpanel_scan_airlock_01")
_create_prop_entry("scripts/settings/level_prop/props/luggable_socket")
_create_prop_entry("scripts/settings/level_prop/props/servo_skull")
_create_prop_entry("scripts/settings/level_prop/props/toxic_gas_volume")
_create_prop_entry("scripts/settings/level_prop/props/voice_over_2d")

return settings("LevelProps", props)
