local ReporterInterface = require("scripts/managers/telemetry/reporters/reporter_interface")
local LoadTimesReporter = class("LoadTimesReporter")

LoadTimesReporter.init = function (self)
	Managers.event:register(self, "event_loading_started", "_loading_started")
	Managers.event:register(self, "event_loading_finished", "_loading_finished")
	Managers.event:register(self, "event_loading_resources_started", "_loading_resources_started")
	Managers.event:register(self, "event_loading_resources_finished", "_loading_resources_finished")
	Managers.event:register(self, "event_mission_intro_started", "_mission_intro_started")
	Managers.event:register(self, "event_mission_intro_finished", "_mission_intro_finished")
end

LoadTimesReporter.destroy = function (self)
	Managers.event:unregister(self, "event_loading_started")
	Managers.event:unregister(self, "event_loading_finished")
	Managers.event:unregister(self, "event_loading_resources_started")
	Managers.event:unregister(self, "event_loading_resources_finished")
	Managers.event:unregister(self, "event_mission_intro_started")
	Managers.event:unregister(self, "event_mission_intro_finished")
end

LoadTimesReporter._loading_started = function (self)
	self._mission_name = nil

	self:reset_timers()
	self:start_timer("loading_timer")
	self:start_timer("wait_for_network_timer")
end

LoadTimesReporter._loading_resources_started = function (self, mission_name)
	self._mission_name = mission_name

	self:stop_timer("wait_for_network_timer")
	self:start_timer("resource_loading_timer")
end

LoadTimesReporter._loading_resources_finished = function (self)
	self:stop_timer("resource_loading_timer")
	self:start_timer("wait_for_spawn_timer")
end

LoadTimesReporter._mission_intro_started = function (self)
	self:start_timer("mission_intro_timer")
end

LoadTimesReporter._mission_intro_finished = function (self)
	if Managers.time:has_timer("mission_intro_timer") then
		self:stop_timer("mission_intro_timer")
	end
end

LoadTimesReporter._loading_finished = function (self)
	self:stop_timer("loading_timer")
	self:report()
end

LoadTimesReporter.update = function (self, dt, t)
	return
end

LoadTimesReporter.report = function (self, dt, t)
	local mission_name = self._mission_name
	local wait_for_network_time = self:time("wait_for_network_timer")
	local resource_loading_time = self:time("resource_loading_timer")
	local wait_for_spawn_time = self:time("wait_for_spawn_timer")
	local mission_intro_time = 0

	if Managers.time:has_timer("mission_intro_timer") then
		mission_intro_time = self:time("mission_intro_timer")
	end

	Managers.telemetry_events:performance_load_times(mission_name, wait_for_network_time, resource_loading_time, mission_intro_time, wait_for_spawn_time)
end

LoadTimesReporter.start_timer = function (self, timer_name)
	if Managers.time:has_timer(timer_name) then
		Managers.time:set_time(timer_name, 0)
		Managers.time:set_active(timer_name, true)
		Log.info("LoadTimesReporter", "Reseting timer %s", timer_name)
	else
		Managers.time:register_timer(timer_name, "main", 0)
	end
end

LoadTimesReporter.stop_timer = function (self, timer_name)
	Managers.time:set_active(timer_name, false)
end

LoadTimesReporter.time = function (self, timer_name)
	return Managers.time:time(timer_name, 0)
end

local TIMERS = {
	"loading_timer",
	"wait_for_network_timer",
	"resource_loading_timer",
	"wait_for_spawn_timer",
	"mission_intro_timer"
}

LoadTimesReporter.reset_timers = function (self)
	for _, timer_name in ipairs(TIMERS) do
		if Managers.time:has_timer(timer_name) then
			Managers.time:unregister_timer(timer_name)
		end
	end
end

implements(LoadTimesReporter, ReporterInterface)

return LoadTimesReporter
