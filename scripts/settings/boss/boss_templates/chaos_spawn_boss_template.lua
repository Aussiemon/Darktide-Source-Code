local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local ChaosSpawnSettings = require("scripts/settings/monster/chaos_spawn_settings")
local NavQueries = require("scripts/utilities/nav_queries")
local Trajectory = require("scripts/utilities/trajectory")
local LEAP_TRAJECTORY_CHECK_FREQUENCY = 0.2
local COLLISION_FILTER = "filter_minion_line_of_sight_check"
local template = {
	name = "chaos_spawn",
	start = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_data.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		template_data.breed = unit_data_extension:breed()
		local blackboard = BLACKBOARDS[unit]
		local behavior_component = Blackboard.write_component(blackboard, "behavior")
		template_data.behavior_component = behavior_component
		local perception_component = Blackboard.write_component(blackboard, "perception")
		template_data.perception_component = perception_component
		local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
		local nav_world = navigation_extension:nav_world()
		template_data.nav_world = nav_world
		template_data.navigation_extension = navigation_extension
		local spawn_component = blackboard.spawn
		template_data.physics_world = spawn_component.physics_world
		template_data.next_leap_trajectory_check_t = 0
		template_data.leap_cooldown = 0
	end,
	update = function (template_data, template_context, dt, t)
		if not template_context.is_server then
			return
		end

		template_data.leap_cooldown = math.max(template_data.leap_cooldown - dt, 0)

		if template_data.leap_cooldown > 0 then
			return
		end

		local behavior_component = template_data.behavior_component

		if behavior_component.move_state ~= "attacking" and template_data.next_leap_trajectory_check_t <= t then
			local physics_world = template_data.physics_world
			local unit = template_data.unit
			local slot_system = Managers.state.extension:system("slot_system")
			local target_position = slot_system:user_unit_slot_position(unit)

			if not target_position then
				return
			end

			local self_position = POSITION_LOOKUP[unit]
			local towards_target_position = Vector3.normalize(target_position - POSITION_LOOKUP[unit])
			local navmesh_position = self_position + towards_target_position * ChaosSpawnSettings.leap_fwd_check_distance
			navmesh_position = NavQueries.position_on_mesh(template_data.nav_world, navmesh_position, 1, 4)

			if not navmesh_position then
				return
			end

			navmesh_position = navmesh_position + Vector3.up()
			self_position = self_position + Vector3.up()
			target_position = target_position + Vector3.up()
			local perception_component = template_data.perception_component
			local target_unit = perception_component.target_unit

			if not target_unit then
				return
			end

			local distance = perception_component.target_distance

			if distance < ChaosSpawnSettings.min_leap_distance or ChaosSpawnSettings.max_leap_distance < distance then
				return
			end

			local navmesh_to_target_distance = Vector3.distance(navmesh_position, target_position)

			if navmesh_to_target_distance < 5 then
				return
			end

			local to_navmesh_position = navmesh_position - self_position
			local direction = Vector3.normalize(to_navmesh_position)
			local ray_distance = Vector3.length(to_navmesh_position)
			local result, hit_position = PhysicsWorld.raycast(physics_world, self_position, direction, ray_distance, "closest", "collision_filter", COLLISION_FILTER)

			if hit_position then
				return
			end

			local speed = ChaosSpawnSettings.leap_speed
			local gravity = ChaosSpawnSettings.leap_gravity
			local acceptable_accuracy = 0.1
			local angle_to_hit_target, est_pos = Trajectory.angle_to_hit_moving_target(navmesh_position, target_position, speed, Vector3(0, 0, 0), gravity, acceptable_accuracy)

			if not angle_to_hit_target then
				return
			end

			local velocity, time_in_flight = Trajectory.get_trajectory_velocity(navmesh_position, est_pos, gravity, speed, angle_to_hit_target)
			time_in_flight = math.min(time_in_flight, ChaosSpawnSettings.leap_max_time_in_flight)
			local debug = nil
			local trajectory_is_ok = Trajectory.check_trajectory_collisions(physics_world, navmesh_position, est_pos, gravity, speed, angle_to_hit_target, 10, "filter_minion_shooting_geometry", time_in_flight, nil, debug, unit)

			if trajectory_is_ok and not behavior_component.should_leap then
				behavior_component.leap_velocity:store(velocity)

				behavior_component.should_leap = true
				template_data.leap_cooldown = ChaosSpawnSettings.leap_cooldown
			end

			template_data.next_leap_trajectory_check_t = t + LEAP_TRAJECTORY_CHECK_FREQUENCY
		end
	end,
	stop = function (template_data, template_context)
		return
	end
}

return template
