local template_functions = require("scripts/ui/views/first_run_settings_view/components")
local SaveData = require("scripts/managers/save/save_data")
local utils = {}

utils.extract_changed_values = function (template, new_value)
	local values = {}

	if type(new_value) == "table" then
		for value_save_location, location_values in pairs(new_value) do
			if type(location_values) == "table" and location_values[1] == nil then
				for location_value_id, location_value in pairs(location_values) do
					values[#values + 1] = {
						save_location = value_save_location,
						id = location_value_id,
						value = location_value
					}
				end
			else
				values[#values + 1] = {
					id = value_save_location,
					value = location_values
				}
			end
		end
	else
		values[#values + 1] = {
			save_location = template.save_location,
			id = template.id,
			value = new_value
		}
	end

	return values
end

utils.add_side_effect_values = function (dest, new)
	local value = table.clone(dest)

	for value_save_location, location_values in pairs(new) do
		if type(location_values) == "table" and location_values[1] == nil then
			for location_value_id, location_value in pairs(location_values) do
				value[value_save_location][location_value_id] = location_value
			end
		else
			value[value_save_location] = location_values
		end
	end

	return value
end

utils.save_account_settings = function (location_name, settings_name, value)
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

utils.get_account_settings = function (location_name, settings_name)
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

utils.get_user_setting = function (location, key)
	if location then
		return Application.user_setting(location, key)
	else
		return Application.user_setting(key)
	end
end

utils.set_user_setting = function (location, key, value)
	if location then
		Application.set_user_setting(location, key, value)
	else
		Application.set_user_setting(key, value)
	end

	Application.save_user_settings()
end

utils.generate_settings_options = function (settings_definitions)
	local settings = {}

	for i = 1, #settings_definitions do
		local definition = settings_definitions[i]
		local widget_type = definition.widget_type
		local template_function = template_functions[widget_type]
		local setting_visibility = definition.setting_visibility

		if setting_visibility == true or setting_visibility == nil then
			if template_function then
				settings[#settings + 1] = template_function(definition)
			else
				settings[#settings + 1] = definition
			end
		end
	end

	return settings
end

utils.get_default_account_save_data = function (template)
	local save_location = template.save_location
	local id = template.id

	if save_location then
		return SaveData.default_account_data[save_location][id]
	else
		return SaveData.default_account_data[id]
	end
end

return utils
