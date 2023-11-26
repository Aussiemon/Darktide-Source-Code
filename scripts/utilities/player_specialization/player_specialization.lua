-- chunkname: @scripts/utilities/player_specialization/player_specialization.lua

local ArchetypeTalents = require("scripts/settings/ability/archetype_talents/archetype_talents")
local TalentSettings = require("scripts/settings/talent/talent_settings_new")
local PlayerSpecialization = {}

PlayerSpecialization.specialization_level_requirement = function ()
	return 1
end

PlayerSpecialization.talent_array_to_set = function (talent_array, talent_set)
	table.clear(talent_set)

	for i = 1, #talent_array do
		local talent_name = talent_array[i]

		talent_set[talent_name] = i
	end

	return talent_set
end

PlayerSpecialization.talent_set_to_array = function (talent_set, talent_array)
	table.clear(talent_array)

	for talent_name in pairs(talent_set) do
		talent_array[#talent_array + 1] = talent_name
	end

	return talent_array
end

PlayerSpecialization.talents_with_tiers_set_to_array = function (talent_set, talents_with_tiers)
	for talent_name, tier in pairs(talent_set) do
		local new_key = talent_name .. "--" .. tier

		talents_with_tiers[new_key] = true
	end

	return PlayerSpecialization.talent_set_to_array(talents_with_tiers, {})
end

PlayerSpecialization.talent_array_to_list_with_tiers = function (talent_array, talents_with_tiers)
	for i = 1, #talent_array do
		local key = talent_array[i]
		local talent_name_sections = string.split(key, "--")
		local talent_name = talent_name_sections[1] or key
		local talent_tier = tonumber(talent_name_sections[2]) or 1

		talents_with_tiers[talent_name] = talent_tier
	end

	return talents_with_tiers
end

PlayerSpecialization.add_nonselected_talents = function (archetype, specialization_name, player_level, talents)
	local specialization = archetype.specializations[specialization_name]
	local talent_groups = specialization.talent_groups

	for i = 1, #talent_groups do
		local talent_group = talent_groups[i]

		if talent_group.non_selectable_group and player_level >= talent_group.required_level then
			local talents_in_group = talent_group.talents

			for j = 1, #talents_in_group do
				local talent_name = talents_in_group[j]

				talents[talent_name] = 1
			end
		end
	end

	return talents
end

PlayerSpecialization.add_archetype_base_talents = function (archetype, talents)
	local talent_definitions = archetype.talents
	local has_combat_ability, has_grenade_ability = false, false
	local combat_ability_talent, grenade_ability_talent

	for talent_name, _ in pairs(talents) do
		local talent = talent_definitions[talent_name]
		local player_ability = talent.player_ability

		if player_ability then
			local ability_type = player_ability.ability_type

			if ability_type == "combat_ability" then
				has_combat_ability = true
				combat_ability_talent = talent_name
			elseif ability_type == "grenade_ability" then
				has_grenade_ability = true
				grenade_ability_talent = talent_name
			else
				ferror("Unknown ability_type(%q) found in talent(%q) for archetype(%q)", ability_type, talent_name, archetype.name)
			end
		end
	end

	local base_talents = archetype.base_talents

	for talent_name, tier in pairs(base_talents) do
		local apply_talent = true
		local talent = talent_definitions[talent_name]
		local player_ability = talent.player_ability

		if player_ability then
			local ability_type = player_ability.ability_type

			if ability_type == "combat_ability" and has_combat_ability then
				apply_talent = false
			elseif ability_type == "grenade_ability" and has_grenade_ability then
				apply_talent = false
			end
		end

		if apply_talent then
			local prev_tier = talents[talent_name] or 0

			talents[talent_name] = prev_tier + tier
		end
	end
end

PlayerSpecialization.filter_nonselectable_talents = function (archetype, specialization_name, player_level, talents)
	local specialization = archetype.specializations[specialization_name]
	local talent_groups = specialization.talent_groups

	for i = 1, #talent_groups do
		local talent_group = talent_groups[i]

		if talent_group.non_selectable_group and player_level >= talent_group.required_level then
			local talents_in_group = talent_group.talents

			for j = 1, #talents_in_group do
				local unwanted_talent_name = talents_in_group[j]

				talents[unwanted_talent_name] = nil
			end
		end
	end

	return talents
end

PlayerSpecialization.from_selected_talents = function (archetype, talents)
	local combat_ability, grenade_ability, passives, coherency_buffs, special_rules, buff_template_tiers, combat_ability_prio, current_coherency, coherency_prio = archetype.combat_ability, archetype.grenade_ability, {}, {}, {}, {}, -1, nil, -1
	local archetype_name = archetype.name
	local talent_definitions = ArchetypeTalents[archetype_name]
	local talent_and_tiers = {}

	for talent_name, tier in pairs(talents) do
		tier = type(tier) == "boolean" and 1 or tier

		if tier > 0 then
			talent_and_tiers[talent_name] = tier
		end
	end

	for talent_name, tier in pairs(talent_and_tiers) do
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
					buff_template_tiers[buff_template_name] = tier
				end
			else
				local buff_template_name = passive.buff_template_name

				passives[identifier] = buff_template_name
				buff_template_tiers[buff_template_name] = tier
			end
		end

		local coherency = talent_definition.coherency

		if coherency then
			local priority = coherency.priority

			if priority then
				if coherency_prio < priority then
					if current_coherency then
						buff_template_tiers[current_coherency.buff_template_name] = nil
						coherency_buffs[current_coherency.identifier] = nil
					end

					local buff_template_name = coherency.buff_template_name

					if buff_template_name then
						coherency_buffs[coherency.identifier] = buff_template_name
						buff_template_tiers[buff_template_name] = tier
					end

					current_coherency = coherency
					coherency_prio = priority
				end
			else
				local buff_template_name = coherency.buff_template_name

				coherency_buffs[coherency.identifier] = buff_template_name
				buff_template_tiers[buff_template_name] = tier
			end
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

PlayerSpecialization.get_talent_value = function (archetype_name, specialization_name, talent_name, value_key)
	specialization_name = specialization_name or "none"

	local talent_definitions = ArchetypeTalents[archetype_name][specialization_name]
	local talent = talent_definitions[talent_name]
	local tier_level = PlayerSpecialization.get_talent_tier(talent_name)

	if talent.tiers and talent.tiers[tier_level][value_key] then
		return talent.tiers[tier_level][value_key]
	end

	return TalentSettings[archetype_name][talent_name][value_key]
end

PlayerSpecialization.get_talent_tier = function (player, talent_name)
	local local_player = Managers.player:local_player(1)
	local profile = local_player:profile()
	local talents = profile.talents
	local talent_tier = talents[talent_name] or 0

	return talent_tier
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

		if not group.non_selectable_group and player_level >= group.required_level then
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
