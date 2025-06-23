-- chunkname: @scripts/settings/breed/breed_blackboard_component_templates/companion_dog_blackboard_component_templates.lua

local companion_dog = {
	behavior = {
		is_out_of_bound = "boolean",
		has_move_to_position = "boolean",
		move_state = "string",
		current_state = "string",
		should_skip_start_anim = "boolean",
		move_to_position = "Vector3Box",
		owner_unit = "Unit"
	},
	follow = {
		last_owner_cooldown_time = "number",
		last_referenced_vector = "Vector3Box",
		current_owner_cooldown = "number",
		current_adaptive_angle_check_right = "number",
		current_movement_type = "string",
		current_movement_animation = "string",
		adaptive_angle_enlarge_t = "number",
		current_position_cooldown = "number",
		speed_reference = "number",
		current_adaptive_angle_check_left = "number"
	},
	perception = {
		previous_target_unit = "Unit",
		has_line_of_sight = "boolean",
		target_distance = "number",
		target_speed_away = "number",
		lock_target = "boolean",
		target_distance_z = "number",
		has_last_los_position = "boolean",
		ignore_alerted_los = "boolean",
		target_position = "Vector3Box",
		target_changed_t = "number",
		last_los_position = "Vector3Box",
		has_good_last_los_position = "boolean",
		target_changed = "boolean",
		target_unit = "Unit",
		aggro_state = "string"
	},
	spawn = {
		unit = "Unit",
		spawner_unit = "Unit",
		world = "World",
		game_object_id = "number",
		physics_world = "PhysicsWorld",
		is_exiting_spawner = "boolean",
		anim_translation_scale_factor = "number",
		game_session = "GameSession",
		spawner_spawn_index = "number"
	},
	aim = {
		lean_dot = "number",
		controlled_aim_position = "Vector3Box",
		controlled_aiming = "boolean"
	},
	nav_smart_object = {
		entrance_is_at_bot_progress_on_path = "boolean",
		exit_position = "Vector3Box",
		id = "number",
		type = "string",
		exit_is_at_the_end_of_path = "boolean",
		unit = "Unit",
		entrance_position = "Vector3Box"
	},
	disable = {
		attacker_unit = "Unit",
		is_disabled = "boolean",
		type = "string"
	},
	pounce = {
		has_pounce_started = "boolean",
		started_leap = "boolean",
		leap_node = "string",
		use_fast_jump = "boolean",
		pounce_cooldown = "number",
		has_jump_off_direction = "boolean",
		has_pounce_target = "boolean",
		target_hit_zone_name = "string",
		pounce_target = "Unit"
	},
	whistle = {
		current_target = "Unit"
	},
	movable_platform = {
		leave_teleport_position = "Vector3Box",
		unit_reference = "Unit",
		has_leave_teleport_position = "boolean",
		node = "string"
	},
	teleport = {
		teleport_position = "Vector3Box",
		has_teleport_position = "boolean"
	}
}
local companion_dog_hub = table.clone(companion_dog)

companion_dog_hub.hub_interaction_with_player = {
	has_owner_started_interaction = "boolean"
}
companion_dog_hub.movable_platform = nil

local templates = {
	companion_dog = companion_dog,
	companion_dog_hub = companion_dog_hub
}

return templates
