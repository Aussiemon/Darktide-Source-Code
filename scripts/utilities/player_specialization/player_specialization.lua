local ArchetypeTalents = require("scripts/settings/ability/archetype_talents/archetype_talents")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local PlayerSpecialization = {
	specialization_level_requirement = function ()
		return 1
	end,
	talent_array_to_set = function (talent_array, talent_set)
		table.clear(talent_set)

		for i = 1, #talent_array do
			local talent_name = talent_array[i]
			talent_set[talent_name] = i
		end

		return talent_set
	end,
	talent_set_to_array = function (talent_set, talent_array)
		table.clear(talent_array)

		for talent_name in pairs(talent_set) do
			talent_array[#talent_array + 1] = talent_name
		end

		return talent_array
	end
}
local _required_levels = {}

PlayerSpecialization.talent_set_to_sorted_array = function (archetype, specialization_name, talent_set, talent_array)
	table.clear(talent_array)
	table.clear(_required_levels)

	local specialization = archetype.specializations[specialization_name]
	local talent_groups = specialization.talent_groups
	local i = 0

	for j = 1, #talent_groups do
		local talent_group = talent_groups[j]
		local required_level = talent_group.required_level
		local talents_in_group = talent_group.talents

		for k = 1, #talents_in_group do
			local talent_name = talents_in_group[k]

			if talent_set[talent_name] then
				i = i + 1
				talent_array[i] = talent_name
				_required_levels[talent_name] = required_level
			end
		end
	end

	local function _talent_sort_function(a, b)
		return _required_levels[a] < _required_levels[b]
	end

	table.sort(talent_array, _talent_sort_function)

	return talent_array
end

PlayerSpecialization.add_nonselected_talents = function (archetype, specialization_name, player_level, talents)
	local specialization = archetype.specializations[specialization_name]
	local talent_groups = specialization.talent_groups

	for i = 1, #talent_groups do
		local talent_group = talent_groups[i]

		if talent_group.non_selectable_group and talent_group.required_level <= player_level then
			local talents_in_group = talent_group.talents

			for j = 1, #talents_in_group do
				local talent_name = talents_in_group[j]
				talents[talent_name] = true
			end
		end
	end

	return talents
end

PlayerSpecialization.filter_nonselectable_talents = function (archetype, specialization_name, player_level, talents)
	local specialization = archetype.specializations[specialization_name]
	local talent_groups = specialization.talent_groups

	for i = 1, #talent_groups do
		local talent_group = talent_groups[i]

		if talent_group.non_selectable_group and talent_group.required_level <= player_level then
			local talents_in_group = talent_group.talents

			for j = 1, #talents_in_group do
				local unwanted_talent_name = talents_in_group[j]
				talents[unwanted_talent_name] = nil
			end
		end
	end

	return talents
end

PlayerSpecialization.from_selected_talents = function (archetype, specialization_name, talents)
	local combat_ability = archetype.combat_ability
	local grenade_ability = archetype.grenade_ability
	local passives = {}
	local coherency_buffs = {}
	local special_rules = {}
	local buff_template_tiers = {}
	local archetype_name = archetype.name
	local talent_definitions = ArchetypeTalents[archetype_name][specialization_name]
	local talent_array = PlayerSpecialization.talent_set_to_sorted_array(archetype, specialization_name, talents, {})

	for i = 1, #talent_array do
		local talent_name = talent_array[i]
		local talent_definition = talent_definitions[talent_name]
		local player_ability = talent_definition.player_ability

		if player_ability then
			local ability_type = player_ability.ability_type

			if ability_type == "combat_ability" then
				combat_ability = player_ability.ability
			elseif ability_type == "grenade_ability" then
				grenade_ability = player_ability.ability
			end
		end

		local passive = talent_definition.passive

		if passive then
			local identifier = passive.identifier

			if type(identifier) == "table" then
				local buff_template_names = passive.buff_template_name

				for j = 1, #identifier do
					local buff_template_name = buff_template_names[j]
					passives[identifier[j]] = buff_template_name
				end
			else
				local buff_template_name = passive.buff_template_name
				passives[identifier] = buff_template_name
			end
		end

		local coherency = talent_definition.coherency

		if coherency then
			local buff_template_name = coherency.buff_template_name
			coherency_buffs[coherency.identifier] = buff_template_name
		end

		local special_rule = talent_definition.special_rule

		if special_rule then
			local identifier = special_rule.identifier
			local special_rule_name = special_rule.special_rule_name

			if type(identifier) == "table" then
				for j = 1, #identifier do
					special_rules[identifier[j]] = special_rule_name[j]
				end
			else
				special_rules[identifier] = special_rule_name
			end
		end
	end

	return combat_ability, grenade_ability, passives, coherency_buffs, special_rules, buff_template_tiers
end

local function extract_all_talents()
	local id_to_talents = {}
	local name_to_id = {}
	local archetypes = ArchetypeTalents

	for archetype_name, archetype_talents in pairs(archetypes) do
		for specialization_name, specialization_talents in pairs(archetype_talents) do
			for talent_id, talent in pairs(specialization_talents) do
				local talent_name = talent.name or talent_id
				name_to_id[talent_name] = talent_id
				id_to_talents[talent_id] = talent
			end
		end
	end

	return id_to_talents, name_to_id
end

local talent_id_to_talent_lookup, talent_name_to_talent_id_lookup = extract_all_talents()

PlayerSpecialization.talent_from_name = function (talent_name)
	local talent_id = talent_name_to_talent_id_lookup[talent_name]
	local talent = talent_id_to_talent_lookup[talent_id]

	return talent_id, talent
end

PlayerSpecialization.talent_group_unlocked_by_level = function (archetype, specialization_name, player_level, mark_unlocked_group_as_new)
	local specialization = archetype.specializations[specialization_name]
	local talent_groups = specialization.talent_groups

	for i = 1, #talent_groups do
		local group = talent_groups[i]

		if group.required_level == player_level and not group.non_selectable_group then
			return i
		end
	end

	return nil
end

PlayerSpecialization.talent_group_from_id = function (archetype, specialization_name, group_id)
	local specialization = archetype.specializations[specialization_name]
	local talent_groups = specialization.talent_groups
	local talent_group = talent_groups[group_id]

	return talent_group
end

PlayerSpecialization.has_empty_talent_groups = function (archetype, specialization_name, player_level, selected_talents)
	local specialization = archetype.specializations[specialization_name]
	local talent_groups = specialization.talent_groups

	for i = 1, #talent_groups do
		local group = talent_groups[i]

		if not group.non_selectable_group and group.required_level <= player_level then
			local group_talents = group.talents
			local group_has_selected_talent = false

			for j = 1, #group_talents do
				if selected_talents[group_talents[j]] then
					group_has_selected_talent = true

					break
				end
			end

			if not group_has_selected_talent then
				return true
			end
		end
	end
end

return PlayerSpecialization
