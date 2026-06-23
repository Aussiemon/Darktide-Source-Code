-- chunkname: @scripts/settings/companion/companion_servo_skull_heal_effect_settings.lua

local companion_servo_skull_heal_effect_settings = {
	inventory_slot = "slot_full",
	vfx = {
		fx_source_name = "fx_heal",
		heal_particle = nil,
	},
	sfx = {
		sound_alias = "companion_servo_skull_heal_loop",
		source_name = "fx_heal",
	},
}

return settings("CompanionServoSkullHealEffectSettings", companion_servo_skull_heal_effect_settings)
