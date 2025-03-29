-- chunkname: @scripts/managers/networked_flow_state/networked_flow_state_manager.lua

local unit_alive = Unit.alive
local NetworkedFlowStateManager = class("NetworkedFlowStateManager")
local FLOW_STATE_TYPES = {
	boolean = {
		rpcs = {
			change = "rpc_flow_state_bool_changed",
		},
	},
	number = {
		network_constant = "number",
		rpcs = {
			change = "rpc_flow_state_number_changed",
		},
	},
}
local CLIENT_RPCS = {
	"rpc_flow_state_story_played",
	"rpc_flow_state_story_stopped",
}

for _, config in pairs(FLOW_STATE_TYPES) do
	for _, rpc_name in pairs(config.rpcs) do
		CLIENT_RPCS[#CLIENT_RPCS + 1] = rpc_name
	end
end

NetworkedFlowStateManager.init = function (self, world, is_server, network_event_delegate)
	self._story_lookup = {}
	self._level_lookup = {}
	self._playing_stories = {}
	self._object_states = {}
	self._return_table = {}
	self._num_states = 0
	self._max_states = NetworkConstants.flow_state_id.max
	self._is_server = is_server

	if is_server then
		self._storyteller = World.storyteller(world)
	else
		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))

		self._network_event_delegate = network_event_delegate
	end
end

NetworkedFlowStateManager.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end
end

NetworkedFlowStateManager.flow_cb_create_story = function (self, node_id)
	local level = Application.flow_callback_context_level()

	self._story_lookup[level] = self._story_lookup[level] or {}

	local lookup = self._story_lookup[level]
	local level_index = #self._story_lookup + 1
	local story_data = {
		level_index = level_index,
		level = level,
		node_id = node_id,
	}

	lookup[node_id] = story_data
	self._story_lookup[level_index] = story_data
end

NetworkedFlowStateManager.flow_cb_play_networked_story = function (self, client_call_event_name, start_time, start_from_stop_time, node_id)
	if not self._is_server then
		return nil
	end

	local level = Application.flow_callback_context_level()
	local lookup = self._story_lookup[level]
	local story_data = lookup[node_id]
	local level_index = story_data.level_index
	local stories = self._playing_stories[level]
	local story

	if stories then
		story = stories[node_id]
	end

	start_time = start_time or start_from_stop_time and story and story.stop_time or 0

	Managers.state.game_session:send_rpc_clients("rpc_flow_state_story_played", level_index, start_time, false)

	if story then
		table.clear(story)

		story.start_time = start_time
	else
		self._playing_stories[level] = self._playing_stories[level] or {}

		local new_story = self._playing_stories[level]

		new_story[node_id] = {
			start_time = start_time,
		}
	end

	local return_table = self._return_table

	table.clear(return_table)

	return_table.play_out = true
	return_table.time_out = start_time

	return return_table
end

NetworkedFlowStateManager.rpc_flow_state_story_played = function (self, channel_id, level_id, start_time)
	local story_data = self._story_lookup[level_id]
	local level = story_data.level
	local node_id = story_data.node_id

	Level.trigger_script_node_event(level, node_id, "play_out", true, "time_out", start_time)
end

NetworkedFlowStateManager.flow_cb_stop_networked_story = function (self, node_id)
	if not self._is_server then
		return nil
	end

	local level = Application.flow_callback_context_level()
	local lookup = self._story_lookup[level]
	local story_data = lookup[node_id]
	local level_id = story_data.level_index
	local stories = self._playing_stories[level]

	if stories then
		local story = stories[node_id]

		if story then
			local stop_time = self._storyteller:time(story.id)

			story.stop_time = stop_time

			Managers.state.game_session:send_rpc_clients("rpc_flow_state_story_stopped", level_id, stop_time)
		else
			Log.warning("[NetworkedFlowStateManager]", "[flow_cb_stop_networked_story] Story(%s) not found. Please check level flow logic.", tostring(node_id))
		end
	else
		Log.warning("[NetworkedFlowStateManager]", "[flow_cb_stop_networked_story] No playing stories for current level. Please check level flow logic.")
	end

	local return_table = self._return_table

	table.clear(return_table)

	return_table.stop_out = true

	return return_table
end

NetworkedFlowStateManager.rpc_flow_state_story_stopped = function (self, channel_id, level_id, stop_time)
	local story_data = self._story_lookup[level_id]
	local level = story_data.level
	local node_id = story_data.node_id

	Level.trigger_script_node_event(level, node_id, "stop_out", true)
	Level.trigger_script_node_event(level, node_id, "play_out", true, "time_out", stop_time)
	Level.trigger_script_node_event(level, node_id, "stop_out", true)
end

NetworkedFlowStateManager.flow_cb_has_stopped_networked_story = function (self, node_id)
	if not self._is_server then
		return nil
	end

	local level = Application.flow_callback_context_level()
	local stories = self._playing_stories[level]

	if stories then
		local story = stories[node_id]

		if story then
			story.stopped = true
		else
			Log.warning("[NetworkedFlowStateManager]", "[flow_cb_has_stopped_networked_story] Story(%s) not found. Please check level flow logic.", tostring(node_id))
		end
	else
		Log.warning("[NetworkedFlowStateManager]", "[flow_cb_has_stopped_networked_story] No playing stories for current level. Please check level flow logic.")
	end
end

NetworkedFlowStateManager.flow_cb_has_played_networked_story = function (self, node_id, story_id)
	if not self._is_server then
		return nil
	end

	local level = Application.flow_callback_context_level()
	local stories = self._playing_stories[level]
	local story = stories[node_id]

	story.id = story_id
	story.length = self._storyteller:length(story_id)
