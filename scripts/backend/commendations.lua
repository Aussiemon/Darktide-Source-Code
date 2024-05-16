-- chunkname: @scripts/backend/commendations.lua

local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Promise = require("scripts/foundation/utilities/promise")
local Interface = {
	"get_commendations",
}
local Commendations = class("Commendations")

Commendations.get_commendations = function (self, account_id, include_all, include_stats)
	return BackendUtilities.make_account_title_request("account", BackendUtilities.url_builder("commendations"):query("includeAll", include_all or false):query("includeStats", include_stats or include_stats == nil), {}, account_id):next(function (data)
		return data.body
	end)
end

Commendations.delete_commendations = function (self, account_id)
	local path = BackendUtilities.url_builder():path("/data/" .. account_id .. "/account/commendations"):to_string()

	return Managers.backend:title_request(path, {
		method = "DELETE",
	})
end

Commendations.create_update = function (self, account_id, stat_updates, completed_commendations)
	return {
		accountId = account_id,
		stats = stat_updates,
		completed = completed_commendations,
	}
end

Commendations.init_commendation_score = function (self, account_id)
	local path = BackendUtilities.url_builder():path("/data/" .. account_id .. "/account/commendations/score"):to_string()

	return Managers.backend:title_request(path, {
		method = "POST",
	})
end

Commendations.bulk_update_commendations = function (self, commendation_update)
	if DevParameters.disable_achievement_backend_update then
		return Promise.resolved(nil)
	end

	local path = BackendUtilities.url_builder():path("/commendations"):to_string()

	return Managers.backend:title_request(path, {
		method = "PATCH",
		body = commendation_update,
	})
end

implements(Commendations, Interface)

return Commendations
