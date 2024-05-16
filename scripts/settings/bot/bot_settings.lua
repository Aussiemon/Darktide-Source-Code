-- chunkname: @scripts/settings/bot/bot_settings.lua

local bot_settings = {
	flat_move_to_epsilon = 0.05,
	flat_move_to_previous_pos_epsilon = 0.25,
	z_move_to_epsilon = 0.3,
	opportunity_target_reaction_times = {
		normal = {
			max = 20,
			min = 10,
		},
	},
	behavior_gestalts = table.enum("none", "killshot", "linesman"),
	blackboard_component_config = {
		behavior = {
			current_interaction_unit = "Unit",
			forced_pickup_unit = "Unit",
			interaction_unit = "Unit",
			melee_gestalt = "string",
			ranged_gestalt = "string",
			revive_with_urgent_target = "boolean",
			target_ally_aid_destination = "Vector3Box",
			target_level_unit_destination = "Vector3Box",
		},
		follow = {
			destination = "Vector3Box",
			has_teleported = "boolean",
			level_forced_teleport = "boolean",
			level_forced_teleport_position = "Vector3Box",
			moving_towards_follow_position = "boolean",
			needs_destination_refresh = "boolean",
		},
		health_station = {
			needs_health = "boolean",
			needs_health_queue_number = "number",
			time_in_proximity = "number",
		},
		melee = {
			engage_position = "Vector3Box",
			engage_position_set = "boolean",
			stop_at_current_position = "boolean",
		},
		perception = {
			aggressive_mode = "boolean",
			aggro_target_enemy = "Unit",
			aggro_target_enemy_distance = "number",
			force_aid = "boolean",
			opportunity_target_enemy = "Unit",
			priority_target_disabled_ally = "Unit",
			priority_target_enemy = "Unit",
			target_ally = "Unit",
			target_ally_distance = "number",
			target_ally_need_type = "string",
			target_ally_needs_aid = "boolean",
			target_enemy = "Unit",
			target_enemy_distance = "number",
			target_enemy_reevaluation_t = "number",
			target_enemy_type = "string",
			target_level_unit = "Unit",
			target_level_unit_distance = "number",
			urgent_target_enemy = "Unit",
		},
		pickup = {
			allowed_to_take_health_pickup = "boolean",
			ammo_pickup = "Unit",
			ammo_pickup_distance = "number",
			ammo_pickup_valid_until = "number",
			force_use_health_pickup = "boolean",
			health_deployable = "Unit",
			health_deployable_distance = "number",
			health_deployable_valid_until = "number",
			mule_pickup = "Unit",
			mule_pickup_distance = "number",
			needs_ammo = "boolean",
			needs_non_permanent_health = "boolean",
		},
		ranged_obstructed_by_static = {
			t = "number",
			target_unit = "Unit",
		},
		spawn = {
			physics_world = "PhysicsWorld",
		},
	},
}

return settings("BotSettings", bot_settings)
