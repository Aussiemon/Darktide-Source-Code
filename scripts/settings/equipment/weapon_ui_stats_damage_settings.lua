-- chunkname: @scripts/settings/equipment/weapon_ui_stats_damage_settings.lua

local bit = require("bit")
local WeaponUIStatsDamageOptions = {
	DAMAGE_BODY = 1,
	DAMAGE_FINESSE = 2,
	DAMAGE_NONE = 0,
}

WeaponUIStatsDamageOptions.DAMAGE_ALL = bit.bor(WeaponUIStatsDamageOptions.DAMAGE_BODY, WeaponUIStatsDamageOptions.DAMAGE_FINESSE)

return WeaponUIStatsDamageOptions
