-- chunkname: @scripts/ui/views/talent_builder_view/utilities/talent_layout_parser.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BuffTemplates = require("scripts/settings/buff/buff_templates")
local DamageCalculation = require("scripts/utilities/attack/damage_calculation")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local TextUtilities = require("scripts/utilities/ui/text")
local armor_types = ArmorSettings.types
local TalentLayoutParser = {}

TalentLayoutParser.verify = function (talent_layout)
	if not talent_layout.version or type(talent_layout.version) ~= "number" then
		return false, "missing version"
	end

	if not talent_layout.nodes then
		return false, "no nodes"
	end

	return true
end

TalentLayoutParser.pack_backend_data = function (talent_layout, points_spent_on_nodes)
	local nodes = talent_layout.nodes
	local num_nodes = #nodes
	local node_string = ""

	for i = 1, num_nodes do
		local node = nodes[i]
		local widget_name = node.widget_name
		local points_spent = points_spent_on_nodes[widget_name] or 0

		if points_spent > 0 then
			node_string = string.format("%s%i|%i,", node_string, i - 1, points_spent)
		end
	end

	local version = talent_layout.version
	local backend_data = string.format("%i;%s", version, node_string:sub(1, -2))

	return backend_data
end

TalentLayoutParser.unpack_backend_data = function (talent_layout, backend_data, points_spent_on_nodes)
	local version_length = string.find(backend_data, ";")

	if version_length == nil then
		Log.info("TalentLayoutParser", "Failed parsing talent string. Could not locate \";\" for version number. (%q)", backend_data)

		return
	end

	local version = tonumber(string.sub(backend_data, 1, version_length - 1))
	local correct_version = talent_layout.version == version

	if correct_version then
		local nodes = talent_layout.nodes
		local points_spent_s = string.sub(backend_data, version_length + 1)
		local has_any_points_spent = string.len(points_spent_s) > 0

		if has_any_points_spent then
			local first_char_is_a_number = tonumber(string.sub(points_spent_s, 1, 1)) ~= nil

			if first_char_is_a_number then
				for backend_node_index, points_spent_in_node in string.gmatch(points_spent_s, "(%d+)|(%d+)") do
					local node_index = tonumber(backend_node_index) + 1
					local node = nodes[node_index]

					if not node then
						Log.info("TalentLayoutParser", "Failed parsing talent string, found node_index(%i) not present in current layout.", node_index)
						table.clear(points_spent_on_nodes)

						break
					end

					points_spent_on_nodes[tostring(node_index)] = tonumber(points_spent_in_node)
				end
			else
				Log.info("TalentLayoutParser", "Failed parsing talent string, first character of selected talents part (after ;) was not a number. %s", backend_data)
			end
		end
	else
		Log.info("TalentLayoutParser", "Failed parsing talent string, mismatching version numbers (layout:%i backend:%i)", talent_layout.version, version)
	end
end

TalentLayoutParser.selected_talents_from_selected_nodes = function (talent_layout, points_spent_on_nodes, selected_talents)
	local nodes = talent_layout.nodes

	for i = 1, #nodes do
		local node = nodes[i]
		local points_spent = points_spent_on_nodes[tostring(i)] or 0

		if points_spent > 0 then
			local talent = node.talent

			if talent ~= "not_selected" and talent ~= nil then
				local previous_points = selected_talents[talent] or 0

				selected_talents[talent] = previous_points + points_spent
			end
		end
	end
end

local function _num_decimals(value)
	local only_decimals = value - math.floor(value)
	local has_digit_10 = false
	local has_digit_100 = false
	local digit_10_v = only_decimals * 10

	if digit_10_v > 1 then
		has_digit_10 = 1
	end

	only_decimals = digit_10_v - math.floor(digit_10_v)

	local digit_100_v = only_decimals * 10

	if digit_100_v > 1 then
		has_digit_100 = true
	end

	local num_decimals

	num_decimals = has_digit_100 and 2 or has_digit_10 and 1 or 0

	return num_decimals
end

