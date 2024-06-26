﻿-- chunkname: @scripts/extension_systems/minigame/minigames/minigame_decode_symbols.lua

local MinigameSettings = require("scripts/settings/minigame/minigame_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local LagCompensation = require("scripts/utilities/lag_compensation")

require("scripts/extension_systems/minigame/minigames/minigame_base")

local FX_SOURCE_NAME = "_speaker"
local MinigameDecodeSymbols = class("MinigameDecodeSymbols", "MinigameBase")

MinigameDecodeSymbols.init = function (self, unit, is_server, seed)
	MinigameDecodeSymbols.super.init(self, unit, is_server, seed)

	self._decode_symbols_sweep_duration = MinigameSettings.decode_symbols_sweep_duration
	self._stage_amount = MinigameSettings.decode_symbols_stage_amount
	self._decode_symbols_items_per_stage = MinigameSettings.decode_symbols_items_per_stage
	self._decode_symbols_total_items = MinigameSettings.decode_symbols_total_items
	self._symbols = {}
	self._decode_targets = {}
	self._decode_start_time = nil
	self._misses_per_player = {}

	Unit.set_flow_variable(unit, "lua_auspex_scanner_speed", MinigameSettings.decode_symbols_sweep_duration)
end

MinigameDecodeSymbols.hot_join_sync = function (self, sender, channel)
	MinigameDecodeSymbols.super.hot_join_sync(self, sender, channel)

	local decode_targets = self._decode_targets

	for target_stage = 1, #decode_targets do
		self:send_rpc_to_channel(channel, "rpc_minigame_sync_decode_symbols_set_target", target_stage, decode_targets[target_stage])
	end

	if self._decode_start_time then
		local fixed_frame_id = self._decode_start_time / Managers.state.game_session.fixed_time_step

		self:send_rpc_to_channel(channel, "rpc_minigame_sync_decode_symbols_set_start_time", fixed_frame_id)
	end

	local symbols = self._symbols

	if #symbols > 0 then
		self:send_rpc_to_channel(channel, "rpc_minigame_sync_decode_symbols_set_symbols", symbols)
	end
end

MinigameDecodeSymbols._player_miss_target = function (self, player)
	if not player then
		Log.error("MinigameDecodeSymbols", "Trying to access user but there is none")

		return
	end

	local unique_id = player:unique_id()

	self._misses_per_player[unique_id] = (self._misses_per_player[unique_id] or 0) + 1
end

MinigameDecodeSymbols.start = function (self, player)
	MinigameDecodeSymbols.super.start(self, player)
	Unit.flow_event(self._minigame_unit, "lua_minigame_start")

	local is_server = self._is_server

	if is_server then
		local player_unit = player.player_unit
		local visual_loadout_extension = ScriptUnit.extension(player_unit, "visual_loadout_system")
		local fx_sources = visual_loadout_extension:source_fx_for_slot("slot_device")

		Unit.set_flow_variable(self._minigame_unit, "player_unit", player_unit)

		self._fx_extension = ScriptUnit.extension(player_unit, "fx_system")
		self._fx_source_name = fx_sources[FX_SOURCE_NAME]

		local fixed_frame_t = FixedFrame.get_latest_fixed_time()
		local rewind_ms = LagCompensation.rewind_ms(is_server, not player.remote, player)
		local decode_start_time = fixed_frame_t + rewind_ms
		local unit_spawner_manager = Managers.state.unit_spawner
		local is_level_unit, minigame_unit_id = unit_spawner_manager:game_object_id_or_level_index(self._minigame_unit)
		local game_session_manager = Managers.state.game_session
		local fixed_frame_id = decode_start_time / Managers.state.game_session.fixed_time_step

		game_session_manager:send_rpc_clients("rpc_minigame_sync_decode_symbols_set_start_time", minigame_unit_id, is_level_unit, fixed_frame_id)

		self._decode_start_time = decode_start_time
	end
end

MinigameDecodeSymbols.stop = function (self)
	local is_server = self._is_server

	if is_server then
		local player = Managers.player:player_from_session_id(self._player_session_id)

		if self:is_completed() then
			local unique_id = player:unique_id()
			local mistakes = self._misses_per_player[unique_id] or 0

			if player then
				Managers.stats:record_private("hook_hack", player, mistakes)
			end

			local is_human_player = player and player:is_human_controlled()

			if is_human_player then
				Managers.telemetry_events:player_hacked_terminal(player, mistakes)
			end

			table.clear(self._misses_per_player)
		elseif self._current_stage > 1 then
			self:_player_miss_target(player)
		end
	end

	Unit.flow_event(self._minigame_unit, "lua_minigame_stop")

	if is_server then
		self._decode_start_time = nil
		self._current_stage = nil

		table.clear(self._symbols)
	end

	MinigameDecodeSymbols.super.stop(self)
end

MinigameDecodeSymbols.setup_game = function (self)
	MinigameDecodeSymbols.super.setup_game(self)

	local targets = self._decode_targets
	local stage_amount = self._stage_amount
	local total_items = self._decode_symbols_total_items
	local items_per_stage = self._decode_symbols_items_per_stage
	local game_session_manager = Managers.state.game_session
	local unit_spawner_manager = Managers.state.unit_spawner
	local is_level_unit, minigame_unit_id = unit_spawner_manager:game_object_id_or_level_index(self._minigame_unit)
	local seed = self._seed
	local symbols = self._symbols

	table.clear(symbols)

	for i = 1, total_items do
		symbols[i] = i
	end

	seed = table.shuffle(symbols, seed)
	self._symbols = symbols

	game_session_manager:send_rpc_clients("rpc_minigame_sync_decode_symbols_set_symbols", minigame_unit_id, is_level_unit, symbols)
	table.clear(targets)

	for stage = 1, stage_amount do
		local new_seed, rnd_num = math.next_random(seed, 1, items_per_stage)

		targets[#targets + 1] = rnd_num
		seed = new_seed

		game_session_manager:send_rpc_clients("rpc_minigame_sync_decode_symbols_set_target", minigame_unit_id, is_level_unit, stage, rnd_num)
	end

	self._seed = seed
	self._current_stage = 1

	game_session_manager:send_rpc_clients("rpc_minigame_sync_set_stage", minigame_unit_id, is_level_unit, 1)
end

MinigameDecodeSymbols.on_action_pressed = function (self, t)
	MinigameDecodeSymbols.super.on_action_pressed(self, t)

	if self:is_completed() then
		return
	end

	local is_action_on_target = self:is_on_target(t)

	if is_action_on_target then
		local stage_amount = self._stage_amount

		self._current_stage = math.min(self._current_stage + 1, stage_amount + 1)

		if self._current_stage > self._stage_amount then
			Unit.flow_event(self._minigame_unit, "lua_minigame_success_last")
			self:play_sound("sfx_minigame_success_last")
		else
			Unit.flow_event(self._minigame_unit, "lua_minigame_success")
			self:play_sound("sfx_minigame_success")
		end
	else
		local player = Managers.player:player_from_session_id(self._player_session_id)

		self:_player_miss_target(player)

		self._current_stage = math.max(self._current_stage - 1, 1)

		Unit.flow_event(self._minigame_unit, "lua_minigame_fail")
		self:play_sound("sfx_minigame_fail")
	end

	local game_session_manager = Managers.state.game_session
	local unit_spawner_manager = Managers.state.unit_spawner
	local is_level_unit, minigame_unit_id = unit_spawner_manager:game_object_id_or_level_index(self._minigame_unit)

	game_session_manager:send_rpc_clients("rpc_minigame_sync_set_stage", minigame_unit_id, is_level_unit, self._current_stage)
end

MinigameDecodeSymbols.is_on_target = function (self, t)
	local sweep_duration = self._decode_symbols_sweep_duration
	local current_stage = self._current_stage
	local targets = self._decode_targets
	local target = targets[current_stage]
	local target_margin = 1 / (self._decode_symbols_items_per_stage - 1) * sweep_duration
	local start_target = (target - 1.5) * target_margin
	local end_target = (target - 0.5) * target_margin
	local cursor_time = self:_calculate_cursor_time(t)

	return start_target < cursor_time and cursor_time < end_target
end

MinigameDecodeSymbols._calculate_cursor_time = function (self, t)
	local delta_time = t - self._decode_start_time
	local sweep_duration = self._decode_symbols_sweep_duration
	local cursor_time = delta_time % (sweep_duration * 2)

	if sweep_duration < cursor_time then
		cursor_time = 2 * sweep_duration - cursor_time
	end

	return cursor_time
end

MinigameDecodeSymbols.current_decode_target = function (self)
	local decode_current_stage = self._current_stage

	if decode_current_stage then
		return self._decode_targets[decode_current_stage]
	end

	return nil
end

MinigameDecodeSymbols.set_start_time = function (self, time)
	self._decode_start_time = time
end

MinigameDecodeSymbols.set_symbols = function (self, symbols)
	self._symbols = table.shallow_copy(symbols)
end

MinigameDecodeSymbols.set_target = function (self, stage, target)
	self._decode_targets[stage] = target
end

MinigameDecodeSymbols.sweep_duration = function (self)
	return self._decode_symbols_sweep_duration
end

MinigameDecodeSymbols.start_time = function (self)
	return self._decode_start_time
end

MinigameDecodeSymbols.symbols = function (self)
	return self._symbols
end

return MinigameDecodeSymbols
