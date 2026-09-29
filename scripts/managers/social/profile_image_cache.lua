-- chunkname: @scripts/managers/social/profile_image_cache.lua

local Promise = require("scripts/foundation/utilities/promise")
local CHUNK_SIZE = 100
local REQUEST_TIMEOUT = 10
local ProfileImageCache = class("ProfileImageCache")

ProfileImageCache.init = function (self, platform, fetch, free, cancel)
	self._platform = platform
	self._fetch = fetch
	self._free = free
	self._cancel = cancel
	self._entries = {}
	self._pending = {}
	self._in_flight_count = 0
end

ProfileImageCache.load = function (self, platform, id)
	if platform ~= self._platform then
		return Promise.rejected({
			reason = "foreign_platform",
			platform = platform,
		})
	end

	local entry = self._entries[id]

	if entry then
		entry.refcount = entry.refcount + 1

		if entry.data then
			return Promise.resolved(entry.data)
		end

		return entry.promise
	end

	entry = {
		cancelled = false,
		elapsed = 0,
		in_flight = false,
		refcount = 1,
		promise = Promise:new(),
	}
	self._entries[id] = entry
	self._pending[#self._pending + 1] = id

	return entry.promise
end

ProfileImageCache.unload = function (self, platform, id)
	if platform ~= self._platform then
		return
	end

	local entry = self._entries[id]

	entry.refcount = entry.refcount - 1

	if entry.refcount > 0 then
		return
	end

	self._entries[id] = nil

	if entry.data then
		self._free(id, entry.data)
	elseif not entry.cancelled then
		entry.cancelled = true

		entry.promise:cancel()

		if entry.in_flight then
			self:_settle_in_flight(entry)

			if self._cancel then
				self._cancel(id)
			end
		end
	end
end

ProfileImageCache._settle_in_flight = function (self, entry)
	entry.in_flight = false
	self._in_flight_count = self._in_flight_count - 1
end

ProfileImageCache._on_result = function (self, id, data, reason)
	local entry = self._entries[id]

	if not entry or entry.cancelled then
		return
	end

	if entry.in_flight then
		self:_settle_in_flight(entry)
	end

	if data then
		entry.data = data

		entry.promise:resolve(data)
	else
		entry.promise:reject({
			reason = reason or "unknown",
		})
	end
end

ProfileImageCache.update = function (self, dt)
	for id, entry in pairs(self._entries) do
		if entry.in_flight and not entry.cancelled then
			entry.elapsed = entry.elapsed + dt

			if entry.elapsed >= REQUEST_TIMEOUT then
				self:_settle_in_flight(entry)

				entry.cancelled = true

				entry.promise:reject({
					reason = "timeout",
				})

				if self._cancel then
					self._cancel(id)
				end
			end
		end
	end

	if self._in_flight_count > 0 then
		return
	end

	local pending = self._pending

	if #pending == 0 then
		return
	end

	local chunk = {}
	local rest = {}
	local queued = {}

	for i = 1, #pending do
		local id = pending[i]
		local entry = self._entries[id]

		if entry and not entry.cancelled and not entry.data and not queued[id] then
			queued[id] = true

			if #chunk < CHUNK_SIZE then
				chunk[#chunk + 1] = id
			else
				rest[#rest + 1] = id
			end
		end
	end

	self._pending = rest

	if #chunk == 0 then
		return
	end

	for i = 1, #chunk do
		local entry = self._entries[chunk[i]]

		entry.in_flight = true
		entry.elapsed = 0
	end

	self._in_flight_count = #chunk

	self._fetch(chunk, function (id, data, reason)
		self:_on_result(id, data, reason)
	end)
end

ProfileImageCache.destroy = function (self)
	for _, entry in pairs(self._entries) do
		if not entry.data and not entry.cancelled then
			entry.promise:cancel()
		end
	end
end

return ProfileImageCache
