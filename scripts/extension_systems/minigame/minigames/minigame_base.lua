-- chunkname: @scripts/extension_systems/minigame/minigames/minigame_base.lua

local MinigameSettings = require("scripts/settings/minigame/minigame_settings")
local NetworkLookup = require("scripts/network_lookup/network_lookup")
local MinigameBase = class("MinigameBase")

MinigameBase.init = function (self, unit, is_server, seed, wwise_world)
	self._minigame_unit = unit
	self._is_server = is_server
	self._current_state = MinigameSettings.game_states.none
	self._seed = seed
	self._player_session_id = nil
	self._wwise_world = wwise_world
	self._current_stage = nil
	self._state_started = nil

	if is_server then
		self._fx_extension = nil
		self._fx_source_name = nil
	end

	local unit_spawner_manager = Managers.state.unit_spawner

	self._is_level_unit, self._minigame_unit_id = unit_spawner_manager:game_object_id_or_level_index(unit)
end

MinigameBase.setup_game = function (self)
	self:set_state(MinigameSettings.game_states.intro)
end

MinigameBase.hot_join_sync = function (self, sender, channel)
	if self._current_state ~= MinigameSettings.game_states.none then
		local state_lookup_id = NetworkLookup.minigame_game_states[self._current_state]

		self:send_rpc_to_channel(channel, "rpc_minigame_sync_game_state", state_lookup_id)
	end

	local current_decode_stage = self._current_stage

	if current_decode_stage then
		self:send_rpc_to_channel(channel, "rpc_minigame_sync_set_stage", current_decode_stage)
	end
end

MinigameBase.decode_interrupt = function (self)
	return
end

MinigameBase.start = function (self, player_or_nil)
	self._player_session_id = player_or_nil and player_or_nil:session_id()
end

MinigameBase.set_state = function (self, state)
	self._current_state = self:handle_state(state)

	if self._is_server and self._current_state ~= MinigameSettings.game_states.none then
		local state_lookup_id = NetworkLookup.minigame_game_states[self._current_state]

		self:send_rpc("rpc_minigame_sync_game_state", state_lookup_id)
	end
end

MinigameBase.handle_state = function (self, state)
	local states = MinigameSettings.game_states

	if state == states.intro then
		state = MinigameSettings.game_states.gameplay
	elseif state == states.transition and self:is_completed() then
		state = MinigameSettings.game_states.outro
	end

	return state
end

MinigameBase.state = function (self)
	return self._current_state
end

MinigameBase.stop = function (self)
	self._player_session_id = nil
end

MinigameBase.complete = function (self)
	return
end

MinigameBase.player_session_id = function (self)
	return self._player_session_id
end

MinigameBase.is_completed = function (self)
	local stage_amount = self._stage_amount
	local current_stage = self._current_stage

	if current_stage and current_stage then
		return stage_amount < current_stage
	end

	return false
end

MinigameBase.should_exit = function (self)
	return self:is_completed()
end

MinigameBase.uses_action = function (self)
	return true
end

MinigameBase.uses_joystick = function (self)
	return false
end

MinigameBase.update = function (self, dt, t)
	return
end

MinigameBase.on_action_pressed = function (self, t)
	return
end

MinigameBase.on_action_released = function (self, t)
	return
end

MinigameBase.on_axis_set = function (self, t, x, y)
	return
end

MinigameBase.send_rpc = function (self, rpc_name, ...)
	Managers.state.game_session:send_rpc_clients(rpc_name, self._minigame_unit_id, self._is_level_unit, ...)
end

MinigameBase.send_rpc_to_server = function (self, rpc_name, ...)
	Managers.state.game_session:send_rpc_server(rpc_name, self._minigame_unit_id, self._is_level_unit, ...)
end

MinigameBase.send_rpc_to_channel = function (self, channel, rpc_name, ...)
	local rpc = RPC[rpc_name]

	rpc(channel, self._minigame_unit_id, self._is_level_unit, ...)
end

MinigameBase._setup_sound = function (self, player, fx_source_name)
	local player_unit = player.player_unit
	local visual_loadout_extension = ScriptUnit.extension(player_unit, "visual_loadout_system")
	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
	local inventory_component = unit_data_extension:read_component("inventory")
	local fx_sources = visual_loadout_extension:source_fx_for_slot(inventory_component.wielded_slot)

	self._fx_extension = ScriptUnit.extension(player_unit, "fx_system")
	self._fx_source_name = fx_sources[fx_source_name]
end

MinigameBase.play_sound = function (self, alias, sync_with_clients, include_client)
	if self._fx_extension then
		sync_with_clients = sync_with_clients == nil and true
		include_client = include_client == nil and true

		if self._fx_extension:sound_source(self._fx_source_name) then
			self._fx_extension:trigger_gear_wwise_event_with_source(alias, nil, self._fx_source_name, sync_with_clients, include_client)
		end
	end
end

MinigameBase.set_parameter_sound = function (self, parameter_name, parameter_value)
	if self._fx_extension and self._fx_extension:sound_source(self._fx_source_name) then
		self._fx_extension:set_source_parameter(parameter_name, parameter_value, self._fx_source_name)
	end
end

MinigameBase.current_stage = function (self)
	return self._current_stage
end

MinigameBase.set_current_stage = function (self, stage)
	if self._current_stage then
		if stage < self._current_stage then
			Unit.flow_event(self._minigame_unit, "lua_minigame_fail")
		elseif stage > self._current_stage then
			if stage > self._stage_amount then
				Unit.flow_event(self._minigame_unit, "lua_minigame_success_last")
			else
				Unit.flow_event(self._minigame_unit, "lua_minigame_success")
			end
		end
	end

	self._current_stage = stage
end

MinigameBase.progressing = function (self)
	return false
end

return MinigameBase
