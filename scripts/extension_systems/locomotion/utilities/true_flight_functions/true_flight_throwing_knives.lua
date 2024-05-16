-- chunkname: @scripts/extension_systems/locomotion/utilities/true_flight_functions/true_flight_throwing_knives.lua

local HitZone = require("scripts/utilities/attack/hit_zone")
local TrueFlightDefaults = require("scripts/extension_systems/locomotion/utilities/true_flight_functions/true_flight_defaults")
local ProjectileLocomotion = require("scripts/extension_systems/locomotion/utilities/projectile_locomotion")
local hit_zone_names = HitZone.hit_zone_names
local true_flight_throwing_knives = {}

true_flight_throwing_knives.throwing_knives_locomotion = function (physics_world, integration_data, dt, t, optional_validate_impact_func, optional_on_impact_func)
	local velocity = integration_data.velocity
	local position = integration_data.position
	local new_position = position + velocity * dt
	local new_rotation = Quaternion.look(velocity)
	local rotation_speed = 12
	local rotation_length = 30
	local sin_test = math.sin(t * rotation_speed + (integration_data.time_since_start * 1)^2)
	local cos_test = math.sin(t * rotation_speed * 0.65)
	local test_vector = Vector3(sin_test, rotation_length, cos_test)
	local test_look = Quaternion.look(test_vector)

	velocity = Quaternion.rotate(test_look, velocity)

	local new_velocity, hit_units_this_frame
	local collision_filter = integration_data.collision_filter

	new_position, new_velocity, hit_units_this_frame = ProjectileLocomotion.impact_detection_and_resolution(integration_data, new_position, velocity, physics_world, collision_filter, dt, false, false)
	integration_data.velocity = new_velocity

	return new_position, new_rotation
end

local function _owner_check(owner_unit, owner_position, first_person_extension, target_unit, target_position, distance_to_owner_requirement_squared)
	if not HEALTH_ALIVE[owner_unit] then
		return false
	end

	if not first_person_extension then
		return true
	end

	local is_within_default_view = first_person_extension:is_within_default_view(target_position)

	if not is_within_default_view then
		return false
	end

	if distance_to_owner_requirement_squared then
		local to_owner = target_position - owner_position
		local to_owner_distance_squared = Vector3.length_squared(to_owner)

		if distance_to_owner_requirement_squared < to_owner_distance_squared then
			return false
		end
	end

	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	local first_person_component = unit_data_extension:read_component("first_person")
	local fp_position = first_person_component.position
	local fp_rotation = first_person_component.rotation
	local raycast_direction = target_position - fp_position
	local hit_something = false
	local smart_target_extension = ScriptUnit.has_extension(owner_unit, "smart_targeting_system")

	if smart_target_extension then
		hit_something = not smart_target_extension:has_line_of_sight(target_unit)
	end

	local fp_direction = Quaternion.forward(fp_rotation)
	local dot_value = Vector3.dot(Vector3.normalize(fp_direction), Vector3.normalize(raycast_direction))

	if hit_something or dot_value < 0.95 then
		return false
	end

	return true
end

local function _throwing_knives_find_best_target(integration_data, search_position, projectile_position, travel_direction, optionl_ignore_unit)
	local true_flight_template = integration_data.true_flight_template
	local owner_unit = integration_data.owner_unit
	local owner_position = TrueFlightDefaults.get_unit_position(owner_unit, hit_zone_names.head)
	local radius = true_flight_template.broadphase_radius
	local radius_squared = radius * radius
	local first_person_extension = ScriptUnit.has_extension(owner_unit, "first_person_system")
	local distance_to_owner_requirement = true_flight_template.distance_to_owner_requirement
	local distance_to_owner_requirement_squared = distance_to_owner_requirement and distance_to_owner_requirement * distance_to_owner_requirement
	local default_hit_zone = true_flight_template.target_hit_zone
	local best_unit, best_position
	local best_score = math.huge
	local number_of_results, results = TrueFlightDefaults.broadphase_query(owner_unit, search_position, radius)

	if number_of_results > 0 then
		for i = 1, number_of_results do
			local unit = results[i]

			if ScriptUnit.has_extension(unit, "health_system") then
				local last_hit_unit = integration_data.last_hit_unit
				local damage_extension = integration_data.damage_extension
				local hit_units = damage_extension:get_hit_units()
				local have_unit_been_hit = hit_units[unit]
				local is_unit_ok = unit ~= optionl_ignore_unit and unit ~= last_hit_unit and HEALTH_ALIVE[unit] and not have_unit_been_hit

				if is_unit_ok then
					local unit_position = TrueFlightDefaults.get_unit_position(unit, default_hit_zone)
					local owner_check = _owner_check(owner_unit, owner_position, first_person_extension, unit, unit_position, distance_to_owner_requirement_squared)

					if owner_check then
						local to_unit = unit_position - projectile_position
						local distance_squared = Vector3.length_squared(to_unit)
						local distance_score = distance_squared / radius_squared
						local angle = Vector3.angle(travel_direction, Vector3.normalize(to_unit))
						local angle_sore = angle / math.pi
						local score = distance_score + angle_sore

						if score < best_score then
							best_unit = unit
							best_score = score
							best_position = unit_position
						end
					end
				end
			end
		end
	end

	return best_unit, best_position, default_hit_zone
