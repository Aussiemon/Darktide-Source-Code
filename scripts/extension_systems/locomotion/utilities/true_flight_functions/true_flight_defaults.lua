local MinionState = require("scripts/utilities/minion_state")
local ProjectileLocomotion = require("scripts/extension_systems/locomotion/utilities/projectile_locomotion")
local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local projectile_impact_results = ProjectileLocomotionSettings.impact_results
local true_flight_defaults = {}

local function _center_of_all_actors(target_unit)
	local Unit_get_node_actors = Unit.get_node_actors
	local Unit_actor = Unit.actor
	local Actor_center_of_mass = Actor.center_of_mass

	Managers.state.extension:system("physics_unit_proximity_system"):activate_unit(target_unit)

	local position = Vector3.zero()
	local number_of_positions = 0
	local number_of_nodes = Unit.num_scene_graph_items(target_unit)

	for i = 1, number_of_nodes do
		local actors = Unit_get_node_actors(target_unit, i, false, true)

		if actors then
			for j = 1, #actors do
				local actor = Unit_actor(target_unit, actors[j])
				local center_of_mass = Actor_center_of_mass(actor)
				position = position + center_of_mass
				number_of_positions = number_of_positions + 1
			end
		end
	end

	if number_of_positions > 0 then
		position = position / number_of_positions

		return position
	end

	return nil
end

local function _center_of_hit_zone(target_unit, target_hit_zone)
	local target_unit_data = ScriptUnit.has_extension(target_unit, "unit_data_system")
	local target_breed = target_unit_data and target_unit_data:breed()
	local position = Vector3.zero()
	local number_of_positions = 0

	if target_breed then
		local Unit_actor = Unit.actor
		local Actor_center_of_mass = Actor.center_of_mass
		local target_actor_names = target_unit_data:hit_zone_actors(target_hit_zone)

		if target_actor_names then
			Managers.state.extension:system("physics_unit_proximity_system"):activate_unit(target_unit)

			for i = 1, #target_actor_names do
				local target_actor = Unit_actor(target_unit, target_actor_names[i])
				local target_position = Actor_center_of_mass(target_actor)
				position = position + target_position
				number_of_positions = number_of_positions + 1
			end
		end
	end

	if number_of_positions > 0 then
		position = position / number_of_positions

		return position
	end

	return nil
end

true_flight_defaults.get_unit_position = function (target_unit, target_hit_zone)
	local center_of_hit_zone = _center_of_hit_zone(target_unit, target_hit_zone)

	if center_of_hit_zone then
		return center_of_hit_zone
	end

	local center_of_all_actors = _center_of_all_actors(target_unit)

	if center_of_all_actors then
		return center_of_all_actors
	end

	local default_unit_position = POSITION_LOOKUP[target_unit]

	return default_unit_position
end

local function _lerp_modifier_func_default(integration_data, distance, height_over_target)
	return distance < 5 and 1 or 5 / distance
end

local function _lerp_modifier_func(true_flight_template)
	local template_func = true_flight_template and true_flight_template.lerp_modifier_func

	return template_func or _lerp_modifier_func_default
end

true_flight_defaults.default_update_towards_position = function (target_position, physics_world, integration_data, dt, t, optional_validate_impact_func, optional_on_impact_func)
	local position = integration_data.position
	local velocity = integration_data.velocity
	local current_direction = Vector3.normalize(velocity)
	local true_flight_template = integration_data.true_flight_template
	local speed_multiplier = true_flight_template.speed_multiplier
	local speed = Vector3.length(velocity) * speed_multiplier
	local required_velocity = target_position - position
	local distance = Vector3.length(required_velocity)
	local wanted_direction = Vector3.normalize(required_velocity)
	local current_rotation = Quaternion.look(current_direction)
	local wanted_rotation = Quaternion.look(wanted_direction)
	local height_offset = integration_data.height_offset
	local height_over_target = height_offset + math.max(position.z - target_position.z, 0)
	local lerp_func = _lerp_modifier_func(true_flight_template)
	local lerp_modifier = lerp_func(integration_data, distance, height_over_target)
	lerp_modifier = lerp_modifier * lerp_modifier * math.min(integration_data.time_since_start, 0.25) / 0.25
	local lerp_value = math.min(dt * lerp_modifier * 100, 0.75)
	local new_rotation = Quaternion.lerp(current_rotation, wanted_rotation, lerp_value)
	local new_direction = Quaternion.forward(new_rotation)
	local acceleration = true_flight_template.on_target_acceleration or 0
	local new_speed = speed + acceleration * dt
	local distance = (speed + new_speed) * dt * 0.5
	local new_position = position + new_direction * distance
	local new_velocity = new_direction * new_speed
	integration_data.velocity = new_velocity
	local new_rotation = Quaternion.look(velocity)
	new_position = true_flight_defaults.default_check_collisions(physics_world, integration_data, position, new_position, dt, t, optional_validate_impact_func, optional_on_impact_func)

	return new_position, new_rotation
