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
local MasterItems = require("scripts/backend/master_items")
local RPCQueue = require("scripts/utilities/rpc_queue")
local ProfileUtils = require("scripts/utilities/profile_utils")
local RPCS = {
	"rpc_player_profile_synced",
	"rpc_notify_profile_changed"
}
local ProfileSynchronizerHost = class("ProfileSynchronizerHost")
local SYNC_STATES = table.enum("not_synced", "syncing", "syncing_need_resync", "synced")

ProfileSynchronizerHost.init = function (self, event_delegate)
	self._peer_id = Network.peer_id()
	self._rpc_queues = {}
	self._event_delegate = event_delegate
	self._connected_peers = {}
	self._registred_channel_ids = {}
	self._profile_sync_states = {}
	self._profile_updates = {}
	self._initial_syncs = {}
end

ProfileSynchronizerHost.register_rpcs = function (self, channel_id)
	self._event_delegate:register_connection_channel_events(self, channel_id, unpack(RPCS))

	self._registred_channel_ids[channel_id] = true
	local rpc_queue_settings = {
		max_rpcs = 1000,
		time_between_sends = 0,
		num_rpcs_per_send = 10
	}
	self._rpc_queues[channel_id] = RPCQueue:new(channel_id, rpc_queue_settings)
end

ProfileSynchronizerHost.sync_player_profile = function (self, channel_id, peer_id, local_player_id, profile_chunks)
	local rpc_queue = self._rpc_queues[channel_id]
	local new_sync_state = self:_update_sync_states(channel_id, peer_id, local_player_id)

	if new_sync_state == SYNC_STATES.syncing_need_resync then
		return
	end

	rpc_queue:queue_rpc("rpc_start_profile_sync", peer_id, local_player_id)

	for j = 1, #profile_chunks, 1 do
		local profile_chunk = profile_chunks[j]

		rpc_queue:queue_rpc("rpc_sync_player_profile_data", peer_id, local_player_id, profile_chunk)
	end

	rpc_queue:queue_rpc("rpc_profile_sync_complete", peer_id, local_player_id)
end

ProfileSynchronizerHost._update_sync_states = function (self, channel_id, sync_peer_id, sync_local_player_id)
	local peer_id = Network.peer_id(channel_id)
	local profile_sync_states = self._profile_sync_states

	if not profile_sync_states[peer_id] then
		profile_sync_states[peer_id] = {}
	end

	if not profile_sync_states[peer_id][sync_peer_id] then
		profile_sync_states[peer_id][sync_peer_id] = {}
	end

	local new_sync_state = SYNC_STATES.syncing
	local player_sync_state = profile_sync_states[peer_id][sync_peer_id][sync_local_player_id]

	if player_sync_state == SYNC_STATES.syncing or player_sync_state == SYNC_STATES.syncing_need_resync then
		new_sync_state = SYNC_STATES.syncing_need_resync
	end

	profile_sync_states[peer_id][sync_peer_id][sync_local_player_id] = new_sync_state

	return new_sync_state
end

ProfileSynchronizerHost.start_initial_sync = function (self, channel_id, peer_id, local_player_ids)
	local initial_syncs = self._initial_syncs[channel_id] or {}
	initial_syncs[peer_id] = {}

	for i = 1, #local_player_ids, 1 do
		local local_player_id = local_player_ids[i]
		initial_syncs[peer_id][local_player_id] = false
	end

	self._initial_syncs[channel_id] = initial_syncs
end

local completed_initial_syncs = {}

ProfileSynchronizerHost.completed_initial_syncs = function (self)
	table.clear(completed_initial_syncs)

	local initial_syncs = self._initial_syncs

	for channel_id, initial_peer_syncs in pairs(initial_syncs) do
		for peer_id, initial_player_syncs in pairs(initial_peer_syncs) do
			local initial_sync_complete = true

			for local_player_id, synced in pairs(initial_player_syncs) do
				if not synced then
					initial_sync_complete = false
				end
			end

			if initial_sync_complete then
				completed_initial_syncs[channel_id] = completed_initial_syncs[channel_id] or {}
				completed_initial_syncs[channel_id][peer_id] = true
				initial_peer_syncs[peer_id] = nil

				if not next(initial_peer_syncs) then
					initial_syncs[channel_id] = nil
				end
			end
		end
	end

	return completed_initial_syncs
end

