-- Decompilation Error: _glue_flows(node)

-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local BoonsManager = require("scripts/managers/boons/boons_manager")
local RemotePlayer = require("scripts/managers/player/remote_player")
local MasterItems = require("scripts/backend/master_items")
local ChatManagerConstants = require("scripts/foundation/managers/chat/chat_manager_constants")
local PlayerManager = require("scripts/foundation/managers/player/player_manager")
local XboxLiveUtilities = require("scripts/foundation/utilities/xbox_live")
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
	self._updated_recent_players = {}
end

MultiplayerSession.became_host = function (self, host_type, lobby_id)
	self._state = self.STATES.host
	self._host_type = host_type

	if host_type ~= HOST_TYPES.hub_server then
		local is_host = true
		Managers.boons = BoonsManager:new(is_host)
	end

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
		local tag = nil

		if host_type == HOST_TYPES.mission_server then
			tag = ChatManagerConstants.ChannelTag.MISSION
		elseif host_type == HOST_TYPES.player then
			tag = ChatManagerConstants.ChannelTag.MISSION
		elseif host_type == HOST_TYPES.hub_server then
			tag = ChatManagerConstants.ChannelTag.HUB
		end

		if tag then
			local voice = host_type == HOST_TYPES.mission_server

			Managers.chat:join_chat_channel(peer_id, voice, tag)
		end
	end

	local package_synchronizer_host, package_synchronizer_client = Managers.package_synchronization:create_synchronizer_host_and_client()

	package_synchronizer_host:add_peer(peer_id)
	package_synchronizer_host:ready_peer(peer_id)

	if not DEDICATED_SERVER then
		package_synchronizer_client:add_peer(peer_id)
	end

	MasterItems.refresh():next(function (item_definitions)
		package_synchronizer_host:init_item_definitions(item_definitions)
		package_synchronizer_client:init_item_definitions(item_definitions)
	end)

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
	local host_type = self._host_type

	if host_type == HOST_TYPES.mission_server then
		if Managers.mission_server then
			Managers.mission_server:delete()

			Managers.mission_server = nil
		end
	elseif host_type == HOST_TYPES.hub_server and Managers.hub_server then
		Managers.hub_server:delete()

		Managers.hub_server = nil
	end

	if Managers.boons then
		Managers.boons:delete()

		Managers.boons = nil
	end

	self._disconnection_info = {
		is_error = is_error,
		source = source,
		reason = reason,
		error_details = optional_error_details
	}
	self._state = self.STATES.dead

	if not DEDICATED_SERVER then
		local peer_id = Network.peer_id()

		for session_handle, channel in pairs(Managers.chat:connected_chat_channels()) do
			local channel_peer_id = Managers.chat:peer_id_from_session_handle(session_handle)

			if channel_peer_id == peer_id then
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

	Managers.player:create_players_from_sync_data(RemotePlayer, channel_id, peer_id, is_server, local_player_id_array, is_human_controlled_array, account_id_array, profile_chunks_array, player_session_id_array, slot_array)
	Managers.loading:add_client(channel_id)

	local package_synchronizer_host = Managers.package_synchronization:synchronizer_host()

	package_synchronizer_host:add_peer(peer_id)

	local bot_synchronizer_host = Managers.bot:synchronizer_host()

	bot_synchronizer_host:add_peer(channel_id)

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

	Managers.event:trigger("multiplayer_session_client_disconnected")
end

MultiplayerSession.has_joined_host = function (self)
	return self._state == self.STATES.client
end

MultiplayerSession.disconnection_info = function (self)
	return self._disconnection_info
end

local function _update_recent_player(account_id)
	local _, promise = Managers.presence:get_presence(account_id)

	promise:next(function (presence)
		if presence and presence:platform() == "xbox" then
			local xuid = presence:platform_user_id()

			if xuid then
				Log.info("MultiplayerSession", "[XboxLive] Updating recent player (account_id: %s, xuid: %s)", account_id, xuid)
				XboxLiveUtilities.update_recent_player_teammate(xuid)
			end
		end
	end):catch(function (err)
		Log.info("MultiplayerSession", "[XboxLive] Couldn't update recent player, presence error: %s", table.tostring(err))
	end)
