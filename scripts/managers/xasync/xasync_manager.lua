-- chunkname: @scripts/managers/xasync/xasync_manager.lua

local Promise = require("scripts/foundation/utilities/promise")
local XAsyncManager = class("XAsyncManager")

XAsyncManager.init = function (self)
	self._async_blocks = {}
end

XAsyncManager.in_progress = function (self)
	return not table.is_empty(self._async_blocks)
end

XAsyncManager.wrap = function (self, async_block, debug_name)
	local p = Promise:new()

	self._async_blocks[async_block] = {
		promise = p,
		debug_name = debug_name,
	}

	return p
end

XAsyncManager.release = function (self, async_block)
	local promise = self._async_blocks[async_block].promise
	local debug_name = self._async_blocks[async_block].debug_name

	if promise and promise:is_pending() then
		if debug_name then
			Log.error("XAsyncManager", "Aborted async_block with debug_name %s", debug_name)
		end

		promise:reject({
			HRESULT.E_ABORT,
		})
	end

	XAsyncBlock.release_block(async_block)

	self._async_blocks[async_block] = nil
end

XAsyncManager.update = function (self, dt)
	local async_blocks = self._async_blocks

	for async_block, data in pairs(async_blocks) do
		if not data.promise:is_pending() then
			XAsyncBlock.release_block(async_block)

			async_blocks[async_block] = nil
		end
	end

	for async_block, data in pairs(async_blocks) do
		local hr = XAsyncBlock.status(async_block)

		if hr == HRESULT.S_OK then
			data.promise:resolve(async_block)
		elseif hr == HRESULT.E_PENDING then
			-- Nothing
		else
			if data.debug_name then
				Log.error("XAsyncManager", "Rejecting async_block with debug_name %s, error code 0x%x", data.debug_name, tostring(hr))
			end

			data.promise:reject({
				hr,
			})
		end
	end
end

XAsyncManager.destroy = function (self)
	for async_block, data in pairs(self._async_blocks) do
		if data.promise:is_pending() then
			if data.debug_name then
				Log.error("XAsyncManager", "Aborted async_block with debug_name %s", data.debug_name)
			end

			data.promise:reject({
				HRESULT.E_ABORT,
			})
		end

		XAsyncBlock.release_block(async_block)

		self._async_blocks[async_block] = nil
	end
end

return XAsyncManager
