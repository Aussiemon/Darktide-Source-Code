-- chunkname: @scripts/settings/bot/bot_settings.lua

local bot_settings = {
	flat_move_to_previous_pos_epsilon = 0.25,
	flat_move_to_epsilon = 0.05,
	z_move_to_epsilon = 0.3,
	opportunity_target_reaction_times = {
		normal = {
			max = 20,
			min = 10
		}
	},
	behavior_gestalts = table.enum("none", "killshot", "linesman"),
	blackboard_component_config = {
		behavior = {
			forced_pickup_unit = "Unit",
			revive_with_urgent_target = "boolean",
			melee_gestalt = "string",
			target_ally_aid_destination = "Vector3Box",
			current_interaction_unit = "Unit",
			target_level_unit_destination = "Vector3Box",
			interaction_unit = "Unit",
			ranged_gestalt = "string"
		},
		follow = {
			level_forced_teleport_position = "Vector3Box",
			needs_destination_refresh = "boolean",
			destination = "Vector3Box",
			has_teleported = "boolean",
			moving_towards_follow_position = "boolean",
			level_forced_teleport = "boolean"
		},
		health_station = {
			needs_health_queue_number = "number",
			needs_health = "boolean",
			time_in_proximity = "number"
		},
		melee = {
			stop_at_current_position = "boolean",
			engage_position = "Vector3Box",
			engage_position_set = "boolean"
		},
		perception = {
			target_level_unit_distance = "number",
			target_enemy = "Unit",
			opportunity_target_enemy = "Unit",
			target_enemy_type = "string",
			aggro_target_enemy = "Unit",
			priority_target_disabled_ally = "Unit",
			target_ally_need_type = "string",
			target_ally_needs_aid = "boolean",
			target_enemy_reevaluation_t = "number",
			aggressive_mode = "boolean",
			force_aid = "boolean",
			target_ally_distance = "number",
			priority_target_enemy = "Unit",
			target_enemy_distance = "number",
			urgent_target_enemy = "Unit",
			target_ally = "Unit",
			aggro_target_enemy_distance = "number",
			target_level_unit = "Unit"
		},
		pickup = {
			needs_non_permanent_health = "boolean",
			mule_pickup = "Unit",
			ammo_pickup = "Unit",
			needs_ammo = "boolean",
			mule_pickup_distance = "number",
			allowed_to_take_health_pickup = "boolean",
			ammo_pickup_valid_until = "number",
			ammo_pickup_distance = "number",
			force_use_health_pickup = "boolean",
			health_deployable_valid_until = "number",
			health_deployable = "Unit",
			health_deployable_distance = "number"
		},
		ranged_obstructed_by_static = {
			target_unit = "Unit",
			t = "number"
		},
		spawn = {
			physics_world = "PhysicsWorld"
		}
	}
}

return settings("BotSettings", bot_settings)
