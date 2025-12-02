-- chunkname: @scripts/extension_systems/unit_data/player_husk_data_component_config.lua

local husk_data_component_config = {
	character_state = {
		"state_name",
	},
	assisted_state_input = {
		"in_progress",
	},
	locomotion_steering = {
		"hub_active_stopping",
		"move_method",
	},
	first_person = {
		"position",
		"rotation",
		"previous_rotation",
		"height",
	},
	first_person_mode = {
		"wants_1p_camera",
		"show_1p_equipment_at_t",
	},
	camera_tree = {
		"tree",
		"node",
	},
	alternate_fire = {
		"is_active",
	},
	weapon_action = {
		"current_action_name",
		"previous_action_name",
		"special_active_at_start",
		"start_t",
		"template_name",
		"time_scale",
	},
	combat_ability_action = {
		"current_action_name",
		"template_name",
	},
	sway = {
		"pitch",
		"yaw",
		"offset_x",
		"offset_y",
	},
	spread = {
		"pitch",
		"yaw",
	},
	suppression = {
		"sway_pitch",
		"sway_yaw",
		"spread_pitch",
		"spread_yaw",
		"time",
		"decay_time",
	},
	recoil = {
		"pitch_offset",
		"yaw_offset",
	},
	stamina = {
		"current_fraction",
	},
	action_aim_projectile = {
		"rotation",
		"position",
	},
	action_flamer_gas = {
		"range",
	},
	action_throw_luggable = {
		"thrown",
	},
	block = {
		"is_blocking",
	},
	inventory = {
		"slot_primary",
		"slot_secondary",
		"slot_pocketable",
		"slot_pocketable_small",
		"wielded_slot",
	},
	slot_primary = {
		"current_ammunition_clip",
		"current_ammunition_clips_in_use",
		"current_ammunition_reserve",
		"max_ammunition_clip",
		"max_ammunition_reserve",
		"overheat_starting_percentage",
		"overheat_current_percentage",
		"special_active",
		"reload_state",
		"num_special_charges",
		"max_num_special_charges",
	},
	slot_secondary = {
		"current_ammunition_clip",
		"current_ammunition_reserve",
		"current_ammunition_clips_in_use",
		"max_ammunition_clip",
		"max_ammunition_reserve",
		"overheat_starting_percentage",
		"overheat_current_percentage",
		"special_active",
		"reload_state",
		"num_special_charges",
		"max_num_special_charges",
	},
	minigame_character_state = {
		"interface_game_object_id",
		"interface_is_level_unit",
		"interface_level_unit_id",
		"pocketable_device_active",
	},
	slot_luggable = {
		"existing_unit_3p",
	},
	action_module_charge = {
		"charge_level",
	},
	critical_strike = {
		"is_active",
	},
	exploding_character_state = {
		"is_exploding",
	},
	sprint_character_state = {
		"is_sprinting",
		"sprint_overtime",
	},
	ledge_hanging_character_state = {
		"is_interactible",
	},
	lunge_character_state = {
		"is_lunging",
		"is_aiming",
		"lunge_template",
	},
	hub_jog_character_state = {
		"move_state",
	},
	movement_state = {
		"method",
	},
	talent_resource = {
		"current_resource",
		"max_resource",
	},
	weapon_tweak_templates = {
		"sway_template_name",
		"recoil_template_name",
	},
	action_sweep = {
		"is_sticky",
		"sweep_aborted_unit",
		"sweep_aborted_actor_index",
	},
	grenade_ability = {
		"active",
	},
	combat_ability = {
		"active",
	},
	pocketable_ability = {
		"active",
	},
	scanning = {
		"is_active",
		"line_of_sight",
		"scannable_unit",
	},
	peeking = {
		"is_peeking",
	},
}

return husk_data_component_config
