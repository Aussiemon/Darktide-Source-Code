-- chunkname: @scripts/settings/companion/companion_servo_skull_hacking_effect_settings.lua

local companion_servo_skull_hacking_effect_settings = {
	vfx = {
		flamer_particle = "content/fx/particles/interacts/servoskull_hack_ability",
		fx_source_name = "fx_scanning",
	},
	sfx = {
		profile_properties_switch = "",
		sound_alias = "companion_servo_skull_hack_loop",
		source_name = "fx_scanning",
	},
}

return settings("CompanionServoSkullHackingEffectSettings", companion_servo_skull_hacking_effect_settings)
