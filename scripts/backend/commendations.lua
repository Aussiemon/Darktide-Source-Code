-- Decompilation Error: _run_step(_unwarp_expressions, node)

-- Decompilation Error: _glue_flows(node)

-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Interface = {
	"get_commendations"
}
local Commendations = class("Commendations")

Commendations.get_commendations = function (self, account_id, include_all, include_stats)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-12, warpins: 1 ---
	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 14-19, warpins: 2 ---
	slot4 = BackendUtilities.make_account_title_request
	slot5 = "account"
	slot7 = BackendUtilities.url_builder("commendations")
	slot6 = BackendUtilities.url_builder("commendations").query
	slot8 = "includeAll"

	if not include_all then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 13-13, warpins: 1 ---
		slot9 = false
		--- END OF BLOCK #0 ---



	end

	slot7 = slot6(slot7, slot8, slot9)
	slot6 = slot6(slot7, slot8, slot9).query
	slot8 = "includeStats"
	slot9 = include_stats or include_stats == nil

	return slot4(slot5, slot6(slot7, slot8, slot9).query(slot7, slot8, slot9), {}, account_id):next(function (data)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-2, warpins: 1 ---
		return data.body
		--- END OF BLOCK #0 ---



	end)

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #3



	-- Decompilation error in this vicinity:
	--- BLOCK #2 20-21, warpins: 1 ---
	if include_stats ~= nil then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 22-23, warpins: 1 ---
		slot9 = false
		--- END OF BLOCK #0 ---



	else

		-- Decompilation error in this vicinity:
		--- BLOCK #0 24-24, warpins: 1 ---
		slot9 = true
		--- END OF BLOCK #0 ---



	end
	--- END OF BLOCK #2 ---

	FLOW; TARGET BLOCK #3



	-- Decompilation error in this vicinity:
	--- BLOCK #3 25-33, warpins: 3 ---
	--- END OF BLOCK #3 ---



end

Commendations.delete_commendations = function (self, account_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-20, warpins: 1 ---
	local path = BackendUtilities.url_builder():path("/data/" .. account_id .. "/account/commendations"):to_string()

	return Managers.backend:title_request(path, {
		method = "DELETE"
	})
	--- END OF BLOCK #0 ---



end

Commendations.create_update = function (self, account_id, stat_updates, completed_commendations)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-6, warpins: 1 ---
	local ok, player_platform, player_platform_id = self:unpack_player(account_id)

	if not ok then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 7-12, warpins: 1 ---
		Log.error("Backend", "Failed to create commendation update")

		return
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 13-19, warpins: 2 ---
	return {
		accountId = account_id,
		platformName = player_platform,
		platformId = player_platform_id,
		stats = stat_updates,
		completed = completed_commendations
	}
	--- END OF BLOCK #1 ---



end

Commendations.bulk_update_commendations = function (self, commendation_update)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-28, warpins: 1 ---
	local path = BackendUtilities.url_builder():path("/commendations"):to_string()

	Log.info("Backend", "Patching commendations %s", table.tostring(commendation_update, 99))

	return Managers.backend:title_request(path, {
		method = "PATCH",
		body = commendation_update
	})
	--- END OF BLOCK #0 ---



end

Commendations.unpack_player = function (self, account_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-2, warpins: 1 ---
	if not account_id then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 3-9, warpins: 1 ---
		Log.warning("Backend", "Expected account id to be present")

		return false
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 10-15, warpins: 2 ---
	local player_platform = "steam"
	local player_platform_id = "76561199099162575"

	return true, player_platform, player_platform_id
	--- END OF BLOCK #1 ---



end

implements(Commendations, Interface)

return Commendations