end

true_flight_throwing_knives.throwing_knives_find_highest_value_target = function (integration_data, position, is_valid_and_legitimate_targe_func)
	local true_flight_template = integration_data.true_flight_template
	local forward_search_distance_to_find_target = true_flight_template.forward_search_distance_to_find_target
	local skip_search_time = true_flight_template.skip_search_time
	local time_since_start = integration_data.time_since_start

	if time_since_start < skip_search_time then
		return nil, nil
	end

	local veclocity = integration_data.velocity
	local travel_direction = Vector3.normalize(veclocity)
	local best_unit, best_position, best_hit_zone

	if integration_data.target_position then
		local target_position = integration_data.target_position

		best_unit, best_position, best_hit_zone = _throwing_knives_find_best_target(integration_data, target_position, target_position, travel_direction, nil)
	else
		local first_search_pos = position + travel_direction * forward_search_distance_to_find_target

		best_unit, best_position, best_hit_zone = _throwing_knives_find_best_target(integration_data, first_search_pos, position, travel_direction, nil)

		if not best_unit then
			local second_search_pos = position + travel_direction * forward_search_distance_to_find_target * 2

			best_unit, best_position, best_hit_zone = _throwing_knives_find_best_target(integration_data, second_search_pos, position, travel_direction, nil)
		end
	end

	return best_unit, best_hit_zone
end

true_flight_throwing_knives.throwing_knives_impact_valid = function (hit_unit, integration_data)
	local is_valid_impact = integration_data.last_hit_unit ~= hit_unit

	return is_valid_impact
end

true_flight_throwing_knives.throwing_knives_on_impact = function (hit_unit, hit, integration_data, new_position, is_server, dt, t)
	local true_flight_template = integration_data.true_flight_template
	local hit_normal = hit.normal or hit[3]
	local hit_position = hit.position or hit[1]
	local velocity = integration_data.velocity
	local current_speed = Vector3.length(velocity)
	local travel_direction = Vector3.normalize(velocity)
	local target_unit = integration_data.target_unit

	integration_data.last_hit_unit = hit_unit

	local bounced_to_much = false

	if HEALTH_ALIVE[hit_unit] then
		integration_data.number_of_bounces = 0

		if target_unit == hit_unit then
			integration_data.target_unit = nil

			if is_server then
				local best_unit, best_position, best_hit_zone = _throwing_knives_find_best_target(integration_data, hit_position, hit_position, travel_direction, hit_unit)

				if best_unit then
					local towards_best = Vector3.normalize(best_position - hit_position) + Vector3(0, 1, 0)
					local new_direction = Vector3.normalize(Vector3.lerp(travel_direction, towards_best, 0.5))
					local new_velocity = new_direction * current_speed

					integration_data.velocity = new_velocity
					integration_data.target_unit = best_unit
					integration_data.target_hit_zone = best_hit_zone
				end
			end
		end
	else
		local radius = integration_data.radius
		local bounce_pos = hit_position + hit_normal * radius
		local travel_to_bounce = bounce_pos - new_position
		local distance_to_bounce = Vector3.length(travel_to_bounce)
		local time_to_bounce = distance_to_bounce / current_speed
		local time_left = dt - time_to_bounce
		local bounce_normal = hit_normal
		local dot = Vector3.dot(travel_direction, bounce_normal)
		local new_direction = travel_direction - 2 * dot * bounce_normal

		if target_unit then
			local target_hit_zone = integration_data.target_hit_zone
			local target_unit_position = TrueFlightDefaults.get_unit_position(target_unit, target_hit_zone)
			local towards_target = Vector3.normalize(target_unit_position - hit_position)
			local angle_to_target_from_hit = Vector3.angle(towards_target, hit_normal)

			if angle_to_target_from_hit < math.pi / 2 then
				new_direction = Vector3.lerp(new_direction, towards_target, 0.5)
			end
		end

		local number_of_bounces = integration_data.number_of_bounces or 0
		local speed_mod = 1

		if number_of_bounces == 0 then
			speed_mod = 0.8
		end

		local new_velocity = current_speed * new_direction * speed_mod

		integration_data.velocity = new_velocity
		integration_data.target_position = nil
		number_of_bounces = number_of_bounces + 1
		integration_data.number_of_bounces = number_of_bounces

		local number_of_allowed_bounces = true_flight_template.allowed_bounces

		if number_of_allowed_bounces < number_of_bounces then
			bounced_to_much = true
		end
	end

	return new_position, bounced_to_much
end

return true_flight_throwing_knives
