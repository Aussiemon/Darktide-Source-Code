local Promise = require("scripts/foundation/utilities/promise")
local PingManager = class("PingManager")

PingManager.init = function (self)
	self._ping_operation_promises = {}
end

PingManager.ping = function (self, timeout, targets)
	local id, error = Ping.ping(timeout, unpack(targets))

	if error then
		return Promise.rejected(error)
	end

	local promise = Promise:new()
	self._ping_operation_promises[id] = promise

	return promise
end

PingManager.update = function (self, dt)
	local done_operations = Ping.update()

	if done_operations then
		for _, operation in ipairs(done_operations) do
			local promise = self._ping_operation_promises[operation.id]

			if promise then
				promise:resolve(operation.results)
			end
		end
	end
end

return PingManager
