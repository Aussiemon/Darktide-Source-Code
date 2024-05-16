-- chunkname: @scripts/managers/multiplayer/multiplayer_session.lua

local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local RemotePlayer = require("scripts/managers/player/remote_player")
local MasterItems = require("scripts/backend/master_items")
local ChatManagerConstants = require("scripts/foundation/managers/chat/chat_manager_constants")
local PlayerManager = require("scripts/foundation/managers/player/player_manager")
local HOST_TYPES = MatchmakingConstants.HOST_TYPES
local MultiplayerSession = class("MultiplayerSession")

MultiplayerSession.STATES = table.enum("booting", "host", "client", "dead")

MultiplayerSession.init = function (self)
	self._state = self.STATES.booting
	self._disconnect_from_host_source = nil
	self._disconnect_from_host_reason = nil
	self._joined_host_peer_id = nil
	self._joined_host_channel_id = nil
	self._host_type = nil
	self._vivox_backend_info = nil
end

MultiplayerSession.set_booted = function (self)
	self._booted = true
end

MultiplayerSession.is_booted = function (self)
	return self._booted
end

MultiplayerSession.became_host = function (self, host_type, lobby_id)
	self._state = self.STATES.host
	self._host_type = host_type

	local peer_id = Network.peer_id()

	Managers.bot:create_synchronizer_host()

	if DEDICATED_SERVER then
		local server_name = Managers.connection:server_name()

		Log.info("MultiplayerSession", "Server Name %s", server_name)

		if PLATFORM == "win32" then
			CommandWindow.print(string.format("Server Name: %s", server_name))
		end
	end

	if not DEDICATED_SERVER then
		local tag

		if host_type == HOST_TYPES.mission_server then
			tag = ChatManagerConstants.ChannelTag.MISSION
		elseif host_type == HOST_TYPES.player then
			tag = ChatManagerConstants.ChannelTag.MISSION
		elseif host_type == HOST_TYPES.hub_server then
			tag = ChatManagerConstants.ChannelTag.HUB
		end

		if tag then
			local text = true
			local voice = host_type == HOST_TYPES.mission_server
			local vivox_backend_info = self:vivox_backend_info()

			if vivox_backend_info then
				Managers.chat:join_chat_channel(vivox_backend_info.channelSip, peer_id, voice, text, tag, vivox_backend_info.token)
			else
				Log.warning("MultiplayerSession", "Missing vivox backend info")
			end
		end
	end

	local package_synchronizer_host, package_synchronizer_client = Managers.package_synchronization:create_synchronizer_host_and_client()

	package_synchronizer_host:add_peer(peer_id)
	package_synchronizer_host:ready_peer(peer_id)

	if not DEDICATED_SERVER then
		package_synchronizer_client:add_peer(peer_id)
	end

	local item_definitions = MasterItems.get_cached()

	package_synchronizer_host:init_item_definitions(item_definitions)
	package_synchronizer_client:init_item_definitions(item_definitions)

	local player_manager = Managers.player
	local local_players = player_manager:players_at_peer(peer_id)

	if local_players then
		for local_player_id, player in pairs(local_players) do
			local slot = player_manager:claim_slot()

			player:set_slot(slot)
		end
	end
end

MultiplayerSession.stopped_being_host = function (self, is_error, source, reason, optional_error_details)
	if Managers.mission_server then
		Managers.mission_server:delete()

		Managers.mission_server = nil
	elseif Managers.hub_server then
		Managers.hub_server:delete()

		Managers.hub_server = nil
	end

	self._disconnection_info = {
		is_error = is_error,
		source = source,
		reason = reason,
		error_details = optional_error_details,
	}
	self._state = self.STATES.dead

	if not DEDICATED_SERVER then
		local peer_id = Network.peer_id()

		for session_handle, channel in pairs(Managers.chat:connected_chat_channels()) do
			local channel_peer_id = Managers.chat:peer_id_from_session_handle(session_handle)

			if channel_peer_id and channel_peer_id == peer_id then
				Managers.chat:leave_channel(session_handle)

				break
			end
		end
	end

	local player_manager = Managers.player
	local local_players = player_manager:players_at_peer(Network.peer_id())

	if local_players then
		for local_player_id, player in pairs(local_players) do
			local slot = player:slot()

			player_manager:release_slot(slot)
			player:set_slot(0)
		end
	end
end