local FORMATING_FUNCTIONS = {
	percentage = function (value, config)
		local value_manipulation = config.value_manipulation

		if value_manipulation then
			value = value_manipulation(value)
		else
			value = value * 100
		end

		local num_decimals = config.num_decimals

		num_decimals = num_decimals or _num_decimals(value)

		local formatter

		if num_decimals > 0 then
			formatter = string.format("%%.%df", num_decimals)
		else
			formatter = "%d"
		end

		local value_string = string.format(formatter, value)

		return string.format("%s%%", value_string)
	end,
	number = function (value, config)
		local value_manipulation = config.value_manipulation

		if value_manipulation then
			value = value_manipulation(value)
		end

		local num_decimals = config.num_decimals

		num_decimals = num_decimals or _num_decimals(value)

		local formatter

		if num_decimals > 0 then
			formatter = string.format("%%.%df", num_decimals)
		else
			formatter = "%d"
		end

		return string.format(formatter, value)
	end,
	loc_string = function (value, config)
		return Managers.localization:localize(value, true)
	end,
	string = function (value, config)
		return value
	end,
	default = function (value, config)
		return tostring(value)
	end,
}
local EMPTY_TABLE = {}

local function _calculate_damage_profile(config)
	local damage_profile_name = config.damage_profile_name
	local damage_profile = DamageProfileTemplates[damage_profile_name]
	local power_level = config.power_level or PowerLevelSettings.default_power_level
	local damage_type = config.damage_type or nil
	local attack_type = config.attack_type or nil
	local armor_type = config.armor_type or armor_types.unarmored
	local target_settings = DamageProfile.target_settings(damage_profile, 0)
	local lerp_values = EMPTY_TABLE
	local hit_zone_name, charge_level, breed_or_nil, attacker_breed_or_nil
	local is_critical_strike = false
	local hit_weakspot = false
	local hit_shield = false
	local is_backstab = false
	local is_flanking = false
	local dropoff_scalar
	local attacker_stat_buffs = EMPTY_TABLE
	local target_stat_buffs = EMPTY_TABLE
	local target_buff_extension, armor_penetrating, target_health_extension, target_toughness_extension
	local target_stagger_count = 0
	local num_triggered_staggers = 0
	local is_attacked_unit_suppressed = false
	local distance, target_unit
	local auto_completed_action = false
	local stagger_impact

	return DamageCalculation.calculate(damage_profile, damage_type, target_settings, lerp_values, hit_zone_name, power_level, charge_level, breed_or_nil, attacker_breed_or_nil, is_critical_strike, hit_weakspot, hit_shield, is_backstab, is_flanking, dropoff_scalar, attack_type, attacker_stat_buffs, target_stat_buffs, target_buff_extension, armor_penetrating, target_health_extension, target_toughness_extension, armor_type, target_stagger_count, num_triggered_staggers, is_attacked_unit_suppressed, distance, target_unit, auto_completed_action, stagger_impact)
end

local function _value_from_path(base_table, path)
	local value_table = base_table
	local num_path = #path

	for i = 1, num_path - 1 do
		value_table = value_table[path[i]]
	end

	local key = path[num_path]
	local value = value_table[key]

	return value, key
end

