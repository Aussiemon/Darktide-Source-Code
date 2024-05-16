-- chunkname: @scripts/managers/data_service/data_service_backend_cache.lua

local Promise = require("scripts/foundation/utilities/promise")
local DataServiceBackendCache = class("DataServiceBackendCache")

DataServiceBackendCache.init = function (self, name)
	self._name = name
	self._cached_data = {}
	self._backend_requests = {}
	self._external_promises = {}
end

DataServiceBackendCache.is_empty = function (self)
	return table.is_empty(self._cached_data)
end

DataServiceBackendCache.get_data = function (self, cache_key, backend_func)
	local promise = Promise.new()

	if cache_key == nil then
		local err = "Tried to get data from cache without providing a cache_key"

		Log.error(self._name, err)
		promise:reject({
			error = string.format("[%s] %s", self._name, err),
		})
	elseif self._cached_data[cache_key] then
		promise:resolve(self._cached_data[cache_key])
	else
		local external_promises = self._external_promises[cache_key]

		if not external_promises then
			external_promises = {}
			self._external_promises[cache_key] = external_promises
		end

		external_promises[#external_promises + 1] = promise

		if not self._backend_requests[cache_key] then
			self:_fetch_backend_data(cache_key, backend_func)
		end
	end

	return promise
end

DataServiceBackendCache._fetch_backend_data = function (self, cache_key, backend_func)
	if self._backend_requests[cache_key] then
		self._backend_requests[cache_key].promise:cancel()
	end

	local backend_promise = backend_func()

	self._backend_requests[cache_key] = {
		promise = backend_promise,
		backend_func = backend_func,
	}

	backend_promise:next(function (result)
		self._backend_requests[cache_key] = nil
		self._cached_data[cache_key] = result

		local external_promises = self._external_promises[cache_key]

		for i = 1, #external_promises do
			local p = external_promises[i]

			if p:is_pending() then
				p:resolve(result)
			end
		end

		self._external_promises[cache_key] = nil
	end):catch(function (err)
		self._backend_requests[cache_key] = nil
		self._cached_data[cache_key] = nil

		local external_promises = self._external_promises[cache_key]

		for i = 1, #external_promises do
			local p = external_promises[i]

			if p:is_pending() then
				p:reject(err)
			end
		end

		self._external_promises[cache_key] = nil

		Log.error(self._name, "Failed fetching data %s: %s", cache_key, table.tostring(err))
	end)
end

DataServiceBackendCache.invalidate = function (self)
	table.clear(self._cached_data)

	for cache_key, request in pairs(self._backend_requests) do
		self:_fetch_backend_data(cache_key, request.backend_func)
	end
end

DataServiceBackendCache.reset = function (self)
	table.clear(self._cached_data)

	local backend_requests = self._backend_requests

	for _, request in pairs(backend_requests) do
		request.promise:cancel()
	end

	table.clear(backend_requests)

	local external_promises = self._external_promises

	for cache_key, promises in pairs(external_promises) do
		for i = 1, #promises do
			local p = promises[i]

			if p:is_pending() then
				p:cancel()
			end
		end
	end

	table.clear(external_promises)
end

DataServiceBackendCache.cached_data_by_key = function (self, cache_key)
	if not cache_key then
		Log.error(self._name, "Tried to access cached data but no key was provided")

		return nil
	end

	return self._cached_data[cache_key]
end

return DataServiceBackendCache
