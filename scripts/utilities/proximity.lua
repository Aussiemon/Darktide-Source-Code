-- chunkname: @scripts/utilities/proximity.lua

local Proximity = {}
local query_results = {}

Proximity.check_proximity_of_position = function (proximity_context, proximity_scratchpad, position, rotation, relation_side_names, proximity_check_params, out_result_table, filter_function, broadphase)
	local radius = proximity_check_params.proximity_radius
	local forward = Vector3.normalize(Quaternion.forward(rotation))
	local broadphase_origin_forward_offset = proximity_check_params.broadphase_origin_forward_offset or nil

	if broadphase_origin_forward_offset and forward then
		position = position + Vector3.multiply(forward, broadphase_origin_forward_offset)
	end

	local num_nearby_units = Broadphase.query(broadphase, position, radius, query_results, relation_side_names)

	for i = 1, num_nearby_units do
		local found_unit = query_results[i]
		local found_result = not filter_function or filter_function(found_unit)

		if found_result then
			out_result_table[found_unit] = found_result
		end
	end

	table.clear(query_results)
end

Proximity.check_proximity_of_position_in_cone = function (proximity_context, proximity_scratchpad, position, rotation, relation_side_names, proximity_check_params, out_result_table, filter_function, broadphase)
	local cone_apex_angle = proximity_check_params.proximity_angle * math.pi
	local length = proximity_check_params.proximity_radius
	local cone_origin = position
	local forward = Vector3.normalize(Quaternion.forward(rotation))
	local cone_hits = broadphase.query_cone(broadphase, cone_origin, forward, cone_apex_angle, length, query_results, relation_side_names)

	for i = 1, cone_hits do
		local found_unit = query_results[i]
		local found_result = not filter_function or filter_function(found_unit)

		if found_result then
			out_result_table[found_unit] = found_result
		end
	end

	table.clear(query_results)
end

