local Proximity = {}
local query_results = {}

Proximity.check_proximity_of_position = function (position, relation_side_names, radius, out_result_table, filter_function, broadphase)
	local num_nearby_units = Broadphase.query(broadphase, position, radius, query_results, relation_side_names)

	for i = 1, num_nearby_units, 1 do
		local found_unit = query_results[i]
		local found_result = not filter_function or filter_function(found_unit)

		if found_result then
			out_result_table[found_unit] = found_result
		end
	end

	table.clear(query_results)
end

Proximity.check_proximity = function (unit, relation_side_names, radius, out_result_table, filter_function, broadphase)
	Proximity._check_proximity(POSITION_LOOKUP[unit], relation_side_names, radius, out_result_table, filter_function, broadphase)
end

Proximity.check_sticky_proximity = function (unit, relation_side_names, radius, out_result_table, filter_function, broadphase, stickiness_limit, stickiness_time, stickiness_table, prev_proximity_units, dt)
	local unit_position = POSITION_LOOKUP[unit]

	Proximity.check_proximity_of_position(unit_position, relation_side_names, radius, out_result_table, filter_function, broadphase)

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
