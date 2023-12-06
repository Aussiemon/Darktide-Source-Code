local SaveData = require("scripts/managers/save/save_data")
local group_name_display_names = {
	input_group_interface = "loc_keybind_category_interface",
	input_group_combat = "loc_keybind_category_combat",
	input_group_hotkeys = "loc_keybind_category_hotkeys",
	input_group_movement = "loc_keybind_category_movement"
}
local services = {
	"Ingame",
	"View"
}
local devices = {
	"keyboard",
	"mouse"
}
local reserved_keys = {}
local cancel_keys = {
	"keyboard_esc"
}
local settings = {}

if IS_XBS or IS_WINDOWS then
	local input_manager = Managers.input

	for _, service_type in ipairs(services) do
		local alias = input_manager:alias_object(service_type)

		if alias then
			local alias_table = alias:alias_table()

			for alias_name, _ in pairs(alias_table) do
				local alias_array_index = 1
				local is_bindable = alias:bindable(alias_name)
				local hide_in_keybindings_menu = alias:hide_in_keybindings_menu(alias_name)

				if is_bindable and not hide_in_keybindings_menu then
					local key_info = alias:get_keys_for_alias(alias_name, alias_array_index, devices)
					local display_name = alias:description(alias_name)
					local group_name = alias:group(alias_name)
					local sort_order = alias:sort_order(alias_name)
					settings[#settings + 1] = {
						widget_type = "keybind",
						alias = alias,
						alias_name = alias_name,
						service_type = service_type,
						display_name = display_name,
						group_name = group_name,
						devices = devices,
						sort_order = sort_order,
						cancel_keys = cancel_keys,
						on_activated = function (new_value, old_value)
							for i = 1, #cancel_keys do
								local cancel_key = cancel_keys[i]

								if cancel_key == new_value.main then
									return true
								end
							end

							for i = 1, #reserved_keys do
								local reserved_key = reserved_keys[i]

								if reserved_key == new_value.main then
									return false
								end
							end

							alias:set_keys_for_alias(alias_name, alias_array_index, devices, new_value)
							input_manager:apply_alias_changes(service_type)
							input_manager:save_key_mappings(service_type)

							return true
						end,
						get_function = function ()
							local key_info = alias:get_keys_for_alias(alias_name, alias_array_index, devices)

							return key_info
						end
					}
				end
			end
		end
	end
end

local function group_name_sort_function(a, b)
	local a_group_name = a.group_name
	local b_group_name = b.group_name

	if a_group_name and b_group_name then
		if a_group_name == b_group_name then
			local a_sort_order = a.sort_order or math.huge
			local b_sort_order = b.sort_order or math.huge

			return a_sort_order < b_sort_order
		end

		return a_group_name < b_group_name
	else
		local a_display_name = a.display_name
		local b_display_name = b.display_name

		return a_display_name < b_display_name
	end

	return false
end

local groups_added = {}

table.sort(settings, group_name_sort_function)

for i = 1, #settings do
	local setting = settings[i]
	local group_name = setting.group_name

	if group_name and not groups_added[group_name] then
		groups_added[group_name] = true
		local group_header_entry = {
			widget_type = "group_header",
			group_name = group_name,
			display_name = group_name_display_names[group_name] or "n/a"
		}

		table.insert(settings, i, group_header_entry)

		i = i + 1
	end
end

local function reset_function()
	local input_manager = Managers.input

	for _, service_type in ipairs(services) do
		local alias = input_manager:alias_object(service_type)

		if alias then
			alias:restore_default_by_devices(nil, devices)
			input_manager:apply_alias_changes(service_type)
			input_manager:save_key_mappings(service_type)
		end
	end
end

return {
	icon = "content/ui/materials/icons/system/settings/category_keybindings",
	display_name = "loc_settings_menu_category_keybind",
	settings = settings,
	reset_function = reset_function
}
