local Breeds = require("scripts/settings/breed/breeds")
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

		fassert(index_of_param ~= -1, "Stat '%s' has no parameter '%s'.", stat_to_check:get_id(), param_name)

		return function (_, _, _, ...)
			return select(index_of_param, ...) == param_value
		end
	end,
	breed_is_boss = function (stat_to_check)
		local index_of_breed_name = table.index_of(stat_to_check:get_parameters(), "breed_name")

		fassert(index_of_breed_name ~= -1, "Stat '%s' has no parameter breed name.", stat_to_check:get_id())

		return function (_, _, _, ...)
			local breed_name = select(index_of_breed_name, ...)
			local breed_data = Breeds[breed_name]

			return breed_data and breed_data.is_boss == true
		end
	end,
	breed_has_tag = function (stat_to_check, tag)
		local index_of_breed_name = table.index_of(stat_to_check:get_parameters(), "breed_name")

		fassert(index_of_breed_name ~= -1, "Stat '%s' has no parameter breed name.", stat_to_check:get_id())

		return function (_, _, _, ...)
			local breed_name = select(index_of_breed_name, ...)
			local breed_data = Breeds[breed_name]

			return breed_data and breed_data.tags and breed_data.tags[tag] == true
		end
	end,
	breed_is_faction = function (stat_to_check, faction)
		local index_of_breed_name = table.index_of(stat_to_check:get_parameters(), "breed_name")

		fassert(index_of_breed_name ~= -1, "Stat '%s' has no parameter breed name.", stat_to_check:get_id())

		return function (_, _, _, ...)
			local breed_name = select(index_of_breed_name, ...)
			local breed_data = Breeds[breed_name]

			return breed_data and breed_data.sub_faction_name == faction
		end
	end
}

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

	fassert(index_of_weapon ~= -1, "Stat '%s' has no parameter weapon template name.")

	return function (_, _, _, ...)
		local weapon_template_name = select(index_of_weapon, ...)

		return table.array_contains(_weapon_templates, weapon_template_name)
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
