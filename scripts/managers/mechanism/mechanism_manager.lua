local MechanismBase = require("scripts/managers/mechanism/mechanisms/mechanism_base")
local MechanismSettings = require("scripts/settings/mechanism/mechanism_settings")
local StateTitle = require("scripts/game_states/game/state_title")
local Teams = require("scripts/managers/mechanism/teams")

for name, settings in pairs(MechanismSettings) do
	local class_file_name = settings.class_file_name

	require(class_file_name)
end

local MechanismManager = class("MechanismManager")
MechanismManager.LOOKUP = {}
local EVENT_TYPES = table.enum("all", "server", "locally")
MechanismManager.EVENTS = {
	game_mode_end = {
		rpc_name = "rpc_mechanism_event_game_mode_end",
		type = EVENT_TYPES.all,
		pack_function = function (self, result, session_id)
			return NetworkLookup.game_mode_outcomes[result], session_id
		end
	},
	all_players_ready = {
		rpc_name = "rpc_mechanism_event",
		type = EVENT_TYPES.all,
		pack_function = function (self, ...)
			return self.id
		end
	},
	victory_defeat_done = {
		rpc_name = "rpc_mechanism_event",
		type = EVENT_TYPES.all,
		pack_function = function (self, ...)
			return self.id
		end
	},
	game_score_done = {
		rpc_name = "rpc_mechanism_event",
		type = EVENT_TYPES.all,
		pack_function = function (self, ...)
			return self.id
		end
	},
	client_exit_gameplay = {
		type = EVENT_TYPES.locally
	},
	ready_for_game_score = {
		rpc_name = "rpc_mechanism_event_ready_for_game_score",
		type = EVENT_TYPES.server,
		pack_function = function (self, peer_id, success)
			return peer_id, success
		end
	}
}
MechanismManager.EVENT_LOOKUP = {}
MechanismManager.CLIENT_RPCS = {
	"rpc_set_mechanism"
}
MechanismManager.SERVER_RPCS = {}
local i = 1
local lookup = MechanismManager.LOOKUP

for name, mechanism_settings in pairs(MechanismSettings) do
	local mechanism_class = CLASSES[mechanism_settings.class_name]

	assert_interface(mechanism_class, MechanismBase.INTERFACE)

	lookup[name] = i
	lookup[i] = name
	i = i + 1
end

local j = 1
local client_rpcs = {}
local server_rpcs = {}

for event_name, event_config in pairs(MechanismManager.EVENTS) do
	local rpc_name = event_config.rpc_name
	local event_type = event_config.type
	local local_side = event_type == EVENT_TYPES.locally

	if not local_side then
		event_config.id = j
		MechanismManager.EVENT_LOOKUP[j] = event_name
		j = j + 1

		if event_type == EVENT_TYPES.all then
			client_rpcs[rpc_name] = true
		else
			server_rpcs[rpc_name] = true
		end
	end
end

