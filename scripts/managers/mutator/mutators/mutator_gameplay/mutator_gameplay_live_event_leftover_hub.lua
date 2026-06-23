-- chunkname: @scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_live_event_leftover_hub.lua

require("scripts/managers/mutator/mutators/mutator_base")

local LiveEvents = require("scripts/settings/live_event/live_events")
local Promise = require("scripts/foundation/utilities/promise")
local MutatorGameplayLiveEventLeftoverHub = class("MutatorGameplayLiveEventLeftoverHub", "MutatorBase")
local EVENT_NAME = "leftover"
local RESOURCE_TYPE = "artifacts"
local PLEDGE_RESULT_EVENT = "event_leftover_pledge_result"
local SERVER_RPCS = {
	"rpc_live_event_pledge_resources",
}
local EVENT_SETTINGS = LiveEvents[EVENT_NAME]
local FACTION_NETWORK_LOOKUP = EVENT_SETTINGS and EVENT_SETTINGS.faction_network_lookup

local function _get_collected_resource(backend_data, statistic_type)
	if not backend_data or not backend_data.statistics then
		return 0
	end

	local statistics_data = backend_data.statistics

	for i = 1, #statistics_data do
		local stat_data = statistics_data[i]
		local type_path = stat_data.typePath
		local stat_type = type_path and type_path[1]

		if stat_type and stat_type == statistic_type then
			local value = stat_data.value

			if value then
				return value.collected or 0
			end
		end
	end

	return 0
end

local function _faction_key_from_network(faction_lookup)
	if not FACTION_NETWORK_LOOKUP then
		return nil
	end

	return FACTION_NETWORK_LOOKUP[faction_lookup + 1]
end

local function _faction_network_from_key(faction_key)
	if not FACTION_NETWORK_LOOKUP then
		return nil
	end

	for network_index, key in pairs(FACTION_NETWORK_LOOKUP) do
		if key == faction_key then
			return network_index - 1
		end
	end

	return nil
end

MutatorGameplayLiveEventLeftoverHub.init = function (self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)
	MutatorGameplayLiveEventLeftoverHub.super.init(self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)

	self._pledges_in_flight = {}
end

MutatorGameplayLiveEventLeftoverHub.activate = function (self)
	MutatorGameplayLiveEventLeftoverHub.super.activate(self)

	if not self._is_server then
		return
	end

	self._network_event_delegate:register_session_events(self, unpack(SERVER_RPCS))
	Managers.event:register(self, "multiplayer_session_client_disconnected", "_on_client_disconnected")
end

MutatorGameplayLiveEventLeftoverHub.deactivate = function (self)
	if not self._is_active then
		return
	end

	if self._is_server then
		self._network_event_delegate:unregister_events(unpack(SERVER_RPCS))
		Managers.event:unregister(self, "multiplayer_session_client_disconnected")
		table.clear(self._pledges_in_flight)
	end

	MutatorGameplayLiveEventLeftoverHub.super.deactivate(self)
end

MutatorGameplayLiveEventLeftoverHub.rpc_live_event_pledge_resources = function (self, channel_id, track_id, faction_lookup)
	local peer_id = Network.peer_id(channel_id)
	local player = Managers.player:player(peer_id, 1)

	if not player then
		Log.warning("MutatorGameplayLiveEventLeftoverHub", "Received pledge for peer_id '%s' that does not exist.", tostring(peer_id))

		return
	end

	local faction_key = _faction_key_from_network(faction_lookup)

	if not faction_key then
		Log.warning("MutatorGameplayLiveEventLeftoverHub", "Received pledge with invalid faction lookup '%s'.", tostring(faction_lookup))

		return
	end

	self:pledge_resources(player, track_id, faction_key, peer_id)
end

MutatorGameplayLiveEventLeftoverHub.pledge_resources = function (self, player, track_id, faction_key, optional_peer_id)
	if not self._is_server then
		return
	end

	if not track_id then
		Log.warning("MutatorGameplayLiveEventLeftoverHub", "Received pledge with no track id; ignoring.")

		return
	end

	local in_flight_key = optional_peer_id or player:local_player_id()

	if self._pledges_in_flight[in_flight_key] then
		return
	end

	local faction_network = _faction_network_from_key(faction_key)

	if not faction_network then
		Log.warning("MutatorGameplayLiveEventLeftoverHub", "Could not map faction key '%s' to a network value.", tostring(faction_key))

		return
	end

	local account_id = player:account_id()
	local tracks = Managers.backend.interfaces.tracks
	local distribute_data = {
		action = "distribute",
		payload = {
			faction = faction_key,
		},
	}

	self._pledges_in_flight[in_flight_key] = true

	tracks:get_track_statistics_by_type(account_id, track_id, RESOURCE_TYPE):next(function (get_stat_response)
		local collected = _get_collected_resource(get_stat_response, RESOURCE_TYPE)

		Log.info("MutatorGameplayLiveEventLeftoverHub", "Fetched collected resource count of %d for player '%s' and track '%s'.", collected, account_id, track_id)

		return tracks:set_event_track_data(account_id, track_id, distribute_data):next(function (distribute_response)
			Log.info("MutatorGameplayLiveEventLeftoverHub", "Successfully called distribute for player '%s', track '%s', faction '%s'.", account_id, track_id, faction_key)

			if collected > 0 then
				tracks:modify_track_account_state(account_id, track_id, collected):catch(function (error)
					Log.error("MutatorGameplayLiveEventLeftoverHub", "Failed to advance track xp for player '%s': %s", account_id, tostring(error))
				end)
			else
				Log.warning("MutatorGameplayLiveEventLeftoverHub", "Pledge for player '%s' resolved 0 collected resources; distribute landed but no progress recorded.", account_id)
			end

			self._pledges_in_flight[in_flight_key] = nil

			self:_send_pledge_result(optional_peer_id, true, collected, faction_network)
			Log.info("MutatorGameplayLiveEventLeftoverHub", "Pledged '%d' resources to faction '%s' for player '%s'.", collected, faction_key, account_id)
		end)
	end):catch(function (error)
		self._pledges_in_flight[in_flight_key] = nil

		self:_send_pledge_result(optional_peer_id, false, 0, faction_network)
		Log.error("MutatorGameplayLiveEventLeftoverHub", "Failed to pledge resources for player '%s': %s", account_id, tostring(error))
	end)
end

MutatorGameplayLiveEventLeftoverHub._send_pledge_result = function (self, optional_peer_id, success, amount, faction_network)
	if not optional_peer_id then
		Managers.event:trigger(PLEDGE_RESULT_EVENT, success, amount, faction_network)

		return
	end

	local game_session = Managers.state.game_session

	if game_session and game_session:is_server() and game_session:connected_to_client(optional_peer_id) then
		game_session:send_rpc_client("rpc_live_event_pledge_result", optional_peer_id, success, amount, faction_network)
	end
end

MutatorGameplayLiveEventLeftoverHub._on_client_disconnected = function (self, removed_players_data)
	if not removed_players_data then
		return
	end

	for i = 1, #removed_players_data do
		local player_data = removed_players_data[i]
		local peer_id = player_data and player_data.peer_id

		if peer_id then
			self._pledges_in_flight[peer_id] = nil
		end
	end
end

return MutatorGameplayLiveEventLeftoverHub