end

NetworkedFlowStateManager.unregister_level = function (self, level)
	local story_data = self._playing_stories[level]

	self._playing_stories[level] = nil

	if story_data then
		local level_index = story_data.level_index

		if level_index then
			self._story_lookup[level_index] = nil
		end
	end
end

NetworkedFlowStateManager.hot_join_sync = function (self, peer, channel)
	self:_sync_states(peer, channel)
	self:_sync_stories(peer, channel)
end

NetworkedFlowStateManager._sync_stories = function (self, peer, channel)
	local storyteller = self._storyteller

	for level, playing_stories in pairs(self._playing_stories) do
		for node_id, story_data in pairs(playing_stories) do
			local stopped = story_data.stopped
			local story_time_constant = NetworkConstants.story_time
			local stories = self._story_lookup[level]
			local story = stories[node_id]
			local level_index = story.level_index

			if stopped then
				RPC.rpc_flow_state_story_stopped(channel, level_index, math.clamp(story_data.stop_time or story_data.length, story_time_constant.min, story_time_constant.max))
			else
				local story_id = story_data.id

				RPC.rpc_flow_state_story_played(channel, level_index, math.clamp(storyteller:time(story_id), story_time_constant.min, story_time_constant.max))
			end
		end
	end
end

NetworkedFlowStateManager._sync_states = function (self, peer, channel)
	for unit, unit_states in pairs(self._object_states) do
		if unit_alive(unit) then
			local is_level_index, unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(unit)

			for state_name, state_table in pairs(unit_states.states) do
				local value = state_table.value

				if value ~= state_table.default_value then
					local state_network_id = unit_states.lookup[state_name]
					local type_data = FLOW_STATE_TYPES[type(value)]

					value = self:_clamp_state(state_name, type_data, value)

					RPC[type_data.rpcs.change](channel, unit_id, state_network_id, value, true, not is_level_index)
				end
			end
		else
			Log.warning("[NetworkedFlowStateManager] Trying to hot join sync state variable for destroyed unit.")
		end
	end
end

NetworkedFlowStateManager.flow_cb_create_state = function (self, unit, state_name, default_value, client_data_changed_event, hot_join_sync_event, is_game_object)
	local states = self._object_states
	local unit_states = states[unit] or {
		lookup = {},
		states = {},
	}
	local state_network_id = #unit_states.lookup + 1

	unit_states.lookup[state_name] = state_network_id
	unit_states.lookup[state_network_id] = state_name
	unit_states.states[state_name] = {
		value = default_value,
		default_value = default_value,
		client_state_changed_event = client_data_changed_event,
		client_state_set_event = hot_join_sync_event,
		state_network_id = state_network_id,
		is_game_object = is_game_object or false,
	}
	states[unit] = unit_states
	self._num_states = self._num_states + 1

	return true, default_value
end

NetworkedFlowStateManager.flow_cb_get_state = function (self, unit, state_name)
	local unit_states = self._object_states[unit]
	local state = unit_states and unit_states.states[state_name]

	return state.value
end

NetworkedFlowStateManager.flow_cb_change_state = function (self, unit, state_name, new_state)
	local level = Application.flow_callback_context_level()
	local unit_states = self._object_states[unit]
	local current_state = unit_states and unit_states.states[state_name]

	current_state.value = new_state

	local unit_spawner = Managers.state.unit_spawner
	local is_game_object = current_state.is_game_object or false
	local unit_id = is_game_object and unit_spawner:game_object_id(unit) or unit_spawner:level_index(unit)
	local type_data = FLOW_STATE_TYPES[type(new_state)]
	local state_network_id = current_state.state_network_id

	new_state = self:_clamp_state(state_name, type_data, new_state)

	Managers.state.game_session:send_rpc_clients(type_data.rpcs.change, unit_id, state_network_id, new_state, false, is_game_object)

	return new_state
end

NetworkedFlowStateManager._clamp_state = function (self, state_name, type_data, new_state)
	local network_constant = type_data.network_constant and NetworkConstants[type_data.network_constant]

	if network_constant and (new_state < network_constant.min or new_state > network_constant.max) then
		new_state = math.max(network_constant.min, math.min(network_constant.max, new_state))

		Application.warning("[NetworkedFlowStateManager] Networked Flow State %q value %f out of bounds [%f..%f]", state_name, new_state, network_constant.min, network_constant.max)
	end

	return new_state
end

NetworkedFlowStateManager.client_flow_state_changed = function (self, unit_id, state_network_id, new_state, only_set, is_game_object)
	local unit = Managers.state.unit_spawner:unit(unit_id, not is_game_object)
	local states = self._object_states
	local unit_states = states[unit]
	local state_name = unit_states.lookup[state_network_id]
	local state = unit_states.states[state_name]

	state.value = new_state

	local flow_event = only_set and state.client_state_set_event or state.client_state_changed_event

	Unit.flow_event(unit, flow_event)
end

NetworkedFlowStateManager.rpc_flow_state_bool_changed = function (self, channel_id, unit_id, state_network_id, new_state, only_set, is_game_object)
	self:client_flow_state_changed(unit_id, state_network_id, new_state, only_set, is_game_object)
end

NetworkedFlowStateManager.rpc_flow_state_number_changed = function (self, channel_id, unit_id, state_network_id, new_state, only_set, is_game_object)
	self:client_flow_state_changed(unit_id, state_network_id, new_state, only_set, is_game_object)
end

return NetworkedFlowStateManager
