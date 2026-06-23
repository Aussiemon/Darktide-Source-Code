-- chunkname: @scripts/utilities/minion_state.lua

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local buff_keywords = BuffSettings.keywords
local group_keywords = BuffSettings.group_keywords
local group_to_keywords = BuffSettings.group_to_keywords
local MinionState = {}

MinionState.is_minion = function (unit)
	if not unit then
		return false
	end

	local unit_data = ScriptUnit.has_extension(unit, "unit_data_system")
	local target_breed = unit_data and unit_data:breed()

	if not target_breed then
		return false
	end

	local is_minion = Breed.is_minion(target_breed)

	return is_minion
end

MinionState.is_sleeping_deamonhost = function (unit)
	if not unit then
		return false
	end

	local unit_data = ScriptUnit.has_extension(unit, "unit_data_system")
	local target_breed = unit_data and unit_data:breed()

	if not target_breed then
		return false
	end

	local breed_name = target_breed.name

	if breed_name ~= "chaos_daemonhost" then
		return false
	end

	local behavior_extension = ScriptUnit.has_extension(unit, "behavior_system")
	local brain = behavior_extension and behavior_extension:brain()
	local current_action = brain and brain:running_action()

	if current_action ~= "sleeping" and current_action ~= "passive" then
		return false
	end

	return true
end

MinionState.is_staggered = function (unit)
	local target_blackboard = BLACKBOARDS[unit]

	if target_blackboard then
		local stagger_component = target_blackboard.stagger
		local num_triggered_staggers = stagger_component.num_triggered_staggers

		if num_triggered_staggers > 0 then
			return true
		end
	end

	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	return buff_extension and buff_extension:has_keyword(buff_keywords.count_as_staggered)
end

MinionState.is_vortex_grabbed = function (unit)
	local target_blackboard = BLACKBOARDS[unit]

	if target_blackboard then
		local in_vortex_state = target_blackboard.in_vortex_state

		if not in_vortex_state == "in_vortex_init" and not in_vortex_state == "landed" then
			return true
		end
	end

	return false
end

MinionState.is_burning = function (unit)
	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	return buff_extension and buff_extension:has_keyword(buff_keywords.burning)
end

MinionState.is_electrocuted = function (buff_extension, optional_target_group_keyword)
	if not buff_extension then
		return false
	end

	local target_group_keyword = optional_target_group_keyword or group_keywords.electrocuted
	local target_grouped_keywords = group_to_keywords[target_group_keyword]

	for keyword, _ in pairs(target_grouped_keywords) do
		if buff_extension:has_keyword(keyword) then
			return true
		end
	end

	return false
end

local malfunction_duration = 12

MinionState.apply_weapon_malfunction = function (unit, t)
	if not HEALTH_ALIVE[unit] then
		return
	end

	local victim_buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	if victim_buff_extension then
		local unit_data = ScriptUnit.has_extension(unit, "unit_data_system")
		local target_breed = unit_data and unit_data:breed()
		local combat_vector_config = target_breed and target_breed.combat_vector_config
		local should_restrict_ranged_combat = combat_vector_config and combat_vector_config.should_switch_to_melee_under_weapon_malfunction

		if should_restrict_ranged_combat then
			victim_buff_extension:add_internally_controlled_buff("minion_weapon_malfunction_restricted_ranged_combat", t)
		end

		local blackboard = BLACKBOARDS[unit]
		local weapon_malfunction_component = Blackboard.has_component(blackboard, "weapon_malfunction") and Blackboard.write_component(blackboard, "weapon_malfunction") or nil

		if weapon_malfunction_component then
			local breed_malfunctioning_time = target_breed and target_breed.weapon_malfunction_time or malfunction_duration

			weapon_malfunction_component.is_malfunctioning = true
			weapon_malfunction_component.malfunctioning_time = t + breed_malfunctioning_time
		end
	end
end

MinionState.is_weapon_malfunctioning = function (unit)
	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	return buff_extension and buff_extension:has_keyword(buff_keywords.weapon_malfunction)
end

return MinionState
