-- chunkname: @scripts/managers/telemetry/telemetry_manager.lua

local BackendError = require("scripts/foundation/managers/backend/backend_error")
local TelemetryManagerTestify = GameParameters.testify and require("scripts/managers/telemetry/telemetry_manager_testify")
local TelemetrySettings = require("scripts/managers/telemetry/telemetry_settings")
local POST_INTERVAL = TelemetrySettings.batch.post_interval
local FULL_POST_INTERVAL = TelemetrySettings.batch.full_post_interval
local MAX_BATCH_SIZE = TelemetrySettings.batch.max_size
local BATCH_SIZE = TelemetrySettings.batch.size
local ENABLED = TelemetrySettings.enabled
local TelemetryManager = class("TelemetryManager")

TelemetryManager.init = function (self)
	self._events = {}
	self._events_in_flight = {}
	self._batch_post_time = 0
	self._t = 0
	self._enable_update = true

	local event_manager = Managers.event

	if event_manager then
		event_manager:register(self, "event_player_authenticated", "_event_player_authenticated")
		event_manager:register(self, "event_telemetry_change", "_event_telemetry_change")
	end
end

TelemetryManager.update = function (self, dt, t)
	if IS_PLAYSTATION and not self._enable_update then
		return
	end

	self._t = t

	if self:_ready_to_post_batch(t) then
		self:post_batch()
	end

	if GameParameters.testify then
		Testify:poll_requests_through_handler(TelemetryManagerTestify, self)
	end
end

TelemetryManager.register_event = function (self, event)
	if not ENABLED then
		return
	end

	local raw_event = event:raw()

	raw_event.time = self._t
	raw_event.data = self:_convert_userdata(raw_event.data)

	if #self._events < MAX_BATCH_SIZE then
		Log.debug("TelemetryManager", "Registered event '%s'", event)
		table.insert(self._events, table.remove_empty_values(raw_event))
	else
		Log.warning("TelemetryManager", "Discarding event '%s', buffer is full!", event)
	end
end

TelemetryManager._convert_userdata = function (self, data)
	if type(data) == "table" then
		for key, value in pairs(data) do
			if Script.type_name(value) == "Vector3" then
				data[key] = {
					x = value.x,
					y = value.y,
					z = value.z,
				}
			elseif type(value) == "function" then
				data[key] = nil
			elseif type(value) == "userdata" then
				data[key] = tostring(value)
			elseif type(value) == "table" then
				data[key] = self:_convert_userdata(value)
			end
		end
	end

	return data
end

TelemetryManager._ready_to_post_batch = function (self, t)
	if self._batch_in_flight then
		return false
	end

	if t - self._batch_post_time > POST_INTERVAL then
		return true
	elseif t - self._batch_post_time > FULL_POST_INTERVAL and #self._events >= BATCH_SIZE then
		return true
	end
end

TelemetryManager.post_batch = function (self, shutdown)
	if not ENABLED or table.is_empty(self._events) then
		return
	end

	if not shutdown then
		local batch_size, time_since_last_post, events = self:batch_info()

		Managers.telemetry_events:post_batch(batch_size, time_since_last_post, events, false)
	end

	Log.info("TelemetryManager", "Posting batch of %d events", #self._events)

	if GameParameters.testify then
		Log.debug("TelemetryManager", cjson.encode(self._events))
	end

	self._batch_in_flight = true
	self._batch_post_time = math.floor(self._t)

	local headers = {
		["x-reference-time"] = tostring(self._t),
	}
	local compress = true

	self._events, self._events_in_flight = self._events_in_flight, self._events

	Managers.backend:send_telemetry_events(self._events_in_flight, headers, compress, shutdown):next(function ()
		table.clear(self._events_in_flight)
		Log.debug("TelemetryManager", "Batch successfully posted")

		self._batch_in_flight = nil
	end):catch(function (error)
		if error.code ~= BackendError.NotInitialized then
			Log.exception("TelemetryManager", "Error posting batch: %s", error)
		else
			Log.info("TelemetryManager", "Error posting batch as we're not logged in")
		end

		self:_remove_events_of_type(self._events_in_flight, "post_batch")
		table.merge_array(self._events, self._events_in_flight)
		table.clear(self._events_in_flight)

		self._batch_in_flight = nil
	end)
end

TelemetryManager.batch_in_flight = function (self)
	return self._batch_in_flight or false
end

TelemetryManager.destroy = function (self)
	local event_manager = Managers.event

	if event_manager then
		event_manager:unregister(self, "event_player_authenticated", "_event_player_authenticated")
		event_manager:unregister(self, "event_telemetry_change", "_event_telemetry_change")
	end

	local shutdown = true

	self:post_batch(shutdown)
end

TelemetryManager._remove_events_of_type = function (self, events, event_type)
	for ii = #events, 1, -1 do
		if events[ii].type == event_type then
			table.remove(events, ii)
		end
	end
end

TelemetryManager._event_telemetry_change = function (self, value)
	self._enable_update = value
end

TelemetryManager.batch_info = function (self)
	local batch_size = #self._events
	local time_since_last_post = self._t - self._batch_post_time
	local event_types = {}

	for _, event in pairs(self._events) do
		local event_type = event.type
		local current = event_types[event_type]

		if current then
			event_types[event_type] = current + 1
		else
			event_types[event_type] = 1
		end
	end

	return batch_size, time_since_last_post, event_types
end

TelemetryManager._event_player_authenticated = function (self)
	local save_manager = Managers.save

	if save_manager then
		local account_data = save_manager:account_data()

		self._enable_update = account_data.interface_settings.telemetry_enabled
	end
end

return TelemetryManager