end

MultiplayerSession._update_recent_players = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-10, warpins: 1 ---
	local my_presence = Managers.presence:presence_entry_myself()

	if my_presence:platform() ~= "xbox" then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 11-11, warpins: 1 ---
		return
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 12-22, warpins: 2 ---
	local my_account_id = my_presence:account_id()

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 23-45, warpins: 0 ---
	for id, player in pairs(Managers.player:players()) do

		-- Decompilation error in this vicinity:
		--- BLOCK #0 23-27, warpins: 1 ---
		local account_id = player:account_id()

		if account_id and account_id ~= PlayerManager.NO_ACCOUNT_ID and account_id ~= my_account_id and not self._updated_recent_players[account_id] then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 38-43, warpins: 1 ---
			_update_recent_player(account_id)

			self._updated_recent_players[account_id] = true
			--- END OF BLOCK #0 ---



		end
		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 44-45, warpins: 6 ---
		--- END OF BLOCK #1 ---



	end

	--- END OF BLOCK #2 ---

	FLOW; TARGET BLOCK #3



	-- Decompilation error in this vicinity:
	--- BLOCK #3 46-46, warpins: 1 ---
	return
	--- END OF BLOCK #3 ---



end

MultiplayerSession.joined_host = function (self, channel_id, host_peer_id, host_type)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-36, warpins: 1 ---
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

		-- Decompilation error in this vicinity:
		--- BLOCK #0 37-41, warpins: 1 ---
		local tag = nil

		if host_type == HOST_TYPES.mission_server then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 42-45, warpins: 1 ---
			tag = ChatManagerConstants.ChannelTag.MISSION
			--- END OF BLOCK #0 ---



		else

			-- Decompilation error in this vicinity:
			--- BLOCK #0 46-49, warpins: 1 ---
			if host_type == HOST_TYPES.player then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 50-53, warpins: 1 ---
				tag = ChatManagerConstants.ChannelTag.MISSION
				--- END OF BLOCK #0 ---



			else

				-- Decompilation error in this vicinity:
				--- BLOCK #0 54-57, warpins: 1 ---
				if host_type == HOST_TYPES.hub_server then

					-- Decompilation error in this vicinity:
					--- BLOCK #0 58-60, warpins: 1 ---
					tag = ChatManagerConstants.ChannelTag.HUB
					--- END OF BLOCK #0 ---



				end
				--- END OF BLOCK #0 ---



			end
			--- END OF BLOCK #0 ---



		end

		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 61-62, warpins: 4 ---
		if tag then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 63-66, warpins: 1 ---
			local voice = host_type == HOST_TYPES.mission_server

			--- END OF BLOCK #0 ---

			FLOW; TARGET BLOCK #1



			-- Decompilation error in this vicinity:
			--- BLOCK #1 70-77, warpins: 2 ---
			Managers.chat:join_chat_channel(host_peer_id, voice, tag)
			--- END OF BLOCK #1 ---



		end
		--- END OF BLOCK #1 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 78-98, warpins: 3 ---
	Managers.boons = BoonsManager:new()
	local server_name = Managers.connection:server_name()

	Log.info("MultiplayerSession", "Joined Server: %s", server_name)

	if host_type == HOST_TYPES.mission_server then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 99-111, warpins: 1 ---
		Managers.presence:set_num_mission_members(Managers.connection:num_members())
		self:_update_recent_players()
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 112-112, warpins: 2 ---
	return
	--- END OF BLOCK #2 ---



end

MultiplayerSession.has_successfully_joined_host = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	return self._joined_host_peer_id ~= nil
	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 7-7, warpins: 2 ---
	--- END OF BLOCK #1 ---



end

