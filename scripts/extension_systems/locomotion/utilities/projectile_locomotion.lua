local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local projectile_impact_results = ProjectileLocomotionSettings.impact_results
local MIN_TRAVEL_DISTANCE_TO_INTEGRATE = ProjectileLocomotionSettings.MIN_TRAVEL_DISTANCE_TO_INTEGRATE
local ProjectileLocomotion = {
	set_kinematic = function (unit, actor_id, kinematic)
		if actor_id then
			local dynamic_actor = Unit.actor(unit, actor_id)

			Actor.set_kinematic(dynamic_actor, kinematic)
		end
	end
}

local function _has_actor(unit, actor_name)
	local actor_id = Unit.find_actor(unit, actor_name)
	local actor = Unit.actor(unit, actor_id)

	return actor
end

ProjectileLocomotion.activate_physics = function (unit)
	if not _has_actor(unit, "dynamic") then
		Unit.create_actor(unit, "dynamic")
	end
end

ProjectileLocomotion.deactivate_physics = function (unit, dynamic_id)
	if _has_actor(unit, "dynamic") then
		Unit.destroy_actor(unit, dynamic_id)
	end
end

local DEFAULT_SUPPRESSION_COLLISION_FILTER = "filter_player_character_shooting_raycast_dynamics"
local DEFAULT_SUPPRESSION_COLLISION_TYPE = "dynamics"
local DEFAULT_SUPPRESSION_CHECK_RADIUS = 0.075

ProjectileLocomotion.check_suppression = function (physics_world, integration_data, previus_position, new_position, is_server, dt, t)
	if not is_server then
		return
	end

	local damage_extension = integration_data.damage_extension

	if not damage_extension or not damage_extension:use_suppression() then
		return
	end

	local suppression_settings = integration_data.suppression_settings
	local suppression_radius = suppression_settings and suppression_settings.suppression_radius or DEFAULT_SUPPRESSION_CHECK_RADIUS
	local suppersion_collision_types = suppression_settings and suppression_settings.suppersion_collision_types or DEFAULT_SUPPRESSION_COLLISION_TYPE
	local suppersion_collision_filter = suppression_settings and suppression_settings.suppersion_collision_filter or DEFAULT_SUPPRESSION_COLLISION_FILTER
	local hits = PhysicsWorld.linear_sphere_sweep(physics_world, previus_position, new_position, suppression_radius, 1, "types", suppersion_collision_types, "collision_filter", suppersion_collision_filter)

	if hits then
		for ii = 1, #hits do
			local hit = hits[ii]
			local hit_actor = hit.actor
			local hit_unit = Actor.unit(hit_actor)
			local hit_position = hit.position

			damage_extension:on_suppression(hit_unit, hit_position)
		end
	end
end

ProjectileLocomotion.check_collision = function (hit_unit, hit_position, integration_data, bounce_unit)
	local owner_unit = integration_data.owner_unit

	if hit_unit == owner_unit then
		return false
	end

	if hit_unit == bounce_unit then
		return false
	end

	return true
end

local NO_HITS = {}
local HITS = Script.new_array(128)
local LAST_NUM_HITS = 0

ProjectileLocomotion.projectile_cast = function (physics_world, travel_position, new_position, travel_direction, travel_distance, collision_filter, radius, optional_skip_static, optional_statics_radius, optional_static_raycast)
	local max_hits = 32
	local hits = nil

	if optional_skip_static then
		hits = PhysicsWorld.linear_sphere_sweep(physics_world, travel_position, new_position, radius, max_hits, "types", "dynamics", "collision_filter", collision_filter) or NO_HITS
	elseif optional_statics_radius or optional_static_raycast then
		local all_dynamics_hits = PhysicsWorld.linear_sphere_sweep(physics_world, travel_position, new_position, radius, max_hits, "types", "dynamics", "collision_filter", collision_filter) or NO_HITS
		local all_statics_hits = nil

		if optional_statics_radius then
			all_statics_hits = PhysicsWorld.linear_sphere_sweep(physics_world, travel_position, new_position, optional_statics_radius, max_hits, "types", "statics", "collision_filter", collision_filter) or NO_HITS
		else
			all_statics_hits = PhysicsWorld.immediate_raycast(physics_world, travel_position, travel_direction, travel_distance, "all", "types", "statics", "collision_filter", collision_filter) or NO_HITS
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

		for ii = merged_hits_i, LAST_NUM_HITS do
			merged_hits[ii] = nil
		end

		LAST_NUM_HITS = merged_hits_i - 1
		hits = merged_hits
	else
		hits = PhysicsWorld.linear_sphere_sweep(physics_world, travel_position, new_position, radius, max_hits, "types", "both", "collision_filter", collision_filter) or NO_HITS
	end

	return hits
