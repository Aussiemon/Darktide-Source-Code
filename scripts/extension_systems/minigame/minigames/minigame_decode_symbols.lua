local FixedFrame = require("scripts/utilities/fixed_frame")
local LagCompensation = require("scripts/utilities/lag_compensation")

require("scripts/extension_systems/minigame/minigames/minigame_base")

local FX_SOURCE_NAME = "_speaker"
local MinigameDecodeSymbols = class("MinigameDecodeSymbols", "MinigameBase")

MinigameDecodeSymbols.init = function (self, unit, is_server, seed, context)
	MinigameDecodeSymbols.super.init(self, unit, is_server, seed, context)

	self._decode_symbols_sweep_duration = context.decode_symbols_sweep_duration
	self._decode_symbols_stage_amount = context.decode_symbols_stage_amount
	self._decode_symbols_items_per_stage = context.decode_symbols_items_per_stage
	self._decode_symbols_target_margin = context.decode_symbols_target_margin
	self._decode_symbols_total_items = context.decode_symbols_total_items
	self._symbols = {}
	self._decode_targets = {}
	self._decode_current_stage = nil
	self._decode_start_time = nil
	self._decode_misses = nil

	Unit.set_flow_variable(unit, "lua_auspex_scanner_speed", context.decode_symbols_sweep_duration)
end

MinigameDecodeSymbols.hot_join_sync = function (self, sender, channel)
	MinigameDecodeSymbols.super.hot_join_sync(self, sender, channel)

	local unit_spawner_manager = Managers.state.unit_spawner
	local is_level_unit, minigame_unit_id = unit_spawner_manager:game_object_id_or_level_index(self._minigame_unit)
	local game_session_manager = Managers.state.game_session
	local current_decode_stage = self._decode_current_stage

	if current_decode_stage then
		game_session_manager:send_rpc_clients("rpc_minigame_sync_decode_symbols_set_stage", minigame_unit_id, is_level_unit, current_decode_stage)
	end

	local decode_targets = self._decode_targets

	for target_stage = 1, #decode_targets do
		game_session_manager:send_rpc_clients("rpc_minigame_sync_decode_symbols_set_target", minigame_unit_id, is_level_unit, target_stage, decode_targets[target_stage])
	end

	if self._decode_start_time then
		local fixed_frame_id = self._decode_start_time / GameParameters.fixed_time_step

		game_session_manager:send_rpc_clients("rpc_minigame_sync_decode_symbols_set_start_time", minigame_unit_id, is_level_unit, fixed_frame_id)
	end

	local symbols = self._symbols

	game_session_manager:send_rpc_clients("rpc_minigame_sync_decode_symbols_set_symbols", minigame_unit_id, is_level_unit, symbols)
end

MinigameDecodeSymbols.start = function (self, player)
	MinigameDecodeSymbols.super.start(self, player)
	Unit.flow_event(self._minigame_unit, "lua_minigame_start")

	local is_server = self._is_server

	if is_server then
		local player_unit = player.player_unit
		local visual_loadout_extension = ScriptUnit.extension(player_unit, "visual_loadout_system")
		local fx_sources = visual_loadout_extension:source_fx_for_slot("slot_device")
		self._fx_extension = ScriptUnit.extension(player_unit, "fx_system")
		self._fx_source_name = fx_sources[FX_SOURCE_NAME]
		local fixed_frame_t = FixedFrame.get_latest_fixed_time()
		local rewind_ms = LagCompensation.rewind_ms(is_server, not player.remote, player)
		local decode_start_time = fixed_frame_t + rewind_ms
		local unit_spawner_manager = Managers.state.unit_spawner
		local is_level_unit, minigame_unit_id = unit_spawner_manager:game_object_id_or_level_index(self._minigame_unit)
		local game_session_manager = Managers.state.game_session
		local fixed_frame_id = decode_start_time / GameParameters.fixed_time_step

		game_session_manager:send_rpc_clients("rpc_minigame_sync_decode_symbols_set_start_time", minigame_unit_id, is_level_unit, fixed_frame_id)

		self._decode_misses = 0
		self._decode_start_time = decode_start_time
	end
end

MinigameDecodeSymbols.stop = function (self)
	local is_server = self._is_server

	if is_server and DEDICATED_SERVER then
		local player_or_nil = Managers.player:player_from_session_id(self._player_session_id)
		local is_human_player = player_or_nil and player_or_nil:is_human_controlled()
		local is_completed = self:is_completed()

		if is_human_player and is_completed then
			Managers.stats:record_hacked_terminal(player_or_nil, self._decode_misses)
			Managers.telemetry_events:player_hacked_terminal(player_or_nil, self._decode_misses)
		end
	end

	Unit.flow_event(self._minigame_unit, "lua_minigame_stop")

	if self._is_server then
		self._decode_start_time = nil
		self._decode_current_stage = nil
		self._decode_misses = nil

		table.clear(self._symbols)
	end

	MinigameDecodeSymbols.super.stop(self)
