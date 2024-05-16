-- chunkname: @scripts/managers/eac/eac_server_manager.lua

local EACError = require("scripts/managers/error/errors/eac_error")

local function _info(...)
	Log.info("EACServerManager", ...)
end

EACServerManager = class("EACServerManager")

local EAC_STATES = table.enum("none", "ready", "in_session")

EACServerManager.init = function (self)
	_info("init")

	self._state = EAC_STATES.none
	self._peers_list = {}
	self._has_eac = self:has_eac()

	if not self._has_eac then
		_info("EOS.has_eac_server() return false")

		return
	end

	self._state = EAC_STATES.ready
end

EACServerManager.has_eac = function (self)
	local has_eac = EOS.has_eac_server()

	return has_eac
end

EACServerManager.begin_session = function (self)
	local state = self._state
	local user_id
	local mode = "ClientServer"
	local server_name = Managers.connection:server_name()

	EOS.begin_session(user_id, mode, server_name)

	self._state = EAC_STATES.in_session

	_info("begin_session server_name:%s", server_name)
end

EACServerManager.end_session = function (self)
	local state = self._state

	EOS.end_session()

	self._state = EAC_STATES.ready

	_info("end_session")
end

EACServerManager.add_peer = function (self, channel_id, account_name, ip_address)
	EOS.add_peer(channel_id, account_name, ip_address)
	_info("add_peer: %s %s", channel_id, account_name)

	local peer_data = {
		channel_id = channel_id,
		account_name = account_name,
		ip_address = ip_address,
	}

	self._peers_list[channel_id] = peer_data
end

EACServerManager.remove_peer = function (self, channel_id)
	EOS.remove_peer(channel_id)
	_info("remove_peer: %s", channel_id)

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
end

EACServerManager._handle_action = function (self, data)
	local data = EOS.next_eac_action()
	local action = data.action
	local reason = data.reason
	local details = data.details
	local peer_id = data.peer

	_info("handle_action: action:%s reason:%s details:%s peer:%s", action, reason, details, peer_id)

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

			_info("peer %s has EOS_status: *EOS.EOS_ACCCAS_Invalid*. Server will kick peer", peer_id)
			self:_kick_player(peer_id, "loc_eac_error_server_auth_eac_failed")
		end
	end
end

EACServerManager._kick_player = function (self, peer_id, details)
	local kick_reason = "EAC_KICK"

	Managers.connection:kick(peer_id, kick_reason, details)
	_info("kicked peer:%s reason:%s details %s", peer_id, kick_reason, details)
end

return EACServerManager
