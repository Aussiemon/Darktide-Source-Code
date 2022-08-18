-- Decompilation Error: _glue_flows(node)

-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Wintracks = class("Wintracks")

local function _patch_wintrack(character_id, wintrack_id, body)
	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id):path("/wintracks/"):path(wintrack_id), {
		method = "PATCH",
		body = body
	}):next(function (data)
		return true
	end)
end

Wintracks.set_wintrack_active_state = function (self, character_id, wintrack_id, active)
	return _patch_wintrack(character_id, wintrack_id, {
		active = active or false
	})
end

local function _map_to_id(wintracks)
	local mapped = {}
	local len = #wintracks

	for i = 1, len, 1 do
		local wintrack = wintracks[i]
		mapped[wintrack.id] = wintrack
	end

	return mapped
end

Wintracks.get_wintracks_state = function (self, include_info)
	return Managers.backend:authenticate():next(function (account)
		local path = BackendUtilities.url_builder():path("/data/"):path(account.sub):path("/wintrackstate"):to_string()

		return Managers.backend:title_request(path)
	end):next(function (data)
		local wintracks = data.body.wintracks
		local mapped = _map_to_id(wintracks)

		if include_info then
			return BackendUtilities.fetch_embedded_links(data.body):next(function (items)
				local infos = {}
				local len = #items

				for i = 1, len, 1 do
					local item = items[i]
					local data = item.body
					data._links = nil
					local state = mapped[data.id]
					state.info = data
				end

				return mapped
			end)
		else
			return mapped
		end
	end)
end

Wintracks.get_wintrack = function (self, wintrack_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-25, warpins: 1 ---
	local path = BackendUtilities.url_builder():path("/wintracks/"):path(wintrack_id):to_string()

	return Managers.backend:title_request(path):next(function (data)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-2, warpins: 1 ---
		return data.body
		--- END OF BLOCK #0 ---



	end)
	--- END OF BLOCK #0 ---



end

return Wintracks
