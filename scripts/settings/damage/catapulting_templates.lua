-- chunkname: @scripts/settings/damage/catapulting_templates.lua

local catapulting_templates = {}

catapulting_templates.plague_ogryn_catapult = {
	direction_from_node = "j_spine",
	force = 12,
	z_force = 6,
}
catapulting_templates.renegade_captain_kick_catapult = {
	direction_from_node = "j_spine",
	force = 10,
	z_force = 3,
}
catapulting_templates.renegade_captain_charge_catapult = {
	direction_from_node = "j_spine",
	force = 10,
	z_force = 3,
}
catapulting_templates.renegade_captain_void_shield_explosion_catapult = {
	direction_from_node = "j_spine",
	force = 14,
	z_force = 4,
}
catapulting_templates.renegade_captain_frag_grenade_close_catapult = {
	direction_from_node = "j_spine",
	force = 12,
	use_hit_position = true,
	z_force = 4,
}
catapulting_templates.renegade_captain_powermaul_ground_slam_catapult = {
	direction_from_node = "j_spine",
	force = 14,
	z_force = 4,
}
catapulting_templates.barrel_explosion = {
	direction_from_node = "j_spine",
	force = 12,
	use_hit_position = true,
	z_force = 6,
}
catapulting_templates.twin_gas_grenade_explosion = {
	direction_from_node = "j_spine",
	force = 7,
	use_hit_position = true,
	z_force = 4,
}
catapulting_templates.corruptor_emerge_explosion = {
	direction_from_node = "j_spine",
	force = 12,
	z_force = 3,
}
catapulting_templates.renegade_shocktrooper_frag_grenade_close_catapult = {
	direction_from_node = "j_spine",
	force = 12,
	z_force = 4,
}
catapulting_templates.poxwalker_bomber = {
	direction_from_node = "j_spine2",
	force = 11,
	z_force = 5,
}
catapulting_templates.poxwalker_bomber_close = {
	direction_from_node = "j_head",
	force = 13,
	z_force = 8,
}
catapulting_templates.breach_charge_catapult = {
	direction_from_node = "j_spine",
	force = 8,
	z_force = 2,
}

return settings("CatapultingTemplates", catapulting_templates)