Proximity.check_proximity_line_of_sight = function (proximity_context, proximity_scratchpad, position, rotation, relation_side_names, proximity_check_params, out_result_table, filter_function, broadphase)
	if not proximity_scratchpad.init then
		proximity_scratchpad.init = true
		proximity_scratchpad.last_unit = nil
		proximity_scratchpad.last_side_idx = 1

		local cast_free_list = {
			[0] = 0,
		}

		proximity_scratchpad.cast_free_list = cast_free_list

		local queried_units = {}

		proximity_scratchpad.queried_units = queried_units

		local results = {}

		proximity_scratchpad.results = results
		proximity_scratchpad.to_nodes = proximity_check_params.to_nodes or {}

		local function _physics_cb_line_of_sight_hit(id, hit, hit_position, hit_distance, hit_normal, hit_actor)
			local cast_data = queried_units[id]
			local test_unit = cast_data.unit
			local ids = cast_data.ids

			ids[id] = nil
			queried_units[id] = nil
			cast_data.success = cast_data.success or not hit
			results[test_unit] = cast_data.success or nil

			if next(ids) == nil then
				cast_data.unit = nil
				cast_data.success = false
				cast_free_list[0] = cast_free_list[0] + 1
				cast_free_list[cast_free_list[0]] = cast_data
				queried_units[test_unit] = nil
			end
		end

		proximity_scratchpad.raycast = PhysicsWorld.make_raycast(proximity_context.physics_world, _physics_cb_line_of_sight_hit, "types", "statics", "closest", "collision_filter", "filter_simple_geometry")
	end

	local last_unit = proximity_scratchpad.last_unit

	last_unit = Unit.alive(last_unit) and last_unit or nil

	local first_unit = last_unit
	local side_idx = proximity_scratchpad.last_side_idx
	local side_name = relation_side_names[side_idx]
	local side_system = proximity_context.side_system
	local side = side_system:get_side_from_name(side_name)
	local unit_lookup = side.units_lookup
	local queried_units = proximity_scratchpad.queried_units
	local raycast = proximity_scratchpad.raycast
	local results = proximity_scratchpad.results
	local to_nodes = proximity_scratchpad.to_nodes
	local cast_free_list = proximity_scratchpad.cast_free_list
	local units_per_attempt = 10

	for i = 1, units_per_attempt do
		last_unit = next(unit_lookup, last_unit)

		if last_unit == first_unit then
			break
		end

		if last_unit then
			if not queried_units[last_unit] then
				for node_i = 1, #to_nodes do
					local node_name = to_nodes[node_i]

					if Unit.has_node(last_unit, node_name) then
						local unit_position = Unit.world_position(last_unit, Unit.node(last_unit, node_name))
						local direction, length = Vector3.direction_length(unit_position - position)

						if length < math.small then
							results[last_unit] = true
						else
							local id = raycast:cast(position, direction, length)
							local cast_data = queried_units[last_unit]

							if not cast_data then
								if cast_free_list[0] > 0 then
									cast_data = cast_free_list[cast_free_list[0]]
									cast_free_list[0] = cast_free_list[0] - 1
								else
									cast_data = {
										success = false,
										unit = nil,
										ids = {},
									}
								end

								cast_data.unit = last_unit
								queried_units[last_unit] = cast_data
							end

							cast_data.ids[id] = true
							queried_units[id] = cast_data
						end
					end
				end
			end
		else
			side_idx = math.index_wrapper(side_idx + 1, #relation_side_names)
			side_name = relation_side_names[side_idx]
			side = side_system:get_side_from_name(side_name)
			unit_lookup = side.units_lookup
			last_unit = nil
		end
	end

	proximity_scratchpad.last_side_idx = side_idx
	proximity_scratchpad.last_unit = last_unit

	for result_unit in pairs(results) do
		if not unit_lookup[result_unit] then
			results[result_unit] = nil
		end
	end

	for result_unit, result in pairs(results) do
		out_result_table[result_unit] = true
	end
end

Proximity.check_proximity = function (proximity_context, proximity_scratchpad, unit, relation_side_names, radius, out_result_table, filter_function, broadphase)
	Proximity._check_proximity(proximity_context, proximity_scratchpad, POSITION_LOOKUP[unit], relation_side_names, radius, out_result_table, filter_function, broadphase)
end

Proximity.check_sticky_proximity = function (proximity_context, proximity_scratchpad, unit, relation_side_names, proximity_check_params, out_result_table, proximity_query_function, filter_function, broadphase, stickiness_limit, stickiness_time, stickiness_table, prev_proximity_units, dt)
	local from_node = proximity_check_params.from_node and Unit.node(unit, proximity_check_params.from_node) or 1
	local unit_position = Unit.world_position(unit, from_node)
	local unit_rotation = Unit.local_rotation(unit, from_node)

	proximity_query_function(proximity_context, proximity_scratchpad, unit_position, unit_rotation, relation_side_names, proximity_check_params, out_result_table, filter_function, broadphase)

	stickiness_time = stickiness_time or 0

	local use_limit = stickiness_limit ~= nil

	stickiness_limit = stickiness_limit or 0

	local stickiness_limit_squared = stickiness_limit * stickiness_limit

	for prev_found_unit, prev_found_extension in pairs(prev_proximity_units) do
		if not out_result_table[prev_found_unit] then
			local time = (stickiness_table[prev_found_unit] or 0) + dt
			local time_check = stickiness_time < time
			local distance_check = false

			if not time_check and use_limit then
				local prev_unit_position = POSITION_LOOKUP[prev_found_unit]
				local distance_squared = Vector3.distance_squared(prev_unit_position, unit_position)

				distance_check = stickiness_limit_squared < distance_squared
			end

			if time_check or distance_check then
				stickiness_table[prev_found_unit] = nil
			else
				stickiness_table[prev_found_unit] = time
				out_result_table[prev_found_unit] = prev_found_extension
			end
		end
	end
end

return Proximity
