-- chunkname: @scripts/backend/gear.lua

local Promise = require("scripts/foundation/utilities/promise")
local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Interface = {
	"fetch"
}
local Gear = class("Gear")

Gear.fetch = function (self, wrapped, promise, all_items)
	if not wrapped then
		local new_promise = Promise.new()

		self:fetch_paged(500):next(function (w)
			self:fetch(w, new_promise, {})
		end):catch(function (error)
			new_promise:reject(error)
		end)

		return new_promise
	else
		for _, item in pairs(wrapped.items) do
			all_items[item.uuid] = item
		end

		if wrapped.has_next then
			wrapped.next_page():next(function (w)
				self:fetch(w, promise, all_items)
			end)
		else
			promise:resolve(all_items)
		end
	end
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

Gear.delete_gear_batch = function (self, gear_ids)
	local operations = {}

	for i = 1, #gear_ids do
		local gear_id = gear_ids[i]

		operations[#operations + 1] = {
			op = "delete",
			gearId = gear_id
		}
	end

	return self:_gear_batch_path():next(function (path)
		return Managers.backend:title_request(path, {
			method = "POST",
			body = {
				operations = operations
			}
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
	else
		string_path.body = nil
	end

	return BackendUtilities.make_account_title_request("account", BackendUtilities.url_builder("/gear/"):path(item_id):path("/overrides/"):path(attach_point), string_path):next(function (data)
		return data.body
	end)
end

Gear._gear_path = function (self)
	return Managers.backend:authenticate():next(function (account)
		return string.format("/data/%s/account/gear", account.sub)
	end)
end

Gear._gear_batch_path = function (self)
	return Managers.backend:authenticate():next(function (account)
		return string.format("/data/%s/account/batch/gear", account.sub)
	end)
end

implements(Gear, Interface)

return Gear
