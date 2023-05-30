local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breeds = require("scripts/settings/breed/breeds")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local Weakspot = require("scripts/utilities/attack/weakspot")
local WeaponTemplates = require("scripts/settings/equipment/weapon_templates/weapon_templates")
local ConditionalFunctions = {
	always_true = function (_, _, _, ...)
		return true
	end,
	inverse = function (condition)
		return function (...)
			return not condition(...)
		end
	end,
	flag_is_set = function (flag_stat)
		return function (stat_table, _, _, ...)
			return flag_stat:get_value(stat_table) == 1
		end
	end,
	stat_is_less_then = function (stat_to_check, stat_value)
		return function (stat_table, _, _, ...)
			return stat_to_check:get_value(stat_table) < stat_value
		end
	end,
	stat_is_less_or_equal_then = function (stat_to_check, stat_value)
		return function (stat_table, _, _, ...)
			return stat_to_check:get_value(stat_table) <= stat_value
		end
	end,
	stat_is_equal_to = function (stat_to_check, stat_value)
		return function (stat_table, _, _, ...)
			return stat_to_check:get_value(stat_table) == stat_value
		end
	end,
	stat_is_equal_or_greater_than = function (stat_to_check, stat_value)
		return function (stat_table, _, _, ...)
			return stat_value <= stat_to_check:get_value(stat_table)
		end
	end,
	calculated_value_comparasions = function (left_value_function, right_value_function, comparator)
		return function (...)
			local left_value = left_value_function(...)
			local right_value = right_value_function(...)

			return comparator(left_value, right_value)
		end
	end,
	trigger_value_greater_than = function (target)
		return function (_, _, trigger_value, ...)
			return target < trigger_value
		end
	end,
	trigger_value_less_than = function (target)
		return function (_, _, trigger_value, ...)
			return trigger_value < target
		end
	end,
	trigger_value_equals_to = function (target)
		return function (_, _, trigger_value, ...)
			return trigger_value == target
		end
	end,
	param_has_value = function (stat_to_check, param_name, param_value)
		local index_of_param = table.index_of(stat_to_check:get_parameters(), param_name)

		return function (_, _, _, ...)
			return select(index_of_param, ...) == param_value
		end
	end,
	param_is_less_than = function (stat_to_check, param_name, param_value)
		local index_of_param = table.index_of(stat_to_check:get_parameters(), param_name)

		return function (_, _, _, ...)
			return select(index_of_param, ...) < param_value
		end
	end,
	param_is_equal_or_less_than = function (stat_to_check, param_name, param_value)
		local index_of_param = table.index_of(stat_to_check:get_parameters(), param_name)

		return function (_, _, _, ...)
			return select(index_of_param, ...) <= param_value
		end
	end,
	param_is_greater_than = function (stat_to_check, param_name, param_value)
		local index_of_param = table.index_of(stat_to_check:get_parameters(), param_name)

		return function (_, _, _, ...)
			return param_value < select(index_of_param, ...)
		end
	end,
	param_is_equal_or_greater_than = function (stat_to_check, param_name, param_value)
		local index_of_param = table.index_of(stat_to_check:get_parameters(), param_name)

		return function (_, _, _, ...)
			return param_value <= select(index_of_param, ...)
		end
	end,
	param_is_equal_to = function (stat_to_check, param_name, param_value)
		local index_of_param = table.index_of(stat_to_check:get_parameters(), param_name)

		return function (_, _, _, ...)
			return select(index_of_param, ...) == param_value
		end
	end,
	param_table_has_value = function (stat_to_check, param_name, param_table_index, param_table_value)
		local index_of_param = table.index_of(stat_to_check:get_parameters(), param_name)

		return function (_, _, _, ...)
			local param_table = select(index_of_param, ...)

			return param_table and param_table[param_table_index] == param_table_value
		end
	end,
	breed_is_boss = function (stat_to_check)
		local index_of_breed_name = table.index_of(stat_to_check:get_parameters(), "breed_name")

		return function (_, _, _, ...)
			local breed_name = select(index_of_breed_name, ...)
			local breed_data = Breeds[breed_name]

			return breed_data and breed_data.is_boss == true
		end
	end,
	breed_has_tag = function (stat_to_check, tag)
		local index_of_breed_name = table.index_of(stat_to_check:get_parameters(), "breed_name")

		return function (_, _, _, ...)
			local breed_name = select(index_of_breed_name, ...)
			local breed_data = Breeds[breed_name]

			return breed_data and breed_data.tags and breed_data.tags[tag] == true
		end
	end,
	breed_has_flag = function (stat_to_check, flag)
		local index_of_breed_name = table.index_of(stat_to_check:get_parameters(), "breed_name")

		return function (_, _, _, ...)
			local breed_name = select(index_of_breed_name, ...)
			local breed_data = Breeds[breed_name]

			return breed_data and breed_data[flag] == true
		end
	end,
	breed_is_faction = function (stat_to_check, faction)
		local index_of_breed_name = table.index_of(stat_to_check:get_parameters(), "breed_name")

		return function (_, _, _, ...)
			local breed_name = select(index_of_breed_name, ...)
			local breed_data = Breeds[breed_name]

			return breed_data and breed_data.sub_faction_name == faction
		end
	end,
	is_breed = function (stat_to_check, wanted_breed_name)
		local index_of_breed_name = table.index_of(stat_to_check:get_parameters(), "breed_name")

		return function (_, _, _, ...)
			local current_breed_name = select(index_of_breed_name, ...)

			return current_breed_name == wanted_breed_name
		end
	end,
	is_weakspot = function (stat_to_check)
		local index_of_breed_name = table.index_of(stat_to_check:get_parameters(), "breed_name")
		local index_of_hit_zone_name = table.index_of(stat_to_check:get_parameters(), "hit_zone_name")
		local index_of_weapon_attack_type = table.index_of(stat_to_check:get_parameters(), "weapon_attack_type")

		return function (_, _, _, ...)
			local breed_name = select(index_of_breed_name, ...)
			local breed_data = Breeds[breed_name]
			local hit_zone_name = select(index_of_hit_zone_name, ...)
			local weapon_attack_type = select(index_of_weapon_attack_type, ...)
			local hit_weakspot = Weakspot.hit_weakspot(breed_data, hit_zone_name, weapon_attack_type)

			return hit_weakspot
		end
	end,
	is_finesse_hit = function (stat_to_check)
		local index_of_breed_name = table.index_of(stat_to_check:get_parameters(), "breed_name")
		local index_of_is_critical_hit = table.index_of(stat_to_check:get_parameters(), "is_critical_hit")
		local index_of_hit_zone_name = table.index_of(stat_to_check:get_parameters(), "hit_zone_name")
		local index_of_weapon_attack_type = table.index_of(stat_to_check:get_parameters(), "weapon_attack_type")

		return function (_, _, _, ...)
			local breed_name = select(index_of_breed_name, ...)
			local breed_data = Breeds[breed_name]
			local hit_zone_name = select(index_of_hit_zone_name, ...)
			local weapon_attack_type = select(index_of_weapon_attack_type, ...)
			local hit_weakspot = Weakspot.hit_weakspot(breed_data, hit_zone_name, weapon_attack_type)
			local is_critical_hit = select(index_of_is_critical_hit, ...)

			return hit_weakspot or is_critical_hit
		end
	end,
	is_non_killing_hit = function (stat_to_check)
		local index_of_attack_result = table.index_of(stat_to_check:get_parameters(), "attack_result")

		return function (_, _, _, ...)
			local attack_result = select(index_of_attack_result, ...)
			local staggered = attack_result ~= AttackSettings.attack_results.died

			return staggered
		end
	end,
	is_staggering_hit = function (stat_to_check)
		local index_of_stagger_result = table.index_of(stat_to_check:get_parameters(), "stagger_result")

		return function (_, _, _, ...)
			local stagger_result = select(index_of_stagger_result, ...)
			local staggered = stagger_result == "stagger"

			return staggered
		end
	end
}
local warp_damage_types = DamageSettings.warp_damage_types

