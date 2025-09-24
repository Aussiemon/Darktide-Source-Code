-- chunkname: @scripts/settings/breed/breed_blackboard_component_templates/renegade_captain_blackboard_component_templates.lua

local ranged_templates = require("scripts/settings/breed/breed_blackboard_component_templates/ranged_blackboard_component_templates")
local renegade_captain = table.clone(ranged_templates.ranged_base)

renegade_captain.suppression = nil
renegade_captain.behavior = table.clone(ranged_templates.netgunner.behavior)
renegade_captain.phase = {
	current_phase = "string",
	exit_phase_t = "number",
	force_next_phase = "boolean",
	lock = "boolean",
	wanted_phase = "string",
}
renegade_captain.nearby_units_broadphase = {
	next_broadphase_t = "number",
	num_units = "number",
}
renegade_captain.toughness = {
	max_toughness = "number",
	toughness_damage = "number",
	toughness_percent = "number",
}
renegade_captain.available_attacks = {
	bolt_pistol_shoot = "boolean",
	bolt_pistol_strafe_shoot = "boolean",
	charge = "boolean",
	fire_grenade = "boolean",
	frag_grenade = "boolean",
	hellgun_shoot = "boolean",
	hellgun_spray_and_pray = "boolean",
	hellgun_strafe_shoot = "boolean",
	hellgun_sweep_shoot = "boolean",
	kick = "boolean",
	power_sword_melee_combo_attack = "boolean",
	power_sword_moving_melee_attack = "boolean",
	powermaul_ground_slam_attack = "boolean",
	punch = "boolean",
	shoot_net = "boolean",
	shotgun_shoot = "boolean",
	shotgun_strafe_shoot = "boolean",
	void_shield_explosion = "boolean",
}
renegade_captain.patrol = {
	auto_patrol = "boolean",
	patrol_id = "number",
	patrol_index = "number",
	patrol_leader_unit = "Unit",
	should_patrol = "boolean",
	walk_position = "Vector3Box",
}
renegade_captain.record_state = {
	has_disabled_player = "boolean",
}
renegade_captain.disable = nil
renegade_captain.stim = {
	can_use_stim = "boolean",
	currently_using_stim = "boolean",
	t_til_use = "number",
}

local templates = {
	renegade_captain = renegade_captain,
}

return templates
