-- chunkname: @scripts/extension_systems/unit_data/unit_data_component_config_formatter.lua

local UnitDataComponentConfigFormatter = {}
local _get_network_info
local LUA_TYPES = {
	Quaternion = "Quaternion",
	Unit = "Unit",
	Vector3 = "Vector3",
	ability_charges = "number",
	action_combo_count = "number",
	action_time_scale = "number",
	actor_node_index = "number",
	aim_assist_multiplier = "number",
	ammunition_large = "number",
	ammunition_small = "number",
	bool = "boolean",
	buff_id = "number",
	buff_proc_count = "number",
	buff_stack_count = "number",
	character_height = "number",
	consecutive_dodges = "number",
	extra_long_distance = "number",
	fixed_frame_offset = "number",
	fixed_frame_offset_end_t_4bit = "number",
	fixed_frame_offset_end_t_6bit = "number",
	fixed_frame_offset_end_t_7bit = "number",
	fixed_frame_offset_end_t_9bit = "number",
	fixed_frame_offset_small = "number",
	fixed_frame_offset_start_t_5bit = "number",
	fixed_frame_offset_start_t_6bit = "number",
	fixed_frame_offset_start_t_7bit = "number",
	fixed_frame_offset_start_t_9bit = "number",
	fixed_frame_time = "number",
	game_object_id = "number",
	high_precision_direction = "Vector3",
	high_precision_position_component = "number",
	high_precision_velocity = "Vector3",
	hit_zone_actor_index = "hit_zone_actor_index",
	level_unit_id = "number",
	local_move_speed = "number",
	locomotion_parent = "Unit",
	locomotion_position = "Vector3",
	locomotion_rotation = "Quaternion",
	lookup_1bit = "number",
	lookup_2bit0 = "number",
	low_precision_long_distance = "number",
	minigame_state_id = "number",
	move_speed = "number",
	movement_settings = "number",
	mover_frames = "number",
	num_special_charges = "number",
	number = "number",
	percentage = "number",
	player_anim = "number",
	player_anim_layer = "number",
	player_anim_state = "number",
	player_anim_time = "number",
	prd_state = "prd_state",
	projectile_speed = "number",
	random_seed = "number",
	recoil_angle = "number",
	recoil_unsteadiness = "number",
	rotation_single = "number",
	rotation_step = "number",
	short_distance = "number",
	short_time = "number",
	stamina_fraction = "number",
	talent_resource = "number",
	warp_charge = "number",
	warp_charge_ramping_modifier = "number",
	weapon_charge_level = "number",
	weapon_overheat = "number",
	weapon_spread = "number",
	weapon_sway = "number",
	weapon_sway_offset = "number",
	weapon_view_lock = "number",
	wounds = "number",
}
local HUSK_NETWORK_TYPE_CONVERSION = {
	Quaternion = "quaternion_17bit",
	Vector3 = "position",
	locomotion_position = "position",
}

UnitDataComponentConfigFormatter.format = function (config, gameobject_name, husk_config, husk_gameobject_name, husk_hud_config, husk_hud_gameobject_name)
	local formatted_config = {}
	local field_network_lookup = {}
	local formatted_husk_config = {}
	local formatted_husk_hud_config = {}
	local lookup_index = 0
	local global_network_lookup_string
	local sorted_components = table.keys(config)

	table.sort(sorted_components)

	local locomotion_parent = {}
	local locomotion_children = {}
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
			local field_type, field_network_type, lookup
			local skip_predict_verification = false
			local use_network_lookup

			if type(data) == "table" then
				field_type = "string"
				use_network_lookup = data.use_network_lookup
				field_network_type = data.network_type

				if not use_network_lookup then
					lookup = {}

					local lookup_size = #data

					for i = 1, lookup_size do
						local val = data[i]

						lookup[i] = val
						lookup[val] = i
					end

					if not field_network_type then
						local num_bits = math.floor(math.log(lookup_size) / math.log(2)) + 1

						field_network_type = "lookup_" .. num_bits .. "bit"
					end
				end

				skip_predict_verification = data.skip_predict_verification or false
			else
				field_network_type = data
				field_type = LUA_TYPES[field_network_type]
			end

			local additional_data

			if field_network_type == "locomotion_parent" then
				locomotion_parent.component_name = component_name
				locomotion_parent.field_name = field_name
				additional_data = {
					children = locomotion_children,
				}
			elseif field_network_type == "locomotion_position" or field_network_type == "locomotion_rotation" then
				locomotion_children[#locomotion_children + 1] = {
					component_name = component_name,
					field_name = field_name,
				}
				additional_data = {
					parent = locomotion_parent,
				}
			end

			field_network_lookup[lookup_index] = {
				component_name,
				field_name,
				field_type,
				field_network_name,
				field_network_type,
				lookup,
				skip_predict_verification,
				use_network_lookup,
			}
			component_config[field_name] = {
				type = field_type,
				lookup_index = lookup_index,
				field_network_type = field_network_type,
				additional_data = additional_data,
			}
		end
	end

	local sorted_husk_components = table.keys(husk_config)

	table.sort(sorted_husk_components)

	for component_i = 1, #sorted_husk_components do
		local component_name = sorted_husk_components[component_i]
		local formatted_husk_component = {}

		formatted_husk_config[component_name] = formatted_husk_component

		local husk_component = husk_config[component_name]
		local formatted_component = formatted_config[component_name]

		table.sort(husk_component)

		for field_i = 1, #husk_component do
			local field_name = husk_component[field_i]

			formatted_husk_component[field_name] = true

			local network_name, network_type = _get_network_info(field_name, formatted_component, field_network_lookup)
		end
	end

	local sorted_husk_hud_components = table.keys(husk_hud_config)

	table.sort(sorted_husk_hud_components)

	for component_i = 1, #sorted_husk_hud_components do
		local component_name = sorted_husk_hud_components[component_i]
		local formatted_husk_hud_component = {}

		formatted_husk_hud_config[component_name] = formatted_husk_hud_component

		local husk_hud_component = husk_hud_config[component_name]
		local formatted_component = formatted_config[component_name]

		table.sort(husk_hud_component)

		for field_i = 1, #husk_hud_component do
			local field_name = husk_hud_component[field_i]
			local husk_component = formatted_husk_config[component_name]

			if husk_component then
				-- Nothing
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
	local network_name, network_type = field[4], field[5]
	local converted_type = HUSK_NETWORK_TYPE_CONVERSION[network_type] or network_type

	return network_name, converted_type
end

return UnitDataComponentConfigFormatter
