-- chunkname: @scripts/utilities/ui/promise_container.lua

local PromiseContainer = class("PromiseContainer")

PromiseContainer.init = function (self)
	self._promises = {}
end

PromiseContainer.destroy = function (self)
	for promise, _ in pairs(self._promises) do
		promise:cancel()
	end
end

PromiseContainer.cancel_on_destroy = function (self, promise)
	local track_promise = promise:is_pending() and not self._promises[promise]

	if track_promise then
		self._promises[promise] = true

		promise:next(function ()
			self._promises[promise] = nil
		end, function ()
			self._promises[promise] = nil
		end)
	end

	return promise
end

return PromiseContainer
