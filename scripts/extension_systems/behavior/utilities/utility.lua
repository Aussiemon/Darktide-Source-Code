-- chunkname: @scripts/extension_systems/behavior/utilities/utility.lua

local Utility = {}

local function get_utility_from_spline(spline, x)
	for i = 3, #spline, 2 do
		local x2 = spline[i]

		if x <= x2 then
			local x1 = spline[i - 2]
			local y1 = spline[i - 1]
			local y2 = spline[i + 1]
			local m = (y2 - y1) / (x2 - x1)
			local y = y1 + m * (x - x1)

			return y
		end
	end

	return spline[#spline]
end

Utility.get_action_utility = function (action, blackboard, t, utility_data)
	local total_utility = 1
	local considerations = action.considerations

	for name, consideration in pairs(considerations) do
		local value
		local component_name = consideration.blackboard_component
		local field_name = consideration.component_field

		if component_name then
			local component = blackboard[component_name]

			value = component[field_name]
		else
			value = utility_data[field_name]
		end

		local utility

		if consideration.is_condition then
			local invert = consideration.invert

			utility = value and (invert and 0 or 1) or invert and 1 or 0
		else
			local current_value = consideration.time_diff and t - value or value
			local min_value = consideration.min_value or 0
			local normalized_value = math.clamp((current_value - min_value) / (consideration.max_value - min_value), 0, 1)

			utility = get_utility_from_spline(consideration.spline, normalized_value)
		end

		if utility <= 0 then
			return 0
		end

		total_utility = total_utility * utility
	end

	total_utility = total_utility * action.utility_weight

	return total_utility
end

Utility.find_rendezvous_position = function (unit, action_data, blackboard)
	local rendezvous_radius = action_data.rendezvous_radius
	local rendezvous_offset = action_data.rendezvous_offset
	local side = Managers.state.extension:system("side_system").side_by_unit[unit]
	local allied_units = side.valid_human_units
	local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
	local Breed = require("scripts/utilities/breed")
	local unit_pos = Unit.local_position(unit, 1)
	local closest_position
	local closest_is_player = false
	local closest_is_disabled = false
	local closest_distance = math.huge
	local rotation = Quaternion.identity()

	for i = 1, #allied_units do
		repeat
			local ally_unit = allied_units[i]
			local data_extension = ScriptUnit.has_extension(ally_unit, "unit_data_system")
			local is_player = data_extension and Breed.is_player(data_extension:breed())

			if closest_is_player and not is_player then
				break
			end

			local character_state_component = is_player and data_extension:read_component("character_state")
			local is_disabled = character_state_component and PlayerUnitStatus.is_disabled(character_state_component)

			if closest_is_disabled and not is_disabled then
				break
			end

			local ally_pos = POSITION_LOOKUP[ally_unit]
			local dist_sq = Vector3.distance_squared(unit_pos, ally_pos)

			if dist_sq < closest_distance then
				closest_is_disabled = is_disabled
				closest_is_player = is_player
				closest_distance = dist_sq
				closest_position = ally_pos
				rotation = Unit.local_rotation(ally_unit, 1)
			end
		until true
	end

	local rendezvous_reference = closest_position

	if not rendezvous_reference then
		return nil, nil
	end

	local rendezvous_position = closest_position + Quaternion.rotate(Quaternion.flat_no_roll(rotation), Vector3(rendezvous_offset[1], rendezvous_offset[2], rendezvous_offset[3]))
	local random_offset_x, random_offset_y = math.get_uniformly_random_point_inside_sector(0, rendezvous_radius, 0, 2 * math.pi)

	rendezvous_position[1] = rendezvous_position[1] + random_offset_x
	rendezvous_position[2] = rendezvous_position[2] + random_offset_y

	return rendezvous_position, rendezvous_reference
end

return Utility
