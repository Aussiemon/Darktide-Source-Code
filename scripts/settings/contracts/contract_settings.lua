﻿-- chunkname: @scripts/settings/contracts/contract_settings.lua

local MissionTemplates = require("scripts/settings/mission/mission_templates")
local StatsDefinitions = require("scripts/managers/stats/stat_definitions")
local WalletSettings = require("scripts/settings/wallet_settings")
local ContractSettings = {}
local task_parameter_strings = {
	cultist = "loc_contract_task_enemy_type_cultist",
	grimoire = "loc_contract_task_pickup_type_grimoire",
	melee = "loc_contract_task_weapon_type_melee",
	ranged = "loc_contract_task_weapon_type_ranged",
	renegade = "loc_contract_task_enemy_type_renegade",
	tome = "loc_contract_task_pickup_type_tome",
	tome_or_grimoire = "loc_contract_task_pickup_type_grimoire_or_tome",
	traitor = "loc_contract_task_enemy_type_traitor",
}

ContractSettings.kill_bosses = {
	backend_name = "KillBosses",
	description = "loc_contracts_task_description_kill_bosses",
	stat_name = "session_boss_kills",
	title = "loc_contracts_task_label_kill_bosses",
}
ContractSettings.collect_pickups = {
	backend_name = "CollectPickup",
	description = "loc_contracts_task_description_collect_pickups",
	title = "loc_contracts_task_label_collect_pickups",
	localization_parameters = function (target_value, specifiers)
		local param_loc = task_parameter_strings[specifiers.pickupTypes]

		if not param_loc then
			local task_criteria_types = specifiers.pickupType

			if #task_criteria_types > 1 then
				param_loc = task_parameter_strings.tome_or_grimoire
			else
				param_loc = task_parameter_strings[task_criteria_types[1]]
			end
		end

		return {
			kind = param_loc and Localize(param_loc) or "",
			count = target_value,
		}
	end,
}
ContractSettings.collect_resources = {
	backend_name = "CollectResource",
	description = "loc_contracts_task_description_collect_resources",
	title = "loc_contracts_task_label_collect_resources",
	localization_parameters = function (target_value, specifiers)
		local wallet_settings = WalletSettings[specifiers.resourceType]

		if not wallet_settings then
			local task_criteria_types = specifiers.resourceTypes

			if task_criteria_types and #task_criteria_types > 0 then
				wallet_settings = WalletSettings[task_criteria_types[1]]
			end
		end

		return {
			kind = wallet_settings and Localize(wallet_settings.display_name) or "",
			count = target_value,
		}
	end,
}
ContractSettings.mission_no_death = {
	backend_name = "CompleteMissionsNoDeath",
	description = "loc_contracts_task_description_complete_mission_no_death",
	title = "loc_contracts_task_label_complete_mission_no_death",
}
ContractSettings.kill_minions = {
	backend_name = "KillMinions",
	description = "loc_contracts_task_description_kill_minions",
	title = "loc_contracts_task_label_kill_minions",
	stat_name = function (target_value, specifiers)
		local enemy_type = specifiers.enemyType
		local weapon_type = specifiers.weaponType

		return string.format("team_%s_killed_with_%s", enemy_type, weapon_type)
	end,
	localization_parameters = function (target_value, specifiers)
		return {
			enemy_type = Localize(task_parameter_strings[specifiers.enemyType]),
			weapon_type = Localize(task_parameter_strings[specifiers.weaponType]),
			count = target_value,
		}
	end,
}
ContractSettings.complete_missions = {
	backend_name = "CompleteMissions",
	description = "loc_contracts_task_label_complete_missions",
	title = "loc_contracts_task_label_complete_missions",
}
ContractSettings.complete_missions_by_name = {
	backend_name = "CompleteMissionsByName",
	description = "loc_contracts_task_description_complete_missions_by_name",
	title = "loc_contracts_task_label_complete_missions_by_name",
	localization_parameters = function (target_value, specifiers)
		local mission_template = MissionTemplates[specifiers.name]

		return {
			map = mission_template and Localize(mission_template.mission_name) or "",
			count = target_value,
		}
	end,
}
ContractSettings.block_damage = {
	backend_name = "BlockDamage",
	description = "loc_contracts_task_description_block_damage",
	stat_name = "session_team_blocked_damage",
	title = "loc_contracts_task_label_block_damage",
}

return settings("ContractSettings", ContractSettings)
