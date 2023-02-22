local base_template = {
	spawn = {
		game_object_id = "number",
		game_session = "GameSession",
		world = "World",
		is_exiting_spawner = "boolean",
		physics_world = "PhysicsWorld",
		unit = "Unit",
		anim_translation_scale_factor = "number",
		spawner_unit = "Unit"
	},
	death = {
		hit_during_death = "boolean",
		force_instant_ragdoll = "boolean",
		hit_zone_name = "string",
		damage_profile_name = "string",
		herding_template_name = "string",
		is_dead = "boolean",
		killing_damage_type = "string",
		attack_direction = "Vector3Box"
	},
	stagger = {
		stagger_strength_multiplier = "number",
		num_triggered_staggers = "number",
		count = "number",
		type = "string",
		controlled_stagger_finished = "boolean",
		length = "number",
		immune_time = "number",
		stagger_pool_last_modified = "number",
		direction = "Vector3Box",
		controlled_stagger = "boolean",
		attacker_unit = "Unit",
		duration = "number",
		stagger_strength_pool = "number"
	},
	perception = {
		previous_target_unit = "Unit",
		has_line_of_sight = "boolean",
		target_distance = "number",
		target_speed_away = "number",
		lock_target = "boolean",
		target_distance_z = "number",
		target_changed_t = "number",
		ignore_alerted_los = "boolean",
		target_position = "Vector3Box",
		target_changed = "boolean",
		target_unit = "Unit",
		aggro_state = "string"
	},
	nav_smart_object = {
		entrance_is_at_bot_progress_on_path = "boolean",
		exit_position = "Vector3Box",
		id = "number",
		type = "string",
		exit_is_at_the_end_of_path = "boolean",
		unit = "Unit",
		entrance_position = "Vector3Box"
	}
}

return base_template
