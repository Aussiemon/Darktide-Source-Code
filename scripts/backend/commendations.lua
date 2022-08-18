local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Interface = {
	"get_commendations"
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
		method = "DELETE"
	})
end

Commendations.create_update = function (self, account_id, stat_updates, completed_commendations)
	local ok, player_platform, player_platform_id = self:unpack_player(account_id)

	if not ok then
		Log.error("Backend", "Failed to create commendation update")

		return
	end

	return {
		accountId = account_id,
		platformName = player_platform,
		platformId = player_platform_id,
		stats = stat_updates,
		completed = completed_commendations
	}
end

Commendations.bulk_update_commendations = function (self, commendation_update)
	local path = BackendUtilities.url_builder():path("/commendations"):to_string()

	Log.info("Backend", "Patching commendations %s", table.tostring(commendation_update, 99))

	return Managers.backend:title_request(path, {
		method = "PATCH",
		body = commendation_update
	})
end

Commendations.unpack_player = function (self, account_id)
	if not account_id then
		Log.warning("Backend", "Expected account id to be present")

		return false
	end

	local player_platform = "steam"
	local player_platform_id = "76561199099162575"

	return true, player_platform, player_platform_id
end

implements(Commendations, Interface)

return Commendations
