-- chunkname: @scripts/settings/damage/catapulting_templates.lua

local catapulting_templates = {}

catapulting_templates.plague_ogryn_catapult = {
	force = 12,
	z_force = 6,
	direction_from_node = "j_spine"
}
catapulting_templates.renegade_captain_kick_catapult = {
	force = 10,
	z_force = 3,
	direction_from_node = "j_spine"
}
catapulting_templates.renegade_captain_charge_catapult = {
	force = 10,
	z_force = 3,
	direction_from_node = "j_spine"
}
catapulting_templates.renegade_captain_void_shield_explosion_catapult = {
	force = 14,
	z_force = 4,
	direction_from_node = "j_spine"
}
catapulting_templates.renegade_captain_frag_grenade_close_catapult = {
	force = 12,
	z_force = 4,
	direction_from_node = "j_spine"
}
catapulting_templates.renegade_captain_powermaul_ground_slam_catapult = {
	force = 14,
	z_force = 4,
	direction_from_node = "j_spine"
}
catapulting_templates.barrel_explosion = {
	force = 12,
	z_force = 6,
	direction_from_node = "j_spine",
	use_hit_position = true
}
catapulting_templates.corruptor_emerge_explosion = {
	force = 12,
	z_force = 3,
	direction_from_node = "j_spine"
}
catapulting_templates.renegade_shocktrooper_frag_grenade_close_catapult = {
	force = 12,
	z_force = 4,
	direction_from_node = "j_spine"
}
catapulting_templates.poxwalker_bomber = {
	force = 11,
	z_force = 5,
	direction_from_node = "j_spine2"
}
catapulting_templates.poxwalker_bomber_close = {
	force = 13,
	z_force = 8,
	direction_from_node = "j_head"
}
catapulting_templates.breach_charge_catapult = {
	force = 8,
	z_force = 2,
	direction_from_node = "j_spine"
}

return settings("CatapultingTemplates", catapulting_templates)
