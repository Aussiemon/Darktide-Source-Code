-- chunkname: @scripts/settings/weapon_unlock_settings.lua

local unlock_config = {
	adamant = require("scripts/settings/weapon_unlock_settings_adamant"),
	broker = require("scripts/settings/weapon_unlock_settings_broker"),
	ogryn = require("scripts/settings/weapon_unlock_settings_ogryn"),
	psyker = require("scripts/settings/weapon_unlock_settings_psyker"),
	veteran = require("scripts/settings/weapon_unlock_settings_veteran"),
	zealot = require("scripts/settings/weapon_unlock_settings_zealot"),
}
local weapon_unlock_settings = {}

for archetype_name, archetype_level_unlocks in pairs(unlock_config) do
	if not weapon_unlock_settings[archetype_name] then
		weapon_unlock_settings[archetype_name] = {}
	end

	for index, level_unlocks in pairs(archetype_level_unlocks) do
		local level = level_unlocks.level
		local items = level_unlocks.items

		weapon_unlock_settings[archetype_name][level] = table.shallow_copy(items)
	end
end

table.clear(unlock_config)

unlock_config = nil

return settings("WeaponUnlockSettings", weapon_unlock_settings)
