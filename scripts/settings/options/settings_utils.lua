-- chunkname: @scripts/settings/options/settings_utils.lua

local function print_func(format, ...)
	print(string.format("[RenderSettings] " .. format, ...))
end

local function get_user_setting(location, key)
	if location then
		return Application.user_setting(location, key)
	else
		return Application.user_setting(key)
	end
end

local function set_user_setting(location, key, value)
	local perf_counter = Application.query_performance_counter()

	if location then
		Application.set_user_setting(location, key, value)

		if location == "render_settings" and type(value) ~= "table" then
			Application.set_render_setting(key, tostring(value))
		end
	else
		Application.set_user_setting(key, value)
	end

	local settings_parse_duration = Application.time_since_query(perf_counter)

	print_func("Time to parse setting [%s] with new value (%s): %.1fms.", key, value, settings_parse_duration)
end

local function apply_user_settings()
	local perf_counter = Application.query_performance_counter()

	Application.apply_user_settings()

	local user_settings_apply_duration = Application.time_since_query(perf_counter)

	print_func("Time to apply settings: %.1fms", user_settings_apply_duration)
	Renderer.bake_static_shadows()

	local event_manager = rawget(_G, "Managers") and Managers.event

	if event_manager then
		event_manager:trigger("event_on_render_settings_applied")
	end
end

local function save_user_settings()
	local perf_counter = Application.query_performance_counter()

	Application.save_user_settings()

	local user_settings_save_duration = Application.time_since_query(perf_counter)

	print_func("Time to save settings: %.1fms", user_settings_save_duration)
end

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

local function save_local_settings(settings_name, value)
	Application.set_user_setting("interface_settings", settings_name, value)
	Application.save_user_settings()
	Application.apply_user_settings()
end

local function get_local_settings(settings_name)
	return Application.user_setting("interface_settings", settings_name)
end

local function is_same(current, new)
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