ConditionalFunctions.is_warp_hit = function (stat_to_check)
	local param_name = "damage_type"
	local index_of_param = table.index_of(stat_to_check:get_parameters(), param_name)

	return function (_, _, _, ...)
		local damage_type = select(index_of_param, ...)

		return warp_damage_types[damage_type]
	end
end

ConditionalFunctions.is_heavy_stagger_hit = function (stat_to_check)
	local index_of_stagger_type = table.index_of(stat_to_check:get_parameters(), "stagger_type")

	return function (_, _, _, ...)
		local stagger_type = select(index_of_stagger_type, ...)
		local staggered = stagger_type == StaggerSettings.stagger_types.heavy

		return staggered
	end
end

ConditionalFunctions.is_explosion_stagger_hit = function (stat_to_check)
	local index_of_stagger_type = table.index_of(stat_to_check:get_parameters(), "stagger_type")

	return function (_, _, _, ...)
		local stagger_type = select(index_of_stagger_type, ...)
		local staggered = stagger_type == StaggerSettings.stagger_types.explosion

		return staggered
	end
end

ConditionalFunctions.is_initial_buff_application = function (stat_to_check, buff_name)
	local index_of_buff_template_name = table.index_of(stat_to_check:get_parameters(), "buff_template_name")
	local index_of_stack_count = table.index_of(stat_to_check:get_parameters(), "stack_count")

	return function (_, _, _, ...)
		local buff_template_name = select(index_of_buff_template_name, ...)

		if buff_template_name ~= buff_name then
			return false
		end

		local stack_count = select(index_of_stack_count, ...)

		return stack_count == 1
	end
end

ConditionalFunctions.weapon_has_keywords = function (stat_to_check, keywords)
	local _weapon_templates = {}

	for name, weapon_template in pairs(WeaponTemplates) do
		local weapon_template_keywords = weapon_template.keywords

		if weapon_template_keywords then
			local template_is_ok = true

			for _, keyword in ipairs(keywords) do
				if not table.array_contains(weapon_template_keywords, keyword) then
					template_is_ok = false

					break
				end
			end

			if template_is_ok then
				_weapon_templates[#_weapon_templates + 1] = name
			end
		end
	end

	local index_of_weapon = table.index_of(stat_to_check:get_parameters(), "weapon_template_name")

	return function (_, _, _, ...)
		local weapon_template_name = select(index_of_weapon, ...)

		return table.array_contains(_weapon_templates, weapon_template_name)
	end
end

ConditionalFunctions.difficulty_is_at_least = function (desired_difficulty)
	return function (_, _, _, ...)
		local current_difficulty = Managers.state and Managers.state.difficulty and Managers.state.difficulty:get_difficulty() or 0

		return desired_difficulty <= current_difficulty
	end
end

ConditionalFunctions.is_private_session = function ()
	return function (_, _, _, ...)
		local is_private_session = Managers.mission_server:is_private_session()

		return is_private_session
	end
end

ConditionalFunctions.all = function (...)
	local conditions = {
		...
	}

	return function (...)
		for i = 1, #conditions do
			if not conditions[i](...) then
				return false
			end
		end

		return true
	end
end

ConditionalFunctions.any = function (...)
	local conditions = {
		...
	}

	return function (...)
		for i = 1, #conditions do
			if conditions[i](...) then
				return true
			end
		end

		return false
	end
end

return ConditionalFunctions
