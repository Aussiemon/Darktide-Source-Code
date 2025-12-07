-- chunkname: @scripts/ui/views/talent_builder_view/utilities/talent_layout_parser.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BuffTemplates = require("scripts/settings/buff/buff_templates")
local DamageCalculation = require("scripts/utilities/attack/damage_calculation")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local Text = require("scripts/utilities/ui/text")
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

TalentLayoutParser.pack_backend_data = function (talent_layout, node_tiers)
	local nodes = talent_layout.nodes
	local num_nodes = #nodes
	local node_string = ""

	for i = 1, num_nodes do
		local node = nodes[i]
		local widget_name = node.widget_name

		if node_tiers[widget_name] then
			local tier = node_tiers[widget_name]

			if tier > 0 then
				local cost = tier * (node.cost or 1)

				node_string = string.format("%s%i|%i,", node_string, i - 1, cost)
			end
		end
	end

	local version = talent_layout.version
	local backend_data = string.format("%i;%s", version, node_string:sub(1, -2))

	return backend_data
end

TalentLayoutParser.unpack_backend_data = function (talent_layout, backend_data, node_tiers)
	local version_length = string.find(backend_data, ";")

	if version_length == nil then
		Log.info("TalentLayoutParser", "Failed parsing talent string. Could not locate \";\" for version number. (%q)", backend_data)

		return
	end

	local version = tonumber(string.sub(backend_data, 1, version_length - 1))
	local correct_version = talent_layout.version == version

	if correct_version then
		local nodes = talent_layout.nodes
		local cost_s = string.sub(backend_data, version_length + 1)
		local has_any_points_spent = string.len(cost_s) > 0

		if has_any_points_spent then
			local first_char_is_a_number = tonumber(string.sub(cost_s, 1, 1)) ~= nil

			if first_char_is_a_number then
				for backend_node_index, cost_in_node in string.gmatch(cost_s, "(%d+)|(%d+)") do
					local node_index = tonumber(backend_node_index) + 1
					local node = nodes[node_index]

					if not node then
						Log.info("TalentLayoutParser", "Failed parsing talent string, found node_index(%i) not present in current layout.", node_index)
						table.clear(node_tiers)

						break
					end

					local tier = node.cost == 0 and 1 or tonumber(cost_in_node) / (node.cost or 1)

					if tier % 1 == 0 then
						node_tiers[node.widget_name] = tier
					end
				end
			else
				Log.info("TalentLayoutParser", "Failed parsing talent string, first character of selected talents part (after ;) was not a number. %s", backend_data)
			end
		end
	else
		Log.info("TalentLayoutParser", "Failed parsing talent string, mismatching version numbers (layout:%i backend:%i)", talent_layout.version, version)
	end
end

TalentLayoutParser.selected_talents_from_selected_nodes = function (talent_layout, node_tiers, selected_talents)
	local nodes = talent_layout.nodes

	for i = 1, #nodes do
		local node = nodes[i]
		local tier = node_tiers[node.widget_name] or 0

		if tier > 0 then
			local talent = node.talent

			if talent ~= "not_selected" and talent ~= nil then
				local previous_tier = selected_talents[talent] or 0

				selected_talents[talent] = previous_tier + tier
			end
		end
	end
end

local _talents_version_scratch = {}