end

local DO_NOTHING_IMPACT_RESULTS = {
	stick = true,
	continue_straight = true
}
local hit_units_this_frame = {}

ProjectileLocomotion.impact_detection_and_resolution = function (integration_data, new_position, new_velocity, physics_world, collision_filter, dt, dont_draw, optional_skip_static)
	integration_data.has_hit = false
	integration_data.bounced_this_frame = false

	table.clear(hit_units_this_frame)

	local target_unit_or_nil = integration_data.target_unit
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
			local integrator_parameters = integration_data.integrator_parameters
			local statics_radius = integrator_parameters.statics_radius
			local statics_raycast = integrator_parameters.statics_raycast
			local skip_static = optional_skip_static or false
			local hits = ProjectileLocomotion.projectile_cast(physics_world, travel_position, new_position, travel_direction, travel_distance, collision_filter, radius, skip_static, statics_radius, statics_raycast)
			local num_hits = #hits

			if num_hits > 0 then
				local damage_extension = integration_data.damage_extension
				local fx_extension = integration_data.fx_extension
				local hit_direction = travel_direction
				local current_speed = Vector3.length(new_velocity)
				local true_flight_template = integration_data.true_flight_template

				for ii = 1, num_hits do
					local hit = hits[ii]
					local hit_position = hit.position or hit[1]
					local hit_actor = hit.actor or hit[4]
					local hit_unit = Actor.unit(hit_actor)

					if ProjectileLocomotion.check_collision(hit_unit, hit_position, integration_data, bounce_unit) then
						local hit_normal = hit.normal or hit[3]
						hit_units_this_frame[hit_unit] = true
						local impact_result = nil

						if damage_extension then
							local is_target_unit = true

							if target_unit_or_nil then
								is_target_unit = hit_unit == target_unit_or_nil
							end

							impact_result = damage_extension:on_impact(hit_position, hit_unit, hit_actor, hit_direction, hit_normal, current_speed, false, is_target_unit)
						end

						if fx_extension then
							fx_extension:on_impact(hit_position, hit_unit, hit_direction, hit_normal, current_speed)
						end

						if impact_result == "removed" then
							break
						elseif impact_result and DO_NOTHING_IMPACT_RESULTS[impact_result] then
							if impact_result == "continue_straight" and true_flight_template and true_flight_template.true_flight_shard_impact_behaviour then
								local new_direction = travel_direction + Vector3(0, 0, 1)
								new_velocity = current_speed * 0.5 * new_direction
							end
						else
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

							if coefficient_of_restitution == 0 then
								new_position = bounce_pos
								integration_data.has_hit = true
								integration_data.last_hit_unit = hit_unit
								integration_data.last_hit_position = bounce_pos
								integration_data.bounced_this_frame = true
								integration_data.number_of_bounces = integration_data.number_of_bounces + 1
								integration_data.integrate = false
								new_velocity = Vector3.zero()

								break
							end

							local dot = Vector3.dot(travel_direction, bounce_normal)
							local new_direction = travel_direction - 2 * dot * bounce_normal
							local new_speed = current_speed * coefficient_of_restitution

							if true_flight_template and true_flight_template.true_flight_shard_impact_behaviour and integration_data.number_of_bounces == 0 then
								new_speed = new_speed * 0.8
							end

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
							integration_data.bounced_this_frame = true
							integration_data.number_of_bounces = integration_data.number_of_bounces + 1

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

	return new_position, new_velocity, hit_units_this_frame
end

return ProjectileLocomotion
