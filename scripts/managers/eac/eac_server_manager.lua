local EACError = require("scripts/managers/error/errors/eac_error")
EACServerManager = class("EACServerManager")
local EAC_STATES = table.enum("none", "ready", "in_session")

EACServerManager.init = function (self)
	self._state = EAC_STATES.none
	self._peers_list = {}
	self._has_eac = self:has_eac()

	if not self._has_eac then
	end

	EOS.set_server(true)

	self._state = EAC_STATES.ready
end

EACServerManager.has_eac = function (self)
	local has_eac = EOS.has_eac_server()

	return has_eac
end

EACServerManager.begin_session = function (self)
	local state = self._state

	fassert(state == EAC_STATES.ready, "Trying to begin a EAC session in wrong state. [In state %s]", state)

	local user_id = nil
	local mode = "ClientServer"
	local server_name = Managers.connection:server_name()

	EOS.begin_session(user_id, mode, server_name)

	self._state = EAC_STATES.in_session
end

EACServerManager.end_session = function (self)
	local state = self._state

	fassert(state == EAC_STATES.in_session, "Trying to end a EAC session without being in a session. [In state %s]", state)
	EOS.end_session()

	self._state = EAC_STATES.ready
end

EACServerManager.add_peer = function (self, channel_id, account_name, ip_address)
	EOS.add_peer(channel_id, account_name, ip_address)

	local peer_data = {
		channel_id = channel_id,
		account_name = account_name,
		ip_address = ip_address
	}
	self._peers_list[channel_id] = peer_data
end

EACServerManager.remove_peer = function (self, channel_id)
	EOS.remove_peer(channel_id)

	self._peers_list[channel_id] = nil
end

EACServerManager.update = function (self, dt, t)
	local state = self._state

	if state ~= EAC_STATES.in_session then
		return
	end

	local num_members = Managers.connection:num_members()

	if num_members == 0 then
		return
	end

	local has_eac_action = EOS.has_eac_action()

	if has_eac_action then
		self:_handle_action()
	end

	self:_check_peer_status()
end

EACServerManager._handle_action = function (self, data)
	local data = EOS.next_eac_action()

	fassert(data, "has_eac_action but next_eac_action returns nil")

	local action = data.action
	local reason = data.reason
	local details = data.details
	local peer_id = data.peer

	if action == EOS.EOS_ACCCA_RemovePlayer then
		self:_kick_player(peer_id, reason)
	end
end

EACServerManager._check_peer_status = function (self)
	local peers = self._peers_list

	for channel_id, peer_data in pairs(peers) do
		local peer_status = EOS.peer_status(channel_id)

		if peer_status == EOS.EOS_ACCCAS_Invalid then
			local peer_id = Managers.connection:channel_to_peer(channel_id)

			self:_kick_player(peer_id, "loc_eac_error_server_auth_eac_failed")
		end
	end
end

EACServerManager._kick_player = function (self, peer_id, details)
	local kick_reason = "EAC_KICK"

	Managers.connection:kick(peer_id, kick_reason, details)
end

return EACServerManager
