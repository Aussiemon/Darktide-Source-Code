-- chunkname: @scripts/extension_systems/minigame/minigames/minigame_defuse.lua

local MinigameSettings = require("scripts/settings/minigame/minigame_settings")

require("scripts/extension_systems/minigame/minigames/minigame_base")

local FX_SOURCE_NAME = "_speaker"
local MinigameDefuse = class("MinigameDefuse", "MinigameBase")

MinigameDefuse.init = function (self, unit, is_server, seed)
	MinigameDefuse.super.init(self, unit, is_server, seed)

	self._stage_amount = MinigameSettings.defuse_stage_amount
	self._option_amount = MinigameSettings.defuse_wire_count
	self._options = {}
	self._targets = {}
	self._selected = nil
	self._last_move = 0
	self._state_start_time = nil
	self._last_click_success = false
end

MinigameDefuse.hot_join_sync = function (self, sender, channel)
	MinigameDefuse.super.hot_join_sync(self, sender, channel)

	if #self._options > 0 then
		self:send_rpc_to_channel(channel, "rpc_minigame_sync_generate_board", self._start_seed)
	end

	if self._selected then
		self:send_rpc_to_channel(channel, "rpc_minigame_sync_defuse_set_selection", self._selected)
	end
end

MinigameDefuse.start = function (self, player)
	MinigameDefuse.super.start(self, player)

	self._moved_time = Managers.time:time("gameplay")

	Unit.flow_event(self._minigame_unit, "lua_minigame_start")

	local is_server = self._is_server

	if is_server then
		local player_unit = player.player_unit
		local visual_loadout_extension = ScriptUnit.extension(player_unit, "visual_loadout_system")
		local fx_sources = visual_loadout_extension:source_fx_for_slot("slot_device")

		Unit.set_flow_variable(self._minigame_unit, "player_unit", player_unit)

		self._fx_extension = ScriptUnit.extension(player_unit, "fx_system")
		self._fx_source_name = fx_sources[FX_SOURCE_NAME]
	end
end

MinigameDefuse.stop = function (self)
	Unit.flow_event(self._minigame_unit, "lua_minigame_stop")
	MinigameDefuse.super.stop(self)
end

MinigameDefuse.complete = function (self)
	MinigameDefuse.super.complete(self)

	if self._is_server then
		self._current_stage = nil
	end
end

MinigameDefuse.setup_game = function (self)
	MinigameDefuse.super.setup_game(self)

	if not self._current_stage then
		self:generate_board(self._seed)
		self:send_rpc("rpc_minigame_sync_generate_board", self._start_seed)

		self._current_stage = 1

		self:send_rpc("rpc_minigame_sync_set_stage", 1)
	end
end

function _option_is_new(stage_options, option)
	for i = 1, #stage_options do
		if stage_options[i] == option then
			return false
		end
	end

	return true
end

MinigameDefuse.generate_board = function (self, seed)
	self._start_seed = seed

	local options = self._options
	local targets = self._targets

	table.clear(options)
	table.clear(targets)

	local t_index

	for s = 1, self._stage_amount do
		local stage_options = {}

		for i = 1, self._option_amount do
			repeat
				seed, t_index = math.next_random(seed, 1, 28)
			until _option_is_new(stage_options, t_index)

			stage_options[i] = t_index
		end

		options[s] = stage_options
		seed, t_index = math.next_random(seed, 1, self._option_amount)
		targets[s] = stage_options[t_index]
	end

	self._selected = math.ceil(self._option_amount / 2)
	self._seed = seed
end

MinigameDefuse.set_state = function (self, state)
	MinigameDefuse.super.set_state(self, state)

	self._state_start_time = Managers.time:time("gameplay")
end

MinigameDefuse.update = function (self, dt, t)
	MinigameDefuse.super.update(self, dt, t)

	if not self._is_server then
		return
	end

	if self._current_state == MinigameSettings.game_states.transition and t - self._state_start_time > MinigameSettings.defuse_transition_time then
		self:set_state(MinigameSettings.game_states.gameplay)
	end
end

MinigameDefuse.on_action_pressed = function (self, t)
	MinigameDefuse.super.on_action_pressed(self, t)

	if self._current_state ~= MinigameSettings.game_states.gameplay then
		return
	end

	local is_action_on_target = self:is_on_target()

	if is_action_on_target then
		local stage_amount = self._stage_amount

		self._current_stage = math.min(self._current_stage + 1, stage_amount + 1)
		self._last_click_success = true

		self:set_state(MinigameSettings.game_states.transition)

		if self._current_stage > self._stage_amount then
			Unit.flow_event(self._minigame_unit, "lua_minigame_success_last")
			self:play_sound("sfx_minigame_success_last")
		else
			Unit.flow_event(self._minigame_unit, "lua_minigame_success")
			self:play_sound("sfx_minigame_success")
		end
	else
		self._current_stage = math.max(self._current_stage - 1, 1)
		self._last_click_success = false

		self:set_state(MinigameSettings.game_states.transition)
		Unit.flow_event(self._minigame_unit, "lua_minigame_fail")
		self:play_sound("sfx_minigame_fail")
	end

	self:send_rpc("rpc_minigame_sync_set_stage", self._current_stage)
end

MinigameDefuse.on_axis_set = function (self, t, x, y)
	MinigameDefuse.super.on_axis_set(self, t, x, y)

	if self._current_state ~= MinigameSettings.game_states.gameplay then
		return
	end

	local abs_x = math.abs(x)
	local dead_zone = MinigameSettings.decode_move_deadzone

	if abs_x < dead_zone then
		self._last_move = 0
	elseif t > self._last_move + MinigameSettings.decode_move_delay then
		self._last_move = t

		if dead_zone <= abs_x then
			if x < 0 then
				if self._selected > 1 then
					self._selected = self._selected - 1

					self:send_rpc("rpc_minigame_sync_defuse_set_selection", self._selected)
				end
			elseif self._selected < self._option_amount then
				self._selected = self._selected + 1

				self:send_rpc("rpc_minigame_sync_defuse_set_selection", self._selected)
			end
		end
	end
end

MinigameDefuse.uses_joystick = function (self)
	return true
end

MinigameDefuse.should_exit = function (self)
	if self._current_state == MinigameSettings.game_states.outro and Managers.time:time("gameplay") - self._state_start_time > MinigameSettings.defuse_transition_time then
		return true
	end

	return false
end

MinigameDefuse.is_on_target = function (self)
	local stage = self._current_stage

	if not stage or #self._targets == 0 then
		return false
	end

	if self._current_state == MinigameSettings.game_states.transition or self._current_state == MinigameSettings.game_states.outro then
		stage = stage - 1
	end

	return self._options[stage][self._selected] == self._targets[stage]
end

MinigameDefuse.options = function (self)
	return self._options
end

MinigameDefuse.targets = function (self)
	return self._targets
end

MinigameDefuse.selected = function (self)
	return self._selected
end

MinigameDefuse.set_selection = function (self, selection)
	self._selected = selection
end

MinigameDefuse.state_start_time = function (self)
	return Managers.time:time("gameplay") - self._state_start_time
end

MinigameDefuse.last_click_success = function (self)
	return self._last_click_success
end

return MinigameDefuse
