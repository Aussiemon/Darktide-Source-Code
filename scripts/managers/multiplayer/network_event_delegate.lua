-- chunkname: @scripts/managers/multiplayer/network_event_delegate.lua

local NetworkEventDelegate = class("NetworkEventDelegate")

NetworkEventDelegate.init = function (self)
	self._registered_objects = {}
	self._registered_channel_objects = {}
	self._registered_unit_objects = {}
	self._state_events = {}

	local event_meta_table = {}

	event_meta_table.__index = function (t, key)
		if BUILD == "release" then
			Crashify.print_exception("NetworkEventDelegate", string.format("Network event not registered %q", key))

			return function ()
				return
			end
		end

		local message_info = Network.message_info(key)

		if message_info and not message_info.session_bound then
			Log.info("NetworkEventDelegate", "Network event not registered %q", key)

			return function ()
				return
			end
		else
			ferror("Network event not registered %q", key)
		end
	end

	self.event_table = setmetatable({}, event_meta_table)
end

NetworkEventDelegate.destroy = function (self)
	self:_cleanup_all()

	self.event_table = nil
end

NetworkEventDelegate.clean_session_events = function (self)
	self:_cleanup_session()
end

NetworkEventDelegate.register_session_events = function (self, object, ...)
	self:_register_events(true, object, ...)
end

NetworkEventDelegate.register_connection_events = function (self, object, ...)
	self:_register_events(false, object, ...)
end

NetworkEventDelegate.register_session_channel_events = function (self, object, channel_id, ...)
	self:_register_channel_events(true, object, channel_id, ...)
end

NetworkEventDelegate.register_connection_channel_events = function (self, object, channel_id, ...)
	self:_register_channel_events(false, object, channel_id, ...)
end

NetworkEventDelegate.register_session_unit_events = function (self, object, unit_id, ...)
	local game_session = Managers.state.game_session:game_session()

	self:_register_session_unit_events(object, unit_id, ...)
end

NetworkEventDelegate.unregister_events = function (self, ...)
	for i = 1, select("#", ...) do
		local callback_name = select(i, ...)

		self._registered_objects[callback_name] = nil
		self.event_table[callback_name] = nil
		self._state_events[callback_name] = nil
	end
end

NetworkEventDelegate.unregister_channel_events = function (self, channel_id, ...)
	for i = 1, select("#", ...) do
		local callback_name = select(i, ...)
		local object_table = self._registered_channel_objects[callback_name]
		local size = object_table.__size - 1

		if size == 0 then
			self._registered_channel_objects[callback_name] = nil
			self.event_table[callback_name] = nil
			self._state_events[callback_name] = nil
		else
			object_table[channel_id] = nil
			object_table.__size = size
		end
	end
end

NetworkEventDelegate.unregister_unit_events = function (self, unit_id, ...)
	for i = 1, select("#", ...) do
		local callback_name = select(i, ...)
		local object_table = self._registered_unit_objects[callback_name]
		local size = object_table.__size - 1

		if size == 0 then
			self._registered_unit_objects[callback_name] = nil
			self.event_table[callback_name] = nil
			self._state_events[callback_name] = nil
		else
			object_table[unit_id] = nil
			object_table.__size = size
		end
	end
end

NetworkEventDelegate._register_events = function (self, is_session_event, object, ...)
	for i = 1, select("#", ...) do
		local callback_name = select(i, ...)
		local object_table = self._registered_unit_objects[callback_name]

		object_table = self._registered_channel_objects[callback_name]

		local registered_object = self._registered_objects[callback_name]

		self._registered_objects[callback_name] = object

		local function callback(event_table, ...)
			return object[callback_name](object, ...)
		end

		self.event_table[callback_name] = callback

		if is_session_event then
			self._state_events[callback_name] = true
		end
	end
end

