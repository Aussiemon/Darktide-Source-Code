-- chunkname: @scripts/managers/event/event_manager.lua

local EventManager = class("EventManager")

EventManager.init = function (self)
	self._events = {}
	self._callbacks = {}
end

EventManager.register = function (self, object, ...)
	for i = 1, select("#", ...), 2 do
		local event_name = select(i, ...)
		local callback_name = select(i + 1, ...)

		self._events[event_name] = self._events[event_name] or setmetatable({}, {
			__mode = "v",
		})
		self._events[event_name][object] = callback_name
	end
end

EventManager.unregister = function (self, object, event_name)
	local events = self._events[event_name]

	if events then
		events[object] = nil

		if table.is_empty(events) then
			self._events[event_name] = nil
		end
	end

	local event_callbacks = self._callbacks[event_name]

	if event_callbacks then
		event_callbacks[object] = nil

		if table.is_empty(event_callbacks) then
			self._callbacks[event_name] = nil
		end
	end
end

EventManager.register_with_parameters = function (self, object, function_name, event_name, ...)
	local cb = callback(object, function_name, ...)

	self._callbacks[event_name] = self._callbacks[event_name] or {}
	self._callbacks[event_name][object] = cb
end

local WARNING_SUPPRESSED = {
	event_player_buff_added = true,
	event_player_buff_proc_start = true,
	event_player_buff_proc_stop = true,
	event_player_buff_removed = true,
	voip_manager_updated_channel_state = true,
}

EventManager.trigger = function (self, event_name, ...)
	local events = self._events[event_name]

	if events then
		for object, callback_name in pairs(events) do
			object[callback_name](object, ...)
		end
	end

	local event_callbacks = self._callbacks[event_name]

	if event_callbacks then
		for object, callback_func in pairs(event_callbacks) do
			callback_func(...)
		end
	end
end

EventManager.destroy = function (self)
	Log.set_global_log_level(Log.ERROR)

	for event_name, events in pairs(self._events) do
		for _, callback_name in pairs(events) do
			Log.error("EventManager", "[destroy] Still have registered callbacks for event: (%s) callback name: (%s)", event_name, callback_name)
		end
	end

	for event_name, callbacks in pairs(self._callbacks) do
		for _, callback_func in pairs(callbacks) do
			Log.error("EventManager", "[destroy] Still have registered callback objects for event: (%s)", event_name)
		end
	end

	Log.set_global_log_level(Log.INFO)
end

return EventManager
