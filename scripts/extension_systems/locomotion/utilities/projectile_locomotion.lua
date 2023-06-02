local HitZone = require("scripts/utilities/attack/hit_zone")
local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local ProjectileLocomotionUtility = require("scripts/extension_systems/locomotion/utilities/projectile_locomotion_utility")
local projectile_impact_results = ProjectileLocomotionSettings.impact_results
local MIN_TRAVEL_DISTANCE_TO_INTEGRATE = ProjectileLocomotionSettings.MIN_TRAVEL_DISTANCE_TO_INTEGRATE
local ProjectileLocomotion = {}
local NO_HITS = {}
local HITS = Script.new_array(128)
local LAST_NUM_HITS = 0
local DO_NOTHING_IMPACT_RESULTS = {
	stick = true,
	continue_straight = true
}

ProjectileLocomotion.integrate_position = function (physics_world, integration_data, dt, t, time_step_multiplier, dont_draw)
	local velocity = integration_data.velocity
	local position = integration_data.position
	local acceleration = integration_data.acceleration
	local gravity = -integration_data.gravity
	local air_drag = integration_data.air_drag
	local collision_types = integration_data.collision_types
	local collision_filter = integration_data.collision_filter
	time_step_multiplier = time_step_multiplier or 1
	local new_position = position
	local new_velocity = velocity
	local new_acceleration = acceleration

	for i = 1, time_step_multiplier do
		local old_acceleration = new_acceleration
		new_position = new_position + dt * new_velocity
		new_position = new_position + dt * dt * 0.5 * new_acceleration
		local air_drag_acceleration = -air_drag * Vector3.length(new_velocity) * new_velocity
		new_acceleration = air_drag_acceleration
		new_acceleration.z = new_acceleration.z + gravity
		new_velocity = new_velocity + dt * 0.5 * (old_acceleration + new_acceleration)
	end

	dt = dt * time_step_multiplier
	integration_data.has_hit = false
	local bounce_unit = nil
	local times_ran = 0

	repeat
		times_ran = times_ran + 1
		local bounced = false
		local travel_position = integration_data.last_hit_detection_position
		local travel_vector = new_position - travel_position
		local travel_distance = Vector3.length(travel_vector)
		local travel_direction = Vector3.normalize(travel_vector)
		local min_distance = MIN_TRAVEL_DISTANCE_TO_INTEGRATE

		if min_distance < travel_distance then
			local radius = integration_data.radius
			local pre_pare_pos = Vector3.lerp(travel_position, new_position, 0.5)
			local pre_pare_raddius = 0.5 * travel_distance + radius

			PhysicsProximitySystem.prepare_for_overlap(physics_world, pre_pare_pos, pre_pare_raddius)

			local max_hits = 32
			local collisions_enabled = true
			local integrator_parameters = integration_data.integrator_parameters
			local statics_radius = integrator_parameters.statics_radius
			local statics_raycast = integrator_parameters.statics_raycast
			local hits = nil

			if statics_radius or statics_raycast then
				local all_dynamics_hits = collisions_enabled and PhysicsWorld.linear_sphere_sweep(physics_world, travel_position, new_position, radius, max_hits, "types", "dynamics", "collision_filter", collision_filter) or NO_HITS
				local all_statics_hits = nil

				if statics_radius then
					all_statics_hits = collisions_enabled and PhysicsWorld.linear_sphere_sweep(physics_world, travel_position, new_position, statics_radius, max_hits, "types", "statics", "collision_filter", collision_filter) or NO_HITS
				else
					all_statics_hits = collisions_enabled and PhysicsWorld.immediate_raycast(physics_world, travel_position, travel_direction, travel_distance, "all", "types", "statics", "collision_filter", collision_filter) or NO_HITS
				end

				local dynamics_i = 1
				local statics_i = 1
				local merged_hits = HITS
				local merged_hits_i = 1
				local dynamic_hit = all_dynamics_hits[dynamics_i]
				local static_hit = all_statics_hits[statics_i]

				while dynamic_hit or static_hit do
					local dynamics_distance = dynamic_hit and dynamic_hit.distance or math.huge
					local statics_distance = static_hit and (static_hit.distance or static_hit[2]) or math.huge
					local hit = nil

					if dynamics_distance < statics_distance then
						hit = dynamic_hit
						dynamics_i = dynamics_i + 1
						dynamic_hit = all_dynamics_hits[dynamics_i]
					else
						hit = static_hit
						statics_i = statics_i + 1
						static_hit = all_statics_hits[statics_i]
					end

					merged_hits[merged_hits_i] = hit
					merged_hits_i = merged_hits_i + 1
				end

				for i = merged_hits_i, LAST_NUM_HITS do
					merged_hits[i] = nil
				end

				LAST_NUM_HITS = merged_hits_i - 1
				hits = merged_hits
			else
				hits = collisions_enabled and PhysicsWorld.linear_sphere_sweep(physics_world, travel_position, new_position, radius, max_hits, "types", "both", "collision_filter", collision_filter) or NO_HITS
			end

			local num_hits = #hits

			if num_hits > 0 then
				local damage_extension = integration_data.damage_extension
				local fx_extension = integration_data.fx_extension
				local hit_direction = travel_direction
				local current_speed = Vector3.length(new_velocity)

				for i = 1, num_hits do
					local hit = hits[i]
					local hit_position = hit.position or hit[1]
					local hit_actor = hit.actor or hit[4]
					local hit_unit = Actor.unit(hit_actor)

					if ProjectileLocomotionUtility.check_collision(hit_unit, hit_position, integration_data, bounce_unit) then
						local hit_normal = hit.normal or hit[3]
						local impact_result = nil

						if damage_extension then
							impact_result = damage_extension:on_impact(hit_position, hit_unit, hit_actor, hit_direction, hit_normal, current_speed)
						end

						if fx_extension then
							fx_extension:on_impact(hit_position, hit_unit, hit_direction, hit_normal, current_speed)
						end

						if impact_result == "removed" then
							break
						elseif not impact_result or not DO_NOTHING_IMPACT_RESULTS[impact_result] then
							bounce_unit = hit_unit
							local bounce_pos = Geometry.closest_point_on_line(hit_position + hit_normal * radius, travel_position, new_position)
							local travel_to_bounce = bounce_pos - travel_position
							local distance_to_bounce = Vector3.length(travel_to_bounce)
							local time_to_bounce = distance_to_bounce / current_speed
							local time_left = dt - math.min(time_to_bounce, dt)
							local bounce_normal = hit_normal
							local has_bounced_once = integration_data.have_bounced
							local used_generous_bouncing = false

							if integration_data.use_generous_bouncing and not has_bounced_once and impact_result == projectile_impact_results.stagger then
								bounce_normal = Vector3.slerp(hit_normal, Vector3.up(), 0.75)
								used_generous_bouncing = true
							end

							integration_data.have_bounced = true
							local coefficient_of_restitution = integration_data.coefficient_of_restitution

							if HEALTH_ALIVE[hit_unit] and not used_generous_bouncing then
								coefficient_of_restitution = coefficient_of_restitution * 0.5
							end

							local dot = Vector3.dot(travel_direction, bounce_normal)
							local new_direction = travel_direction - 2 * dot * bounce_normal
							local new_speed = current_speed * coefficient_of_restitution
							integration_data.last_hit_detection_position = bounce_pos
							new_velocity = new_speed * new_direction
							new_position = bounce_pos + new_velocity * time_left

							if has_bounced_once and new_speed < 0.3 then
								integration_data.integrate = false
							else
								bounced = true
							end

							integration_data.has_hit = true
							integration_data.last_hit_unit = hit_unit
							integration_data.last_hit_position = bounce_pos

							break
						end
					end
				end

				if not bounced then
					integration_data.last_hit_detection_position = new_position
				end
			else
				integration_data.last_hit_detection_position = new_position
			end
		end
	until not bounced or times_ran >= 2

	integration_data.previous_position = position
	integration_data.position = new_position
	integration_data.velocity = new_velocity
	integration_data.acceleration = new_acceleration
	integration_data.time_since_start = integration_data.time_since_start + dt

	return new_position