MultiplayerSession.client_joined = function (self, channel_id, peer_id, player_sync_data)
	local is_server = true
	local local_player_id_array = player_sync_data.local_player_id_array
	local is_human_controlled_array = player_sync_data.is_human_controlled_array
	local account_id_array = player_sync_data.account_id_array
	local profile_chunks_array = player_sync_data.profile_chunks_array
	local player_session_id_array = player_sync_data.player_session_id_array
	local slot_array = player_sync_data.slot_array
	local last_mission_id = player_sync_data.last_mission_id

	Managers.player:create_players_from_sync_data(RemotePlayer, channel_id, peer_id, is_server, local_player_id_array, is_human_controlled_array, account_id_array, profile_chunks_array, player_session_id_array, slot_array, last_mission_id)
	Managers.loading:add_client(channel_id)

	local package_synchronizer_host = Managers.package_synchronization:synchronizer_host()

	package_synchronizer_host:add_peer(peer_id)

	local server_manager = Managers.hub_server or Managers.mission_server

	if server_manager then
		server_manager:client_joined(channel_id, peer_id)
	end
end

MultiplayerSession.client_disconnected = function (self, channel_id, peer_id, game_reason, engine_reason, host_became_empty)
	local server_manager = Managers.hub_server or Managers.mission_server
	local loading_manager = Managers.loading

	if loading_manager and loading_manager:is_host() then
		loading_manager:remove_client(channel_id)
	end

	local removed_players_data = {}

	self:_remove_remote_players(peer_id, removed_players_data)

	if Managers.package_synchronization then
		local package_synchronizer_host = Managers.package_synchronization:synchronizer_host()

		package_synchronizer_host:remove_peer(peer_id)
	end

	if Managers.bot then
		local bot_synchronizer_host = Managers.bot:synchronizer_host()

		bot_synchronizer_host:remove_peer(channel_id)
	end

	if server_manager then
		server_manager:client_disconnected(channel_id, host_became_empty, removed_players_data)
	end

	Managers.event:trigger("multiplayer_session_client_disconnected", removed_players_data, host_became_empty)
end

MultiplayerSession.has_joined_host = function (self)
	return self._state == self.STATES.client
end

MultiplayerSession.disconnection_info = function (self)
	return self._disconnection_info
end

MultiplayerSession.vivox_backend_info = function (self)
	return self._vivox_backend_info
end

MultiplayerSession.set_vivox_backend_info = function (self, vivox_backend_info)
	self._vivox_backend_info = vivox_backend_info
end

MultiplayerSession.joined_host = function (self, channel_id, host_peer_id, host_type)
	self._state = self.STATES.client
	self._joined_host_channel_id = channel_id
	self._joined_host_peer_id = host_peer_id
	self._host_type = host_type

	Managers.bot:create_synchronizer_client(channel_id)

	local package_synchronizer_client = Managers.package_synchronization:create_synchronizer_client(false, channel_id)
	local peer_id = Network.peer_id()

	package_synchronizer_client:add_peer(peer_id)

	local item_definitions = MasterItems.get_cached()

	package_synchronizer_client:init_item_definitions(item_definitions)

	if not DEDICATED_SERVER then
		local tag

		if host_type == HOST_TYPES.mission_server then
			tag = ChatManagerConstants.ChannelTag.MISSION
		elseif host_type == HOST_TYPES.player then
			tag = ChatManagerConstants.ChannelTag.MISSION
		elseif host_type == HOST_TYPES.hub_server then
			tag = ChatManagerConstants.ChannelTag.HUB
		end

		if tag then
			local text = true
			local voice = host_type == HOST_TYPES.mission_server
			local vivox_backend_info = self:vivox_backend_info()

			if vivox_backend_info then
				Managers.chat:join_chat_channel(vivox_backend_info.channelSip, host_peer_id, voice, text, tag, vivox_backend_info.token)
			else
				Log.warning("MultiplayerSession", "Missing vivox backend info")
			end
		end
	end

	local server_name = Managers.connection:server_name()

	Log.info("MultiplayerSession", "Joined Server: %s", server_name)

	if host_type == HOST_TYPES.mission_server then
		local my_presence = Managers.presence:presence_entry_myself()
		local my_account_id = my_presence:account_id()

		for id, player in pairs(Managers.player:players()) do
			local account_id = player:account_id()

			if account_id and account_id ~= PlayerManager.NO_ACCOUNT_ID and account_id ~= my_account_id then
				Managers.data_service.social:update_recent_players(account_id)
			end
		end
	end

	Managers.event:trigger("event_multiplayer_session_joined_host")
end