ProfileSynchronizerHost.add_bot = function (self, local_player_id, profile)
	local connected_peer_channel_ids = self._connected_peers
	local profile_json = ProfileUtils.pack_profile(profile)
	local profile_chunks = {}

	ProfileUtils.split_for_network(profile_json, profile_chunks)

	for _, connected_peer_channel_id in pairs(connected_peer_channel_ids) do
		self:sync_player_profile(connected_peer_channel_id, self._peer_id, local_player_id, profile_chunks)
	end
end

ProfileSynchronizerHost.profile_changed = function (self, peer_id, local_player_id)
	local player = Managers.player:player(peer_id, local_player_id)
	local account_id = player:account_id()
	local character_id = player:character_id()
	local connected_peer_channel_ids = self._connected_peers

	Managers.backend.interfaces.characters:fetch_account_character(account_id, character_id, true, true):next(function (backend_profile_data)
		backend_profile_data = ProfileUtils.process_backend_body(backend_profile_data)
		local new_profile = ProfileUtils.backend_profile_data_to_profile(backend_profile_data)
		local profile_json = ProfileUtils.pack_backend_profile_data(backend_profile_data)
		local profile_chunks = {}

		ProfileUtils.split_for_network(profile_json, profile_chunks)

		for _, connected_peer_channel_id in pairs(connected_peer_channel_ids) do
			self:sync_player_profile(connected_peer_channel_id, peer_id, local_player_id, profile_chunks)
		end

		local profile_updates = self._profile_updates[peer_id] or {}
		profile_updates[local_player_id] = new_profile
		self._profile_updates[peer_id] = profile_updates
	end):catch(function (error)
		Log.error("ProfileSynchronizerHost", "Error when fetching profile: %s", error)
	end)
end

ProfileSynchronizerHost.override_slot = function (self, peer_id, local_player_id, slot_name, item_name)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-29, warpins: 1 ---
	local player = Managers.player:player(peer_id, local_player_id)
	local new_profile = table.clone_instance(player:profile())
	local loadout_item_ids = new_profile.loadout_item_ids
	loadout_item_ids[slot_name] = item_name .. slot_name
	local loadout_item_data = new_profile.loadout_item_data
	loadout_item_data[slot_name] = {
		id = item_name
	}

	self:_profile_changed_override(peer_id, local_player_id, new_profile)

	return
	--- END OF BLOCK #0 ---



end

ProfileSynchronizerHost._profile_changed_override = function (self, peer_id, local_player_id, new_profile)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-14, warpins: 1 ---
	local profile_json = ProfileUtils.pack_profile(new_profile)
	local profile_chunks = {}

	ProfileUtils.split_for_network(profile_json, profile_chunks)

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 15-23, warpins: 0 ---
	for _, connected_peer_channel_id in pairs(self._connected_peers) do

		-- Decompilation error in this vicinity:
		--- BLOCK #0 15-21, warpins: 1 ---
		self:sync_player_profile(connected_peer_channel_id, peer_id, local_player_id, profile_chunks)
		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 22-23, warpins: 2 ---
		--- END OF BLOCK #1 ---



	end

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 24-32, warpins: 1 ---
	new_profile = ProfileUtils.unpack_profile(profile_json)
	local profile_updates = self._profile_updates[peer_id] or {}
	--- END OF BLOCK #2 ---

	FLOW; TARGET BLOCK #3



	-- Decompilation error in this vicinity:
	--- BLOCK #3 34-37, warpins: 2 ---
	profile_updates[local_player_id] = new_profile
	self._profile_updates[peer_id] = profile_updates

	return
	--- END OF BLOCK #3 ---



end

ProfileSynchronizerHost.profiles_synced = function (self, peer_ids)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-4, warpins: 1 ---
	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 5-14, warpins: 0 ---
	for i = 1, #peer_ids, 1 do

		-- Decompilation error in this vicinity:
		--- BLOCK #0 5-11, warpins: 2 ---
		local peer_id = peer_ids[i]
		local peer_synced = self:peer_profiles_synced(peer_id)

		if not peer_synced then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 12-13, warpins: 1 ---
			return false
			--- END OF BLOCK #0 ---



		end
		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 14-14, warpins: 2 ---
		--- END OF BLOCK #1 ---



	end

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 15-16, warpins: 1 ---
	return true
	--- END OF BLOCK #2 ---



end

