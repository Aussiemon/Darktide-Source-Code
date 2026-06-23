-- chunkname: @scripts/settings/companion/companion_servo_skull_flamer_settings.lua

local companion_servo_skull_flamer_settings = {
	inventory_slot = "slot_full",
	vfx = {
		flamer_particle = "content/fx/particles/abilities/cryptic/companion_servo_skull_flamer_code_control",
		fx_source_name = "muzzle",
		max_range = 10,
		speed = 10,
	},
	sfx = {
		profile_properties_switch = "servo_skull_flame",
		sound_alias = "companion_servo_skull_flame_loop",
		source_name = "fx_muzzle",
	},
}

return settings("CompanionServoSkullFlamerSettings", companion_servo_skull_flamer_settings)