MultiplayerSession.has_successfully_joined_host = function (self)
	return self._joined_host_peer_id ~= nil
end

MultiplayerSession.disconnected_from_host = function (self, is_error, source, reason, optional_error_details)
	self._disconnection_info = {
		is_error = is_error,
		source = source,
		reason = reason,
		error_details = optional_error_details,
	}

	if Managers.telemetry_events then
		for _, player in pairs(Managers.player:players_at_peer(Network.peer_id())) do
			Managers.telemetry_events:client_disconnected(player, self._disconnection_info)
		end
	end

	self._state = self.STATES.dead

	local host_peer_id = self._joined_host_peer_id

	self:_remove_remote_players(host_peer_id)

	if Managers.package_synchronization then
		local package_synchronizer_client = Managers.package_synchronization:synchronizer_client()
		local peer_id = Network.peer_id()

		if package_synchronizer_client then
			package_synchronizer_client:remove_peer(peer_id)
			package_synchronizer_client:remove_peer(host_peer_id)
		end
	end

	for session_handle, channel in pairs(Managers.chat:connected_chat_channels()) do
		local channel_peer_id = Managers.chat:peer_id_from_session_handle(session_handle)

		if channel_peer_id and channel_peer_id == host_peer_id then
			Managers.chat:leave_channel(session_handle)

			break
		end
	end

	Managers.event:trigger("event_multiplayer_session_disconnected_from_host")
end

MultiplayerSession.failed_to_boot = function (self, is_error, source, reason, optional_error_details)
	self._disconnection_info = {
		session_was_booting = true,
		is_error = is_error,
		source = source,
		reason = reason,
		error_details = optional_error_details,
	}
	self._state = self.STATES.dead

	Managers.event:trigger("event_multiplayer_session_failed_to_boot")
end

MultiplayerSession.other_client_joined = function (self, peer_id, player_sync_data)
	local channel_id
	local is_server = false
	local local_player_id_array = player_sync_data.local_player_id_array
	local is_human_controlled_array = player_sync_data.is_human_controlled_array
	local account_id_array = player_sync_data.account_id_array
	local profile_chunks_array = player_sync_data.profile_chunks_array
	local player_session_id_array = player_sync_data.player_session_id_array
	local slot_array = player_sync_data.slot_array

	Managers.player:create_players_from_sync_data(RemotePlayer, channel_id, peer_id, is_server, local_player_id_array, is_human_controlled_array, account_id_array, profile_chunks_array, player_session_id_array, slot_array)

	local package_synchronizer_client = Managers.package_synchronization:synchronizer_client()

	package_synchronizer_client:add_peer(peer_id)

	local my_presence = Managers.presence:presence_entry_myself()
	local my_account_id = my_presence:account_id()

	for _, player in pairs(Managers.player:players_at_peer(peer_id)) do
		local account_id = player:account_id()

		if account_id and account_id ~= PlayerManager.NO_ACCOUNT_ID and account_id ~= my_account_id then
			if self._host_type == HOST_TYPES.mission_server then
				Managers.data_service.social:update_recent_players(account_id)
			end

			if Managers.chat then
				Managers.chat:player_mute_status_changed(account_id)
			end

			break
		end
	end
end

MultiplayerSession.other_client_left = function (self, peer_id)
	self:_remove_remote_players(peer_id)

	if Managers.package_synchronization then
		local package_synchronizer_client = Managers.package_synchronization:synchronizer_client()

		package_synchronizer_client:remove_peer(peer_id)
	end
end

MultiplayerSession._remove_remote_players = function (self, peer_id, optional_out_player_data)
	local player_manager = Managers.player
	local players_at_peer = player_manager:players_at_peer(peer_id)

	if players_at_peer then
		for local_player_id, player in pairs(players_at_peer) do
			if optional_out_player_data then
				local account_id = player:account_id()
				local character_id = player:character_id()
				local is_human = player:is_human_controlled()
				local stat_id = player.stat_id

				optional_out_player_data[#optional_out_player_data + 1] = {
					account_id = account_id,
					character_id = character_id,
					is_human = is_human,
					stat_id = stat_id,
				}
			end

			player_manager:remove_player(peer_id, local_player_id)
		end
	end
end

MultiplayerSession.is_dead = function (self)
	return self._state == self.STATES.dead
end

MultiplayerSession.is_host = function (self)
	return self._state == self.STATES.host
end

MultiplayerSession.host_type = function (self)
	return self._host_type
end

return MultiplayerSession
