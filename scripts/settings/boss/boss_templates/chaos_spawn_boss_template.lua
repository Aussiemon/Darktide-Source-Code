local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Trajectory = require("scripts/utilities/trajectory")
local LEAP_TRAJECTORY_CHECK_FREQUENCY = 1
local LEAP_SPEED = 14
local GRAVITY = 10
local ACCEPTABLE_ACCURACY = 0.1
local MAX_TIME_IN_FLIGHT = 2
local LEAP_COOLDOWN = 5
local MIN_LEAP_DISTANCE = 12
local MAX_LEAP_DISTANCE = 22
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
			local self_position = POSITION_LOOKUP[unit] + Vector3.up()
			local perception_component = template_data.perception_component
			local target_unit = perception_component.target_unit

			if not target_unit then
				return
			end

			local distance = perception_component.target_distance

			if distance < MIN_LEAP_DISTANCE or MAX_LEAP_DISTANCE < distance then
				return
			end

			local speed = LEAP_SPEED
			local gravity = GRAVITY
			local acceptable_accuracy = ACCEPTABLE_ACCURACY
			local slot_system = Managers.state.extension:system("slot_system")
			local target_position = slot_system:user_unit_slot_position(unit)

			if not target_position then
				return
			end

			local angle_to_hit_target, est_pos = Trajectory.angle_to_hit_moving_target(self_position, target_position, speed, Vector3(0, 0, 0), gravity, acceptable_accuracy)

			if not angle_to_hit_target then
				return
			end

			local velocity, time_in_flight = Trajectory.get_trajectory_velocity(self_position, est_pos, gravity, speed, angle_to_hit_target)
			time_in_flight = math.min(time_in_flight, MAX_TIME_IN_FLIGHT)
			local debug = nil
			local trajectory_is_ok = Trajectory.check_trajectory_collisions(physics_world, self_position, est_pos, gravity, speed, angle_to_hit_target, 10, "filter_minion_shooting_geometry", time_in_flight, nil, debug, unit)

			if trajectory_is_ok and not behavior_component.should_leap then
				behavior_component.leap_velocity:store(velocity)

				behavior_component.should_leap = true
				template_data.leap_cooldown = LEAP_COOLDOWN
			end

			template_data.next_leap_trajectory_check_t = t + LEAP_TRAJECTORY_CHECK_FREQUENCY
		end
	end,
	stop = function (template_data, template_context)
		return
	end
}

return template
