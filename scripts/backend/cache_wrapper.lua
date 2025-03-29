-- chunkname: @scripts/backend/cache_wrapper.lua

local Promise = require("scripts/foundation/utilities/promise")
local CacheWrapper = class("CacheWrapper")
local Interface = {
	"refresh",
	"get_cached",
	"has_data",
	"add_listener",
	"remove_listener",
}

CacheWrapper.init = function (self, metadata_fn, refresh_fn, fallback_fn)
	self._metadata_fn = metadata_fn
	self._refresh_fn = refresh_fn
	self._fallback_fn = fallback_fn
	self._current_metadata = {}
	self._current_value = nil
	self._listeners = {}
end

CacheWrapper.add_listener = function (self, callback_fn)
	self._listeners[callback_fn] = true
end

CacheWrapper.remove_listener = function (self, callback_fn)
	self._listeners[callback_fn] = nil
end

CacheWrapper.refresh = function (self, version, url)
	local promise

	if version ~= nil and url ~= nil then
		promise = Promise.resolved({
			version = version,
			url = url,
		})
	else
		promise = self._metadata_fn()
	end

	return promise:next(function (metadata)
		Log.debug("CacheWrapper", "Got meta data with version: %s", metadata.version)

		if self._current_metadata.version ~= metadata.version then
			return self._refresh_fn(metadata.version, metadata.url):next(function (v)
				self._current_metadata = metadata
				self._current_value = v

				for k, _ in pairs(self._listeners) do
					local success, reason = pcall(function ()
						k(metadata.version, v)
					end)

					if not success then
						Log.error("CacheWrapper", "Unexpected error when calling cache listener: %s", reason)
					end
				end

				return v
			end)
		else
			return self._current_value
		end
	end):catch(function (e)
		if type(e) == "table" then
			Log.warning("CacheWrapper", "Error refreshing data for cached value \n%s", table.tostring(e, 3))
		else
			Log.warning("CacheWrapper", "Error refreshing data for cached value \n%s", tostring(e))
		end

		if self._current_value then
			return self._current_value
		else
			Log.warning("CacheWrapper", "No already cached value, using fallback")

			return self._fallback_fn():next(function (v)
				self._current_value = v

				return v
			end)
		end
	end)
end

CacheWrapper.get_version = function (self)
	return self._current_metadata and self._current_metadata.version
end

CacheWrapper.get_metadata = function (self)
	return self._current_metadata or {}
end

CacheWrapper.get_cached = function (self)
	return self._current_value
end

CacheWrapper.has_data = function (self)
	return self._current_value ~= nil
end

implements(CacheWrapper, Interface)

return CacheWrapper