ProfileSynchronizerHost.peer_profiles_synced = function (self, peer_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-5, warpins: 1 ---
	local profile_sync_states = self._profile_sync_states

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 6-32, warpins: 0 ---
	for other_peer_id, peer_states in pairs(profile_sync_states) do

		-- Decompilation error in this vicinity:
		--- BLOCK #0 6-6, warpins: 2 ---
		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 6-30, warpins: 0 ---
		repeat

			-- Decompilation error in this vicinity:
			--- BLOCK #0 6-6, warpins: 2 ---
			--- END OF BLOCK #0 ---

			FLOW; TARGET BLOCK #1



			-- Decompilation error in this vicinity:
			--- BLOCK #1 7-9, warpins: 1 ---
			local player_states = peer_states[peer_id]

			if not player_states then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 10-12, warpins: 1 ---
				if peer_id == self._peer_id then

					-- Decompilation error in this vicinity:
					--- BLOCK #0 13-13, warpins: 1 ---
					break
					--- END OF BLOCK #0 ---

					FLOW; TARGET BLOCK #1



					-- Decompilation error in this vicinity:
					--- BLOCK #1 14-14, warpins: 0 ---
					--- END OF BLOCK #1 ---



				else

					-- Decompilation error in this vicinity:
					--- BLOCK #0 15-16, warpins: 1 ---
					return false
					--- END OF BLOCK #0 ---



				end
				--- END OF BLOCK #0 ---



			end

			--- END OF BLOCK #1 ---

			FLOW; TARGET BLOCK #2



			-- Decompilation error in this vicinity:
			--- BLOCK #2 17-20, warpins: 3 ---
			--- END OF BLOCK #2 ---

			FLOW; TARGET BLOCK #3



			-- Decompilation error in this vicinity:
			--- BLOCK #3 21-28, warpins: 0 ---
			for _, sync_state in pairs(player_states) do

				-- Decompilation error in this vicinity:
				--- BLOCK #0 21-24, warpins: 1 ---
				if sync_state ~= SYNC_STATES.synced then

					-- Decompilation error in this vicinity:
					--- BLOCK #0 25-26, warpins: 1 ---
					return false
					--- END OF BLOCK #0 ---



				end
				--- END OF BLOCK #0 ---

				FLOW; TARGET BLOCK #1



				-- Decompilation error in this vicinity:
				--- BLOCK #1 27-28, warpins: 3 ---
				--- END OF BLOCK #1 ---



			end
			--- END OF BLOCK #3 ---

			FLOW; TARGET BLOCK #4



			-- Decompilation error in this vicinity:
			--- BLOCK #4 29-30, warpins: 1 ---
			--- END OF BLOCK #4 ---



		until true
		--- END OF BLOCK #1 ---

		FLOW; TARGET BLOCK #2



		-- Decompilation error in this vicinity:
		--- BLOCK #2 31-32, warpins: 3 ---
		--- END OF BLOCK #2 ---



	end

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 33-34, warpins: 1 ---
	return true
	--- END OF BLOCK #2 ---



end

ProfileSynchronizerHost.is_player_synced_to_peer = function (self, peer_id, player_peer_id, local_player_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-8, warpins: 1 ---
	local profile_sync_states = self._profile_sync_states
	local peer_states = profile_sync_states[peer_id]
	local player_states = peer_states[player_peer_id]
	local sync_state = player_states[local_player_id]

	return sync_state == SYNC_STATES.synced
	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 12-12, warpins: 2 ---
	--- END OF BLOCK #1 ---



end

ProfileSynchronizerHost.peer_connected = function (self, peer_id, channel_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	self._connected_peers[peer_id] = channel_id

	return
	--- END OF BLOCK #0 ---



end

ProfileSynchronizerHost.peer_disconnected = function (self, peer_id, channel_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-7, warpins: 1 ---
	local profile_sync_states = self._profile_sync_states
	profile_sync_states[peer_id] = nil

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 8-19, warpins: 0 ---
	for _, peer_states in pairs(profile_sync_states) do

		-- Decompilation error in this vicinity:
		--- BLOCK #0 8-11, warpins: 1 ---
		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 12-17, warpins: 0 ---
		for sync_peer_id, _ in pairs(peer_states) do

			-- Decompilation error in this vicinity:
			--- BLOCK #0 12-13, warpins: 1 ---
			if sync_peer_id == peer_id then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 14-15, warpins: 1 ---
				peer_states[sync_peer_id] = nil
				--- END OF BLOCK #0 ---



			end
			--- END OF BLOCK #0 ---

			FLOW; TARGET BLOCK #1



			-- Decompilation error in this vicinity:
			--- BLOCK #1 16-17, warpins: 3 ---
			--- END OF BLOCK #1 ---



		end
		--- END OF BLOCK #1 ---

		FLOW; TARGET BLOCK #2



		-- Decompilation error in this vicinity:
		--- BLOCK #2 18-19, warpins: 2 ---
		--- END OF BLOCK #2 ---



	end

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 20-23, warpins: 1 ---
	--- END OF BLOCK #2 ---

	FLOW; TARGET BLOCK #3



	-- Decompilation error in this vicinity:
	--- BLOCK #3 24-30, warpins: 0 ---
	for _, other_channel_id in pairs(self._connected_peers) do

		-- Decompilation error in this vicinity:
		--- BLOCK #0 24-28, warpins: 1 ---
		RPC.rpc_profile_sync_peer_disconnected(other_channel_id, peer_id)
		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 29-30, warpins: 2 ---
		--- END OF BLOCK #1 ---



	end

	--- END OF BLOCK #3 ---

	FLOW; TARGET BLOCK #4



	-- Decompilation error in this vicinity:
	--- BLOCK #4 31-34, warpins: 1 ---
	local registered_channel_ids = self._registred_channel_ids

	if registered_channel_ids[channel_id] then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 35-50, warpins: 1 ---
		self._event_delegate:unregister_channel_events(channel_id, unpack(RPCS))
		self._rpc_queues[channel_id]:delete()

		self._rpc_queues[channel_id] = nil
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #4 ---

	FLOW; TARGET BLOCK #5



	-- Decompilation error in this vicinity:
	--- BLOCK #5 51-55, warpins: 2 ---
	local initial_syncs = self._initial_syncs

	--- END OF BLOCK #5 ---

	FLOW; TARGET BLOCK #6



	-- Decompilation error in this vicinity:
	--- BLOCK #6 56-66, warpins: 0 ---
	for sync_channel_id, initial_peer_syncs in pairs(initial_syncs) do

		-- Decompilation error in this vicinity:
		--- BLOCK #0 56-62, warpins: 1 ---
		initial_peer_syncs[peer_id] = nil

		if not next(initial_peer_syncs) then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 63-64, warpins: 1 ---
			initial_syncs[sync_channel_id] = nil
			--- END OF BLOCK #0 ---



		end
		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 65-66, warpins: 3 ---
		--- END OF BLOCK #1 ---



	end

	--- END OF BLOCK #6 ---

	FLOW; TARGET BLOCK #7



	-- Decompilation error in this vicinity:
	--- BLOCK #7 67-79, warpins: 1 ---
	self._registred_channel_ids[channel_id] = nil
	self._initial_syncs[channel_id] = nil
	self._connected_peers[peer_id] = nil
	self._profile_updates[peer_id] = nil

	return
	--- END OF BLOCK #7 ---



end

ProfileSynchronizerHost.update = function (self, dt)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-5, warpins: 1 ---
	local rpc_queues = self._rpc_queues

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 6-11, warpins: 0 ---
	for _, queue in pairs(rpc_queues) do

		-- Decompilation error in this vicinity:
		--- BLOCK #0 6-9, warpins: 1 ---
		queue:update(dt)
		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 10-11, warpins: 2 ---
		--- END OF BLOCK #1 ---



	end

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 12-17, warpins: 1 ---
	local connected_peer_channel_ids = self._connected_peers
	local profile_updates = self._profile_updates

	--- END OF BLOCK #2 ---

	FLOW; TARGET BLOCK #3



	-- Decompilation error in this vicinity:
	--- BLOCK #3 18-85, warpins: 0 ---
	for synced_peer_id, local_player_ids in pairs(profile_updates) do

		-- Decompilation error in this vicinity:
		--- BLOCK #0 18-23, warpins: 1 ---
		local peer_synced = self:peer_profiles_synced(synced_peer_id)

		if peer_synced then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 24-27, warpins: 1 ---
			--- END OF BLOCK #0 ---

			FLOW; TARGET BLOCK #1



			-- Decompilation error in this vicinity:
			--- BLOCK #1 28-75, warpins: 0 ---
			for synced_local_player_id, new_profile in pairs(local_player_ids) do

				-- Decompilation error in this vicinity:
				--- BLOCK #0 28-45, warpins: 1 ---
				local player = Managers.player:player(synced_peer_id, synced_local_player_id)
				local old_profile = player:profile()

				player:set_profile(new_profile)

				--- END OF BLOCK #0 ---

				FLOW; TARGET BLOCK #1



				-- Decompilation error in this vicinity:
				--- BLOCK #1 46-53, warpins: 0 ---
				for _, connected_peer_channel_id in pairs(connected_peer_channel_ids) do

					-- Decompilation error in this vicinity:
					--- BLOCK #0 46-51, warpins: 1 ---
					RPC.rpc_profile_synced_by_all(connected_peer_channel_id, synced_peer_id, synced_local_player_id)
					--- END OF BLOCK #0 ---

					FLOW; TARGET BLOCK #1



					-- Decompilation error in this vicinity:
					--- BLOCK #1 52-53, warpins: 2 ---
					--- END OF BLOCK #1 ---



				end

				--- END OF BLOCK #1 ---

				FLOW; TARGET BLOCK #2



				-- Decompilation error in this vicinity:
				--- BLOCK #2 54-73, warpins: 1 ---
				Managers.event:trigger("updated_player_profile_synced", synced_peer_id, synced_local_player_id, old_profile)
				Managers.event:trigger("event_player_profile_updated", synced_peer_id, synced_local_player_id, new_profile)

				local_player_ids[synced_local_player_id] = nil
				--- END OF BLOCK #2 ---

				FLOW; TARGET BLOCK #3



				-- Decompilation error in this vicinity:
				--- BLOCK #3 74-75, warpins: 2 ---
				--- END OF BLOCK #3 ---



			end
			--- END OF BLOCK #1 ---



		end

		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 76-80, warpins: 2 ---
		if not next(local_player_ids) then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 81-83, warpins: 1 ---
			self._profile_updates[synced_peer_id] = nil
			--- END OF BLOCK #0 ---



		end
		--- END OF BLOCK #1 ---

		FLOW; TARGET BLOCK #2



		-- Decompilation error in this vicinity:
		--- BLOCK #2 84-85, warpins: 3 ---
		--- END OF BLOCK #2 ---



	end

	--- END OF BLOCK #3 ---

	FLOW; TARGET BLOCK #4



	-- Decompilation error in this vicinity:
	--- BLOCK #4 86-86, warpins: 1 ---
	return
	--- END OF BLOCK #4 ---



end

ProfileSynchronizerHost.destroy = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-5, warpins: 1 ---
	local network_event_delegate = self._event_delegate

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 6-19, warpins: 0 ---
	for channel_id, _ in pairs(self._registred_channel_ids) do

		-- Decompilation error in this vicinity:
		--- BLOCK #0 6-17, warpins: 1 ---
		network_event_delegate:unregister_channel_events(channel_id, unpack(RPCS))
		self._rpc_queues[channel_id]:delete()
		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 18-19, warpins: 2 ---
		--- END OF BLOCK #1 ---



	end

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 20-26, warpins: 1 ---
	self._registred_channel_ids = nil
	self._connected_peers = nil
	self._rpc_queues = nil

	return
	--- END OF BLOCK #2 ---



end

ProfileSynchronizerHost.rpc_player_profile_synced = function (self, channel_id, profile_peer_id, profile_local_player_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-8, warpins: 1 ---
	local peer_id = Network.peer_id(channel_id)

	if not self._profile_sync_states[profile_peer_id] and profile_peer_id ~= self._peer_id then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 12-12, warpins: 1 ---
		return
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 13-20, warpins: 3 ---
	local peer_states = self._profile_sync_states[peer_id]
	local current_state = peer_states[profile_peer_id][profile_local_player_id]

	if current_state == SYNC_STATES.syncing_need_resync then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 21-45, warpins: 1 ---
		peer_states[profile_peer_id][profile_local_player_id] = SYNC_STATES.not_synced
		local profile = self._profile_updates[profile_peer_id][profile_local_player_id]
		local profile_json = ProfileUtils.pack_profile(profile)
		local profile_chunks = {}

		ProfileUtils.split_for_network(profile_json, profile_chunks)
		self:sync_player_profile(channel_id, profile_peer_id, profile_local_player_id, profile_chunks)
		--- END OF BLOCK #0 ---



	else

		-- Decompilation error in this vicinity:
		--- BLOCK #0 46-49, warpins: 1 ---
		peer_states[profile_peer_id][profile_local_player_id] = SYNC_STATES.synced
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 50-53, warpins: 2 ---
	local initial_syncs = self._initial_syncs

	if initial_syncs[channel_id] and initial_syncs[channel_id][profile_peer_id] then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 58-61, warpins: 1 ---
		initial_syncs[channel_id][profile_peer_id][profile_local_player_id] = true
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #2 ---

	FLOW; TARGET BLOCK #3



	-- Decompilation error in this vicinity:
	--- BLOCK #3 62-62, warpins: 3 ---
	return
	--- END OF BLOCK #3 ---



end

ProfileSynchronizerHost.rpc_notify_profile_changed = function (self, channel_id, peer_id, local_player_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-6, warpins: 1 ---
	self:profile_changed(peer_id, local_player_id)

	return
	--- END OF BLOCK #0 ---



end

return ProfileSynchronizerHost
