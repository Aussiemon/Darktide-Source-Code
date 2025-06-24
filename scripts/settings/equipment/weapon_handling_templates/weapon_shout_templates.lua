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

return settings("WeaponShoutTemplates", weapon_shout_templates)
