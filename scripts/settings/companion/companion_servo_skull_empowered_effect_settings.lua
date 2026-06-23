-- chunkname: @scripts/settings/companion/companion_servo_skull_empowered_effect_settings.lua

local companion_servo_skull_empowered_effect_settings = {
	vfx = {
		effect_template_name = "content/fx/particles/abilities/cryptic/servoskull_empowered",
		fx_source_name = "fx_base",
	},
	sfx = {
		sound_alias = "companion_servoskull_empowered_loop",
		source_name = "base",
	},
}

return settings("CompanionServoSkullEmpoweredEffectSettings", companion_servo_skull_empowered_effect_settings)