local FIND_VALUE_FUNCTIONS = {
	buff_template = function (config, points_spent)
		local buff_template_name = config.buff_template_name
		local buff_template = BuffTemplates[buff_template_name]
		local base_table

		if config.tier then
			local talent_overrides = buff_template.talent_overrides
			local use_tier = math.clamp(points_spent, 1, #talent_overrides)

			base_table = talent_overrides[use_tier]
		else
			base_table = buff_template
		end

		local value = _value_from_path(base_table, config.path)

		return value
	end,
	damage = function (config, points_spent)
		local damage, damage_efficiency, base_damage, base_buff_damage, rending_damage, finesse_boost_damage, backstab_damage, flanking_damage, armor_damage_modifier, hit_zone_damage_multiplier = _calculate_damage_profile(config)

		return damage
	end,
	base_damage = function (config, points_spent)
		local damage, damage_efficiency, base_damage, base_buff_damage, rending_damage, finesse_boost_damage, backstab_damage, flanking_damage, armor_damage_modifier, hit_zone_damage_multiplier = _calculate_damage_profile(config)

		return base_damage
	end,
	armor_modifier = function (config, points_spent)
		local damage, damage_efficiency, base_damage, base_buff_damage, rending_damage, finesse_boost_damage, backstab_damage, flanking_damage, armor_damage_modifier, hit_zone_damage_multiplier = _calculate_damage_profile(config)

		return armor_damage_modifier
	end,
	default = function (config, points_spent)
		return config.value
	end,
}
local ARMOR_TYPE_GROUPS = {}
local MODIFIER_VALUES = {}
local INTERESTING_ARMOR_TYPES = {
	armor_types.unarmored,
	armor_types.armored,
	armor_types.resistant,
	armor_types.berserker,
	armor_types.super_armor,
	armor_types.disgustingly_resilient,
}
local DEV_INFO_FUNCTIONS = {
	damage_profile = function (config)
		local old_armor_type = config.armor_type

		table.clear(ARMOR_TYPE_GROUPS)
		table.clear(MODIFIER_VALUES)

		for _, armor_type in pairs(INTERESTING_ARMOR_TYPES) do
			config.armor_type = armor_type

			local damage, damage_efficiency, base_damage, base_buff_damage, rending_damage, finesse_boost_damage, backstab_damage, flanking_damage, armor_damage_modifier, hit_zone_damage_multiplier = _calculate_damage_profile(config)

			if table.index_of(MODIFIER_VALUES, armor_damage_modifier) == -1 then
				MODIFIER_VALUES[#MODIFIER_VALUES + 1] = armor_damage_modifier
			end

			local group = ARMOR_TYPE_GROUPS[armor_damage_modifier]

			if not ARMOR_TYPE_GROUPS[armor_damage_modifier] then
				group = {}
				ARMOR_TYPE_GROUPS[armor_damage_modifier] = group
			end

			group[#group + 1] = armor_type
		end

		table.sort(MODIFIER_VALUES, function (a, b)
			return b < a
		end)

		config.armor_type = old_armor_type

		local damage, damage_efficiency, base_damage, base_buff_damage, rending_damage, finesse_boost_damage, backstab_damage, flanking_damage, armor_damage_modifier, hit_zone_damage_multiplier = _calculate_damage_profile(config)
		local base_damage_value_string = TextUtilities.apply_color_to_text(string.format("%d", base_damage), Color.ui_terminal(255, true))
		local base_damage_string = string.format("%s base damage\n", base_damage_value_string)
		local armors_string

		for _, mod_values in ipairs(MODIFIER_VALUES) do
			local group = ARMOR_TYPE_GROUPS[mod_values]
			local armors

			for _, armor_type in ipairs(group) do
				if armors then
					armors = armors .. string.format(", %s", armor_type)
				else
					armors = tostring(armor_type)
				end
			end

			local value_string = TextUtilities.apply_color_to_text(string.format("%d%%", mod_values * 100), Color.ui_terminal(255, true))

			if armors_string then
				armors_string = armors_string .. string.format("\n%s: %s", value_string, armors)
			else
				armors_string = string.format("%s: %s", value_string, armors)
			end
		end

		return base_damage_string .. armors_string
	end,
	text = function (config)
		return config.value
	end,
	buff_template = function (config)
		local buff_template_name = config.buff_template_name
		local buff_template = BuffTemplates[buff_template_name]
		local values_to_show = config.values_to_show
		local num_values = #values_to_show
		local values_string = ""

		for i = 1, num_values do
			local value_config = values_to_show[i]
			local path = value_config.path
			local value, key = _value_from_path(buff_template, path)
			local format_function = FORMATING_FUNCTIONS[value_config.format_type] or FORMATING_FUNCTIONS.default
			local value_s = TextUtilities.apply_color_to_text(format_function(value, value_config), Color.ui_terminal(255, true))

			values_string = values_string .. string.format("%s: %s ", key, value_s)
		end

		return values_string:sub(1, -1)
	end,
}
local FORMAT_VALUES_TEMP = {}

TalentLayoutParser.talent_description = function (talent_definition, points_spent, value_color)
	local format_values = talent_definition.format_values
	local actual_format_values

	if format_values then
		actual_format_values = FORMAT_VALUES_TEMP

		table.clear(actual_format_values)

		for key, config in pairs(format_values) do
			if type(config) == "table" then
				local value
				local find_value_config = config.find_value

				if find_value_config then
					local find_value_function = FIND_VALUE_FUNCTIONS[find_value_config.find_value_type] or FIND_VALUE_FUNCTIONS.default

					value = find_value_function(find_value_config, points_spent)
				else
					value = config.value
				end

				local format_type = config.format_type
				local format_function = FORMATING_FUNCTIONS[format_type] or FORMATING_FUNCTIONS.default
				local string_value = format_function(value, config)

				if config.prefix then
					string_value = config.prefix .. string_value
				end

				if config.suffix then
					string_value = string_value .. config.suffix
				end

				if value_color then
					actual_format_values[key] = TextUtilities.apply_color_to_text(tostring(string_value), value_color)
				else
					actual_format_values[key] = string.format("%s", string_value)
				end
			else
				actual_format_values[key] = config
			end
		end
	end

	local talent_description = Managers.localization:localize(talent_definition.description, true, actual_format_values)

	return talent_description
end

return TalentLayoutParser
