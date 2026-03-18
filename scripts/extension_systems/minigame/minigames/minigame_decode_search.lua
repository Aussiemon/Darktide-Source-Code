-- chunkname: @scripts/extension_systems/minigame/minigames/minigame_decode_search.lua

local MinigameSettings = require("scripts/settings/minigame/minigame_settings")

require("scripts/extension_systems/minigame/minigames/minigame_base")

local FX_SOURCE_NAME = "_speaker"
local MinigameDecodeSearch = class("MinigameDecodeSearch", "MinigameBase")

MinigameDecodeSearch.init = function (self, unit, is_server, seed, context)
	MinigameDecodeSearch.super.init(self, unit, is_server, seed, context)

	self._start_seed = seed
	self._stage_amount = MinigameSettings.decode_search_stage_amount
	self._board_width = MinigameSettings.decode_search_board_width
	self._board_height = MinigameSettings.decode_search_board_height
	self._cursor_width = MinigameSettings.decode_search_cursor_width
	self._cursor_height = MinigameSettings.decode_search_cursor_height
	self._cursor_position = nil
	self._last_move = 0
	self._moved_time = nil
	self._state_start_time = nil
	self._decode_symbols_total_items = MinigameSettings.decode_symbols_total_items
	self._symbols = {}
	self._decode_targets = {}
	self._misses_per_player = {}
end

MinigameDecodeSearch.hot_join_sync = function (self, sender, channel)
	MinigameDecodeSearch.super.hot_join_sync(self, sender, channel)

	if #self._symbols > 0 then
		self:send_rpc_to_channel(channel, "rpc_minigame_sync_generate_board", self._start_seed)
	end

	if self._cursor_position then
		self:send_rpc_to_channel(channel, "rpc_minigame_sync_decode_search_set_cursor", self._cursor_position.x, self._cursor_position.y)
	end
end

MinigameDecodeSearch._player_miss_target = function (self, player)
	local unique_id = player:unique_id()

	self._misses_per_player[unique_id] = (self._misses_per_player[unique_id] or 0) + 1
end

MinigameDecodeSearch.start = function (self, player, send_to_self_client)
	MinigameDecodeSearch.super.start(self, player, send_to_self_client)
	Unit.flow_event(self._minigame_unit, "lua_minigame_start")

	if player then
		self:_setup_sound(player, FX_SOURCE_NAME)

		local player_unit = player.player_unit

		Unit.set_flow_variable(self._minigame_unit, "player_unit", player_unit)
	end
end

MinigameDecodeSearch.stop = function (self)
	local is_server = self._is_server

	if is_server then
		local player = Managers.player:player_from_session_id(self._player_session_id)

		if not player then
			return
		end

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
		elseif self._current_stage and self._current_stage > 1 then
			self:_player_miss_target(player)
		end
	end

	Unit.flow_event(self._minigame_unit, "lua_minigame_stop")
	MinigameDecodeSearch.super.stop(self)
end

MinigameDecodeSearch.setup_game = function (self)
	MinigameDecodeSearch.super.setup_game(self)

	if #self._decode_targets == 0 then
		self:generate_board(self._seed)
		self:send_rpc("rpc_minigame_sync_generate_board", self._start_seed)

		self._current_stage = 1

		self:send_rpc("rpc_minigame_sync_set_stage", 1)
	end

	self._cursor_position = {
		x = math.floor(self._board_width / 2),
		y = math.floor(self._board_height / 2),
	}

	self:send_rpc("rpc_minigame_sync_decode_search_set_cursor", self._cursor_position.x, self._cursor_position.y)
end