local function remove_repeated_entries(changes_list, start_index)
	if not changes_list or #changes_list < 1 then
		return {}
	end

	local start_index = start_index or 1

	if start_index >= #changes_list then
		return changes_list
	else
		local occurences = {}
		local entry = changes_list[start_index]

		for i = start_index + 1, #changes_list do
			local stored_change = changes_list[i]

			if stored_change and stored_change.id == entry.id then
				occurences[#occurences + 1] = i
			end
		end

		local new_table = {}

		if #occurences > 0 then
			local count = #changes_list

			for i = 1, #occurences do
				local index = occurences[i]

				changes_list[index] = nil
			end

			for i = 1, count do
				if changes_list[i] then
					new_table[#new_table + 1] = changes_list[i]
				end
			end
		else
			new_table = changes_list
		end

		return remove_repeated_entries(new_table, start_index + 1)
	end
end

local function verify_and_apply_changes(changed_setting, new_value, affected_settings, origin_id, settings_by_id)
	local changes_list = {}
	local first_level = not affected_settings

	if first_level then
		changes_list[#changes_list + 1] = {
			id = changed_setting.id,
			value = new_value,
			save_location = changed_setting.save_location,
			require_apply = changed_setting.require_apply
		}
	end

	local settings_list = affected_settings or {}
	local changed_setting_valid = not changed_setting.validation_function or changed_setting.validation_function and changed_setting.validation_function(changed_setting)

	if changed_setting_valid and (not changed_setting.disabled or changed_setting.disabled and changed_setting.disabled_origin == origin_id) then
		if changed_setting.disable_rules then
			local disabled_by_id = {}
			local enabled_by_id = {}
			local affected_ids = {}

			for i = 1, #changed_setting.disable_rules do
				local disabled_rule = changed_setting.disable_rules[i]
				local disabled_setting = settings_by_id[disabled_rule.id]

				if disabled_setting and (not disabled_setting.validation_function or disabled_setting.validation_function and disabled_setting.validation_function(disabled_setting)) then
					if disabled_rule.validation_function(new_value) then
						if not disabled_by_id[disabled_rule.id] then
							affected_ids[disabled_rule.id] = true
							disabled_by_id[disabled_rule.id] = {
								disabled_origin_id = changed_setting.id,
								affected_setting = disabled_setting,
								disabled_rule = disabled_rule
							}
						end
					elseif not disabled_rule.validation_function(new_value) and (not disabled_setting.disabled_by or disabled_setting.disabled_by and disabled_setting.disabled_by[changed_setting.id]) and not enabled_by_id[disabled_rule.id] then
						affected_ids[disabled_rule.id] = true
						enabled_by_id[disabled_rule.id] = {
							disabled_origin_id = changed_setting.id,
							affected_setting = disabled_setting,
							disabled_rule = disabled_rule
						}
					end
				end
			end

			for id, _ in pairs(affected_ids) do
				local disabled_data = disabled_by_id[id]
				local enabled_data = enabled_by_id[id]

				if disabled_data then
					local disabled_setting = disabled_data.affected_setting
					local disabled_origin_id = disabled_data.disabled_origin_id
					local disabled_rule = disabled_data.disabled_rule

					disabled_setting.disabled_by = disabled_setting.disabled_by or {}

					if table.is_empty(disabled_setting.disabled_by) then
						disabled_setting.value_on_enabled = disabled_setting.get_function(disabled_setting)
						disabled_setting.disabled_origin = disabled_origin_id
					end

					disabled_setting.disabled_by[changed_setting.id] = disabled_rule.reason
					disabled_setting.disabled = true
					changes_list[#changes_list + 1] = {
						id = disabled_rule.id,
						value = disabled_rule.disable_value,
						save_location = disabled_setting.save_location,
						require_apply = disabled_setting.require_apply
					}
				elseif enabled_data then
					local enabled_setting = enabled_data.affected_setting
					local enabled_origin_id = enabled_data.disabled_origin_id
					local disabled_rule = enabled_data.disabled_rule

					if enabled_setting.disabled_by and enabled_setting.disabled_by[enabled_origin_id] then
						enabled_setting.disabled_by[enabled_origin_id] = nil
						enabled_setting.disabled = not table.is_empty(enabled_setting.disabled_by)
					end

					if enabled_setting.disabled == false then
						enabled_setting.disabled_origin = nil
						changes_list[#changes_list + 1] = {
							id = disabled_rule.id,
							value = enabled_setting.value_on_enabled,
							save_location = enabled_setting.save_location,
							require_apply = enabled_setting.require_apply
						}
					end
				end
			end
		end

		if changed_setting.options then
			for i = 1, #changed_setting.options do
				local option = changed_setting.options[i]

				if option.id == new_value then
					if option.values then
						for id, value in pairs(option.values) do
							if type(value) == "table" then
								for inner_id, inner_value in pairs(value) do
									if settings_by_id[inner_id] and (not settings_by_id[inner_id].validation_function or settings_by_id[inner_id].validation_function and settings_by_id[inner_id].validation_function()) then
										if not settings_by_id[inner_id].disabled then
											changes_list[#changes_list + 1] = {
												id = inner_id,
												value = inner_value,
												save_location = settings_by_id[inner_id].save_location,
												require_apply = settings_by_id[inner_id].require_apply
											}
										elseif settings_by_id[inner_id].disabled then
											settings_by_id[inner_id].value_on_enabled = inner_value
										end
									elseif not settings_by_id[inner_id] then
										changes_list[#changes_list + 1] = {
											id = inner_id,
											value = inner_value,
											save_location = id
										}
									end
								end
							elseif settings_by_id[id] and (not settings_by_id[id].validation_function or settings_by_id[id].validation_function and settings_by_id[id].validation_function()) then
								if not settings_by_id[id].disabled then
									changes_list[#changes_list + 1] = {
										id = id,
										value = value,
										save_location = settings_by_id[id].save_location,
										require_apply = settings_by_id[id].require_apply
									}
								elseif settings_by_id[id].disabled then
									settings_by_id[id].value_on_enabled = value
								end
							elseif not settings_by_id[id] then
								changes_list[#changes_list + 1] = {
									id = id,
									value = value
								}
							end
						end
					end

					if option.apply_values_on_edited then
						for id, value in pairs(option.apply_values_on_edited) do
							if settings_by_id[id] and (not settings_by_id[id].validation_function or settings_by_id[id].validation_function and settings_by_id[id].validation_function()) then
								if not settings_by_id[id].disabled then
									changes_list[#changes_list + 1] = {
										id = id,
										value = value,
										save_location = settings_by_id[id].save_location,
										require_apply = settings_by_id[id].require_apply
									}
								elseif settings_by_id[id] and settings_by_id[id].disabled then
									settings_by_id[id].value_on_enabled = value
								end
							end
						end
					end

					break
				end
			end
		end

		if changed_setting.apply_values_on_edited then
			for id, value in pairs(changed_setting.apply_values_on_edited) do
				if settings_by_id[id] and (not settings_by_id[id].validation_function or settings_by_id[id].validation_function and settings_by_id[id].validation_function()) then
					if not settings_by_id[id].disabled then
						changes_list[#changes_list + 1] = {
							id = id,
							value = value,
							save_location = settings_by_id[id].save_location,
							require_apply = settings_by_id[id].require_apply
						}
					elseif settings_by_id[id].disabled then
						settings_by_id[id].value_on_enabled = value
					end
				end
			end
		end

		for i = 1, #changes_list do
			local change = changes_list[i]

			settings_list[#settings_list + 1] = change

			if settings_by_id[change.id] then
				local should_verify = first_level and i > 1 or not first_level

				if should_verify then
					verify_and_apply_changes(settings_by_id[change.id], change.value, settings_list, changed_setting.id, settings_by_id)
				end
			end
		end
	end

	if first_level then
		local filtered_changes = remove_repeated_entries(settings_list)
		local dirty = false
		local require_apply = false

		for i = 1, #filtered_changes do
			local setting_changed = filtered_changes[i]

			if setting_changed.require_apply then
				require_apply = true
			end

			local id = setting_changed.id
			local new_value = setting_changed.value

			if settings_by_id[id] and settings_by_id[id].on_changed then
				local saved, needs_apply = settings_by_id[id].on_changed(new_value, settings_by_id[id])

				dirty = dirty or saved

				if not require_apply then
					require_apply = needs_apply
				end
			elseif settings_by_id[id] and settings_by_id[id].on_value_changed_function then
				settings_by_id[id].on_value_changed_function(new_value, settings_by_id[id])

				local save_location = setting_changed.save_location
				local current_value = setting_changed.get_function(setting_changed)

				if not is_same(current_value, new_value) then
					set_user_setting(save_location, id, new_value)

					dirty = true

					if not require_apply then
						require_apply = setting_changed.require_apply
					end
				end
			else
				local save_location = setting_changed.save_location
				local current_value = get_user_setting(save_location, id)

				if not is_same(current_value, new_value) then
					set_user_setting(save_location, id, new_value)

					dirty = true
					require_apply = require_apply or setting_changed.require_apply
				end
			end
		end

		if dirty then
			if require_apply then
				apply_user_settings()
			end

			save_user_settings()
		end
	end
end

local function generate_settings(settings)
	local settings_by_id = {}

	for i = 1, #settings do
		local setting = settings[i]

		if setting.id then
			settings_by_id[setting.id] = setting
		end
	end

	return {
		settings_by_id = settings_by_id,
		verify_and_apply_changes = function (changed_setting, new_value, affected_settings, origin_id)
			return verify_and_apply_changes(changed_setting, new_value, affected_settings, origin_id, settings_by_id)
		end,
		is_same = function (current, new)
			return is_same(current, new)
		end,
		get_account_settings = function (location_name, settings_name)
			return get_account_settings(location_name, settings_name)
		end,
		save_account_settings = function (location_name, settings_name, value)
			return save_account_settings(location_name, settings_name, value)
		end,
		get_user_setting = function (location, key)
			return get_user_setting(location, key)
		end,
		set_user_setting = function (location, key, value)
			return set_user_setting(location, key, value)
		end,
		apply_user_settings = function ()
			return apply_user_settings()
		end,
		save_user_settings = function ()
			return save_user_settings()
		end,
		save_local_settings = function (settings_name, value)
			return save_local_settings(settings_name, value)
		end,
		get_local_settings = function (settings_name)
			return get_local_settings(settings_name)
		end
	}
end

return function (settings)
	return generate_settings(settings)
end
