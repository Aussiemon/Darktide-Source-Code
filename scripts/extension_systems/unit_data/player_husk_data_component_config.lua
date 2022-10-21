local husk_data_component_config = {
	character_state = {
		"state_name"
	},
	assisted_state_input = {
		"in_progress"
	},
	locomotion_steering = {
		"hub_active_stopping",
		"move_method"
	},
	first_person = {
		"position",
		"rotation",
		"previous_rotation",
		"height"
	},
	first_person_mode = {
		"wants_1p_camera",
		"show_1p_equipment_at_t"
	},
	camera_tree = {
		"tree",
		"node"
	},
	alternate_fire = {
		"is_active"
	},
	weapon_action = {
		"template_name",
		"current_action_name",
		"previous_action_name",
		"start_t",
		"special_active_at_start"
	},
	sway = {
		"pitch",
		"yaw",
		"offset_x",
		"offset_y"
	},
	spread = {
		"pitch",
		"yaw"
	},
	suppression = {
		"sway_pitch",
		"sway_yaw",
		"spread_pitch",
		"spread_yaw",
		"time",
		"decay_time"
	},
	recoil = {
		"pitch_offset",
		"yaw_offset"
	},
	stamina = {
		"current_fraction"
	},
	action_aim_projectile = {
		"rotation",
		"position"
	},
	action_flamer_gas = {
		"range"
	},
	action_throw = {
		"thrown"
	},
	block = {
		"is_blocking"
	},
	inventory = {
		"slot_primary",
		"slot_secondary",
		"slot_pocketable",
		"wielded_slot"
	},
	slot_primary = {
		"current_ammunition_clip",
		"current_ammunition_reserve",
		"max_ammunition_clip",
		"max_ammunition_reserve",
		"overheat_starting_percentage",
		"overheat_current_percentage",
		"special_active"
	},
	slot_secondary = {
		"current_ammunition_clip",
		"current_ammunition_reserve",
		"max_ammunition_clip",
		"max_ammunition_reserve",
		"overheat_starting_percentage",
		"overheat_current_percentage",
		"special_active"
	},
	minigame_character_state = {
		"interface_unit_id"
	},
	slot_luggable = {
		"existing_unit_3p"
	},
	action_module_charge = {
		"charge_level"
	},
	critical_strike = {
		"is_active"
	},
	exploding_character_state = {
		"is_exploding"
	},
	sprint_character_state = {
		"is_sprinting",
		"sprint_overtime"
	},
	ledge_hanging_character_state = {
		"is_interactible"
	},
	lunge_character_state = {
		"is_lunging",
		"is_aiming",
		"lunge_template"
	},
	hub_jog_character_state = {
		"move_state"
	},
	movement_state = {
		"method"
	},
	specialization_resource = {
		"current_resource",
		"max_resource"
	},
	weapon_tweak_templates = {
		"sway_template_name",
		"recoil_template_name"
	},
	action_sweep = {
		"is_sticky",
		"sweep_aborted_unit",
		"sweep_aborted_actor_index"
	},
	grenade_ability = {
		"active"
	},
	combat_ability = {
		"active"
	},
	scanning = {
		"is_active",
		"line_of_sight",
		"scannable_unit"
	}
}

return husk_data_component_config