end

MinigameDecodeSymbols.setup_game = function (self)
	MinigameDecodeSymbols.super.setup_game(self)

	local targets = self._decode_targets
	local stage_amount = self._decode_symbols_stage_amount
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
	self._decode_current_stage = 1

	game_session_manager:send_rpc_clients("rpc_minigame_sync_decode_symbols_set_stage", minigame_unit_id, is_level_unit, 1)
end

MinigameDecodeSymbols.on_action_pressed = function (self, t)
	MinigameDecodeSymbols.super.on_action_pressed(self, t)

	if self:is_completed() then
		return
	end

	local sweep_duration = self._decode_symbols_sweep_duration
	local current_stage = self._decode_current_stage
	local targets = self._decode_targets
	local target = targets[current_stage]
	local target_margin = self._decode_symbols_target_margin * sweep_duration
	local start_target = (target - 1) * target_margin
	local end_target = target * target_margin
	local cursor_time = self:_calculate_cursor_time(t)
	local is_action_on_target = start_target < cursor_time and cursor_time < end_target
	local fx_extension = self._fx_extension
	local sync_with_clients = true
	local include_client = true

	if is_action_on_target then
		local stage_amount = self._decode_symbols_stage_amount
		self._decode_current_stage = math.min(self._decode_current_stage + 1, stage_amount + 1)

		if self._decode_symbols_stage_amount < self._decode_current_stage then
			Unit.flow_event(self._minigame_unit, "lua_minigame_success_last")
			fx_extension:trigger_gear_wwise_event_with_source("sfx_minigame_success_last", nil, self._fx_source_name, sync_with_clients, include_client)
		else
			Unit.flow_event(self._minigame_unit, "lua_minigame_success")
			fx_extension:trigger_gear_wwise_event_with_source("sfx_minigame_success", nil, self._fx_source_name, sync_with_clients, include_client)
		end
	else
		self._decode_misses = self._decode_misses + 1
		self._decode_current_stage = math.max(self._decode_current_stage - 1, 1)

		Unit.flow_event(self._minigame_unit, "lua_minigame_fail")
		fx_extension:trigger_gear_wwise_event_with_source("sfx_minigame_fail", nil, self._fx_source_name, sync_with_clients, include_client)
	end

	local game_session_manager = Managers.state.game_session
	local unit_spawner_manager = Managers.state.unit_spawner
	local is_level_unit, minigame_unit_id = unit_spawner_manager:game_object_id_or_level_index(self._minigame_unit)

	game_session_manager:send_rpc_clients("rpc_minigame_sync_decode_symbols_set_stage", minigame_unit_id, is_level_unit, self._decode_current_stage)
end

MinigameDecodeSymbols._calculate_cursor_time = function (self, t)
	fassert(self._decode_start_time, "[MinigameDecodeSymbols][_calculate_cursor_time] start time is nil.")

	local delta_time = t - self._decode_start_time
	local sweep_duration = self._decode_symbols_sweep_duration
	local cursor_time = delta_time % (sweep_duration * 2)

	if sweep_duration < cursor_time then
		cursor_time = 2 * sweep_duration - cursor_time
	end

	return cursor_time
end

MinigameDecodeSymbols.is_completed = function (self)
	local stage_amount = self._decode_symbols_stage_amount
	local current_stage = self._decode_current_stage

	if current_stage then
		return stage_amount < current_stage
	end

	return false
end

MinigameDecodeSymbols.current_decode_target = function (self)
	local decode_current_stage = self._decode_current_stage

	if decode_current_stage then
		return self._decode_targets[decode_current_stage]
	end

	return nil
end

MinigameDecodeSymbols.set_current_stage = function (self, stage)
	fassert(not self._is_server, "[MinigameDecodeSymbols][set_current_stage] Client only method.")

	if self._decode_current_stage then
		if stage < self._decode_current_stage then
			Unit.flow_event(self._minigame_unit, "lua_minigame_fail")
		elseif self._decode_current_stage < stage then
			if self._decode_symbols_stage_amount < stage then
				Unit.flow_event(self._minigame_unit, "lua_minigame_success_last")
			else
				Unit.flow_event(self._minigame_unit, "lua_minigame_success")
			end
		end
	end

	self._decode_current_stage = stage
end

MinigameDecodeSymbols.set_start_time = function (self, time)
	fassert(not self._is_server, "[MinigameDecodeSymbols][set_start_time] Client only method.")

	self._decode_start_time = time
end

MinigameDecodeSymbols.set_symbols = function (self, symbols)
	fassert(not self._is_server, "[MinigameDecodeSymbols][set_symbols] Client only method.")

	self._symbols = table.shallow_copy(symbols)
end

MinigameDecodeSymbols.set_target = function (self, stage, target)
	fassert(not self._is_server, "[MinigameDecodeSymbols][set_target] Client only method.")

	self._decode_targets[stage] = target
end

MinigameDecodeSymbols.current_stage = function (self)
	return self._decode_current_stage
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
