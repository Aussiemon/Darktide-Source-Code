local ProfileUtils = require("scripts/utilities/profile_utils")
local RPCS = {
	"rpc_start_profile_sync",
	"rpc_sync_player_profile_data",
	"rpc_profile_sync_complete",
	"rpc_profile_synced_by_all",
	"rpc_profile_sync_peer_disconnected"
}
local ProfileSynchronizerClient = class("ProfileSynchronizerClient")

ProfileSynchronizerClient.init = function (self, event_delegate)
	self._event_delegate = event_delegate
	self._peer_profile_chunks = {}
	self._peer_profiles_json = {}
end

ProfileSynchronizerClient.register_rpcs = function (self, channel_id)
	self._channel_id = channel_id

	self._event_delegate:register_connection_channel_events(self, channel_id, unpack(RPCS))
end

ProfileSynchronizerClient.peer_profile_chunks_array = function (self, peer_id, local_player_id_array)
	local profile_chunks = self._peer_profile_chunks[peer_id]

	fassert(profile_chunks, "Peer with peer_id %s has either disconnected or not had their profile synced")

	local profile_chunks_array = {}

	for i = 1, #local_player_id_array do
		local local_player_id = local_player_id_array[i]
		local chunks = profile_chunks[local_player_id]

		fassert(chunks, "Profile not synced, peer_id:%s local_player_id:%s", peer_id, local_player_id)

		profile_chunks_array[i] = chunks
	end

	return profile_chunks_array
end

ProfileSynchronizerClient.player_profile_json = function (self, peer_id, local_player_id)
	local peer_profiles_json = self._peer_profiles_json
	local profile_json = peer_profiles_json[peer_id][local_player_id]

	fassert(peer_profiles_json, "Peer with peer_id %s has either disconnected or not had their profile synced")
	fassert(profile_json, "Profile not synced, peer_id:%s local_player_id:%s", peer_id, local_player_id)

	return profile_json
end

ProfileSynchronizerClient.destroy = function (self)
	local network_event_delegate = self._event_delegate
	local channel_id = self._channel_id

	if channel_id then
		network_event_delegate:unregister_channel_events(channel_id, unpack(RPCS))
	end

	self._channel_id = nil
end

ProfileSynchronizerClient.rpc_start_profile_sync = function (self, channel_id, peer_id, local_player_id)
	local peer_profile_chunks = self._peer_profile_chunks
	local peer_profiles_json = self._peer_profiles_json
	peer_profile_chunks[peer_id] = peer_profile_chunks[peer_id] or {}
	peer_profile_chunks[peer_id][local_player_id] = {}
	peer_profiles_json[peer_id] = peer_profiles_json[peer_id] or {}
	peer_profiles_json[peer_id][local_player_id] = ""
end

ProfileSynchronizerClient.rpc_sync_player_profile_data = function (self, channel_id, peer_id, local_player_id, profile_chunk)
	local peer_profile_chunks = self._peer_profile_chunks
	local profile_chunks = peer_profile_chunks[peer_id]

	if not profile_chunks then
		return
	end

	local chunks = profile_chunks[local_player_id]
	chunks[#chunks + 1] = profile_chunk
	local peer_profiles_json = self._peer_profiles_json[peer_id]
	local profile_json = peer_profiles_json[local_player_id]
	peer_profiles_json[local_player_id] = profile_json .. profile_chunk
end

ProfileSynchronizerClient.rpc_profile_sync_complete = function (self, channel_id, peer_id, local_player_id)
	RPC.rpc_player_profile_synced(channel_id, peer_id, local_player_id)
end

ProfileSynchronizerClient.rpc_profile_synced_by_all = function (self, channel_id, peer_id, local_player_id)
	local player_profiles_json = self._peer_profiles_json[peer_id]
	local player = Managers.player:player(peer_id, local_player_id)

	if not player_profiles_json then
		return
	end

	if player then
		local profile_json = player_profiles_json[local_player_id]
		local profile = ProfileUtils.unpack_profile(profile_json)

		player:set_profile(profile)
		Managers.event:trigger("event_player_profile_updated", peer_id, local_player_id, profile)
	end
end

ProfileSynchronizerClient.rpc_profile_sync_peer_disconnected = function (self, channel_id, peer_id)
	self._peer_profile_chunks[peer_id] = nil
	self._peer_profiles_json[peer_id] = nil
end

return ProfileSynchronizerClient