end

ProjectileLocomotion.integrate_rotation = function (physics_world, integration_data, dt, t)
	local angular_velocity = integration_data.angular_velocity
	local have_bounced = integration_data.have_bounced
	local rotate_towards_direction = integration_data.rotate_towards_direction

	if not have_bounced and rotate_towards_direction then
		local previous_rotation = integration_data.rotation
		local previous_up = Quaternion.up(previous_rotation)
		local direction = integration_data.velocity
		local angle = -angular_velocity.x * dt
		local up_rotator = Quaternion.axis_angle(direction, angle)
		local new_up = Quaternion.rotate(up_rotator, previous_up)
		local rotation = Quaternion.look(direction, new_up)
		integration_data.rotation = rotation
	else
		local new_rotation = Quaternion.from_elements(angular_velocity.x, angular_velocity.y, angular_velocity.z, 0)
		new_rotation = Quaternion.multiply_scalar(new_rotation, 0.5)
		local rotation = integration_data.rotation
		local spin = Quaternion.multiply(rotation, new_rotation)
		spin = Quaternion.multiply_scalar(spin, dt)
		rotation = Quaternion.add_elements(rotation, spin)
		rotation = Quaternion.normalize(rotation)
		integration_data.rotation = rotation

		return rotation
	end
end

ProjectileLocomotion.integrate = function (physics_world, integration_data, dt, t, is_server, time_step_multiplier, dont_draw)
	if integration_data.integrate then
		local previus_position = integration_data.position
		local new_position = ProjectileLocomotion.integrate_position(physics_world, integration_data, dt, t, time_step_multiplier, dont_draw)
		local _ = ProjectileLocomotion.integrate_rotation(physics_world, integration_data, dt, t)

		ProjectileLocomotionUtility.check_suppression(physics_world, integration_data, previus_position, new_position, is_server, dt, t)
	end
end

return ProjectileLocomotion