NetworkEventDelegate._register_channel_events = function (self, is_session_event, object, channel_id, ...)
	for i = 1, select("#", ...) do
		local callback_name = select(i, ...)
		local registered_object = self._registered_objects[callback_name]
		local object_table = self._registered_unit_objects[callback_name]

		object_table = self._registered_channel_objects[callback_name] or {
			__size = 0,
		}
		self._registered_channel_objects[callback_name] = object_table
		object_table[channel_id] = object
		object_table.__size = object_table.__size + 1

		if not rawget(self.event_table, callback_name) then
			local function callback(event_table, channel_id, ...)
				local object = object_table[channel_id]

				if object then
					object[callback_name](object, channel_id, ...)
				else
					local message_info = Network.message_info(callback_name)

					if message_info and not message_info.session_bound then
						Log.info("NetworkEventDelegate", "No callback registered for event %q on channel id %i", callback_name, channel_id)
					else
						ferror("No callback registered for event %q on channel id %i", callback_name, channel_id)
					end
				end
			end

			self.event_table[callback_name] = callback

			if is_session_event then
				self._state_events[callback_name] = true
			end
		end
	end
end

NetworkEventDelegate._register_session_unit_events = function (self, object, unit_id, ...)
	for i = 1, select("#", ...) do
		local callback_name = select(i, ...)
		local registered_object = self._registered_objects[callback_name]
		local object_table = self._registered_channel_objects[callback_name]

		object_table = self._registered_unit_objects[callback_name] or {
			__size = 0,
		}
		self._registered_unit_objects[callback_name] = object_table
		object_table[unit_id] = object
		object_table.__size = object_table.__size + 1

		if not rawget(self.event_table, callback_name) then
			local function callback(event_table, sender, unit_id, ...)
				local object = object_table[unit_id]

				object[callback_name](object, sender, unit_id, ...)
			end

			self.event_table[callback_name] = callback
			self._state_events[callback_name] = true
		end
	end
end

NetworkEventDelegate._cleanup_all = function (self)
	local success = true
	local error_str = ""

	if not table.is_empty(self._registered_objects) then
		for callback_name, object in pairs(self._registered_objects) do
			error_str = error_str .. string.format("\tEvent callback %s not unregistered. Held by %q\n", callback_name, object.__class_name)
		end

		success = false
	end

	if not table.is_empty(self._registered_unit_objects) then
		for callback_name, object_table in pairs(self._registered_unit_objects) do
			local unit_id, object = next(object_table)

			error_str = error_str .. string.format("\tUnit event callback %s for unit id %i not unregistered. Held by %q\n", callback_name, unit_id, object.__class_name)
		end

		success = false
	end

	if not table.is_empty(self._registered_channel_objects) then
		for callback_name, object_table in pairs(self._registered_channel_objects) do
			local channel_id, object = next(object_table)

			error_str = error_str .. string.format("\tChannel event callback %s for channel %i not unregistered. Held by %q\n", callback_name, channel_id, object.__class_name)
		end

		success = false
	end

	self._registered_objects = nil
	self._registered_unit_objects = nil
end

NetworkEventDelegate._cleanup_session = function (self)
	if not table.is_empty(self._state_events) then
		local error_str = ""

		for callback_name, _ in pairs(self._state_events) do
			local object = self._registered_objects[callback_name]

			if object then
				error_str = error_str .. string.format("\tEvent callback %s not unregistered. Held by %q\n", callback_name, object.__class_name)
			end

			local object_table = self._registered_unit_objects[callback_name]

			if object_table then
				local unit_id

				unit_id, object = next(object_table)
				error_str = error_str .. string.format("\tUnit event callback %s for unit id %i not unregistered. Held by %q\n", callback_name, unit_id, object.__class_name)
			end

			object_table = self._registered_channel_objects[callback_name]

			if object_table then
				local channel_id

				channel_id, object = next(object_table)
				error_str = error_str .. string.format("\tChannel event callback %s for channel %i not unregistered. Held by %q\n", callback_name, channel_id, object.__class_name)
			end
		end

		ferror("All callbacks have not been unregistered.\n%s", error_str)
	end
end

return NetworkEventDelegate
