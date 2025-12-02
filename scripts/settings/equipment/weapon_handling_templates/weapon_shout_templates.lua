-- chunkname: @scripts/settings/equipment/weapon_handling_templates/weapon_shout_templates.lua

local weapon_shout_templates = {}

weapon_shout_templates.powermaul_shield_p1_block_special = {
	close_radius = 2.5,
	shape = "cone",
	range = {
		lerp_basic = 8,
		lerp_perfect = 26.46,
	},
	dot = {
		lerp_basic = 0.35,
		lerp_perfect = 0.85,
	},
}
weapon_shout_templates.missile_launcher_knockback = {
	close_radius = 0,
	shape = "cone",
	range = {
		lerp_basic = 6,
		lerp_perfect = 6,
	},
	dot = {
		lerp_basic = 0.5,
		lerp_perfect = 0.5,
	},
}

return settings("WeaponShoutTemplates", weapon_shout_templates)
