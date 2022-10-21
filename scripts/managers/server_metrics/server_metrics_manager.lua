local ServerMetricsManager = class("ServerMetricsManager")
local ServerMetricNames = require("scripts/managers/server_metrics/server_metrics_names")
local ServerMetricsManagerInterface = require("scripts/managers/server_metrics/server_metrics_manager_dummy")
local full_flush_interval = 300
local target_frame_time = GameParameters.fixed_time_step + 0.0005
local update_interval = 1

ServerMetricsManager.init = function (self)
	self._metrics = {}
	self._metrics_as_array = {}
	self._last_update = update_interval

	for _, metric_name in pairs(ServerMetricNames.gauge) do
		if metric_name ~= ServerMetricNames.gauge.target_frame_time then
			self:set_gauge(metric_name, 0)
		end
	end

	self:set_gauge(ServerMetricNames.gauge.target_frame_time, GameParameters.fixed_time_step)
end

ServerMetricsManager.destroy = function (self)
	return
end

ServerMetricsManager.add_annotation = function (self, type_name, metadata)
	assert(type(type_name) == "string", "type_name has to be string")
	assert(type(metadata) == "table" or type(metadata) == "nil", "metadata has to be table")

	local json_object = {
		ts = os.time(),
		type = type_name,
		metadata = metadata
	}

	Log.info("ServerMetricsManager", string.format("annotation:%s", cjson.encode(json_object)))
end

ServerMetricsManager.set_gauge = function (self, metric_name, value)
	assert(type(metric_name) == "string", "metric_name has to be string")
	assert(type(value) == "number", "value has to be a number")

	local metric = self._metrics[metric_name]

	if not metric then
		metric = {
			flush_dt = 9999,
			type = "gauge",
			name = metric_name
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
	assert(type(metric_name) == "string", "metric_name has to be string")
	assert(type(value) == "number", "value has to be a number")

	local metric = self._metrics[metric_name]

	if not metric then
		metric = {
			value = 0,
			flush_dt = 9999,
			type = "counter",
			name = metric_name
		}
		self._metrics[metric_name] = metric

		table.insert(self._metrics_as_array, metric)
	end

	metric.value = metric.value + value
	metric.dirty = true

	self:_flush_metric(metric, 0)
end

ServerMetricsManager._flush_metric = function (self, metric, dt)
	if metric.dirty and metric.flush_dt > 5 or full_flush_interval < metric.flush_dt then
		Log.info("ServerMetricsManager", string.format("metric: %s %s %f", metric.name, metric.type, metric.value))

		metric.flush_dt = 0
		metric.dirty = false

		if metric.type == "counter" then
			metric.value = 0
		end
	else
		metric.flush_dt = metric.flush_dt + dt
	end
end

ServerMetricsManager.update = function (self, dt)
	local missed_frame_time = dt - target_frame_time

	if missed_frame_time > 0 then
		self:add_to_counter(ServerMetricNames.counter.missed_frame_time, missed_frame_time)
		self:add_to_counter(ServerMetricNames.counter.lagging_frames, 1)
	end

	for i = 1, #self._metrics_as_array do
		self:_flush_metric(self._metrics_as_array[i], dt)
	end

	self._last_update = self._last_update + dt

	if update_interval < self._last_update then
		if Managers.state and Managers.state.minion_spawn then
			self:set_gauge(ServerMetricNames.gauge.spawned_minions, Managers.state.minion_spawn:num_spawned_minions())
		end

		self._last_update = 0
	end
end

implements(ServerMetricsManager, ServerMetricsManagerInterface)

return ServerMetricsManager