end

true_flight_defaults.default_update_position_velocity = function (physics_world, integration_data, dt, t, optional_validate_impact_func, optional_on_impact_func)
	local velocity = integration_data.velocity
	local position = integration_data.position
	local new_position = position + velocity * dt
	local new_rotation = Quaternion.look(velocity)
	new_position = true_flight_defaults.default_check_collisions(physics_world, integration_data, position, new_position, dt, t, optional_validate_impact_func, optional_on_impact_func)

	return new_position, new_rotation
end

local broadphase_results = {}

true_flight_defaults.broadphase_query = function (owner_unit, position, radius)
	table.clear(broadphase_results)

	local extension_manager = Managers.state.extension
	local broadphase_system = extension_manager:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local side = ScriptUnit.extension(owner_unit, "side_system").side
	local relation_side_names = side:relation_side_names("enemy")
	local num_hits = Broadphase.query(broadphase, position, radius, broadphase_results, relation_side_names)

	return num_hits, broadphase_results
end

true_flight_defaults.get_closest_highest_value_target = function (integration_data, number_of_results, results, position, is_valid_and_legitimate_target_func, default_hit_zone)
	local closest_unit = nil
	local closest_distance = math.huge

	if number_of_results > 0 then
		for i = 1, number_of_results do
			local unit = results[i]

			if ScriptUnit.has_extension(unit, "health_system") and is_valid_and_legitimate_target_func(integration_data, unit, position) then
				local unit_position = POSITION_LOOKUP[unit]
				local distance = Vector3.distance_squared(unit_position, position)

				if distance < closest_distance then
					closest_unit = unit
					closest_distance = distance
				end
			end
		end

		return closest_unit, default_hit_zone
	end

	return nil, nil
end

true_flight_defaults.find_closest_highest_value_target = function (integration_data, position, is_valid_and_legitimate_targe_func)
	local owner_unit = integration_data.owner_unit
	local true_flight_template = integration_data.true_flight_template
	local broadphase_radius = true_flight_template.broadphase_radius
	local forward_search_distance_to_find_target = true_flight_template.forward_search_distance_to_find_target
	local results, number_of_results = nil

	if integration_data.target_position then
		local target_position = integration_data.target_position
		number_of_results, results = true_flight_defaults.broadphase_query(owner_unit, target_position, broadphase_radius)
	else
		local veclocity = integration_data.velocity
		local current_direction = Vector3.normalize(veclocity)
		local first_search_pos = position + current_direction * forward_search_distance_to_find_target
		number_of_results, results = true_flight_defaults.broadphase_query(owner_unit, first_search_pos, broadphase_radius)

		if number_of_results <= 0 then
			local second_search_pos = position + current_direction * forward_search_distance_to_find_target * 2
			number_of_results, results = true_flight_defaults.broadphase_query(owner_unit, second_search_pos, broadphase_radius * 2)
		end
	end

	local closest_unit, hit_zone = true_flight_defaults.get_closest_highest_value_target(integration_data, number_of_results, results, position, is_valid_and_legitimate_targe_func, true_flight_template.target_hit_zone)

	return closest_unit, hit_zone
end

true_flight_defaults.default_no_new_target = function (integration_data, position, is_valid_and_legitimate_targe_func)
	return nil, nil
end

true_flight_defaults.legitimate_always = function (integration_data, target_unit, target_position, position)
	return true
end

true_flight_defaults.legitimate_never = function (integration_data, target_unit, target_position, position)
	return false
end

true_flight_defaults.legitimate_line_of_sight_from_player = function (integration_data, target_unit, target_position, position)
	local player_unit = integration_data.owner_unit

	if not HEALTH_ALIVE[player_unit] then
		return false
	end

	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
	local first_person_component = unit_data_extension:read_component("first_person")
	local fp_position = first_person_component.position
	local fp_rotation = first_person_component.rotation
	local hit_something = false
	local smart_target_extension = ScriptUnit.has_extension(player_unit, "smart_targeting_system")

	if smart_target_extension then
		hit_something = not smart_target_extension:has_line_of_sight(target_unit)
	end

	local fp_direction = Quaternion.forward(fp_rotation)
	local raycast_direction = target_position - fp_position
	local dot_value = Vector3.dot(Vector3.normalize(fp_direction), Vector3.normalize(raycast_direction))

	if dot_value < 0.95 then
		return false
	end

	return not hit_something
end

