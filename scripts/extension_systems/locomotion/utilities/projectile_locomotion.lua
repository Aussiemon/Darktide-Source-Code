local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local ProjectileLocomotionUtility = require("scripts/extension_systems/locomotion/utilities/projectile_locomotion_utility")
local projectile_impact_results = ProjectileLocomotionSettings.impact_results
local MIN_TRAVEL_DISTANCE_TO_INTEGRATE = ProjectileLocomotionSettings.MIN_TRAVEL_DISTANCE_TO_INTEGRATE
local ProjectileLocomotion = {
	integrate_position = function (physics_world, integration_data, dt, t)
		local velocity = integration_data.velocity:unbox()
		local position = integration_data.position:unbox()
		local acceleration = integration_data.acceleration:unbox()
		local gravity = -integration_data.gravity
		local air_drag = integration_data.air_drag
		local collision_types = integration_data.collision_types
		local collision_filter = integration_data.collision_filter
		local owner_unit = integration_data.owner_unit
		local new_position = position + dt * velocity
		new_position = new_position + dt * dt * 0.5 * acceleration
		local air_drag_acceleration = -air_drag * Vector3.length(velocity) * velocity
		local new_acceleration = air_drag_acceleration
		new_acceleration.z = new_acceleration.z + gravity
		local new_velocity = velocity + dt * 0.5 * (acceleration + new_acceleration)
		local travel_vector = new_position - position
		local travel_distance = Vector3.length(travel_vector)
		local travel_direction = Vector3.normalize(travel_vector)
		local min_distance = MIN_TRAVEL_DISTANCE_TO_INTEGRATE

		if min_distance < travel_distance then
			local radius = integration_data.radius
			local pre_pare_pos = Vector3.lerp(position, new_position, 0.5)
			local pre_pare_raddius = 0.5 * travel_distance + radius

			PhysicsProximitySystem.prepare_for_overlap(physics_world, pre_pare_pos, pre_pare_raddius)

			local max_hit = 1
			local hits = PhysicsWorld.linear_sphere_sweep(physics_world, position, new_position, radius, max_hit, "types", collision_types, "collision_filter", collision_filter, "report_initial_overlap", true)

			if not integration_data.has_hit and hits and #hits > 0 then
				local hit = hits[1]
				local hit_normal = hit.normal
				local hit_position = hit.position
				local hit_actor = hit.actor
				local hit_unit = Actor.unit(hit_actor)
				local hit_direction = travel_direction
				local is_valid_collision = ProjectileLocomotionUtility.check_collision(hit_unit, hit_position, integration_data)

				if is_valid_collision then
					local current_speed = Vector3.length(new_velocity)
					local impact_result = nil

					if integration_data.damage_extension then
						impact_result = integration_data.damage_extension:on_impact(hit_position, hit_actor, hit_direction, hit_normal, current_speed)
					end

					if integration_data.fx_extension then
						integration_data.fx_extension:on_impact(hit_position, hit_actor, hit_direction, hit_normal, current_speed)
					end

					local is_first_bounce = not integration_data.have_bounced
					local bounce_pos = hit_position + hit_normal * radius
					local travel_to_bounce = bounce_pos - position
					local distance_to_bounce = Vector3.length(travel_to_bounce)
					local time_to_bounce = distance_to_bounce / current_speed
					local time_left = dt - time_to_bounce
					local coefficient_of_restitution = integration_data.coefficient_of_restitution
					local use_generous_bouncing = integration_data.use_generous_bouncing
					local have_staggered = impact_result == projectile_impact_results.stagger
					local bounce_normal = hit_normal

					if use_generous_bouncing and is_first_bounce and have_staggered then
						bounce_normal = Vector3.slerp(hit_normal, Vector3.up(), 0.75)
						integration_data.last_hit_unit = hit_unit
					else
						integration_data.last_hit_unit = nil
					end

					if impact_result ~= "continue_straight" then
						local dot = Vector3.dot(travel_direction, bounce_normal)
						local new_direction = travel_direction - 2 * dot * bounce_normal
						local new_speed = current_speed * coefficient_of_restitution
						new_velocity = new_speed * new_direction
						new_position = bounce_pos + new_velocity * time_left

						if new_speed == 0 then
							integration_data.integrate = false
						end
					end

					integration_data.have_bounced = true
					integration_data.has_hit = true
					integration_data.hit_count = integration_data.hit_count + 1
					local max_hit_count = integration_data.max_hit_count

					if max_hit_count < integration_data.hit_count then
						integration_data.integrate = false
					end

					integration_data.hits = hits
				else
					integration_data.has_hit = false
					integration_data.hits = nil
				end
			else
				integration_data.has_hit = false
				integration_data.hits = nil
			end
		else
			integration_data.integrate = false
			integration_data.hits = nil
		end

		integration_data.previous_position:store(position)
		integration_data.position:store(new_position)
		integration_data.velocity:store(new_velocity)
		integration_data.acceleration:store(new_acceleration)

		integration_data.time_since_start = integration_data.time_since_start + dt

		return new_position
	end,
	integrate_rotation = function (physics_world, integration_data, dt, t)
		local angular_momentum = integration_data.angular_momentum:unbox()
		local inertia = integration_data.inertia
		local angular_velocity = angular_momentum / inertia
		local have_bounced = integration_data.have_bounced
		local rotate_towards_direction = integration_data.rotate_towards_direction

		if not have_bounced and rotate_towards_direction then
			local previous_rotation = integration_data.rotation:unbox()
			local previous_up = Quaternion.up(previous_rotation)
			local direction = integration_data.velocity:unbox()
			local angle = -angular_velocity.x * dt
			local up_rotator = Quaternion.axis_angle(direction, angle)
			local new_up = Quaternion.rotate(up_rotator, previous_up)
			local rotation = Quaternion.look(direction, new_up)

			integration_data.rotation:store(rotation)
		else
			local new_rotation = Quaternion.from_elements(angular_velocity.x, angular_velocity.y, angular_velocity.z, 0)
			new_rotation = Quaternion.multiply_scalar(new_rotation, 0.5)
			local rotation = integration_data.rotation:unbox()
			local spin = Quaternion.multiply(rotation, new_rotation)
			spin = Quaternion.multiply_scalar(spin, dt)
			rotation = Quaternion.add_elements(rotation, spin)
			rotation = Quaternion.normalize(rotation)

			integration_data.rotation:store(rotation)

			return rotation
		end
	end,
	integrate = function (physics_world, integration_data, dt, t, is_server)
		Profiler.start("ProjectileLocomotion_integrate")

		if integration_data.integrate then
			local previus_position = integration_data.position:unbox()
			local new_position = ProjectileLocomotion.integrate_position(physics_world, integration_data, dt, t)
			local _ = ProjectileLocomotion.integrate_rotation(physics_world, integration_data, dt, t)

			ProjectileLocomotionUtility.check_suppresion(physics_world, integration_data, previus_position, new_position, is_server, dt, t)
		end

		Profiler.stop("ProjectileLocomotion_integrate")
	end
}

return ProjectileLocomotion
