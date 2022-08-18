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
local Promise = require("scripts/foundation/utilities/promise")
local BackendError = require("scripts/foundation/managers/backend/backend_error")
local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Interface = {
	"fetch"
}
local Gear = class("Gear")

Gear.fetch = function (self)
	Log.warning("Gear", "Deprecated, use fetch_paged instead")

	return self:_gear_path():next(function (path)
		return Managers.backend:title_request(path)
	end):next(function (data)
		return data.body.gearList
	end)
end

Gear.fetch_by_id = function (self, account_id, gear_id)
	return BackendUtilities.make_account_title_request("account", BackendUtilities.url_builder("/gear/"):path(gear_id), {}, account_id):next(function (data)
		return data.body.gear
	end)
end

Gear.fetch_paged = function (self, size, slots)
	return Managers.backend:authenticate():next(function (account)
		local builder = BackendUtilities.url_builder():path("/v2/data/"):path(account.sub):path("/account/gear"):query("limit", size)

		if slots then
			builder:query("slots", slots)
		end

		return builder:to_string()
	end):next(function (path)
		return Managers.backend:title_request(path)
	end):next(function (data)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-4, warpins: 1 ---
		return BackendUtilities.wrap_paged_response(data.body)
		--- END OF BLOCK #0 ---



	end)
end

Gear.delete_gear = function (self, item_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-8, warpins: 1 ---
	return self:_gear_path():next(function (path)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-15, warpins: 1 ---
		return Managers.backend:title_request(path .. "/" .. item_id, {
			method = "DELETE"
		}):next(function (data)

			-- Decompilation error in this vicinity:
			--- BLOCK #0 1-2, warpins: 1 ---
			return data.body
			--- END OF BLOCK #0 ---



		end)
		--- END OF BLOCK #0 ---



	end)
	--- END OF BLOCK #0 ---



end

Gear.create = function (self, master_id, slot, character_id, overrides, allow_duplicate)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-14, warpins: 1 ---
	return Managers.backend:authenticate():next(function (account)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-6, warpins: 1 ---
		return string.format("/data/%s/account/gear?allowDuplicate=%s", account.sub, allow_duplicate)
		--- END OF BLOCK #0 ---



	end):next(function (path)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-26, warpins: 1 ---
		return Managers.backend:title_request(path, {
			method = "POST",
			body = {
				characterId = character_id,
				slots = {
					slot
				},
				masterDataInstance = {
					id = master_id
				},
				overrides = overrides
			}
		}):next(function (data)

			-- Decompilation error in this vicinity:
			--- BLOCK #0 1-2, warpins: 1 ---
			return data.body
			--- END OF BLOCK #0 ---



		end)
		--- END OF BLOCK #0 ---



	end)
	--- END OF BLOCK #0 ---



end

Gear.set_traits = function (self, item_id, traits)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-25, warpins: 1 ---
	return BackendUtilities.make_account_title_request("account", BackendUtilities.url_builder("/gear/"):path(item_id):path("/overrides/bound_traits"), {
		method = "PUT",
		body = {
			data = traits
		}
	}):next(function (data)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-2, warpins: 1 ---
		return nil
		--- END OF BLOCK #0 ---



	end)
	--- END OF BLOCK #0 ---



end

Gear.attach_item_as_override = function (self, item_id, attach_point, gear_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-29, warpins: 1 ---
	return BackendUtilities.make_account_title_request("account", BackendUtilities.url_builder("/gear/"):path(item_id):path("/overrides/"):path(attach_point), {
		method = "PUT",
		body = {
			itemRef = gear_id
		}
	}):next(function (data)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-2, warpins: 1 ---
		return nil
		--- END OF BLOCK #0 ---



	end)
	--- END OF BLOCK #0 ---



end

Gear._gear_path = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-10, warpins: 1 ---
	return Managers.backend:authenticate():next(function (account)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-5, warpins: 1 ---
		return string.format("/data/%s/account/gear", account.sub)
		--- END OF BLOCK #0 ---



	end)
	--- END OF BLOCK #0 ---



end

implements(Gear, Interface)

return Gear
