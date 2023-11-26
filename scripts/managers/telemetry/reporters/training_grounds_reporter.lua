-- chunkname: @scripts/managers/telemetry/reporters/training_grounds_reporter.lua

local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local ReporterInterface = require("scripts/managers/telemetry/reporters/reporter_interface")
local SINGLEPLAY_TYPES = MatchmakingConstants.SINGLEPLAY_TYPES
local TrainingGroundsReporter = class("TrainingGroundsReporter")

TrainingGroundsReporter.init = function (self)
	self:reset()
end

TrainingGroundsReporter.update = function (self, dt, t)
	return
end

TrainingGroundsReporter.report = function (self)
	if not self._reporter_set_up then
		return
	end

	local start_type = self._start_type or ""
	local finish_type = self._checkpoint or ""
	local user_quit = not self._training_completed

	if user_quit then
		Log.info("TrainingGroundsReporter", "Training Complete was not registered properly. Level was likely force quit.")
	end

	local duration = Managers.time:time("training_grounds_timer")
	local is_onboarding = not Managers.narrative:is_story_complete("onboarding")
	local latest_started_scenario = self._latest_started_scenario or ""
	local num_scenarios_started = self._num_scenarios_started or 0

	Managers.telemetry_events:training_grounds_completed(start_type, finish_type, user_quit, is_onboarding, duration, latest_started_scenario, num_scenarios_started)
	self:reset()
end

TrainingGroundsReporter.set_start_type = function (self, start_type)
	if self._reporter_set_up then
		Log.info("TrainingGroundsReporter", "Attempted to set up reporter twice. This is expected when continuing onto advanced training.")

		return
	end

	self._reporter_set_up = true
	self._start_type = start_type

	Managers.time:register_timer("training_grounds_timer", "main")
end

TrainingGroundsReporter.register_training_checkpoint = function (self, checkpoint)
	self._checkpoint = checkpoint
end

TrainingGroundsReporter.register_training_completed = function (self)
	self._training_completed = true
end

TrainingGroundsReporter.register_new_scenario_started = function (self, scenario_name)
	self._latest_started_scenario = scenario_name
	self._num_scenarios_started = (self._num_scenarios_started or 0) + 1
end

TrainingGroundsReporter.destroy = function (self)
	return
end

TrainingGroundsReporter.reset = function (self)
	self._reporter_set_up = false
	self._training_completed = false
	self._start_type = nil
	self._checkpoint = nil
	self._duration = nil
	self._latest_started_scenario = nil
	self._scenarios_started = nil

	if Managers.time:has_timer("training_grounds_timer") then
		Managers.time:unregister_timer("training_grounds_timer")
	end
end

implements(TrainingGroundsReporter, ReporterInterface)

return TrainingGroundsReporter
