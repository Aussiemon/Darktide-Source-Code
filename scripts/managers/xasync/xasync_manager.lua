local Promise = require("scripts/foundation/utilities/promise")
local XAsyncManager = class("XAsyncManager")

XAsyncManager.init = function (self)
	self._async_blocks = {}
end

XAsyncManager.in_progress = function (self)
	return not table.is_empty(self._async_blocks)
end

XAsyncManager.wrap = function (self, async_block, release_function)
	local p = Promise:new()
	self._async_blocks[async_block] = {
		promise = p,
		release_function = release_function
	}

	return p
end

XAsyncManager.release = function (self, async_block)
	local promise = self._async_blocks[async_block].promise
	local release_function = self._async_blocks[async_block].release_function

	if promise and promise:is_pending() then
		promise:reject({
			HRESULT.E_ABORT
		})
	end

	release_function(async_block)

	self._async_blocks[async_block] = nil
end

XAsyncManager.update = function (self, dt)
	for async_block, data in pairs(self._async_blocks) do
		if not data.promise:is_pending() then
			local release_function = data.release_function

			release_function(async_block)

			self._async_blocks[async_block] = nil
		end
	end

	for async_block, data in pairs(self._async_blocks) do
		local hr = XAsyncBlock.status(async_block)

		if hr == HRESULT.S_OK then
			data.promise:resolve(async_block)
		elseif hr == HRESULT.E_PENDING then
		else
			data.promise:reject({
				hr
			})
		end
	end
end

XAsyncManager.destroy = function (self)
	for async_block, data in pairs(self._async_blocks) do
		if data.promise:is_pending() then
			data.promise:reject({
				HRESULT.E_ABORT
			})
		end

		local release_function = data.release_function

		release_function(async_block)

		self._async_blocks[async_block] = nil
	end
end

return XAsyncManager
