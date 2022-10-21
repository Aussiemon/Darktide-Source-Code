local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Contracts = class("Contracts")

Contracts.localization_strings_from_criteria = function (self, criteria)
	local localization = {
		title_key = "loc_contracts_" .. criteria.taskType:lower() .. "_title",
		description_key = "loc_contracts_" .. criteria.taskType:lower() .. "_description"
	}

	if criteria.taskType == "CompleteMissions" then
		localization.title_params = {
			p1 = criteria.numberMissions
		}
		localization.description_params = {
			p1 = criteria.numberMissions
		}
	elseif criteria.taskType == "CompleteMissionsDifficulty" then
		localization.title_params = {
			p1 = criteria.numberMissions,
			p2 = criteria.minDifficulty
		}
		localization.description_params = {
			p1 = criteria.numberMissions,
			p2 = criteria.minDifficulty
		}
	elseif criteria.taskType == "CompleteMissionsType" then
		localization.title_params = {
			p1 = criteria.numberMissions,
			p2 = criteria.missionType
		}
		localization.description_params = {
			p1 = criteria.numberMissions,
			p2 = criteria.missionType
		}
	elseif criteria.taskType == "KillWithRanged" or criteria.taskType == "KillWithMelee" then
		localization.title_params = {
			p1 = criteria.numberKills,
			p2 = criteria.weaponTemplate
		}
		localization.description_params = {
			p1 = criteria.numberKills,
			p2 = criteria.weaponTemplate
		}
	elseif criteria.taskType == "FinishSideObjectives" then
		localization.title_params = {
			p1 = criteria.numberObjectives
		}
		localization.description_params = {
			p1 = criteria.numberObjectives
		}
	end

	return localization
end

Contracts.get_current_contract = function (self, character_id, account_id, create_if_missing)
	if create_if_missing == nil then
		create_if_missing = true
	end

	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id):path("/contracts/current"):query("createIfMissing", create_if_missing), {}, account_id):next(function (data)
		return data.body.contract
	end)
end

Contracts.get_current_task = function (self, character_id, task_id, optional_account_id)
	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id):path("/contracts/current/tasks/" .. task_id), {}, optional_account_id):next(function (data)
		return data.body.task
	end)
end

Contracts.complete_contract = function (self, character_id)
	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id):path("/contracts/current/complete"), {
		method = "POST"
	}):next(function (data)
		return data.body.contract
	end)
end

Contracts.reroll_task = function (self, character_id, task_id, last_transaction_id)
	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id):path("/contracts/current/tasks/"):path(task_id):query("lastTransactionId", last_transaction_id), {
		method = "DELETE"
	}):next(function (data)
		return data.body.refreshedContract
	end)
end

return Contracts
