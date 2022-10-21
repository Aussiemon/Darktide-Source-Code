local UnitDataComponentConfigFormatter = {}
local _get_network_info = nil
local LUA_TYPES = {
	buff_id = "number",
	level_unit_id = "number",
	low_precision_long_distance = "number",
	high_precision_direction = "Vector3",
	fixed_frame_time = "number",
	Quaternion = "Quaternion",
	fixed_frame_offset_small = "number",
	Vector3 = "Vector3",
	player_anim_time = "number",
	rotation_single = "number",
	buff_stack_count = "number",
	minigame_state_id = "number",
	fixed_frame_offset_end_t_4bit = "number",
	weapon_charge_level = "number",
	actor_node_index = "number",
	wounds = "number",
	fixed_frame_offset_end_t_7bit = "number",
	fixed_frame_offset_start_t_7bit = "number",
	weapon_view_lock = "number",
	Unit = "Unit",
	random_seed = "number",
	extra_long_distance = "number",
	player_anim_layer = "number",
	local_move_speed = "number",
	recoil_unsteadiness = "number",
	stamina_fraction = "number",
	buff_proc_count = "number",
	character_height = "number",
	rotation_step = "number",
	num_special_activations = "number",
	action_time_scale = "number",
	bool = "boolean",
	hit_zone_actor_index = "hit_zone_actor_index",
	player_anim = "number",
	short_time = "number",
	fixed_frame_offset_start_t_6bit = "number",
	specialization_resource = "number",
	high_precision_position_component = "number",
	warp_charge = "number",
	fixed_frame_offset = "number",
	projectile_speed = "number",
	prd_state = "prd_state",
	weapon_overheat = "number",
	weapon_spread = "number",
	weapon_sway = "number",
	weapon_sway_offset = "number",
	player_anim_state = "number",
	short_distance = "number",
	fixed_frame_offset_end_t_6bit = "number",
	percentage = "number",
	consecutive_dodges = "number",
	move_speed = "number",
	powered_weapon_intensity = "number",
	number = "number",
	movement_settings = "number",
	ability_charges = "number",
	warp_charge_ramping_modifier = "number",
	ammunition = "number",
	recoil_angle = "number",
	high_precision_velocity = "Vector3",
	aim_assist_multiplier = "number"
}

UnitDataComponentConfigFormatter.format = function (config, gameobject_name, husk_config, husk_gameobject_name, husk_hud_config, husk_hud_gameobject_name)
	local formatted_config = {}
	local field_network_lookup = {}
	local formatted_husk_config = {}
	local formatted_husk_hud_config = {}
	local lookup_index = 0
	local global_network_lookup_string = nil
	local sorted_components = table.keys(config)

	table.sort(sorted_components)

	local num_components = #sorted_components

	for component_index = 1, num_components do
		local component_name = sorted_components[component_index]
		local component = config[component_name]
		local component_config = {}
		formatted_config[component_name] = component_config
		local sorted_fields = table.keys(component)

		table.sort(sorted_fields)

		local num_sorted_fields = #sorted_fields

		for field_index = 1, num_sorted_fields do
			local field_name = sorted_fields[field_index]
			local data = component[field_name]
			lookup_index = lookup_index + 1
			local field_network_name = component_name .. "_" .. field_name
			local field_type, field_network_type, lookup = nil
			local skip_predict_verification = false

			if type(data) == "table" then
				field_type = "string"
				lookup = {}
				local lookup_size = #data

				for i = 1, lookup_size do
					local val = data[i]
					lookup[i] = val
					lookup[val] = i
				end

				field_network_type = data.network_type

				if not field_network_type then
					local num_bits = math.floor(math.log(lookup_size) / math.log(2)) + 1
					field_network_type = "lookup_" .. num_bits .. "bit"
				end

				skip_predict_verification = data.skip_predict_verification or false
			else
				field_network_type = data
				field_type = LUA_TYPES[field_network_type]

				fassert(field_type, "Network type %q used in field %q does not have a bound lua type in LUA_TYPES.", field_network_type, field_name)
			end

			field_network_lookup[lookup_index] = {
				component_name,
				field_name,
				field_type,
				field_network_name,
				field_network_type,
				lookup,
				skip_predict_verification
			}
			component_config[field_name] = {
				type = field_type,
				lookup_index = lookup_index,
				field_network_type = field_network_type
			}
		end
	end

	local sorted_husk_components = table.keys(husk_config)

	table.sort(sorted_husk_components)

	for component_i = 1, #sorted_husk_components do
		local component_name = sorted_husk_components[component_i]

		fassert(formatted_config[component_name], "[PlayerHuskDataComponentConfig] Component \"%s\" does not exist in PlayerUnitDataComponentConfig.", component_name)

		local formatted_husk_component = {}
		formatted_husk_config[component_name] = formatted_husk_component
		local husk_component = husk_config[component_name]
		local formatted_component = formatted_config[component_name]

		table.sort(husk_component)

		for field_i = 1, #husk_component do
			local field_name = husk_component[field_i]

			fassert(formatted_component[field_name], "[PlayerHuskDataComponentConfig] \"%s\" does not exist in \"%s\"", field_name, component_name)

			formatted_husk_component[field_name] = true
			local network_name, network_type = _get_network_info(field_name, formatted_component, field_network_lookup)
		end
	end

	local sorted_husk_hud_components = table.keys(husk_hud_config)

	table.sort(sorted_husk_hud_components)

	for component_i = 1, #sorted_husk_hud_components do
		local component_name = sorted_husk_hud_components[component_i]

		fassert(formatted_config[component_name], "[PlayerHuskHudDataComponentConfig] Component \"%s\" does not exist in PlayerUnitDataComponentConfig.", component_name)

		local formatted_husk_hud_component = {}
		formatted_husk_hud_config[component_name] = formatted_husk_hud_component
		local husk_hud_component = husk_hud_config[component_name]
		local formatted_component = formatted_config[component_name]

		table.sort(husk_hud_component)

		for field_i = 1, #husk_hud_component do
			local field_name = husk_hud_component[field_i]

			fassert(formatted_component[field_name], "[PlayerHuskHudDataComponentConfig] \"%s\" does not exist in \"%s\"", field_name, component_name)

			local husk_component = formatted_husk_config[component_name]

			if husk_component then
				fassert(husk_component[field_name] == nil, "[PlayerHuskHudDataComponentConfig] Field \"%s\" in component \"%s\" is already tracked in husk_data_component_config.", field_name, component_name)
			end

			formatted_husk_hud_component[field_name] = true
			local network_name, network_type = _get_network_info(field_name, formatted_component, field_network_lookup)
		end
	end

	return formatted_config, field_network_lookup, formatted_husk_config, formatted_husk_hud_config, global_network_lookup_string
end

function _get_network_info(field_name, formatted_component, field_network_lookup)
	local formatted_field = formatted_component[field_name]
	local field_lookup_index = formatted_field.lookup_index
	local field = field_network_lookup[field_lookup_index]
	local network_name = field[4]
	local network_type = field[5]

	return network_name, network_type
end

return UnitDataComponentConfigFormatter