TalentLayoutParser.talents_version = function (profile)
	table.clear(_talents_version_scratch)

	local archetype = profile.archetype
	local talent_layout_version = archetype.talent_layout_file_path and require(archetype.talent_layout_file_path).version or nil

	_talents_version_scratch[#_talents_version_scratch + 1] = talent_layout_version

	local specialization_talent_version = archetype.specialization_talent_layout_file_path and require(archetype.specialization_talent_layout_file_path).version or nil

	_talents_version_scratch[#_talents_version_scratch + 1] = specialization_talent_version

	return table.concat(_talents_version_scratch, ":")
end

TalentLayoutParser.is_same_version = function (left, right)
	return (tonumber(left) or left) == (tonumber(right) or right)
end

TalentLayoutParser.filter_layout_talents = function (profile, layout_key, selected_talents, out_talents)
	out_talents = out_talents or {}

	local archetype = profile.archetype

	if archetype[layout_key] then
		local layout = require(archetype[layout_key])
		local nodes = layout.nodes

		for i = 1, #nodes do
			local node = nodes[i]

			if selected_talents[node.widget_name] then
				out_talents[node.widget_name] = selected_talents[node.widget_name]
			end
		end
	end

	return out_talents
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

local FORMATTING_FUNCTIONS = {
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
	local hit_zone_name, charge_level, breed_or_nil, attacker_owner_breed_or_nil, attacker_breed_or_nil
	local is_critical_strike = false
	local hit_weakspot = false
	local hit_shield = false
	local is_backstab = false
	local is_flanking = false
	local dropoff_scalar
	local attacker_stat_buffs = EMPTY_TABLE
	local target_stat_buffs = EMPTY_TABLE
	local attacker_buff_extension, target_buff_extension, armor_penetrating, target_health_extension, target_toughness_extension
	local target_stagger_count = 0
	local num_triggered_staggers = 0
	local is_attacked_unit_suppressed = false
	local distance, target_unit
	local auto_completed_action = false
	local stagger_impact = 0

	return DamageCalculation.calculate(damage_profile, damage_type, target_settings, lerp_values, hit_zone_name, power_level, charge_level, breed_or_nil, attacker_owner_breed_or_nil, attacker_breed_or_nil, is_critical_strike, hit_weakspot, hit_shield, is_backstab, is_flanking, dropoff_scalar, attack_type, attacker_stat_buffs, target_stat_buffs, attacker_buff_extension, target_buff_extension, armor_penetrating, target_health_extension, target_toughness_extension, armor_type, target_stagger_count, num_triggered_staggers, is_attacked_unit_suppressed, distance, target_unit, auto_completed_action, stagger_impact)
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
		local base_damage_value_string = Text.apply_color_to_text(string.format("%d", base_damage), Color.ui_terminal(255, true))
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

			local value_string = Text.apply_color_to_text(string.format("%d%%", mod_values * 100), Color.ui_terminal(255, true))

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
			local format_function = FORMATTING_FUNCTIONS[value_config.format_type] or FORMATTING_FUNCTIONS.default
			local value_s = Text.apply_color_to_text(format_function(value, value_config), Color.ui_terminal(255, true))

			values_string = values_string .. string.format("%s: %s ", key, value_s)
		end

		return values_string:sub(1, -1)
	end,
}

local function _actual_format_values(format_values, out_table, points_spent, value_color)
	table.clear(out_table)

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
			local format_function = FORMATTING_FUNCTIONS[format_type] or FORMATTING_FUNCTIONS.default
			local string_value = format_function(value, config)

			if config.prefix then
				string_value = config.prefix .. string_value
			end

			if config.suffix then
				string_value = string_value .. config.suffix
			end

			if value_color then
				out_table[key] = Text.apply_color_to_text(tostring(string_value), value_color)
			else
				out_table[key] = string.format("%s", string_value)
			end
		else
			out_table[key] = config
		end
	end

	return out_table
end

local FORMAT_VALUES_TEMP = {}
local UNIQUE_FORMAT_VALUES_TEMP = {}
local TALENT_FORMAT_SCRATCH = {}

TalentLayoutParser.talent_title = function (talent_definition, points_spent, value_color)
	local display_name = talent_definition.display_name

	if not display_name then
		return nil
	end

	local format_values = talent_definition.format_values

	format_values = format_values and _actual_format_values(format_values, FORMAT_VALUES_TEMP, points_spent, value_color)

	local talent_title
	local format_values_per_index = talent_definition.format_values_per_index or EMPTY_TABLE

	if type(talent_definition.display_name) == "table" then
		table.clear(TALENT_FORMAT_SCRATCH)

		for i = 1, #talent_definition.display_name do
			local unique_format_values = format_values_per_index[i]

			unique_format_values = unique_format_values and _actual_format_values(unique_format_values, UNIQUE_FORMAT_VALUES_TEMP, points_spent, value_color)
			TALENT_FORMAT_SCRATCH[#TALENT_FORMAT_SCRATCH + 1] = Managers.localization:localize(talent_definition.display_name[i], true, unique_format_values or format_values)
		end

		talent_title = table.concat(TALENT_FORMAT_SCRATCH, "\n")
	else
		talent_title = Managers.localization:localize(talent_definition.display_name, true, format_values)
	end

	return talent_title
end

TalentLayoutParser.talent_description = function (talent_definition, points_spent, value_color)
	local format_values = talent_definition.format_values

	format_values = format_values and _actual_format_values(format_values, FORMAT_VALUES_TEMP, points_spent, value_color)

	local talent_description
	local format_values_per_index = talent_definition.format_values_per_index or EMPTY_TABLE

	if type(talent_definition.description) == "table" then
		table.clear(TALENT_FORMAT_SCRATCH)

		for i = 1, #talent_definition.description do
			local unique_format_values = format_values_per_index[i]

			unique_format_values = unique_format_values and _actual_format_values(unique_format_values, UNIQUE_FORMAT_VALUES_TEMP, points_spent, value_color)
			TALENT_FORMAT_SCRATCH[#TALENT_FORMAT_SCRATCH + 1] = Managers.localization:localize(talent_definition.description[i], true, unique_format_values or format_values)
		end

		talent_description = table.concat(TALENT_FORMAT_SCRATCH, "\n")
	else
		talent_description = Managers.localization:localize(talent_definition.description, true, format_values)
	end

	return talent_description
end

TalentLayoutParser.node_points_spent = function (talent_layout, node_tiers)
	local total_points = 0
	local nodes = talent_layout.nodes

	for i = 1, #nodes do
		local node = nodes[i]
		local tier = node_tiers[node.widget_name]

		if tier then
			total_points = total_points + tier * node.cost
		end
	end

	return total_points
end

TalentLayoutParser.profile_percent_points_used = function (profile, optional_node_tiers)
	local archetype = profile.archetype
	local talent_layout = require(archetype.talent_layout_file_path)
	local node_tiers = optional_node_tiers or profile.selected_nodes
	local max_points = profile.talent_points

	return TalentLayoutParser.percent_points_used(talent_layout, node_tiers, max_points)
end

TalentLayoutParser.profile_percent_specialization_points_used = function (profile, optional_node_tiers)
	local archetype = profile.archetype
	local layout_path = archetype.specialization_talent_layout_file_path

	if layout_path then
		local talent_layout = require(layout_path)
		local node_tiers = optional_node_tiers or profile.selected_nodes
		local max_points = profile.expertise_points

		return TalentLayoutParser.percent_points_used(talent_layout, node_tiers, max_points)
	end

	return 1
end

TalentLayoutParser.profile_specialization_node_points_spent = function (profile, optional_node_tiers)
	local total_points, max_points = 0, 0
	local archetype = profile.archetype
	local layout_path = archetype.specialization_talent_layout_file_path

	if layout_path then
		local talent_layout = require(layout_path)
		local node_tiers = optional_node_tiers or profile.selected_nodes
		local nodes = talent_layout.nodes

		for i = 1, #nodes do
			local node = nodes[i]
			local tier = node_tiers[node.widget_name]

			if tier then
				total_points = total_points + tier * node.cost
			end
		end

		max_points = profile.expertise_points
	end

	return total_points, max_points
end

TalentLayoutParser.percent_points_used = function (talent_layout, node_tiers, max_points)
	local points_spent = TalentLayoutParser.node_points_spent(talent_layout, node_tiers)

	return max_points == 0 and 1 or points_spent / max_points
end

return TalentLayoutParser
