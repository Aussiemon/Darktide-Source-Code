-- chunkname: @scripts/extension_systems/minigame/minigames/minigame_frequency.lua

local MinigameSettings = require("scripts/settings/minigame/minigame_settings")

require("scripts/extension_systems/minigame/minigames/minigame_base")

local FX_SOURCE_NAME = "_speaker"
local WWISE_PARAMETER_NAME_SINUS_A_X = "auspex_a_h"
local WWISE_PARAMETER_NAME_SINUS_A_Y = "auspex_a_w"
local WWISE_PARAMETER_NAME_SINUS_B_X = "auspex_b_h"
local WWISE_PARAMETER_NAME_SINUS_B_Y = "auspex_b_w"
local WWISE_PARAMETER_NAME_SINUS_B_GOAL = "auspex_b_goal"
local MinigameFrequency = class("MinigameFrequency", "MinigameBase")

MinigameFrequency.init = function (self, unit, is_server, seed, context)
	MinigameFrequency.super.init(self, unit, is_server, seed, context)

	self._start_seed = seed
	self._frequency = {
		x = 0,
		y = 0,
	}
	self._target_frequency = {
		x = 0,
		y = 0,
	}
	self._last_axis_set = 0
	self._stage_amount = MinigameSettings.frequency_search_stage_amount
end

MinigameFrequency.hot_join_sync = function (self, sender, channel)
	MinigameFrequency.super.hot_join_sync(self, sender, channel)

	if self._current_stage then
		self:send_rpc_to_channel(channel, "rpc_minigame_sync_frequency_set_target_frequency", self._target_frequency.x, self._target_frequency.y)
		self:send_rpc("rpc_minigame_sync_generate_board", self._start_seed)
	end
end

MinigameFrequency.start = function (self, player)
	MinigameFrequency.super.start(self, player)
	Unit.flow_event(self._minigame_unit, "lua_minigame_start")

	if player then
		local player_unit = player.player_unit

		Unit.set_flow_variable(self._minigame_unit, "player_unit", player_unit)
		self:_setup_sound(player, FX_SOURCE_NAME)
	end

	if self._is_server then
		self:_change_target_frequency()
	end

	self:_update_frequency_sound(self._frequency)
end

MinigameFrequency.stop = function (self)
	Unit.flow_event(self._minigame_unit, "lua_minigame_stop")
	MinigameFrequency.super.stop(self)

	if self._is_server then
		self._current_stage = nil
	end
end

MinigameFrequency._get_random_frequency = function (self, seed)
	local tx, ty

	seed, tx = math.next_random(seed, MinigameSettings.frequency_width_min_scale * 100, MinigameSettings.frequency_width_max_scale * 100)
	seed, ty = math.next_random(seed, MinigameSettings.frequency_height_min_scale * 100, MinigameSettings.frequency_height_max_scale * 100)

	return seed, {
		x = tx / 100,
		y = ty / 100,
	}
end

MinigameFrequency.setup_game = function (self)
	MinigameFrequency.super.setup_game(self)
	self:generate_board(self._seed)
	self:send_rpc("rpc_minigame_sync_generate_board", self._start_seed)

	self._current_stage = 1

	self:send_rpc("rpc_minigame_sync_set_stage", self._current_stage)
end

MinigameFrequency.generate_board = function (self, seed)
	self._seed = seed
	self._seed, self._frequency = self:_get_random_frequency(self._seed)
end

MinigameFrequency._change_target_frequency = function (self)
	self._seed, self._target_frequency = self:_get_random_frequency(self._seed)

	while math.abs(self._frequency.x - self._target_frequency.x) < MinigameSettings.frequency_success_margin or math.abs(self._frequency.y - self._target_frequency.y) < MinigameSettings.frequency_success_margin do
		self._seed, self._target_frequency = self:_get_random_frequency(self._seed)
	end

	self:send_rpc("rpc_minigame_sync_frequency_set_target_frequency", self._target_frequency.x, self._target_frequency.y)
	self:_set_frequency_target_sound(self._target_frequency)
end