for rpc_name in pairs(client_rpcs) do
	MechanismManager.CLIENT_RPCS[#MechanismManager.CLIENT_RPCS + 1] = rpc_name
end

for rpc_name in pairs(server_rpcs) do
	MechanismManager.SERVER_RPCS[#MechanismManager.SERVER_RPCS + 1] = rpc_name
end

local function _info(...)
	Log.info("MechanismManager", ...)
end

MechanismManager.init = function (self, network_event_delegate, initial_mechanism_name, server_context)
	self._mechanism_name = nil
	self._clients = {}
	self._network_event_delegate = network_event_delegate

	if initial_mechanism_name then
		self:change_mechanism(initial_mechanism_name, server_context)
	else
		_info("Initialized without mechanism")
	end
end

MechanismManager.leave_mechanism = function (self)
	if self._mechanism then
		_info("Leaving mechanism %q", self._mechanism.name)
		self._mechanism:delete()

		self._mechanism = nil
		self._mechanism_name = nil
	end

	if self._teams then
		self._teams:delete()

		self._teams = nil
	end
end

MechanismManager.mechanism_name = function (self)
	return self._mechanism_name
end

MechanismManager.player_package_synchronization_settings = function (self)
	local package_settings = nil

	if self._mechanism then
		local settings = self._mechanism:settings()
		package_settings = settings.player_package_synchronization_settings
	end

	return package_settings
end

MechanismManager.add_client = function (self, channel_id)
	local lookup_id = self.LOOKUP[self._mechanism_name]

	RPC.rpc_set_mechanism(channel_id, lookup_id)
	self._mechanism:sync_data(channel_id)

	self._clients[channel_id] = true

	self._network_event_delegate:register_connection_channel_events(self, channel_id, unpack(MechanismManager.SERVER_RPCS))
end

MechanismManager.remove_client = function (self, channel_id)
	self._clients[channel_id] = nil

	self._network_event_delegate:unregister_channel_events(channel_id, unpack(MechanismManager.SERVER_RPCS))
end

MechanismManager.clients = function (self)
	return self._clients
end

MechanismManager.is_allowed_to_reserve_slots = function (self, peer_ids)
	if not self._mechanism then
		Log.warning("MechanismManager", "No mechanism set yet, can't decide")

		return false
	end

	return self._mechanism:is_allowed_to_reserve_slots(peer_ids)
end

MechanismManager.peers_reserved_slots = function (self, peer_ids)
	self._mechanism:peers_reserved_slots(peer_ids)
end

MechanismManager.peer_freed_slot = function (self, peer_id)
	self._mechanism:peer_freed_slot(peer_id)
end

MechanismManager.connect_to_host = function (self, channel_id)
	_info("Connecting to mechanism host on channel %i", channel_id)

	self._mechanism_host_channel = channel_id

	self._network_event_delegate:register_connection_channel_events(self, channel_id, unpack(MechanismManager.CLIENT_RPCS))
end

MechanismManager.disconnect = function (self, channel_id)
	fassert(channel_id == self._mechanism_host_channel, "Trying to disconnect to host not connected to")
	_info("Disconnecting from mechanism host on channel %i", channel_id)

	self._mechanism_host_channel = nil

	self._network_event_delegate:unregister_channel_events(channel_id, unpack(MechanismManager.CLIENT_RPCS))
	self:leave_mechanism()
end

MechanismManager.rpc_set_mechanism = function (self, channel_id, lookup_id)
	local mechanism_name = self.LOOKUP[lookup_id]

	_info("Received mechanism %q from host.", mechanism_name)
	self:change_mechanism(mechanism_name, {
		server_channel = channel_id
	})
end

MechanismManager.change_mechanism = function (self, mechanism_name, context)
	local old_mechanism = self._mechanism

	if old_mechanism then
		_info("Change mechanism %q->%q", old_mechanism.name, mechanism_name)
		self:leave_mechanism()
	else
		_info("Change mechanism <none>->%q", mechanism_name)
	end

	local settings = MechanismSettings[mechanism_name]

	fassert(settings, "%q does not exist in MechanismSettings", mechanism_name)

	local lookup_id = self.LOOKUP[mechanism_name]

	for channel_id in pairs(self._clients) do
		RPC.rpc_set_mechanism(channel_id, lookup_id)
	end

	self._mechanism_name = mechanism_name
	local team_settings = settings.team_settings

	if team_settings then
		self._teams = Teams:new(team_settings)
	end

	local mechanism_class = CLASSES[settings.class_name]

	assert_interface(mechanism_class, MechanismBase.INTERFACE)

	self._mechanism = mechanism_class:new(mechanism_name, self._network_event_delegate, context, self._teams)

	for channel_id in pairs(self._clients) do
		self._mechanism:sync_data(channel_id)
	end

	Managers.event:trigger("mechanism_changed")
end

MechanismManager.wanted_transition = function (self)
	if not self._mechanism then
		return nil, nil
	end

	local done, next_state, next_state_context = self._mechanism:wanted_transition()

	if done then
		if self._mechanism_host_channel then
			self:leave_mechanism()
		elseif Managers.connection:is_dedicated_mission_server() then
			self:leave_mechanism()
		else
			self:change_mechanism("hub", {})

			done, next_state, next_state_context = self._mechanism:wanted_transition()
		end
	end

	return next_state, next_state_context
end

local function _send_event_rpc(rpc_name, clients, ...)
	local rpc = RPC[rpc_name]

	for channel_id in pairs(clients) do
		rpc(channel_id, ...)
	end
end

MechanismManager.trigger_event = function (self, event, ...)
	local host_channel = self._mechanism_host_channel
	local event_data = self.EVENTS[event]

	if host_channel and event_data.type == EVENT_TYPES.all then
		return
	end

	local mechanism = self._mechanism

	if not mechanism then
		return
	end

	local event_function = mechanism[event]

	fassert(event_function, "Mechanism %q does not handle event %q.", mechanism.name, event)

	if event_data.type == EVENT_TYPES.locally then
		event_function(mechanism, ...)
	elseif event_data.type == EVENT_TYPES.server then
		if host_channel then
			local rpc_name = event_data.rpc_name

			RPC[rpc_name](host_channel, event_data:pack_function(...))
		else
			event_function(mechanism, ...)
		end
	else
		local rpc_name = event_data.rpc_name

		_send_event_rpc(rpc_name, self._clients, event_data:pack_function(...))
		event_function(mechanism, ...)
	end
end

MechanismManager.rpc_mechanism_event_game_mode_end = function (self, channel_id, result_id, session_id)
	local mechanism = self._mechanism

	fassert(mechanism.game_mode_end, "Mechanism %q does not handle event %q.", mechanism.name, "game_mode_end")

	local reason = NetworkLookup.game_mode_outcomes[result_id]

	mechanism:game_mode_end(reason, session_id)
	_info("session_id %s", session_id)
end

MechanismManager.rpc_mechanism_event = function (self, channel_id, event_id)
	local event_name = self.EVENT_LOOKUP[event_id]
	local mechanism = self._mechanism
	local event_function = mechanism[event_name]

	fassert(event_function, "Mechanism %q does not handle event %q.", mechanism.name, event_name)
	event_function(mechanism)
end

MechanismManager.rpc_mechanism_event_ready_for_game_score = function (self, channel_id, peer_id, success)
	local mechanism = self._mechanism

	fassert(mechanism.ready_for_game_score, "Mechanism %q does not handle event 'ready_for_game_score'.", mechanism.name)
	mechanism:ready_for_game_score(peer_id, success)
end

MechanismManager.end_result = function (self)
	local end_result = self._mechanism and self._mechanism._mechanism_data.end_result or false

	return end_result
end

MechanismManager.mechanism_state = function (self)
	local mechanism_state = self._mechanism and self._mechanism._state or false

	return mechanism_state
end

return MechanismManager
