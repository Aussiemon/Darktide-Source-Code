-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_training_grounds.lua

local FixedFrame = require("scripts/utilities/fixed_frame")
local GameModeBase = require("scripts/managers/game_mode/game_modes/game_mode_base")
local GameModeTrainingGrounds = class("GameModeTrainingGrounds", "GameModeBase")

local function _log(...)
	Log.info("GameModeTrainingGrounds", ...)
end

GameModeTrainingGrounds.init = function (self, game_mode_context, game_mode_name, network_event_delegate)
	GameModeTrainingGrounds.super.init(self, game_mode_context, game_mode_name, network_event_delegate)
	Managers.event:register(self, "event_loading_finished", "_on_loading_finished")

	self._init_scenario = nil
end

GameModeTrainingGrounds.set_init_scenario = function (self, scenario_alias, scenario_name)
	self._init_scenario = {
		alias = scenario_alias,
		name = scenario_name,
	}
end

GameModeTrainingGrounds._game_mode_state_changed = function (self, new_state, old_state)
	_log("[_game_mode_state_changed] new_state: %s; old_state: %s", new_state, old_state)

	if new_state == "in_game" then
		local settings = self._settings

		if settings.force_base_talents then
			local player = Managers.player:local_player(1)

			self:_force_base_talents(player)
		end

		local scenario_system = Managers.state.extension:system("scripted_scenario_system")
		local init_scenario = self._init_scenario
		local default_scenario = settings.default_init_scripted_scenario

		if init_scenario then
			scenario_system:queue_scenario(init_scenario.alias, init_scenario.name)
		elseif default_scenario then
			scenario_system:queue_scenario(default_scenario.alias, default_scenario.name)
		end

		scenario_system:on_level_enter()
	end
end

GameModeTrainingGrounds._on_loading_finished = function (self)
	Managers.event:unregister(self, "event_loading_finished")
	self:_change_state("in_game")
end

GameModeTrainingGrounds.evaluate_end_conditions = function (self)
	local current_state = self:state()

	if current_state == "loading" then
		return false
	elseif current_state == "in_game" then
		local failed = self._failed
		local completed = self._completed

		if completed or failed then
			local t = Managers.time:time("gameplay")

			self._leave_game_t = t + 2.5

			local scenario_system = Managers.state.extension:system("scripted_scenario_system")

			scenario_system:stop_scenario(t, nil, true)
			scenario_system:on_level_exit()
			scenario_system:set_enabled(false)
			self:_change_state("leaving_game")
		end
	elseif current_state == "leaving_game" then
		local t = Managers.time:time("gameplay")

		if t > self._leave_game_t then
			return true, "won"
		end
	end

	return false
end

GameModeTrainingGrounds.complete = function (self, reason, triggered_from_flow)
	self._completed = true
end

GameModeTrainingGrounds.fail = function (self)
	self._failed = true
end

GameModeTrainingGrounds._force_base_talents = function (self, player)
	local profile = player:profile()
	local fixed_t = FixedFrame.get_latest_fixed_time()
	local base_talents = profile.archetype.base_talents
	local talent_extension = ScriptUnit.extension(player.player_unit, "talent_system")

	talent_extension:select_new_talents(base_talents, fixed_t)
end

GameModeTrainingGrounds.destroy = function (self)
	local telemetry_reporter = Managers.telemetry_reporters:reporter("training_grounds")

	if telemetry_reporter then
		Managers.telemetry_reporters:stop_reporter("training_grounds")
	end

	GameModeTrainingGrounds.super.destroy(self)
end

implements(GameModeTrainingGrounds, GameModeBase.INTERFACE)

return GameModeTrainingGrounds