true_flight_defaults.legitimate_dot_check = function (integration_data, target_unit, target_position, position)
	local velocity = integration_data.velocity
	local current_direction = Vector3.normalize(velocity)
	local direction_to_target = target_position - position
	local wanted_direction = Vector3.normalize(direction_to_target)
	local dot_value = Vector3.dot(current_direction, wanted_direction)

	if dot_value > -0.75 then
		return true
	end

	return false
end

true_flight_defaults.legitimate_angle_check = function (integration_data, target_unit, target_position, position)
	local true_flight_template = integration_data.true_flight_template
	local velocity = integration_data.velocity
	local current_direction = Vector3.normalize(velocity)
	local direction_to_target = target_position - position
	local wanted_direction = Vector3.normalize(direction_to_target)
	local angle = Vector3.angle(current_direction, wanted_direction)
	local allowed_angle = true_flight_template.allowed_angle or 135

	if angle < math.degrees_to_radians(allowed_angle) then
		return true
	end

	return false
end

true_flight_defaults.is_not_sleeping_demon_host = function (integration_data, target_unit, target_position, position)
	local is_not_sleeping_deamonhost = not MinionState.is_sleeping_deamonhost(target_unit)
	local is_angle_ok = true_flight_defaults.legitimate_angle_check(integration_data, target_unit, target_position, position)

	return is_not_sleeping_deamonhost and is_angle_ok
end

true_flight_defaults.impact_is_always_valid = function (hit_unit, integration_data)
	return true
end

true_flight_defaults.on_impact_do_nothing = function (hit_unit, hit, integration_data, new_position, is_server, dt, t)
	return new_position
end

true_flight_defaults.retry_if_no_target = function (integration_data)
	local target_unit = integration_data.target_unit
	local target_pos = integration_data.target_position

	return not target_unit and not target_pos
end

true_flight_defaults.dont_retry_target = function (integration_data)
	return false
end

true_flight_defaults.always_retry_target = function (integration_data)
	return true
end

true_flight_defaults.retry_if_target_position = function (integration_data)
	local target_unit = integration_data.target_unit

	return not target_unit
end

true_flight_defaults.default_check_collisions = function (physics_world, integration_data, previus_position, new_position, dt, t, optional_validate_impact_func, optional_on_impact_func)
	local true_flight_template = integration_data.true_flight_template
	local radius = integration_data.radius
	local collision_filter = integration_data.collision_filter
	local target_unit_or_nil = integration_data.target_unit
	local have_target = target_unit_or_nil ~= nil
	local have_target_collision_filter_override = true_flight_template.have_target_collision_filter_override

	if have_target and have_target_collision_filter_override then
		collision_filter = have_target_collision_filter_override
	end

	local travel_vector = new_position - previus_position
	local travel_direction = Vector3.normalize(travel_vector)
	local travel_distance = Vector3.length(travel_vector)
	local integrator_parameters = integration_data.integrator_parameters
	local statics_radius = integrator_parameters.statics_radius
	local statics_raycast = integrator_parameters.statics_raycast
	local skip_static = false
	local hits = ProjectileLocomotion.projectile_cast(physics_world, previus_position, new_position, travel_direction, travel_distance, collision_filter, radius, skip_static, statics_radius, statics_raycast)

	if hits and #hits > 0 then
		local damage_extension = integration_data.damage_extension
		local fx_extension = integration_data.fx_extension
		local hit_direction = travel_direction
		local current_speed = Vector3.length(integration_data.velocity)
		local hit = hits[1]
		local hit_position = hit.position or hit[1]
		local hit_actor = hit.actor or hit[4]
		local hit_unit = Actor.unit(hit_actor)
		local is_valid_true_flight = not optional_validate_impact_func or optional_validate_impact_func(hit_unit, integration_data)
		local is_valid_collision = is_valid_true_flight and ProjectileLocomotion.check_collision(hit_unit, hit_position, integration_data)

		if is_valid_collision then
			local hit_normal = hit.normal or hit[3]
			integration_data.has_hit = true
			local force_delete = false

			if optional_on_impact_func then
				new_position, force_delete = optional_on_impact_func(hit_unit, hit, integration_data, new_position, dt, t)
			else
				new_position = hit_position
			end

			local impact_result = nil

			if damage_extension then
				local is_target_unit = true

				if have_target and target_unit_or_nil ~= hit_unit then
					is_target_unit = false
				end

				impact_result = damage_extension:on_impact(hit_position, hit_unit, hit_actor, hit_direction, hit_normal, current_speed, force_delete, is_target_unit)
			end

			if fx_extension then
				fx_extension:on_impact(hit_position, hit_actor, hit_direction, hit_normal, current_speed)
			end

			if impact_result == projectile_impact_results.removed then
				integration_data.integrate = false
			end
		else
			integration_data.has_hit = false

			return new_position
		end

		return new_position
	else
		integration_data.has_hit = false
	end

	return new_position
end

return true_flight_defaults
