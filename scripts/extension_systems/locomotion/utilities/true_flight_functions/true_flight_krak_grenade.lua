local Armor = require("scripts/utilities/attack/armor")
local ProjectileLocomotion = require("scripts/extension_systems/locomotion/utilities/projectile_locomotion")
local TrueFlightDefaults = require("scripts/extension_systems/locomotion/utilities/true_flight_functions/true_flight_defaults")
local true_flight_krak_grenade = {
	krak_projectile_locomotion = function (physics_world, integration_data, dt, t)
		local position = ProjectileLocomotion.integrate_position(physics_world, integration_data, dt, t)
		local rotation = ProjectileLocomotion.integrate_rotation(physics_world, integration_data, dt, t)

		return position, rotation
	end,
	krak_update_towards_position = function (target_position, physics_world, integration_data, dt, t)
		local true_flight_template = integration_data.true_flight_template
		local trigger_time = true_flight_template.trigger_time
		local on_target_time = integration_data.on_target_time
		local have_triggered = trigger_time < on_target_time
		local velocity = integration_data.velocity:unbox()
		local position = integration_data.position:unbox()
		local towards_target = target_position - position
		local wanted_direction = Vector3.normalize(towards_target)
		local current_direction = Vector3.normalize(velocity)
		local dot_product = Vector3.dot(wanted_direction, current_direction)
		local slow_down_dot_product_threshold = true_flight_template.slow_down_dot_product_threshold
		local slow_down_factor = true_flight_template.slow_down_factor
		local should_slow_down = dot_product < slow_down_dot_product_threshold

		if not have_triggered and should_slow_down then
			local slow_down_lerp = math.clamp(on_target_time / (trigger_time * 0.2), 0, 1)
			local slow_down = math.lerp(1, slow_down_factor, slow_down_lerp)
			local current_min_slowdown = integration_data.min_slow_down or 1
			integration_data.min_slow_down = math.min(current_min_slowdown, slow_down)
			dt = dt * slow_down

			if dt > 0 then
				ProjectileLocomotion.integrate(physics_world, integration_data, dt, t, false)
			end

			integration_data.integrate = true
			position = integration_data.position:unbox()
			local rotation = integration_data.rotation:unbox()

			return position, rotation
		else
			integration_data.integrate = true
			local min_slow_down = integration_data.min_slow_down or 1
			local time_after_trigger = on_target_time - trigger_time
			local speed_up_lerp = math.clamp(time_after_trigger / (trigger_time * 0.2), 0, 1)
			local speed_up = math.lerp(min_slow_down, 1, speed_up_lerp)
			dt = dt * speed_up
			local rotation = nil
			position, rotation = TrueFlightDefaults.default_update_towards_position(target_position, physics_world, integration_data, dt, t)

			return position, rotation
		end
	end
}

local function _check_target_armor(unit, target_armor_types, default_hit_zone, current_position, check_all_hit_zones)
	local health_extension = ScriptUnit.has_extension(unit, "health_system")

	if not health_extension then
		return false, nil, nil
	end

	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local breed = unit_data_extension:breed()

	if check_all_hit_zones then
		local vector3_distance_squared = Vector3.distance_squared
		local breed_hit_zones = breed.hit_zones
		local cloest_hit_zone_name = nil
		local closest_distance = math.huge
		local closest_position = nil

		for i = 1, #breed_hit_zones, 1 do
			local hit_zone_name = breed_hit_zones[i].name
			local hit_zone_armor_type = Armor.armor_type(unit, breed, hit_zone_name)
			local can_stick = target_armor_types[hit_zone_armor_type]

			if can_stick then
				local hit_zone_position = TrueFlightDefaults.get_unit_position(unit, hit_zone_name)
				local distance_squared = vector3_distance_squared(current_position, hit_zone_position)

				if distance_squared < closest_distance then
					cloest_hit_zone_name = hit_zone_name
					closest_distance = distance_squared
					closest_position = hit_zone_position
				end
			end
		end

		if cloest_hit_zone_name then
			return true, cloest_hit_zone_name, closest_position
		end
	end

	local base_armor_type = Armor.armor_type(unit, breed, nil)
	local position = TrueFlightDefaults.get_unit_position(unit, default_hit_zone)
	local can_stick = target_armor_types[base_armor_type]

	return can_stick, default_hit_zone, position
end

local function _broadphase_query(owner_unit, position, radius, query_results)
	local extension_manager = Managers.state.extension
	local broadphase_system = extension_manager:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local side = ScriptUnit.extension(owner_unit, "side_system").side
	local relation_side_names = side:relation_side_names("enemy")
	local num_hits = Broadphase.query(broadphase, position, radius, query_results, relation_side_names)

	return num_hits
end

local function _play_fx_target_found_fx(integration_data)
	local projectile_unit = integration_data.projectile_unit
	local projectile_fx = ScriptUnit.has_extension(projectile_unit, "fx_system")

	if projectile_fx then
		projectile_fx:on_target_aquired()
	end
end

local broadphase_results = {}

true_flight_krak_grenade.krak_find_armored_target = function (integration_data, position, is_valid_and_legitimate_targe_func)
	local true_flight_template = integration_data.true_flight_template
	local skip_search_time = true_flight_template.skip_search_time
	local time_since_start = integration_data.time_since_start

	if time_since_start < skip_search_time then
		return nil, nil
	end

	local projectile_unit = integration_data.projectile_unit
	local owner_unit = integration_data.owner_unit
	local broadphase_radius = true_flight_template.broadphase_radius
	local forward_search_distance_to_find_target = true_flight_template.forward_search_distance_to_find_target
	local target_armor_types = true_flight_template.target_armor_types
	local default_hit_zone = true_flight_template.target_hit_zone

	table.clear(broadphase_results)

	local number_of_results = nil
	local veclocity = integration_data.velocity:unbox()
	local current_direction = Vector3.normalize(veclocity)
	local offset = current_direction * forward_search_distance_to_find_target
	local seach_position = position + offset
	number_of_results = _broadphase_query(owner_unit, seach_position, broadphase_radius, broadphase_results)
	local check_all_hit_zones = true_flight_template.check_all_hit_zones
	local closest_unit = nil
	local closest_distance = math.huge
	local target_hit_zone = nil

	if number_of_results > 0 then
		for i = 1, number_of_results, 1 do
			local unit = broadphase_results[i]

			if is_valid_and_legitimate_targe_func(integration_data, unit, position) then
				local can_stick, hit_zone, target_pos = _check_target_armor(unit, target_armor_types, default_hit_zone, position, check_all_hit_zones)

				if can_stick then
					local distance = Vector3.distance_squared(target_pos, position)

					if distance < closest_distance then
						closest_unit = unit
						closest_distance = distance
						target_hit_zone = hit_zone
					end
				end
			end
		end

		if closest_unit then
			_play_fx_target_found_fx(integration_data)
		end

		return closest_unit, target_hit_zone
	end

	return nil, nil
end

return true_flight_krak_grenade
