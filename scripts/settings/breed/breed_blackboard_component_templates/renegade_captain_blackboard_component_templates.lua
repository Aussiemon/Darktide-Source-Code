local ranged_templates = require("scripts/settings/breed/breed_blackboard_component_templates/ranged_blackboard_component_templates")
local renegade_captain = table.clone(ranged_templates.ranged_base)
renegade_captain.suppression = nil
renegade_captain.behavior = table.clone(ranged_templates.netgunner.behavior)
renegade_captain.phase = {
	lock = "boolean",
	force_next_phase = "boolean",
	exit_phase_t = "number",
	wanted_phase = "string",
	current_phase = "string"
}
renegade_captain.nearby_units_broadphase = {
	next_broadphase_t = "number",
	num_units = "number"
}
renegade_captain.toughness = {
	max_toughness = "number",
	toughness_percent = "number",
	toughness_damage = "number"
}
renegade_captain.available_attacks = {
	hellgun_shoot = "boolean",
	shoot_net = "boolean",
	powermaul_ground_slam_attack = "boolean",
	bolt_pistol_strafe_shoot = "boolean",
	power_sword_melee_combo_attack = "boolean",
	charge = "boolean",
	void_shield_explosion = "boolean",
	bolt_pistol_shoot = "boolean",
	punch = "boolean",
	shotgun_shoot = "boolean",
	kick = "boolean",
	shotgun_strafe_shoot = "boolean",
	hellgun_strafe_shoot = "boolean",
	frag_grenade = "boolean",
	power_sword_moving_melee_attack = "boolean",
	hellgun_spray_and_pray = "boolean",
	fire_grenade = "boolean",
	hellgun_sweep_shoot = "boolean"
}
renegade_captain.record_state = {
	has_disabled_player = "boolean"
}
local templates = {
	renegade_captain = renegade_captain
}

return templates
