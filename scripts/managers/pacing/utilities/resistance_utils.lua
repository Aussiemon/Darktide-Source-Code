-- chunkname: @scripts/managers/pacing/utilities/resistance_utils.lua

local ResistanceUtils = {}

ResistanceUtils.MAX_RESISTANCE = 6

ResistanceUtils.empty = function ()
	local t = {}

	for i = 1, ResistanceUtils.MAX_RESISTANCE do
		t[i] = {}
	end

	return t
end

ResistanceUtils.constant = function (lo, hi, from_resistance)
	local t = ResistanceUtils.empty({
		0,
		0,
	})

	from_resistance = from_resistance or 1

	for i = 1, ResistanceUtils.MAX_RESISTANCE do
		if i < from_resistance then
			t[i] = {
				0,
				0,
			}
		else
			t[i] = {
				lo,
				hi,
			}
		end
	end

	return t
end

ResistanceUtils.interpolate = function (from, target, from_resistance, interpolate_function, interpolate_floats)
	local is_number = type(from) == "number"
	local t, size

	if is_number then
		size = 1
		t = ResistanceUtils.empty(0)
	else
		size = #from
		t = ResistanceUtils.empty(table.arra)
	end

	from_resistance = from_resistance or 1

	for i = 1, ResistanceUtils.MAX_RESISTANCE do
		local percent_to_max = interpolate_function((i - from_resistance) / (ResistanceUtils.MAX_RESISTANCE - from_resistance))

		if size == 1 then
			if i < from_resistance then
				t[i] = 0
			else
				t[i] = from[i] + percent_to_max * (target[i] - from[i])
				t[i] = not interpolate_floats and math.round(t[i]) or t[i]
			end
		else
			for j = 1, size do
				if i < from_resistance then
					t[i][j] = 0
				else
					t[i][j] = from[j] + percent_to_max * (target[j] - from[j])
					t[i][j] = not interpolate_floats and math.round(t[i][j]) or t[i][j]
				end
			end
		end
	end

	return t
end

ResistanceUtils.interpolation_linear = function (x)
	return x
end

ResistanceUtils.linear = function (from, target, from_resistance, interpolate_floats)
	return ResistanceUtils.interpolate(from, target, from_resistance, ResistanceUtils.interpolation_linear, interpolate_floats)
end

ResistanceUtils.add = function (a, b)
	local t = ResistanceUtils.empty()

	for i = 1, ResistanceUtils.MAX_RESISTANCE do
		local _a = a[i] or a[#a]
		local _b = b[i] or b[#b]
		local is_number = type(_a) == "number"

		if is_number then
			t[i] = _a + _b
		else
			for j = 1, #_a do
				t[i][j] = _a[j] + _b[j]
			end
		end
	end

	return t
end

ResistanceUtils.to_interpolated_array = function (template_table)
	local resistance_array = ResistanceUtils.empty()

	for k, v in pairs(template_table) do
		local interpolated_values = ResistanceUtils.interpolate(v.low, v.high, 1, v.interpolation_func, v.interpolate_floats)

		for resistance = 1, ResistanceUtils.MAX_RESISTANCE do
			resistance_array[resistance][k] = interpolated_values[resistance]
		end
	end

	return resistance_array
end

return ResistanceUtils
