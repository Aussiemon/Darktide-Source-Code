local ApproveChannelDelegate = class("ApproveChannelDelegate")

local function _warning(...)
	Log.warning("ApproveChannelDelegate", ...)
end

ApproveChannelDelegate.init = function (self)
	self._registered_lobbies = {}
end

ApproveChannelDelegate.destroy = function (self)
	local success = true
	local error_str = ""

	if not table.is_empty(self._registered_lobbies) then
		for lobby_id, object in pairs(self._registered_lobbies) do
			error_str = error_str .. string.format("\tApprove channel callback for lobby %q not unregistered. Held by %q\n", lobby_id, object.__class_name)
		end

		success = false
	end

	fassert(success, "All callbacks have not been unregistered.\n%s", error_str)

	self._registered_lobbies = nil
end

ApproveChannelDelegate.register = function (self, lobby_id, message, object)
	fassert(object.approve_channel, "No approve_channel callback function specified in passed object")

	local key = self.make_key(lobby_id, message)
	local registered_object = self._registered_lobbies[key]

	fassert(not registered_object, "Trying to register an already registered approve channel delegate for lobby %q with message %q. Registered by %q.", lobby_id, message, registered_object and registered_object.__class_name)

	self._registered_lobbies[key] = object
end

ApproveChannelDelegate.unregister = function (self, lobby_id, message)
	local key = self.make_key(lobby_id, message)

	fassert(self._registered_lobbies[key], "Trying to unregister non-registered approve channel delegate for lobby %q and message %q", lobby_id, message)

	self._registered_lobbies[key] = nil
end

ApproveChannelDelegate.approve_channel = function (self, channel_id, peer_id, lobby_id, message)
	local key = self.make_key(lobby_id, message)
	local object = self._registered_lobbies[key]

	if object then
		return object:approve_channel(channel_id, peer_id, lobby_id, message)
	else
		_warning("No approve channel delegate registered for lobby %q and message %q - denying channel request", lobby_id, message)

		return false
	end
end

ApproveChannelDelegate.make_key = function (lobby_id, message)
	if message then
		return string.format("%s:%s", lobby_id, message)
	else
		return lobby_id
	end
end

return ApproveChannelDelegate
