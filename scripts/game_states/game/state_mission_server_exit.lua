local NameGenerator = require("scripts/multiplayer/utilities/name_generator")

local function _warning(...)
	Log.warning("[StateMissionServerExit]", ...)
end

local StateMissionServerExit = class("StateMissionServerExit")
local TIMEOUT = 30

StateMissionServerExit.on_enter = function (self, parent, params, creation_context)
	self._creation_context = creation_context

	if DEDICATED_SERVER then
		CommandWindow.print("Waiting for players to leave")

		self._timeout = 0
	end
end

StateMissionServerExit.on_exit = function (self)
	return
end

StateMissionServerExit.update = function (self, dt)
	local context = self._creation_context

	context.network_receive_function(dt)

	if self._timeout then
		self._timeout = self._timeout + dt

		if TIMEOUT < self._timeout then
			self._timeout = nil

			Managers.multiplayer_session:leave("mission_server_exit_timeout")
		end
	end

	if not DEDICATED_SERVER and GameParameters.prod_like_backend and not self._multiplayer_session then
		self._multiplayer_session = Managers.multiplayer_session:party_immaterium_hot_join_hub_server()
	end

	context.network_transmit_function()

	return Managers.mechanism:wanted_transition()
end

return StateMissionServerExit
