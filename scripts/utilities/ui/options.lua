local OptionsUtilities = {}

OptionsUtilities.create_percent_slider_template = function (params)
	local normalized_step_size = params.normalized_step_size or (params.step_size_value or 1) / 100
	local default_value = params.default_value or 0

	local function default_value_function()
		return default_value
	end

	local value_get_function = params.value_get_function or default_value_function
	local value_change_function = params.on_value_changed_function or default_value_function
	local format_value_function = params.format_value_function
	format_value_function = format_value_function or function (percent_value)
		local result = string.format("%d %%", percent_value)

		return result
	end
	local slider_template = {
		widget_type = "percent_slider",
		display_name = params.display_name,
		default_value = default_value,
		on_activated = value_change_function,
		get_function = value_get_function,
		format_value_function = format_value_function,
		normalized_step_size = normalized_step_size,
		apply_on_drag = params.apply_on_drag,
		indentation_level = params.indentation_level,
		validation_function = params.validation_function,
		disable_rules = params.disable_rules,
		id = params.id,
		tooltip_text = params.tooltip_text
	}

	return slider_template
end

OptionsUtilities.create_value_slider_template = function (params)
	local min_value = params.min_value
	local max_value = params.max_value
	local value_range = max_value - min_value
	local default_value = params.default_value or min_value
	local num_decimals = params.num_decimals or 1
	local step_size = params.step_size_value or 0.1
	local normalized_step_size = step_size / value_range
	local explode_function = params.explode_function or function (normalized_value)
		local exploded_value = min_value + normalized_value * value_range
		exploded_value = math.round(exploded_value / step_size) * step_size

		return exploded_value
	end

	local function default_value_function(normalized_value)
		return default_value
	end

	local value_get_function = params.value_get_function or default_value_function
	local value_change_function = params.on_value_changed_function or default_value_function
	local format_value_function = params.format_value_function
	format_value_function = format_value_function or function (value)
		local number_format = string.format("%%.%sf", num_decimals)
		local result = string.format(number_format, value)

		return result
	end
	local slider_template = {
		widget_type = "value_slider",
		min_value = min_value,
		max_value = max_value,
		display_name = params.display_name,
		default_value = default_value,
		on_activated = value_change_function,
		get_function = value_get_function,
		explode_function = explode_function,
		format_value_function = format_value_function,
		step_size = step_size,
		normalized_step_size = normalized_step_size,
		apply_on_drag = params.apply_on_drag,
		indentation_level = params.indentation_level,
		validation_function = params.validation_function,
		disable_rules = params.disable_rules,
		id = params.id,
		tooltip_text = params.tooltip_text
	}

	return slider_template
end

OptionsUtilities.keybind_value_to_string = function (value)
	if not value then
		return
	end

	local out = nil

	if type(value) == "table" then
		for n, i in ipairs(value) do
			if not out then
				out = i
			else
				out = out .. "+" .. i
			end
		end

		if out then
			return out
		end

		for k, v in pairs(value) do
			if type(v) == "table" then
				v = OptionsUtilities.keybind_value_to_string(v)
			end

			if not out then
				out = v
			else
				out = out .. "+" .. v
			end
		end

		return out
	end

	return tostring(value)
end

return OptionsUtilities
