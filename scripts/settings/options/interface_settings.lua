local OptionsUtilities = require("scripts/utilities/ui/options")

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

local function construct_interface_settings_boolean(template)
	local entry = {
		default_value = template.default_value,
		display_name = template.display_name,
		on_value_changed = template.on_value_changed
	}
	local id = template.id
	local save_location = template.save_location
	local default_value = template.default_value

	entry.get_function = function ()
		local old_value = get_account_settings(save_location, id)

		if old_value == nil then
			return default_value
		else
			return old_value
		end
	end

	entry.on_activated = function (new_value)
		local current_value = get_account_settings(save_location, id)

		if current_value == nil then
			current_value = default_value
		end

		if not _is_same(current_value, new_value) then
			save_account_settings(save_location, id, new_value)

			if entry.on_value_changed then
				entry.on_value_changed(new_value)
			end
		end
	end

	return entry
end

local function construct_interface_settings_percent_slider(template)
	local min_value = template.min_value or 0
	local max_value = template.max_value or 100
	local value_range = max_value - min_value
	local convertion_value = value_range / 100
	local step_size = template.step_size_value or 1
	local percent_step_size = step_size / convertion_value
	local default_value = ((template.default_value or min_value) - min_value) / convertion_value
	local id = template.id
	local save_location = template.save_location

	local function explode_value(percent_value)
		local exploded_value = min_value + percent_value * convertion_value
		exploded_value = math.round(exploded_value / step_size) * step_size

		return exploded_value
	end

	local on_value_changed = template.on_value_changed

	local function on_value_changed_function(percent_value)
		local exploded_value = explode_value(percent_value)

		save_account_settings(save_location, id, exploded_value)

		if on_value_changed then
			on_value_changed(exploded_value)
		end
	end

	local value_get_function = template.get_function or function ()
		local exploded_value = get_account_settings(save_location, id)

		if exploded_value == nil then
			exploded_value = default_value
		end

		local percent_value = (exploded_value - min_value) / convertion_value

		return percent_value
	end
	local format_value_function = template.format_value_function or function (current_value)
		local exploded_value = explode_value(current_value)
		local result = string.format("%d %%", exploded_value)

		return result
	end
	local params = {
		apply_on_drag = true,
		display_name = template.display_name,
		default_value = default_value,
		step_size_value = percent_step_size,
		value_get_function = value_get_function,
		on_value_changed_function = on_value_changed_function,
		format_value_function = format_value_function
	}

	return OptionsUtilities.create_percent_slider_template(params)
end

local function construct_interface_settings_value_slider(template)
	local min_value = template.min_value or 0
	local max_value = template.max_value or 100
	local default_value = template.default_value or min_value
	local step_size_value = template.step_size_value
	local num_decimals = template.num_decimals
	local on_value_changed = template.on_value_changed
	local id = template.id
	local save_location = template.save_location

	local function on_value_changed_function(value)
		save_account_settings(save_location, id, value)

		if on_value_changed then
			on_value_changed(value)
		end
	end

	local function value_get_function()
		return get_account_settings(save_location, id) or default_value
	end

	local params = {
		apply_on_drag = true,
		min_value = min_value,
		max_value = max_value,
		display_name = template.display_name,
		default_value = default_value,
		num_decimals = num_decimals,
		step_size_value = step_size_value,
		value_get_function = value_get_function,
		on_value_changed_function = on_value_changed_function
	}

	return OptionsUtilities.create_value_slider_template(params)
end

local template_functions = {
	boolean = construct_interface_settings_boolean,
	percent_slider = construct_interface_settings_percent_slider,
	value_slider = construct_interface_settings_value_slider
}
local settings_definitions = {
	{
		group_name = "subtitle_settings",
		display_name = "loc_settings_menu_group_subtitle_settings",
		widget_type = "group_header"
	},
	{
		save_location = "interface_settings",
		display_name = "loc_interface_setting_subtitle_enabled",
		id = "subtitle_enabled",
		default_value = true,
		widget_type = "boolean",
		on_value_changed = function (value)
			Managers.event:trigger("event_update_subtitles_enabled", value)
		end
	},
	{
		save_location = "interface_settings",
		display_name = "loc_interface_setting_subtitle_speaker_enabled",
		id = "subtitle_speaker_enabled",
		default_value = true,
		widget_type = "boolean",
		on_value_changed = function (value)
			Managers.event:trigger("event_update_subtitle_speaker_enabled", value)
		end
	},
	{
		save_location = "interface_settings",
		min_value = 0,
		display_name = "loc_interface_setting_subtitle_background_opacity",
		id = "subtitle_background_opacity",
		default_value = 80,
		widget_type = "percent_slider",
		on_value_changed = function (value)
			Managers.event:trigger("event_update_subtitles_background_opacity", value)
		end
	},
	{
		save_location = "interface_settings",
		min_value = 10,
		display_name = "loc_interface_setting_subtitle_text_opacity",
		id = "subtitle_text_opacity",
		default_value = 100,
		widget_type = "percent_slider",
		on_value_changed = function (value)
			Managers.event:trigger("event_update_subtitle_text_opacity", value)
		end
	},
	{
		step_size_value = 1,
		min_value = 12,
		display_name = "loc_interface_setting_subtitle_font_size",
		num_decimals = 0,
		max_value = 72,
		default_value = 32,
		widget_type = "value_slider",
		id = "subtitle_font_size",
		save_location = "interface_settings",
		on_value_changed = function (value)
			Managers.event:trigger("event_update_subtitles_font_size", value)
		end
	},
	{
		group_name = "other_settings",
		display_name = "loc_settings_menu_group_other_settings",
		widget_type = "group_header"
	},
	{
		save_location = "interface_settings",
		display_name = "loc_interface_setting_news_enabled",
		id = "news_enabled",
		default_value = true,
		widget_type = "boolean",
		on_value_changed = function (value)
			Managers.event:trigger("event_update_news_enabled", value)
		end
	}
}
local settings = {}

for i = 1, #settings_definitions, 1 do
	local definition = settings_definitions[i]
	local widget_type = definition.widget_type
	local template_function = template_functions[widget_type]

	if template_function then
		settings[#settings + 1] = template_function(definition)
	else
		settings[#settings + 1] = definition
	end
end

return {
	icon = "content/ui/materials/icons/system/settings/category_interface",
	display_name = "loc_settings_menu_category_interface",
	settings = settings
}