MultiplayerSession.disconnected_from_host = function (self, is_error, source, reason, optional_error_details)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-10, warpins: 1 ---
	self._disconnection_info = {
		is_error = is_error,
		source = source,
		reason = reason,
		error_details = optional_error_details
	}

	if Managers.telemetry_events then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 11-21, warpins: 1 ---
		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 22-30, warpins: 0 ---
		for _, player in pairs(Managers.player:players_at_peer(Network.peer_id())) do

			-- Decompilation error in this vicinity:
			--- BLOCK #0 22-28, warpins: 1 ---
			Managers.telemetry_events:client_disconnected(player, self._disconnection_info)
			--- END OF BLOCK #0 ---

			FLOW; TARGET BLOCK #1



			-- Decompilation error in this vicinity:
			--- BLOCK #1 29-30, warpins: 2 ---
			--- END OF BLOCK #1 ---



		end
		--- END OF BLOCK #1 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 31-43, warpins: 2 ---
	self._state = self.STATES.dead
	local host_peer_id = self._joined_host_peer_id

	self:_remove_remote_players(host_peer_id)

	if self._host_type == HOST_TYPES.mission_server and reason == "leave_mission" then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 46-56, warpins: 1 ---
		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 57-72, warpins: 0 ---
		for _, player in pairs(Managers.player:players_at_peer(Network.peer_id())) do

			-- Decompilation error in this vicinity:
			--- BLOCK #0 57-61, warpins: 1 ---
			local account_id = player:account_id()

			if account_id and account_id ~= PlayerManager.NO_ACCOUNT_ID then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 66-70, warpins: 1 ---
				RPC.rpc_ignore_disconnected_slot_reservation(self._joined_host_channel_id, account_id)
				--- END OF BLOCK #0 ---



			end
			--- END OF BLOCK #0 ---

			FLOW; TARGET BLOCK #1



			-- Decompilation error in this vicinity:
			--- BLOCK #1 71-72, warpins: 4 ---
			--- END OF BLOCK #1 ---



		end
		--- END OF BLOCK #1 ---



	end

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 73-76, warpins: 3 ---
	if Managers.package_synchronization then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 77-86, warpins: 1 ---
		local package_synchronizer_client = Managers.package_synchronization:synchronizer_client()
		local peer_id = Network.peer_id()

		if package_synchronizer_client then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 87-94, warpins: 1 ---
			package_synchronizer_client:remove_peer(peer_id)
			package_synchronizer_client:remove_peer(host_peer_id)
			--- END OF BLOCK #0 ---



		end
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #2 ---

	FLOW; TARGET BLOCK #3



	-- Decompilation error in this vicinity:
	--- BLOCK #3 95-102, warpins: 3 ---
	--- END OF BLOCK #3 ---

	FLOW; TARGET BLOCK #4



	-- Decompilation error in this vicinity:
	--- BLOCK #4 103-119, warpins: 0 ---
	for session_handle, channel in pairs(Managers.chat:connected_chat_channels()) do

		-- Decompilation error in this vicinity:
		--- BLOCK #0 103-110, warpins: 1 ---
		local channel_peer_id = Managers.chat:peer_id_from_session_handle(session_handle)

		if channel_peer_id == host_peer_id then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 111-117, warpins: 1 ---
			Managers.chat:leave_channel(session_handle)

			--- END OF BLOCK #0 ---

			FLOW; TARGET BLOCK #1



			-- Decompilation error in this vicinity:
			--- BLOCK #1 118-118, warpins: 1 ---
			break
			--- END OF BLOCK #1 ---



		end
		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 118-119, warpins: 2 ---
		--- END OF BLOCK #1 ---



	end

	--- END OF BLOCK #4 ---

	FLOW; TARGET BLOCK #5



	-- Decompilation error in this vicinity:
	--- BLOCK #5 120-124, warpins: 2 ---
	if self._host_type == HOST_TYPES.mission_server and Managers.presence then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 129-134, warpins: 1 ---
		Managers.presence:set_num_mission_members(nil)
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #5 ---

	FLOW; TARGET BLOCK #6



	-- Decompilation error in this vicinity:
	--- BLOCK #6 135-138, warpins: 3 ---
	if Managers.boons then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 139-146, warpins: 1 ---
		Managers.boons:delete()

		Managers.boons = nil
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #6 ---

	FLOW; TARGET BLOCK #7



	-- Decompilation error in this vicinity:
	--- BLOCK #7 147-147, warpins: 2 ---
	return
	--- END OF BLOCK #7 ---



