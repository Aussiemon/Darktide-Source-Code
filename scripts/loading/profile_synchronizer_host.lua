local MasterItems = require("scripts/backend/master_items")
local ProfileUtils = require("scripts/utilities/profile_utils")
local RPCQueue = require("scripts/utilities/rpc_queue")
local Text = require("scripts/utilities/ui/text")
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
	self._registered_channel_ids = {}
	self._profile_sync_states = {}
	self._profile_updates = {}
	self._initial_syncs = {}
	self._delayed_profile_changes = {}
end

ProfileSynchronizerHost.register_rpcs = function (self, channel_id)
	self._event_delegate:register_connection_channel_events(self, channel_id, unpack(RPCS))

	self._registered_channel_ids[channel_id] = true
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

	for j = 1, #profile_chunks do
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

	for i = 1, #local_player_ids do
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
	local generated_name = ProfileUtils.generate_random_name(profile)
	generated_name = string.format("%s {#color(216,229,207,120)}[%s]{#reset()}", generated_name, Text.localize_to_upper("loc_bot_tag"))
	profile.name = generated_name
	local profile_json = ProfileUtils.pack_profile(profile)
	local profile_chunks = {}

	ProfileUtils.split_for_network(profile_json, profile_chunks)

	for _, connected_peer_channel_id in pairs(connected_peer_channel_ids) do
		self:sync_player_profile(connected_peer_channel_id, self._peer_id, local_player_id, profile_chunks)
	end
end

