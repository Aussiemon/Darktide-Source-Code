-- chunkname: @scripts/ui/views/first_run_settings_view/components.lua

local components = {}

local function save_account_settings(location_name, settings_name, value)
	local player = Managers.player:local_player(1)
	local save_manager = Managers.save

	if player and save_manager then
		local account_data = save_manager:account_data()

		if location_name then
			account_data[location_name][settings_name] = value
		else
			account_data[settings_name] = value
		end

		save_manager:queue_save()

		return true
	end

	return false
end

local function get_account_settings(location_name, settings_name)
	local player = Managers.player:local_player(1)
	local save_manager = Managers.save

	if player and save_manager then
		local account_data = save_manager:account_data()

		if location_name then
			return account_data[location_name][settings_name]
		else
			return account_data[settings_name]
		end
	end
end

local function _is_same(current, new)
	if current == new then
		return true
	elseif type(current) == "table" and type(new) == "table" then
		for k, v in pairs(current) do
			if new[k] ~= v then
				return false
			end
		end

		for k, v in pairs(new) do
			if current[k] ~= v then
				return false
			end
		end

		return true
	else
		return false
	end
end

components.dropdown = function (template)
	if type(template.options) == "function" then
		template.options = template.options()
	end

	local entry = table.clone(template)

	entry.on_value_changed = nil

	local default_value

	if type(template.default_value) == "function" then
		default_value = template.default_value(template)
	else
		default_value = template.default_value
	end

	entry.get_function = function ()
		if template.get_function then
			local value = template.get_function(template)

			if value ~= nil then
				return value
			end
		end

		return default_value
	end

	entry.on_activated = function (new_value, current_value, new_option)
		if not _is_same(current_value, new_value) and template.on_value_changed then
			template.on_value_changed(template, new_value, new_option)
		end
	end

	entry.default_value = default_value

	return entry
end

components.checkbox = function (template)
	local entry = table.clone(template)

	entry.on_value_changed = nil

	local default_value

	if type(template.default_value) == "function" then
		default_value = template.default_value(template)
	else
		default_value = template.default_value
	end

	entry.default_value = default_value

	entry.get_function = function ()
		if template.get_function then
			local value = template.get_function(template)

			if value ~= nil then
				return value
			end
		end

		return default_value
	end

	local options_by_id = {}

	if template.options then
		for i = 1, #template.options do
			local option = template.options[i]
			local id = option.id

			options_by_id[id] = option
		end
	end

	entry.on_activated = function (new_value, current_value)
		if not _is_same(current_value, new_value) and template.on_value_changed then
			local option = options_by_id[tostring(new_value)]

			template.on_value_changed(template, new_value, option)
		end
	end

	return entry
end

components.percent_slider = function (template)
	local min_value = template.min_value or 0
	local max_value = template.max_value or 100
	local value_range = max_value - min_value
	local convertion_value = value_range / 100
	local step_size = template.step_size_value or 1
	local percent_step_size = step_size / convertion_value
	local default_value

	if type(template.default_value) == "function" then
		default_value = template.default_value(template)
	else
		default_value = ((template.default_value or min_value) - min_value) / convertion_value
	end

	local function explode_value(percent_value)
		local exploded_value = min_value + percent_value * convertion_value

		exploded_value = math.round(exploded_value / step_size) * step_size

		return exploded_value
	end

	local function value_get_function()
		local exploded_value = template.get_function(template)

		if exploded_value == nil then
			exploded_value = default_value
		end

		local percent_value = (exploded_value - min_value) / convertion_value

		return percent_value
	end

	local function on_value_changed_function(new_value, current_value)
		local exploded_value = explode_value(new_value)

		if template.on_value_changed then
			template.on_value_changed(template, exploded_value)
		end
	end

	local format_value_function = template.format_value_function or function (current_value)
		local exploded_value = explode_value(current_value)
		local result = string.format("%d %%", exploded_value)

		return result
	end
	local normalized_step_size = (percent_step_size or 1) / 100
	local entry = table.clone(template)

	entry.on_value_changed = nil
	entry.apply_on_drag = true
	entry.default_value = default_value or min_value
	entry.format_value_function = format_value_function
	entry.on_activated = on_value_changed_function
	entry.get_function = value_get_function
	entry.normalized_step_size = normalized_step_size

	return entry
end

components.value_slider = function (template)
	local min_value = template.min_value or 0
	local max_value = template.max_value or 100
	local step_size_value = template.step_size_value
	local num_decimals = template.num_decimals
	local default_value

	if type(template.default_value) == "function" then
		default_value = template.default_value(template)
	else
		default_value = template.default_value or min_value
	end

	local value_range = max_value - min_value
	local new_num_decimals = num_decimals or 1
	local step_size = step_size_value or 0.1
	local normalized_step_size = step_size / value_range

	local function explode_function(normalized_value)
		local exploded_value = min_value + normalized_value * value_range

		exploded_value = math.round(exploded_value / step_size) * step_size

		return exploded_value
	end

	local function value_get_function()
		if template.get_function then
			local value = template.get_function(template)

			if value ~= nil then
				return value
			end
		end

		return default_value
	end

	local function on_value_changed_function(new_value, current_value)
		if template.on_value_changed then
			template.on_value_changed(template, new_value)
		end
	end

	local value_change_function = on_value_changed_function

	local function format_value_function(value)
		local number_format = string.format("%%.%sf", new_num_decimals)
		local result = string.format(number_format, value)

		return result
	end

	local entry = table.clone(template)

	entry.on_value_changed = nil
	entry.apply_on_drag = true
	entry.default_value = default_value
	entry.format_value_function = format_value_function
	entry.on_activated = value_change_function
	entry.get_function = value_get_function
	entry.normalized_step_size = normalized_step_size
	entry.step_size = step_size
	entry.explode_function = explode_function
	entry.min_value = min_value
	entry.max_value = max_value

	return entry
end

return components
