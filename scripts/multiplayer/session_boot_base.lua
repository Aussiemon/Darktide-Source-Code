-- chunkname: @scripts/multiplayer/session_boot_base.lua

local function _info(...)
	Log.info("SessionBootBase", ...)
end

local SessionBootBase = class("SessionBootBase")

SessionBootBase.INTERFACE = {
	"result"
}

SessionBootBase.init = function (self, states, event_object)
	self._event_object = event_object
end

SessionBootBase.update = function (self, dt)
	local connection_client = self._connection_client

	if connection_client then
		connection_client:update(dt)

		if connection_client:has_disconnected() then
			self._event_object:failed_to_boot(true, "game", "DISCONNECTED_FROM_HOST")
			connection_client:delete()

			self._connection_client = nil

			self:_set_state("failed")
		end
	end

	local connection_host = self._connection_host

	if connection_host then
		connection_host:update(dt)
	end
end

SessionBootBase._set_state = function (self, new_state)
	_info("Changed state %s -> %s", self._state, new_state)

	self._state = new_state
end

SessionBootBase.state = function (self)
	return self._state
end

SessionBootBase.event_object = function (self)
	return self._event_object
end

SessionBootBase._set_window_title = function (self, ...)
	return
end

return SessionBootBase