MinigameDecodeSearch.generate_board = function (self, seed)
	self._start_seed = seed

	local total_items = self._board_width * self._board_height
	local symbols = self._symbols
	local decode_search_symbols = MinigameSettings.decode_search_symbols
	local symbol_count = #decode_search_symbols
	local board_symbols = {}
	local t_index

	for i = 1, symbol_count do
		seed, t_index = math.next_random(seed, 1, #decode_search_symbols[i])
		board_symbols[i] = decode_search_symbols[i][t_index]
	end

	table.clear(symbols)

	for i = 1, total_items do
		seed, t_index = math.next_random(seed, 1, symbol_count)
		symbols[i] = board_symbols[t_index]
	end

	local targets = self._decode_targets
	local stage_amount = self._stage_amount

	table.clear(targets)

	local last_x = math.floor(self._board_width / 2)
	local last_y = math.floor(self._board_height / 2)

	for stage = 1, stage_amount do
		local x_pos, y_pos = last_x, last_y

		while x_pos == last_x and y_pos == last_y do
			seed, x_pos = math.next_random(seed, 1, self._board_width - self._cursor_width + 1)
			seed, y_pos = math.next_random(seed, 1, self._board_height - self._cursor_height + 1)
		end

		last_x = x_pos
		last_y = y_pos
		targets[#targets + 1] = table.clone(self:get_symbols_for_target(x_pos, y_pos))
	end

	self._seed = seed
end

local TEMP_SYMBOL_ARRAY = {}

MinigameDecodeSearch.get_symbols_for_target = function (self, target_x, target_y)
	local symbols = self._symbols

	table.clear(TEMP_SYMBOL_ARRAY)

	for y = 1, self._cursor_height do
		for x = 1, self._cursor_width do
			TEMP_SYMBOL_ARRAY[#TEMP_SYMBOL_ARRAY + 1] = symbols[target_x + (x - 1) + (target_y + (y - 2)) * self._board_width]
		end
	end

	return TEMP_SYMBOL_ARRAY
end

MinigameDecodeSearch.set_state = function (self, state)
	MinigameDecodeSearch.super.set_state(self, state)

	self._state_start_time = Managers.time:time("gameplay")
end

MinigameDecodeSearch.update = function (self, dt, t)
	MinigameDecodeSearch.super.update(self, dt, t)

	if not self._is_server then
		return
	end

	if self._current_state == MinigameSettings.game_states.transition and t - self._state_start_time > MinigameSettings.decode_transition_time then
		self:set_state(MinigameSettings.game_states.gameplay)
	end
end

MinigameDecodeSearch.on_action_pressed = function (self, t)
	MinigameDecodeSearch.super.on_action_pressed(self, t)

	if self._current_state ~= MinigameSettings.game_states.gameplay or not self._is_server then
		return
	end

	local is_action_on_target = self:is_on_target()

	if is_action_on_target then
		local stage_amount = self._stage_amount

		self._current_stage = math.min(self._current_stage + 1, stage_amount + 1)

		self:set_state(MinigameSettings.game_states.transition)

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

	self:send_rpc("rpc_minigame_sync_set_stage", self._current_stage)
end

MinigameDecodeSearch.on_axis_set = function (self, t, x, y)
	MinigameDecodeSearch.super.on_axis_set(self, t, x, y)

	if not self._is_server then
		return
	end

	if self._current_state ~= MinigameSettings.game_states.gameplay then
		return
	end

	y = -y

	local abs_x = math.abs(x)
	local abs_y = math.abs(y)
	local dead_zone = MinigameSettings.decode_move_deadzone

	if abs_x < dead_zone and abs_y < dead_zone then
		self._last_move = 0
	elseif t > self._last_move + MinigameSettings.decode_move_delay then
		self._last_move = t

		if dead_zone <= abs_x then
			if x < 0 then
				if self._cursor_position.x > 1 then
					self._moved_time = t
					self._cursor_position.x = self._cursor_position.x - 1

					self:send_rpc("rpc_minigame_sync_decode_search_set_cursor", self._cursor_position.x, self._cursor_position.y)
				end
			elseif self._cursor_position.x < self._board_width - self._cursor_width + 1 then
				self._moved_time = t
				self._cursor_position.x = self._cursor_position.x + 1

				self:send_rpc("rpc_minigame_sync_decode_search_set_cursor", self._cursor_position.x, self._cursor_position.y)
			end
		end

		if dead_zone <= abs_y then
			if y < 0 then
				if self._cursor_position.y > 1 then
					self._moved_time = t
					self._cursor_position.y = self._cursor_position.y - 1

					self:send_rpc("rpc_minigame_sync_decode_search_set_cursor", self._cursor_position.x, self._cursor_position.y)
				end
			elseif self._cursor_position.y < self._board_height - self._cursor_height + 1 then
				self._moved_time = t
				self._cursor_position.y = self._cursor_position.y + 1

				self:send_rpc("rpc_minigame_sync_decode_search_set_cursor", self._cursor_position.x, self._cursor_position.y)
			end
		end
	end
end

MinigameDecodeSearch.uses_joystick = function (self)
	return true
end

MinigameDecodeSearch.should_exit = function (self)
	if self._current_state == MinigameSettings.game_states.outro and Managers.time:time("gameplay") - self._state_start_time > MinigameSettings.decode_transition_time then
		return true
	end

	return false
end

MinigameDecodeSearch.is_on_target = function (self)
	local target = self:current_decode_target()

	if not target then
		return false
	end

	local selected_symbols = self:get_symbols_for_target(self._cursor_position.x, self._cursor_position.y)

	for i = 1, #target do
		if target[i] ~= selected_symbols[i] then
			return false
		end
	end

	return true
end

MinigameDecodeSearch.decode_targets = function (self)
	return self._decode_targets
end

MinigameDecodeSearch.current_decode_target = function (self)
	local decode_current_stage = self._current_stage

	if decode_current_stage then
		return self._decode_targets[decode_current_stage]
	end

	return nil
end

MinigameDecodeSearch.set_cursor_position = function (self, x, y)
	if not self._cursor_position then
		self._cursor_position = {}
	end

	self._cursor_position.x = x
	self._cursor_position.y = y
	self._moved_time = Managers.time:time("gameplay")
end

MinigameDecodeSearch.set_symbols = function (self, symbols)
	self._symbols = table.shallow_copy(symbols)
end

MinigameDecodeSearch.cursor_position = function (self)
	return self._cursor_position
end

MinigameDecodeSearch.symbols = function (self)
	return self._symbols
end

MinigameDecodeSearch.time_since_move = function (self)
	if not self._moved_time then
		return 0
	end

	return Managers.time:time("gameplay") - self._moved_time
end

return MinigameDecodeSearch
