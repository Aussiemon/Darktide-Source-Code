-- chunkname: @scripts/managers/server_metrics/server_metrics_manager.lua

local ServerMetricNames = require("scripts/managers/server_metrics/server_metrics_names")
local ServerMetricsManagerInterface = require("scripts/managers/server_metrics/server_metrics_manager_dummy")
local ServerMetricsManager = class("ServerMetricsManager")
local full_flush_interval = 300
local target_frame_time = 1 / GameParameters.tick_rate + 0.0005
local lagging_frame_time_bucket1 = target_frame_time * 0.1
local lagging_frame_time_bucket2 = target_frame_time * 0.3
local lagging_frame_time_bucket3 = target_frame_time * 0.5
local lagging_frame_time_bucket4 = target_frame_time
local lagging_frame_time_bucket5 = 0.1
local lagging_frame_time_bucket6 = 1
local update_interval = 1
local _log

ServerMetricsManager.init = function (self)
	self._metrics = {}
	self._metrics_as_array = {}
	self._last_update = update_interval

	for _, metric_name in pairs(ServerMetricNames.gauge) do
		if metric_name ~= ServerMetricNames.gauge.target_frame_time then
			self:set_gauge(metric_name, 0)
		end
	end

	for _, metric_name in pairs(ServerMetricNames.counter) do
		self:add_to_counter(metric_name, 0)
	end

	local fixed_time_step = 1 / GameParameters.tick_rate

	self:set_gauge(ServerMetricNames.gauge.target_frame_time, fixed_time_step)

	self._last_travel_progress_report = -1
	self._mission_started = false
end

ServerMetricsManager.destroy = function (self)
	return
end

ServerMetricsManager.add_annotation = function (self, type_name, metadata)
	local json_object = {
		ts = os.time(),
		type = type_name,
		metadata = metadata,
	}

	_log("annotation:%s", cjson.encode(json_object))

	if type_name == "mission_end" then
		self._mission_started = false

		self:set_gauge(ServerMetricNames.gauge.progression, 0)
	end

	if type_name == "mission_start" then
		self._mission_started = true
	end
end

ServerMetricsManager.set_gauge = function (self, metric_name, value)
	local metric = self._metrics[metric_name]

	if not metric then
		metric = {
			flush_dt = 9999,
			type = "gauge",
			name = metric_name,
		}
		self._metrics[metric_name] = metric

		table.insert(self._metrics_as_array, metric)
	end

	if metric.value ~= value then
		metric.value = value
		metric.dirty = true

		self:_flush_metric(metric, 0)
	end
end

ServerMetricsManager.add_to_counter = function (self, metric_name, value)
	local metric = self._metrics[metric_name]

	if not metric then
		metric = {
			flush_dt = 9999,
			type = "counter",
			value = 0,
			name = metric_name,
		}
		self._metrics[metric_name] = metric

		table.insert(self._metrics_as_array, metric)
	end

	metric.value = metric.value + value
	metric.dirty = true

	self:_flush_metric(metric, 0)
end

ServerMetricsManager._flush_metric = function (self, metric, dt)
	if metric.dirty and metric.flush_dt > 5 or metric.flush_dt > full_flush_interval then
		_log("metric: %s %s %f", metric.name, metric.type, metric.value)

		metric.flush_dt = 0
		metric.dirty = false

		if metric.type == "counter" then
			metric.value = 0
		end
	else
		metric.flush_dt = metric.flush_dt + dt
	end
end

ServerMetricsManager._track_progression = function (self)
	if not Managers.state or not Managers.state.main_path or not self._mission_started then
		return
	end

	local travel_progress = Managers.state.main_path:furthest_travel_percentage(1)

	self:set_gauge(ServerMetricNames.gauge.progression, math.floor(travel_progress * 100) / 100)

	local normalized_travel = math.floor(travel_progress * 10) / 10

	if normalized_travel < self._last_travel_progress_report then
		self._last_travel_progress_report = -1
	end

	if self._last_travel_progress_report == -1 and travel_progress > 0.01 or self._last_travel_progress_report ~= -1 and normalized_travel > self._last_travel_progress_report then
		self:add_annotation("progression", {
			value = normalized_travel,
		})

		self._last_travel_progress_report = normalized_travel
	end
end

ServerMetricsManager.update = function (self, dt)
	local missed_frame_time = dt - target_frame_time

	if missed_frame_time > 0 then
		self:add_to_counter(ServerMetricNames.counter.missed_frame_time, missed_frame_time)
		self:add_to_counter(ServerMetricNames.counter.lagging_frames, 1)

		if missed_frame_time < lagging_frame_time_bucket1 then
			self:add_to_counter(ServerMetricNames.counter.lagging_frames_bucket1, 1)
		elseif missed_frame_time < lagging_frame_time_bucket2 then
			self:add_to_counter(ServerMetricNames.counter.lagging_frames_bucket2, 1)
		elseif missed_frame_time < lagging_frame_time_bucket3 then
			self:add_to_counter(ServerMetricNames.counter.lagging_frames_bucket3, 1)
		elseif missed_frame_time < lagging_frame_time_bucket4 then
			self:add_to_counter(ServerMetricNames.counter.lagging_frames_bucket4, 1)
		elseif missed_frame_time < lagging_frame_time_bucket5 then
			self:add_to_counter(ServerMetricNames.counter.lagging_frames_bucket5, 1)
		elseif missed_frame_time < lagging_frame_time_bucket6 then
			self:add_to_counter(ServerMetricNames.counter.lagging_frames_bucket6, 1)
		else
			self:add_to_counter(ServerMetricNames.counter.lagging_frames_bucket7, 1)
		end
	end

	for i = 1, #self._metrics_as_array do
		self:_flush_metric(self._metrics_as_array[i], dt)
	end

	self._last_update = self._last_update + dt

	if self._last_update > update_interval then
		if Managers.state and Managers.state.minion_spawn then
			self:set_gauge(ServerMetricNames.gauge.spawned_minions, Managers.state.minion_spawn:num_spawned_minions())
		end

		self:_track_progression()

		self._last_update = 0
	end
end

function _log(format, ...)
	if DevParameters.disable_server_metrics_prints then
		return
	end

	Log.info("ServerMetricsManager", string.format(format, ...))
end

implements(ServerMetricsManager, ServerMetricsManagerInterface)

return ServerMetricsManager
