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
local Promise = require("scripts/foundation/utilities/promise")
local CacheWrapper = class("CacheWrapper")
local Interface = {
	"refresh",
	"get_cached",
	"has_data",
	"add_listener",
	"remove_listener"
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
	local promise = nil

	if version ~= nil and url ~= nil then
		promise = Promise.resolved({
			version = version,
			url = url
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
		Log.warning("CacheWrapper", "Error refreshing data for cached value \n%s", tostring(e))

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

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	return self._current_metadata and self._current_metadata.version
	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 6-6, warpins: 2 ---
	--- END OF BLOCK #1 ---



end

CacheWrapper.get_metadata = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	return self._current_metadata or {}
	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 5-5, warpins: 2 ---
	--- END OF BLOCK #1 ---



end

CacheWrapper.get_cached = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-6, warpins: 1 ---
	fassert(self._current_value, "Function refresh() must be called and allowed to finish before get_cached() can be called")

	return self._current_value
	--- END OF BLOCK #0 ---



end

CacheWrapper.has_data = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	return self._current_value ~= nil
	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 7-7, warpins: 2 ---
	--- END OF BLOCK #1 ---



end

implements(CacheWrapper, Interface)

return CacheWrapper
