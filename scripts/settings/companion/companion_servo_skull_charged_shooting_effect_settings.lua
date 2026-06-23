-- chunkname: @scripts/settings/companion/companion_servo_skull_charged_shooting_effect_settings.lua

local companion_servo_skull_charged_shooting_effect_settings = {
	vfx = {
		charge_up = "content/fx/particles/weapons/rifles/lasgun/lasgun_chargeup_skull_yellow",
		charge_variable_name = "charge_level",
		max_value = 3,
		source_name = "fx_muzzle",
	},
	sfx = {
		sound_alias = "companion_servo_skull_charge_shoot",
	},
}

return settings("CompanionServoSkullChargedShootingEffectSettings", companion_servo_skull_charged_shooting_effect_settings)