ProfileSynchronizerHost._profile_changed = function (self, local_player_id, peer_id, character_id)
	local player = Managers.player:player(peer_id, local_player_id)
	local account_id = player:account_id()
	local connected_peer_channel_ids = self._connected_peers

	Managers.backend.interfaces.characters:fetch_account_character(account_id, character_id, true, true):next(function (backend_profile_data)
		if not Managers.player:player(peer_id, local_player_id) then
			return
		end

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

ProfileSynchronizerHost.profile_changed = function (self, peer_id, local_player_id)
	local player = Managers.player:player(peer_id, local_player_id)
	local character_id = player:character_id()

	self:_profile_changed(local_player_id, peer_id, character_id)
end

ProfileSynchronizerHost.override_slot = function (self, peer_id, local_player_id, slot_name, item_name)
	local player = Managers.player:player(peer_id, local_player_id)
	local new_profile = table.clone_instance(player:profile())
	local loadout_item_ids = new_profile.loadout_item_ids
	loadout_item_ids[slot_name] = item_name and item_name .. slot_name or nil
	local loadout_item_data = new_profile.loadout_item_data
	loadout_item_data[slot_name] = {
		id = item_name
	}

	self:override_singleplay_profile(peer_id, local_player_id, new_profile)
end

ProfileSynchronizerHost.override_singleplay_profile = function (self, peer_id, local_player_id, new_profile)
	local profile_json = ProfileUtils.pack_profile(new_profile)
	local profile_chunks = {}

	ProfileUtils.split_for_network(profile_json, profile_chunks)

	for _, connected_peer_channel_id in pairs(self._connected_peers) do
		self:sync_player_profile(connected_peer_channel_id, peer_id, local_player_id, profile_chunks)
	end

	new_profile = ProfileUtils.unpack_profile(profile_json)
	local profile_updates = self._profile_updates[peer_id] or {}
	profile_updates[local_player_id] = new_profile
	self._profile_updates[peer_id] = profile_updates
end

ProfileSynchronizerHost.profile_updates_profile = function (self, peer_id, local_player_id)
	local profile_updates = self._profile_updates[peer_id]

	if not profile_updates then
		return nil
	end

	return profile_updates[local_player_id]
end

ProfileSynchronizerHost.profiles_synced = function (self, peer_ids)
	for i = 1, #peer_ids do
		local peer_id = peer_ids[i]
		local peer_synced = self:peer_profiles_synced(peer_id)

		if not peer_synced then
			return false
		end
	end

	return true
end

ProfileSynchronizerHost.peer_profiles_synced = function (self, peer_id)
	local profile_sync_states = self._profile_sync_states

	for other_peer_id, peer_states in pairs(profile_sync_states) do
		repeat
			local player_states = peer_states[peer_id]

			if not player_states then
				if peer_id == self._peer_id then
					break
				else
					return false
				end
			end

			for _, sync_state in pairs(player_states) do
				if sync_state ~= SYNC_STATES.synced then
					return false
				end
			end
		until true
	end

	return true
end

ProfileSynchronizerHost.is_player_synced_to_peer = function (self, peer_id, player_peer_id, local_player_id)
	local profile_sync_states = self._profile_sync_states
	local peer_states = profile_sync_states[peer_id]
	local player_states = peer_states[player_peer_id]
	local sync_state = player_states[local_player_id]

	return sync_state == SYNC_STATES.synced
end

ProfileSynchronizerHost.peer_connected = function (self, peer_id, channel_id)
	self._connected_peers[peer_id] = channel_id
end

ProfileSynchronizerHost.peer_disconnected = function (self, peer_id, channel_id)
	local profile_sync_states = self._profile_sync_states
	profile_sync_states[peer_id] = nil

	for _, peer_states in pairs(profile_sync_states) do
		for sync_peer_id, _ in pairs(peer_states) do
			if sync_peer_id == peer_id then
				peer_states[sync_peer_id] = nil
			end
		end
	end

	for _, other_channel_id in pairs(self._connected_peers) do
		RPC.rpc_profile_sync_peer_disconnected(other_channel_id, peer_id)
	end

	local registered_channel_ids = self._registered_channel_ids

	if registered_channel_ids[channel_id] then
		self._event_delegate:unregister_channel_events(channel_id, unpack(RPCS))
		self._rpc_queues[channel_id]:delete()

		self._rpc_queues[channel_id] = nil
	end

	local initial_syncs = self._initial_syncs

	for sync_channel_id, initial_peer_syncs in pairs(initial_syncs) do
		initial_peer_syncs[peer_id] = nil

		if not next(initial_peer_syncs) then
			initial_syncs[sync_channel_id] = nil
		end
	end

	self._registered_channel_ids[channel_id] = nil
	self._initial_syncs[channel_id] = nil
	self._connected_peers[peer_id] = nil
	self._profile_updates[peer_id] = nil
end

ProfileSynchronizerHost.update = function (self, dt)
	local rpc_queues = self._rpc_queues

	for _, queue in pairs(rpc_queues) do
		queue:update(dt)
	end

	local connected_peer_channel_ids = self._connected_peers
	local profile_updates = self._profile_updates

	for synced_peer_id, local_player_ids in pairs(profile_updates) do
		local peer_synced = self:peer_profiles_synced(synced_peer_id)

		if peer_synced then
			for synced_local_player_id, new_profile in pairs(local_player_ids) do
				local player = Managers.player:player(synced_peer_id, synced_local_player_id)
				local old_profile = player:profile()

				player:set_profile(new_profile)

				for _, connected_peer_channel_id in pairs(connected_peer_channel_ids) do
					RPC.rpc_profile_synced_by_all(connected_peer_channel_id, synced_peer_id, synced_local_player_id)
				end

				Managers.event:trigger("updated_player_profile_synced", synced_peer_id, synced_local_player_id, old_profile)
				Managers.event:trigger("event_player_profile_updated", synced_peer_id, synced_local_player_id, new_profile)

				local_player_ids[synced_local_player_id] = nil
			end
		end

		if not next(local_player_ids) then
			self._profile_updates[synced_peer_id] = nil
		end
	end

	for peer_id, local_player_ids in pairs(self._delayed_profile_changes) do
		for local_player_id, _ in pairs(local_player_ids) do
			local player = Managers.player:player(peer_id, local_player_id)

			if player then
				self:profile_changed(peer_id, local_player_id)

				local_player_ids[local_player_id] = nil
			end
		end

		if not next(local_player_ids) then
			self._delayed_profile_changes[peer_id] = nil
		end
	end
end

ProfileSynchronizerHost.destroy = function (self)
	local network_event_delegate = self._event_delegate

	for channel_id, _ in pairs(self._registered_channel_ids) do
		network_event_delegate:unregister_channel_events(channel_id, unpack(RPCS))
		self._rpc_queues[channel_id]:delete()
	end

	self._registered_channel_ids = nil
	self._connected_peers = nil
	self._rpc_queues = nil
end

ProfileSynchronizerHost.rpc_player_profile_synced = function (self, channel_id, profile_peer_id, profile_local_player_id)
	local peer_id = Network.peer_id(channel_id)

	if not self._profile_sync_states[profile_peer_id] and profile_peer_id ~= self._peer_id then
		return
	end

	local peer_states = self._profile_sync_states[peer_id]
	local current_state = peer_states[profile_peer_id][profile_local_player_id]

	if current_state == SYNC_STATES.syncing_need_resync then
		peer_states[profile_peer_id][profile_local_player_id] = SYNC_STATES.not_synced
		local profile = self._profile_updates[profile_peer_id][profile_local_player_id]
		local profile_json = ProfileUtils.pack_profile(profile)
		local profile_chunks = {}

		ProfileUtils.split_for_network(profile_json, profile_chunks)
		self:sync_player_profile(channel_id, profile_peer_id, profile_local_player_id, profile_chunks)
	else
		peer_states[profile_peer_id][profile_local_player_id] = SYNC_STATES.synced
	end

	local initial_syncs = self._initial_syncs

	if initial_syncs[channel_id] and initial_syncs[channel_id][profile_peer_id] then
		initial_syncs[channel_id][profile_peer_id][profile_local_player_id] = true
	end
end

ProfileSynchronizerHost.rpc_notify_profile_changed = function (self, channel_id, peer_id, local_player_id)
	local player = Managers.player:player(peer_id, local_player_id)

	if not Managers.mechanism:profile_changes_are_allowed() then
		return
	end

	if not player then
		self._delayed_profile_changes[peer_id] = self._delayed_profile_changes[peer_id] or {}
		self._delayed_profile_changes[peer_id][local_player_id] = true

		return
	end

	self:profile_changed(peer_id, local_player_id)
end

return ProfileSynchronizerHost