MinigameFrequency.on_action_pressed = function (self, t)
	MinigameFrequency.super.on_action_pressed(self, t)

	if self:is_completed() then
		return
	end

	if not self._is_server then
		self:send_rpc_to_server("rpc_minigame_sync_frequency_test_frequency", self._frequency.x, self._frequency.y)
	end
end

MinigameFrequency._adjust_value_with_auto_aim = function (self, current_value, target_value, change_ratio, dt, min_scale, max_scale, input)
	local new_value = math.clamp(current_value + input * change_ratio * dt, min_scale, max_scale)
	local to_target = math.abs(new_value - target_value)

	if MinigameSettings.frequency_help_enabled and to_target < MinigameSettings.frequency_help_margin then
		local adjustment = (1 - to_target / MinigameSettings.frequency_help_margin) * MinigameSettings.frequency_help_power * dt

		if to_target < adjustment then
			new_value = target_value
		else
			if new_value - target_value > 0 then
				adjustment = -adjustment
			end

			new_value = new_value + adjustment
		end
	end

	return new_value
end

MinigameFrequency.on_axis_set = function (self, t, x, y)
	MinigameFrequency.super.on_axis_set(self, t, x, y)

	if self:is_completed() then
		return
	end

	local dt = t - self._last_axis_set

	self._last_axis_set = t

	local changed = false

	if x ~= 0 then
		local old_x = self._frequency.x
		local new_x = self:_adjust_value_with_auto_aim(old_x, self._target_frequency.x, MinigameSettings.frequency_change_ratio_x, dt, MinigameSettings.frequency_width_min_scale, MinigameSettings.frequency_width_max_scale, x)

		if old_x ~= new_x then
			self:play_sound("sfx_minigame_sinus_adjust_x")

			self._frequency.x = new_x
			changed = true
		end
	end

	if y ~= 0 then
		local old_y = self._frequency.y
		local new_y = self:_adjust_value_with_auto_aim(old_y, self._target_frequency.y, MinigameSettings.frequency_change_ratio_y, dt, MinigameSettings.frequency_height_min_scale, MinigameSettings.frequency_height_max_scale, y)

		if old_y ~= new_y then
			self:play_sound("sfx_minigame_sinus_adjust_y")

			self._frequency.y = new_y
			changed = true
		end
	end

	if changed then
		self:_update_frequency_sound(self._frequency)
	end
end

MinigameFrequency.update = function (self, dt, t)
	MinigameFrequency.super.update(self, dt, t)

	if MinigameSettings.frequency_directional_control and not DEDICATED_SERVER then
		local local_player = Managers.player:local_player(1)
		local viewport_name = local_player.viewport_name
		local camera_rotation = Managers.state.camera:camera_rotation(viewport_name)
		local yaw = Quaternion.yaw(camera_rotation)
		local pitch = Quaternion.pitch(camera_rotation)
		local yaw_change = yaw - (self._old_yaw or 0)

		if yaw_change > math.pi then
			yaw_change = yaw_change - math.pi * 2
		end

		if yaw_change < -math.pi then
			yaw_change = yaw_change + math.pi * 2
		end

		local pitch_change = pitch - (self._old_pitch or 0)

		if pitch_change > math.pi then
			pitch_change = pitch_change - math.pi * 2
		end

		if pitch_change < -math.pi then
			pitch_change = pitch_change + math.pi * 2
		end

		self._old_yaw = yaw
		self._old_pitch = pitch

		local change_ratio = MinigameSettings.frequency_driection_change_ratio

		self:on_axis_set(t, yaw_change * change_ratio, pitch_change * change_ratio)
	end
end

MinigameFrequency.uses_joystick = function (self)
	return true
end

MinigameFrequency.is_visually_on_target = function (self)
	if not self._frequency then
		return false
	end

	if self:_is_frequency_on_target(self._frequency.x, self._frequency.y) then
		return true
	end

	return false
end

MinigameFrequency._is_frequency_on_target = function (self, x, y)
	if not self._target_frequency then
		return false
	end

	if math.abs(x - self._target_frequency.x) < MinigameSettings.frequency_success_margin and math.abs(y - self._target_frequency.y) < MinigameSettings.frequency_success_margin then
		return true
	end
