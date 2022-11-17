local Breeds = require("scripts/settings/breed/breeds")
local ParameterFunctions = {
	echo = function (_, ...)
		return ...
	end
}
local _generate_pick_x = {
	function (i1)
		return function (_, ...)
			return select(i1, ...)
		end
	end,
	function (i1, i2)
		return function (_, ...)
			return select(i1, ...), select(i2, ...)
		end
	end,
	function (i1, i2, i3)
		return function (_, ...)
			return select(i1, ...), select(i2, ...), select(i3, ...)
		end
	end,
	function (i1, i2, i3, i4)
		return function (_, ...)
			return select(i1, ...), select(i2, ...), select(i3, ...), select(i4, ...)
		end
	end,
	function (i1, i2, i3, i4, i5)
		return function (_, ...)
			return select(i1, ...), select(i2, ...), select(i3, ...), select(i4, ...), select(i5, ...)
		end
	end,
	function (i1, i2, i3, i4, i5, i6)
		return function (_, ...)
			return select(i1, ...), select(i2, ...), select(i3, ...), select(i4, ...), select(i5, ...), select(i6, ...)
		end
	end,
	function (i1, i2, i3, i4, i5, i6, i7)
		return function (_, ...)
			return select(i1, ...), select(i2, ...), select(i3, ...), select(i4, ...), select(i5, ...), select(i6, ...), select(i7, ...)
		end
	end,
	function (i1, i2, i3, i4, i5, i6, i7, i8)
		return function (_, ...)
			return select(i1, ...), select(i2, ...), select(i3, ...), select(i4, ...), select(i5, ...), select(i6, ...), select(i7, ...), select(i8, ...)
		end
	end,
	function (i1, i2, i3, i4, i5, i6, i7, i8, i9)
		return function (_, ...)
			return select(i1, ...), select(i2, ...), select(i3, ...), select(i4, ...), select(i5, ...), select(i6, ...), select(i7, ...), select(i8, ...), select(i9, ...)
		end
	end,
	function (i1, i2, i3, i4, i5, i6, i7, i8, i9, i10)
		return function (_, ...)
			return select(i1, ...), select(i2, ...), select(i3, ...), select(i4, ...), select(i5, ...), select(i6, ...), select(i7, ...), select(i8, ...), select(i9, ...), select(i10, ...)
		end
	end,
	function (i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11)
		return function (_, ...)
			return select(i1, ...), select(i2, ...), select(i3, ...), select(i4, ...), select(i5, ...), select(i6, ...), select(i7, ...), select(i8, ...), select(i9, ...), select(i10, ...), select(i11, ...)
		end
	end,
	function (i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12)
		return function (_, ...)
			return select(i1, ...), select(i2, ...), select(i3, ...), select(i4, ...), select(i5, ...), select(i6, ...), select(i7, ...), select(i8, ...), select(i9, ...), select(i10, ...), select(i11, ...), select(i12, ...)
		end
	end,
	function (i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12, i13)
		return function (_, ...)
			return select(i1, ...), select(i2, ...), select(i3, ...), select(i4, ...), select(i5, ...), select(i6, ...), select(i7, ...), select(i8, ...), select(i9, ...), select(i10, ...), select(i11, ...), select(i12, ...), select(i13, ...)
		end
	end,
	function (i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12, i13, i14)
		return function (_, ...)
			return select(i1, ...), select(i2, ...), select(i3, ...), select(i4, ...), select(i5, ...), select(i6, ...), select(i7, ...), select(i8, ...), select(i9, ...), select(i10, ...), select(i11, ...), select(i12, ...), select(i13, ...), select(i14, ...)
		end
	end,
	function (i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12, i13, i14, i15)
		return function (_, ...)
			return select(i1, ...), select(i2, ...), select(i3, ...), select(i4, ...), select(i5, ...), select(i6, ...), select(i7, ...), select(i8, ...), select(i9, ...), select(i10, ...), select(i11, ...), select(i12, ...), select(i13, ...), select(i14, ...), select(i15, ...)
		end
	end,
	function (i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12, i13, i14, i15, i16)
		return function (_, ...)
			return select(i1, ...), select(i2, ...), select(i3, ...), select(i4, ...), select(i5, ...), select(i6, ...), select(i7, ...), select(i8, ...), select(i9, ...), select(i10, ...), select(i11, ...), select(i12, ...), select(i13, ...), select(i14, ...), select(i15, ...), select(i16, ...)
		end
	end
}

ParameterFunctions.pick = function (stat_definition, ...)
	local indices = {}
	local stat_params = stat_definition:get_parameters()
	local amount_to_pick = select("#", ...)

	for index = 1, amount_to_pick do
		local desired_param_name = select(index, ...)
		local desired_index = table.index_of(stat_params, desired_param_name)
		indices[index] = desired_index
	end

	return _generate_pick_x[amount_to_pick](unpack(indices))
end

ParameterFunctions.smart_pick = function (stat_definition, names, transforms)
	local indices = {}
	local stat_params = stat_definition:get_parameters()
	local output = {}
	local size = #names

	for index = 1, size do
		local desired_param_name = names[index]
		local desired_index = table.index_of(stat_params, desired_param_name)
		indices[index] = desired_index
	end

	return function (_, ...)
		for i = 1, size do
			output[i] = select(indices[i], ...)

			if transforms[i] then
				output[i] = transforms[i](output[i])
			end
		end

		return unpack(output)
	end
end

ParameterFunctions.transformers = {
	faction_of_breed = function (breed_name)
		local breed_data = Breeds[breed_name]

		return breed_data and breed_data.sub_faction_name or "unknown"
	end,
	side_objective_to_type = function (side_objective_name)
		if side_objective_name == "side_mission_grimoire" then
			return "grimoire"
		end

		if side_objective_name == "side_mission_tome" then
			return "tome"
		end

		if side_objective_name == "side_mission_consumable" then
			return "relic"
		end

		return "unknown"
	end
}

return ParameterFunctions
