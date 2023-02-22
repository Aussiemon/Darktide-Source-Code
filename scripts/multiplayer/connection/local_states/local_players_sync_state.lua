local RPCS = {
	"rpc_sync_local_players_reply"
}
local LocalPlayersSyncState = class("LocalPlayersSyncState")

LocalPlayersSyncState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	self._time = 0
	self._got_reply = false

	shared_state.event_delegate:register_connection_channel_events(self, shared_state.channel_id, unpack(RPCS))

	local sync_data = Managers.player:create_sync_data(Network.peer_id(), false)
	local local_player_id_array = sync_data.local_player_id_array
	local is_human_controlled_array = sync_data.is_human_controlled_array
	local account_id_array = sync_data.account_id_array
	local character_id_array = sync_data.character_id_array
	local player_session_id_array = sync_data.player_session_id_array
	local last_mission_id = sync_data.last_mission_id

	RPC.rpc_sync_local_players(shared_state.channel_id, local_player_id_array, is_human_controlled_array, account_id_array, character_id_array, player_session_id_array, last_mission_id)
end

LocalPlayersSyncState.destroy = function (self)
	local shared_state = self._shared_state

	shared_state.event_delegate:unregister_channel_events(shared_state.channel_id, unpack(RPCS))
end

LocalPlayersSyncState.update = function (self, dt)
	local shared_state = self._shared_state
	self._time = self._time + dt

	if shared_state.timeout < self._time then
		Log.info("LocalPlayersSyncState", "Timeout waiting for rpc_sync_local_players_reply")

		return "timeout", {
			game_reason = "timeout"
		}
	end

	local state, reason = Network.channel_state(shared_state.channel_id)

	if state == "disconnected" then
		Log.info("LocalPlayersSyncState", "Connection channel disconnected")

		return "disconnected", {
			engine_reason = reason
		}
	end

	if self._got_reply then
		return "players synced"
	end
end

LocalPlayersSyncState.rpc_sync_local_players_reply = function (self, channel_id, local_player_id_array, slot_array)
	local peer_id = Network.peer_id()

	for i = 1, #local_player_id_array do
		local local_player_id = local_player_id_array[i]
		local slot = slot_array[i]
		local player = Managers.player:player(peer_id, local_player_id)

		if player then
			player:set_slot(slot)
		end
	end

	self._got_reply = true
end

return LocalPlayersSyncState