end

MinigameFrequency.frequency = function (self)
	return self._frequency
end

MinigameFrequency.target_frequency = function (self)
	return self._target_frequency
end

MinigameFrequency.test_frequency = function (self, x, y)
	if self._current_state ~= MinigameSettings.game_states.gameplay then
		return
	end

	if self:_is_frequency_on_target(x, y) then
		local stage_amount = self._stage_amount

		self._current_stage = math.min(self._current_stage + 1, stage_amount + 1)

		if self._current_stage > self._stage_amount then
			Unit.flow_event(self._minigame_unit, "lua_minigame_success_last")
			self:play_sound("sfx_minigame_sinus_success_last")
		else
			self:_change_target_frequency()
			Unit.flow_event(self._minigame_unit, "lua_minigame_success")
			self:play_sound("sfx_minigame_success")
		end
	else
		if self._current_stage > 1 then
			self:_change_target_frequency()
		end

		self._current_stage = math.max(self._current_stage - 1, 1)

		Unit.flow_event(self._minigame_unit, "lua_minigame_fail")
		self:play_sound("sfx_minigame_bio_fail")
	end

	self:send_rpc("rpc_minigame_sync_set_stage", self._current_stage)
end

MinigameFrequency.set_target_frequency = function (self, x, y)
	self._target_frequency.x = x
	self._target_frequency.y = y

	self:_set_frequency_target_sound(self._target_frequency)
end

local TEMP_FREQ_PERCENT = {
	x = 0,
	y = 0,
}

MinigameFrequency._frequency_to_percentage = function (self, frequency)
	local x_percent = (frequency.x - MinigameSettings.frequency_width_min_scale) / (MinigameSettings.frequency_width_max_scale - MinigameSettings.frequency_width_min_scale)
	local y_percent = (frequency.y - MinigameSettings.frequency_height_min_scale) / (MinigameSettings.frequency_height_max_scale - MinigameSettings.frequency_height_min_scale)

	x_percent = math.clamp(x_percent, 0, 1)
	y_percent = math.clamp(y_percent, 0, 1)
	TEMP_FREQ_PERCENT.x = x_percent
	TEMP_FREQ_PERCENT.y = y_percent

	return TEMP_FREQ_PERCENT
end

MinigameFrequency._update_frequency_sound = function (self, frequency)
	local freq_percent = self:_frequency_to_percentage(frequency)

	self:set_parameter_sound(WWISE_PARAMETER_NAME_SINUS_B_X, freq_percent.x)
	self:set_parameter_sound(WWISE_PARAMETER_NAME_SINUS_B_Y, freq_percent.y)

	if self._target_frequency then
		local alignment = self:_calculate_frequency_alignment(frequency, self._target_frequency)

		self:set_parameter_sound(WWISE_PARAMETER_NAME_SINUS_B_GOAL, alignment)
	end
end

MinigameFrequency._set_frequency_target_sound = function (self, frequency)
	local freq_percent = self:_frequency_to_percentage(frequency)

	self:set_parameter_sound(WWISE_PARAMETER_NAME_SINUS_A_X, freq_percent.x)
	self:set_parameter_sound(WWISE_PARAMETER_NAME_SINUS_A_Y, freq_percent.y)
end

MinigameFrequency._calculate_frequency_alignment = function (self, current, target)
	local x_diff = math.abs(current.x - target.x)
	local y_diff = math.abs(current.y - target.y)
	local x_max_range = MinigameSettings.frequency_width_max_scale - MinigameSettings.frequency_width_min_scale
	local y_max_range = MinigameSettings.frequency_height_max_scale - MinigameSettings.frequency_height_min_scale
	local normalized_x_range = math.min(x_diff / x_max_range, 1)
	local normalized_y_range = math.min(y_diff / y_max_range, 1)
	local combined_range = (normalized_x_range + normalized_y_range) / 2
	local alignment = math.clamp(1 - combined_range, 0, 1)

	if x_diff <= MinigameSettings.frequency_success_margin and y_diff <= MinigameSettings.frequency_success_margin then
		alignment = 1
	end

	return alignment
end

return MinigameFrequency
