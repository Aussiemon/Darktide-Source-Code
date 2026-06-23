-- chunkname: @scripts/settings/equipment/weapon_handling_templates/weapon_chain_lightning_templates.lua

local weapon_chain_lightning_templates = {}

weapon_chain_lightning_templates.powermaul_p3_arc = {
	extra_angle_stat_buff = "chain_lightning_powermaul_max_angle",
	jump_time = 0.01,
	jump_time_multiplier_stat_buff = "chain_lightning_jump_time_multiplier",
	max_jumps = 2,
	max_jumps_stat_buff = "chain_lightning_powermaul_max_jumps",
	max_radius_stat_buff = "chain_lightning_powermaul_max_radius",
	max_z_diff_stat_buff = "chain_lightning_max_z_diff",
	staff = false,
	max_targets = {
		num_targets = 1,
	},
	max_angle = {
		lerp_basic = math.degrees_to_radians(25),
		lerp_perfect = math.degrees_to_radians(50),
	},
	close_max_angle = {
		lerp_basic = math.degrees_to_radians(35),
		lerp_perfect = math.degrees_to_radians(70),
	},
	radius = {
		lerp_basic = 3,
		lerp_perfect = 7.5,
	},
}
weapon_chain_lightning_templates.arc_rifle_p1_arc = {
	extra_angle_stat_buff = "chain_lightning_arc_rifle_max_angle",
	jump_time = 0.01,
	jump_time_multiplier_stat_buff = "chain_lightning_jump_time_multiplier",
	max_jumps = 1,
	max_jumps_stat_buff = "chain_lightning_arc_rifle_max_jumps",
	max_radius_stat_buff = "chain_lightning_arc_rifle_max_radius",
	max_z_diff_stat_buff = "chain_lightning_max_z_diff",
	staff = false,
	max_targets = {
		num_targets = 1,
	},
	max_angle = {
		lerp_basic = math.degrees_to_radians(25),
		lerp_perfect = math.degrees_to_radians(70),
	},
	radius = {
		lerp_basic = 2,
		lerp_perfect = 5.5,
	},
}
weapon_chain_lightning_templates.arc_rifle_p1_arc_braced = {
	extra_angle_stat_buff = "chain_lightning_arc_rifle_max_angle",
	jump_time = 0.01,
	jump_time_multiplier_stat_buff = "chain_lightning_jump_time_multiplier",
	max_jumps = 2,
	max_jumps_stat_buff = "chain_lightning_arc_rifle_max_jumps",
	max_radius_stat_buff = "chain_lightning_arc_rifle_max_radius",
	max_z_diff_stat_buff = "chain_lightning_max_z_diff",
	staff = false,
	max_targets = {
		num_targets = 1,
	},
	max_angle = {
		lerp_basic = math.degrees_to_radians(25),
		lerp_perfect = math.degrees_to_radians(70),
	},
	radius = {
		lerp_basic = 2,
		lerp_perfect = 5.5,
	},
}

return settings("WeaponChainLightningTemplates", weapon_chain_lightning_templates)