end

MultiplayerSession.failed_to_boot = function (self, is_error, source, reason, optional_error_details)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-10, warpins: 1 ---
	self._disconnection_info = {
		session_was_booting = true,
		is_error = is_error,
		source = source,
		reason = reason,
		error_details = optional_error_details
	}
	self._state = self.STATES.dead

	return
	--- END OF BLOCK #0 ---



end

MultiplayerSession.other_client_joined = function (self, peer_id, player_sync_data)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-37, warpins: 1 ---
	local channel_id = nil
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

	if self._host_type == HOST_TYPES.mission_server then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 38-50, warpins: 1 ---
		Managers.presence:set_num_mission_members(Managers.connection:num_members())
		self:_update_recent_players()
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 51-51, warpins: 2 ---
	return
	--- END OF BLOCK #1 ---



end

MultiplayerSession.other_client_left = function (self, peer_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-8, warpins: 1 ---
	self:_remove_remote_players(peer_id)

	if Managers.package_synchronization then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 9-17, warpins: 1 ---
		local package_synchronizer_client = Managers.package_synchronization:synchronizer_client()

		package_synchronizer_client:remove_peer(peer_id)
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 18-22, warpins: 2 ---
	if self._host_type == HOST_TYPES.mission_server and not self:is_dead() and Managers.presence then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 32-41, warpins: 1 ---
		Managers.presence:set_num_mission_members(Managers.connection:num_members())
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 42-42, warpins: 4 ---
	return
	--- END OF BLOCK #2 ---



end

MultiplayerSession._remove_remote_players = function (self, peer_id, optional_out_player_data)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-8, warpins: 1 ---
	local player_manager = Managers.player
	local players_at_peer = player_manager:players_at_peer(peer_id)

	if players_at_peer then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 9-12, warpins: 1 ---
		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 13-37, warpins: 0 ---
		for local_player_id, player in pairs(players_at_peer) do

			-- Decompilation error in this vicinity:
			--- BLOCK #0 13-14, warpins: 1 ---
			if optional_out_player_data then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 15-30, warpins: 1 ---
				local account_id = player:account_id()
				local character_id = player:character_id()
				local is_human = player:is_human_controlled()
				optional_out_player_data[#optional_out_player_data + 1] = {
					account_id = account_id,
					character_id = character_id,
					is_human = is_human
				}
				--- END OF BLOCK #0 ---



			end

			--- END OF BLOCK #0 ---

			FLOW; TARGET BLOCK #1



			-- Decompilation error in this vicinity:
			--- BLOCK #1 31-35, warpins: 2 ---
			player_manager:remove_player(peer_id, local_player_id)
			--- END OF BLOCK #1 ---

			FLOW; TARGET BLOCK #2



			-- Decompilation error in this vicinity:
			--- BLOCK #2 36-37, warpins: 2 ---
			--- END OF BLOCK #2 ---



		end
		--- END OF BLOCK #1 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 38-38, warpins: 2 ---
	return
	--- END OF BLOCK #1 ---



end

MultiplayerSession.is_dead = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-5, warpins: 1 ---
	return self._state == self.STATES.dead
	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 9-9, warpins: 2 ---
	--- END OF BLOCK #1 ---



end

MultiplayerSession.is_host = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-5, warpins: 1 ---
	return self._state == self.STATES.host
	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 9-9, warpins: 2 ---
	--- END OF BLOCK #1 ---



end

MultiplayerSession.server_needs_reboot = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-4, warpins: 1 ---
	local server_manager = Managers.hub_server or Managers.mission_server

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 7-8, warpins: 2 ---
	if server_manager then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 9-11, warpins: 1 ---
		return server_manager:needs_reboot()
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 12-12, warpins: 2 ---
	return
	--- END OF BLOCK #2 ---



end

MultiplayerSession.host_type = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-2, warpins: 1 ---
	return self._host_type
	--- END OF BLOCK #0 ---



end

return MultiplayerSession
