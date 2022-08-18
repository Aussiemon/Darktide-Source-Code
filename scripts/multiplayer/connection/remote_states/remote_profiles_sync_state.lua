local MasterItems = require("scripts/backend/master_items")
local ProfileUtils = require("scripts/utilities/profile_utils")
local PlayerManager = require("scripts/foundation/managers/player/player_manager")
local RPCS = {
	"rpc_ready_to_receive_local_profiles"
}
local RemoteProfilesSyncState = class("RemoteProfilesSyncState")
local SYNC_STATES = table.enum("requesting_profile", "ready_to_sync", "syncing", "synced")

RemoteProfilesSyncState.init = function (self, state_machine, shared_state)
	assert(type(shared_state.event_delegate) == "table", "Event delegate required")
	assert(type(shared_state.channel_id) == "number", "Numeric channel id required")
	assert(type(shared_state.timeout) == "number", "Numeric timeout required")
	assert(type(shared_state.is_dedicated_server) == "boolean", "Dedicated server state required")
	assert(type(shared_state.host_type) == "string", "host_type required.")

	self._shared_state = shared_state
	self._is_dedicated_server = shared_state.is_dedicated_server
	self._host_type = shared_state.host_type
	local player_sync_data = shared_state.player_sync_data
	player_sync_data.profile_chunks_array = {}
	self._local_player_id_array = player_sync_data.local_player_id_array
	self._is_human_controlled_array = player_sync_data.is_human_controlled_array
	self._account_id_array = player_sync_data.account_id_array
	self._character_id_array = player_sync_data.character_id_array
	self._profile_chunks_array = player_sync_data.profile_chunks_array
	self._time = 0
	self._sync_profiles = false
	self._profile_sync_states = {}
	self._profile_syncs = {}
	local network_event_delegate = shared_state.event_delegate
	local channel_id = shared_state.channel_id
	local profile_synchronizer_host = shared_state.profile_synchronizer_host

	profile_synchronizer_host:register_rpcs(channel_id)

	self._profile_synchronizer_host = profile_synchronizer_host

	network_event_delegate:register_connection_channel_events(self, channel_id, unpack(RPCS))
end

RemoteProfilesSyncState.destroy = function (self)
	local shared_state = self._shared_state

	shared_state.event_delegate:unregister_channel_events(shared_state.channel_id, unpack(RPCS))
end

RemoteProfilesSyncState.update = function (self, dt)
	local shared_state = self._shared_state
	self._time = self._time + dt

	if shared_state.timeout < self._time then
		Log.info("RemoteProfilesSyncState", "[update] Timeout waiting for rpc_sync_local_profiles %s", shared_state.peer_id)

		return "timeout", {
			game_reason = "timeout"
		}
	end

	local channel_id = shared_state.channel_id
	local state, reason = Network.channel_state(channel_id)

	if state == "disconnected" then
		Log.info("RemoteProfilesSyncState", "[update] Connection channel disconnect %s", shared_state.peer_id)

		return "disconnected", {
			engine_reason = reason
		}
	end

	if not self._sync_profiles then
		return
	end

	local peer_id = shared_state.peer_id
	local profile_synchronizer_host = self._profile_synchronizer_host
	local local_player_id_array = self._local_player_id_array
	local profiles_synced = true

	profile_synchronizer_host:start_initial_sync(channel_id, peer_id, local_player_id_array)

	for array_index = 1, #local_player_id_array do
		local profile_sync_state = self._profile_sync_states[array_index]

		if not profile_sync_state then
			local account_id = self._account_id_array[array_index]
			local character_id = self._character_id_array[array_index]
			self._profile_sync_states[array_index] = SYNC_STATES.requesting_profile
			local use_local_profile = nil

			if not use_local_profile then
				self:_request_backend_profile(array_index, account_id, character_id)
			end
		end

		local peer_id = shared_state.peer_id
		local local_player_id = local_player_id_array[array_index]

		if profile_sync_state == SYNC_STATES.ready_to_sync then
			local profile_chunks = self._profile_chunks_array[array_index]

			profile_synchronizer_host:sync_player_profile(channel_id, peer_id, local_player_id, profile_chunks)

			self._profile_sync_states[array_index] = SYNC_STATES.syncing
		end

		if profile_sync_state == SYNC_STATES.syncing then
			local player_peer_id = peer_id
			local is_player_synced = profile_synchronizer_host:is_player_synced_to_peer(peer_id, player_peer_id, local_player_id)

			if is_player_synced then
				self._profile_sync_states[array_index] = SYNC_STATES.synced
			end
		end

		if profile_sync_state ~= SYNC_STATES.synced then
			profiles_synced = false
		end
	end

	if profiles_synced then
		RPC.rpc_sync_local_profiles_reply(channel_id)
		Log.info("RemoteProfilesSyncState", "[update] LoadingTimes: Initial Peer Profiles Synced", shared_state.peer_id)

		return "profiles synced"
	end
end

RemoteProfilesSyncState._request_profile = function (self, array_index, account_id, character_id)
	local item_definitions = MasterItems.get_cached()
	local profiles = ProfileUtils.placeholder_profiles(item_definitions)
	local profile = profiles[tonumber(character_id)]

	if profile or account_id == PlayerManager.NO_ACCOUNT_ID then
		local profile_json = ProfileUtils.pack_profile(profile)
		local profile_chunks = {}

		ProfileUtils.split_for_network(profile_json, profile_chunks)

		self._profile_chunks_array[array_index] = profile_chunks
		self._profile_sync_states[array_index] = SYNC_STATES.ready_to_sync

		return true
	end

	return false
end

RemoteProfilesSyncState._request_backend_profile = function (self, array_index, account_id, character_id)
	local profile_chunks_array = self._profile_chunks_array

	Managers.backend.interfaces.characters:fetch_account_character(account_id, character_id, true, true):next(function (backend_profile_data)
		backend_profile_data = ProfileUtils.process_backend_body(backend_profile_data)
		local profile_json = ProfileUtils.pack_backend_profile_data(backend_profile_data)
		local profile_chunks = {}

		ProfileUtils.split_for_network(profile_json, profile_chunks)

		profile_chunks_array[array_index] = profile_chunks
		self._profile_sync_states[array_index] = SYNC_STATES.ready_to_sync
	end):catch(function (error)
		Log.error("RemoteProfilesSyncState", "Error when fetching profile: %s", error)
	end)
end

RemoteProfilesSyncState.rpc_ready_to_receive_local_profiles = function (self, channel_id)
	self._sync_profiles = true

	Log.info("RemoteProfilesSyncState", "[rpc_ready_to_receive_local_profiles] LoadingTimes: Started Syncing Profiles To Connecting Peer", self._shared_state.peer_id)
end

return RemoteProfilesSyncState
