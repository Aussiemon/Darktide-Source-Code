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
	self._client_side = false
	self._current_stage = nil
	self._state_started = nil
	self._action_held = nil

	if is_server then
		self._fx_extension = nil
		self._fx_source_name = nil
	end

	local unit_spawner_manager = Managers.state.unit_spawner

	if unit then
		self._minigame_extension = ScriptUnit.extension(unit, "minigame_system")
		self._is_level_unit, self._minigame_unit_id = unit_spawner_manager:game_object_id_or_level_index(unit)
	end
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
	self:set_state(MinigameSettings.game_states.intro)
end

MinigameBase.start = function (self, player)
	self._player_session_id = player and player:session_id()

	if self._minigame_extension then
		self._minigame_extension:set_active(true)

		if self._is_server then
			Managers.state.game_session:send_rpc_clients_except("rpc_minigame_sync_start", player:channel_id(), self._minigame_unit_id, self._is_level_unit)
		end
	end
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
		state = states.gameplay
	elseif state == states.transition and self:is_completed() then
		state = states.outro
	end

	return state
end

MinigameBase.complete = function (self)
	self:set_state(MinigameSettings.game_states.complete)

	if self._minigame_extension then
		self._minigame_extension:set_active(false)

		if self._is_server then
			Managers.state.game_session:send_rpc_clients("rpc_minigame_sync_completed", self._minigame_unit_id, self._is_level_unit)

			if self._is_side_mission then
				self:_update_side_mission_progression()
			end

			local mutator_on_minigame_complete = self._mutator_on_minigame_complete

			if mutator_on_minigame_complete then
				local mutator_manager = Managers.state.mutator
				local communication_hack_mutator = mutator_manager:mutator(mutator_on_minigame_complete)

				if communication_hack_mutator then
					local player_unit
					local player_session_id = self._minigame:player_session_id()

					if player_session_id then
						local player = Managers.player:player_from_session_id(self._minigame._player_session_id)

						player_unit = player.player_unit
					end

					communication_hack_mutator:spawn_random_from_template(player_unit)
				end
			end
		end
	end
end

MinigameBase._update_side_mission_progression = function (self)
	local mission_objective_target_extension = ScriptUnit.extension(self._minigame_unit, "mission_objective_target_system")
	local objective_name = mission_objective_target_extension:objective_name()
	local group_id = mission_objective_target_extension:group_id()
	local mission_objective_system = Managers.state.extension:system("mission_objective_system")

	if mission_objective_system:is_current_active_objective(objective_name) then
		local synchronizer_unit = mission_objective_system:objective_synchronizer_unit(objective_name, group_id)
		local synchronizer_extension = ScriptUnit.extension(synchronizer_unit, "event_synchronizer_system")
		local increment_value = 1

		synchronizer_extension:add_progression(increment_value)
	end
end

MinigameBase.stop = function (self, player)
	if self._is_server and self._current_state ~= MinigameSettings.game_states.complete and self:is_completed() then
		self:complete()
	end

	self._player_session_id = nil
	self._action_held = nil

	if self._minigame_extension then
		self._minigame_extension:set_active(false)

		if self._is_server then
			if player then
				Managers.state.game_session:send_rpc_clients_except("rpc_minigame_sync_stop", player:channel_id(), self._minigame_unit_id, self._is_level_unit)
			else
				Managers.state.game_session:send_rpc_clients("rpc_minigame_sync_stop", self._minigame_unit_id, self._is_level_unit)
			end
		end
	end
end

MinigameBase.state = function (self)
	return self._current_state
end

MinigameBase.player_session_id = function (self)
	return self._player_session_id
end

MinigameBase.is_completed = function (self)
	if self._current_state == MinigameSettings.game_states.complete then
		return true
	end

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

MinigameBase.angle_check = function (self)
	return self._minigame_unit ~= nil
end

MinigameBase.unequip_on_exit = function (self)
	return true
end

MinigameBase.unit = function (self)
	return self._minigame_unit
end

MinigameBase.update = function (self, dt, t)
	return
end

MinigameBase.action = function (self, held, t)
	if self._action_held == nil then
		if not held then
			self._action_held = false
		else
			return false
		end
	end

	if self._action_held ~= held then
		self._action_held = held

		if held then
			self:on_action_pressed(t)
		else
			self:on_action_released(t)
		end

		return true
	end

	return false
end

MinigameBase.on_action_pressed = function (self, t)
	return
end

MinigameBase.on_action_released = function (self, t)
	return
end

MinigameBase.escape_action = function (self, held)
	return held
end

MinigameBase.on_axis_set = function (self, t, x, y)
	return
end

MinigameBase.send_rpc = function (self, rpc_name, ...)
	if not self._client_side then
		Managers.state.game_session:send_rpc_clients(rpc_name, self._minigame_unit_id, self._is_level_unit, ...)
	end
end

MinigameBase.send_rpc_to_server = function (self, rpc_name, ...)
	Managers.state.game_session:send_rpc_server(rpc_name, self._minigame_unit_id, self._is_level_unit, ...)
end

MinigameBase.send_rpc_to_channel = function (self, channel, rpc_name, ...)
	if not self._client_side then
		local rpc = RPC[rpc_name]

		rpc(channel, self._minigame_unit_id, self._is_level_unit, ...)
	end
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
