﻿-- chunkname: @scripts/extension_systems/behavior/utilities/utility.lua

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

return Utility
