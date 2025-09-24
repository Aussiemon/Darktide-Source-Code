-- chunkname: @scripts/settings/breed/breed_blackboard_component_templates/companion_dog_blackboard_component_templates.lua

local companion_dog = {
	behavior = {
		current_state = "string",
		has_move_to_position = "boolean",
		is_out_of_bound = "boolean",
		move_state = "string",
		move_to_position = "Vector3Box",
		owner_unit = "Unit",
		should_skip_start_anim = "boolean",
	},
	follow = {
		adaptive_angle_enlarge_t = "number",
		current_adaptive_angle_check_left = "number",
		current_adaptive_angle_check_right = "number",
		current_movement_animation = "string",
		current_movement_type = "string",
		current_owner_cooldown = "number",
		current_position_cooldown = "number",
		last_owner_cooldown_time = "number",
		last_referenced_vector = "Vector3Box",
		speed_reference = "number",
	},
	perception = {
		aggro_state = "string",
		has_good_last_los_position = "boolean",
		has_last_los_position = "boolean",
		has_line_of_sight = "boolean",
		ignore_alerted_los = "boolean",
		last_los_position = "Vector3Box",
		lock_target = "boolean",
		previous_target_unit = "Unit",
		target_changed = "boolean",
		target_changed_t = "number",
		target_distance = "number",
		target_distance_z = "number",
		target_position = "Vector3Box",
		target_speed_away = "number",
		target_unit = "Unit",
	},
	spawn = {
		anim_translation_scale_factor = "number",
		game_object_id = "number",
		game_session = "GameSession",
		is_exiting_spawner = "boolean",
		physics_world = "PhysicsWorld",
		spawner_spawn_index = "number",
		spawner_unit = "Unit",
		unit = "Unit",
		world = "World",
	},
	aim = {
		controlled_aim_position = "Vector3Box",
		controlled_aiming = "boolean",
		lean_dot = "number",
	},
	nav_smart_object = {
		entrance_is_at_bot_progress_on_path = "boolean",
		entrance_position = "Vector3Box",
		exit_is_at_the_end_of_path = "boolean",
		exit_position = "Vector3Box",
		id = "number",
		type = "string",
		unit = "Unit",
	},
	pounce = {
		has_jump_off_direction = "boolean",
		has_pounce_started = "boolean",
		has_pounce_target = "boolean",
		leap_node = "string",
		pounce_cooldown = "number",
		pounce_target = "Unit",
		started_leap = "boolean",
		target_hit_zone_name = "string",
		use_fast_jump = "boolean",
	},
	whistle = {
		current_target = "Unit",
	},
	movable_platform = {
		has_leave_teleport_position = "boolean",
		leave_teleport_position = "Vector3Box",
		node = "string",
		unit_reference = "Unit",
	},
	teleport = {
		has_teleport_position = "boolean",
		teleport_position = "Vector3Box",
	},
}
local companion_dog_hub = table.clone(companion_dog)

companion_dog_hub.hub_interaction_with_player = {
	has_owner_started_interaction = "boolean",
}
companion_dog_hub.behavior.is_out_of_bound = nil
companion_dog_hub.pounce = nil
companion_dog_hub.whistle = nil
companion_dog_hub.movable_platform = nil

local templates = {
	companion_dog = companion_dog,
	companion_dog_hub = companion_dog_hub,
}

return templates
