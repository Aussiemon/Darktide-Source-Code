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
		return BackendUtilities.wrap_paged_response(data.body)
	end)
end

Gear.delete_gear = function (self, item_id)
	return self:_gear_path():next(function (path)
		return Managers.backend:title_request(path .. "/" .. item_id, {
			method = "DELETE"
		}):next(function (data)
			return data.body
		end)
	end)
end

Gear.create = function (self, master_id, slot, character_id, overrides, allow_duplicate)
	return Managers.backend:authenticate():next(function (account)
		return string.format("/data/%s/account/gear?allowDuplicate=%s", account.sub, allow_duplicate)
	end):next(function (path)
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
			return data.body
		end)
	end)
end

Gear.set_traits = function (self, item_id, traits)
	return BackendUtilities.make_account_title_request("account", BackendUtilities.url_builder("/gear/"):path(item_id):path("/overrides/bound_traits"), {
		method = "PUT",
		body = {
			data = traits
		}
	}):next(function (data)
		return nil
	end)
end

Gear.attach_item_as_override = function (self, item_id, attach_point, gear_id)
	local string_path = {
		method = "PUT",
		body = {}
	}

	if gear_id then
		string_path.body.itemRef = gear_id
	end

	return BackendUtilities.make_account_title_request("account", BackendUtilities.url_builder("/gear/"):path(item_id):path("/overrides/"):path(attach_point), string_path):next(function (data)
		return nil
	end)
end

Gear._gear_path = function (self)
	return Managers.backend:authenticate():next(function (account)
		return string.format("/data/%s/account/gear", account.sub)
	end)
end

implements(Gear, Interface)

return Gear
