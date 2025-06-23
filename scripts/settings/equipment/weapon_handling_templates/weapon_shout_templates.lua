-- chunkname: @scripts/settings/equipment/weapon_handling_templates/weapon_shout_templates.lua

local weapon_shout_templates = {}

weapon_shout_templates.powermaul_shield_p1_block_special = {
	shape = "cone",
	close_radius = 2.5,
	range = {
		lerp_perfect = 26.46,
		lerp_basic = 8
	},
	dot = {
		lerp_perfect = 0.85,
		lerp_basic = 0.35
	}
}

return settings("WeaponShoutTemplates", weapon_shout_templates)
