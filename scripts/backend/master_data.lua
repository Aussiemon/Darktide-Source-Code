-- chunkname: @scripts/backend/master_data.lua

local CacheWrapper = require("scripts/backend/cache_wrapper")
local ItemPackage = require("scripts/foundation/managers/package/utilities/item_package")
local LocalLoader = require("scripts/settings/equipment/local_items_loader")
local Promise = require("scripts/foundation/utilities/promise")
local Interface = {
	"items_cache"
}
local MasterData = class("MasterData")

MasterData.init = function (self)
	self._local_item_version = 0
end

MasterData.on_reload = function (self, refreshed_resources)
	if refreshed_resources.item then
		self._local_item_version = self._local_item_version + 1

		Log.info("MasterData", "Items recompiled, reloading. Version: %s", self._local_item_version)
		self._fetch_items_wrapper:refresh()
	end
end

MasterData.items_cache = function (self)
	if not self._fetch_items_wrapper then
		local metadata_cb = callback(self, "_get_items_metadata")
		local fetch_cb = callback(self, "_get_items_from_backend")
		local fallback_cb = callback(self, "_fail_on_missing_metadata")

		self._fetch_items_wrapper = CacheWrapper:new(metadata_cb, fetch_cb, fallback_cb)
	end

	return self._fetch_items_wrapper
end

local function create_network_lookup(items)
	NetworkLookup.create_item_names_lookup(items)

	local NetworkConstants = require("scripts/network_lookup/network_constants")

	NetworkConstants.check_network_lookup_boundaries("player_item_name", "player_item_names")
end

MasterData.refresh_network_lookup = function (self)
	if not NetworkLookup.player_item_names then
		create_network_lookup(self:items_cache():get_cached())
	end
end

local function _include_item_definition(items)
	for k, entry_data in pairs(items) do
		entry_data.name = k
		entry_data.display_name = entry_data.display_name or "n/a"
		entry_data.resource_dependencies = {}

		ItemPackage.compile_resource_dependencies(entry_data, entry_data.resource_dependencies)
	end
end

MasterData._get_items_from_metadata_db = function (self)
	return LocalLoader.get_items_from_metadata_db():next(function (items)
		_include_item_definition(items)
		create_network_lookup(items)
		table.set_readonly(items, "Item Definitions")

		return items
	end)
end

MasterData._get_items_from_backend = function (self, version, url)
	local promise

	if version ~= nil and url ~= nil then
		promise = Managers.backend:url_request(url, {
			require_auth = true
		})
	else
		promise = self:_get_items_metadata():next(function (metadata)
			Log.info("MasterData", "Fetching master items at %s", metadata.url)

			return Managers.backend:url_request(metadata.url, {
				require_auth = true
			})
		end)
	end

	return promise:next(function (data)
		return data.body
	end):next(function (items)
		_include_item_definition(items)
		create_network_lookup(items)
		table.set_readonly(items, "Item Definitions")

		return items
	end)
end

MasterData._get_local_items_metadata = function (self)
	local promise = Promise.new()

	promise:resolve({
		version = self._local_item_version
	})

	return promise
end

MasterData._fail_on_missing_metadata = function (self)
	return Promise.rejected({
		message = "Failed fetching item master data"
	})
end

MasterData._get_items_metadata = function (self)
	return Managers.backend:title_request("/master-data/meta/items"):next(function (data)
		return data.body
	end):next(function (metadata)
		return {
			version = metadata.playerItems.version,
			url = metadata.playerItems.href
		}
	end)
end

implements(MasterData, Interface)

return MasterData
