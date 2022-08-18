local GameStateMachine = class("GameStateMachine")
GameStateMachine.DEBUG = true

local function _debug_print(format, ...)
	if GameStateMachine.DEBUG then
		if rawget(_G, "Log") then
			Log.info("GameStateMachine", format, ...)
		else
			print(string.format("[GameStateMachine] " .. format, ...))
		end
	end
end

GameStateMachine.init = function (self, parent, start_state, params, optional_creation_context, state_change_callbacks)
	self._parent = parent
	self._next_state = start_state
	self._next_state_params = params
	self._optional_creation_context = optional_creation_context
	self._state_change_callbacks = {}

	if state_change_callbacks then
		for reference_name, callback in pairs(state_change_callbacks) do
			self:register_on_state_change_callback(reference_name, callback)
		end
	end

	_debug_print("Init state %s", start_state.__class_name)
	self:_change_state()
end

GameStateMachine.register_on_state_change_callback = function (self, reference_name, callback)
	fassert(not self._state_change_callbacks[reference_name], "[GameStateMachine] register_on_state_change_callback - reference name is already in use (%s)", reference_name)

	self._state_change_callbacks[reference_name] = callback
end

GameStateMachine.unregister_on_state_change_callback = function (self, reference_name)
	fassert(self._state_change_callbacks[reference_name], "[GameStateMachine] unregister_on_state_change_callback - reference name is not in use (%s)", reference_name)

	self._state_change_callbacks[reference_name] = nil
end

GameStateMachine.next_state = function (self)
	return self._next_state
end

GameStateMachine._change_state = function (self)
	local new_state = self._next_state
	local params = self._next_state_params
	self._next_state = nil
	self._next_state_params = nil
	local current_state_name = self:current_state_name()

	if self._state and self._state.on_exit then
		self._state:on_exit()
		self._state:delete()
	end

	local new_state_name = new_state.__class_name
	local state_change_callbacks = self._state_change_callbacks

	for _, callback in pairs(state_change_callbacks) do
		callback(current_state_name, new_state_name)
	end

	self._state = new_state:new()

	if self._state.on_enter then
		self._state:on_enter(self._parent, params, self._optional_creation_context)
	end
end

GameStateMachine.update = function (self, dt, t)
	if self._next_state then
		_debug_print("Changing state to %s", self._next_state.__class_name)
		self:_change_state()
	end

	self._next_state, self._next_state_params = self._state:update(dt, t)
end

GameStateMachine.post_update = function (self, dt, t)
	if self._state and self._state.post_update then
		self._state:post_update(dt, t)
	end
end

GameStateMachine.render = function (self)
	if self._state and self._state.render then
		self._state:render()
	end
end

GameStateMachine.post_render = function (self)
	if self._state and self._state.post_render then
		self._state:post_render()
	end
end

GameStateMachine.on_reload = function (self, refreshed_resources)
	if self._state and self._state.on_reload then
		self._state:on_reload(refreshed_resources)
	end
end

GameStateMachine.on_close = function (self)
	if self._state and self._state.on_close then
		return self._state:on_close()
	else
		return true
	end
end

GameStateMachine.destroy = function (self, ...)
	local state_change_callbacks = self._state_change_callbacks

	if not table.is_empty(state_change_callbacks) then
		for reference_name, _ in pairs(state_change_callbacks) do
			if rawget(_G, "Log") then
				Log.warning("GameStateMachine", "Found unregistered callback for state change by name: (%s)", reference_name)
			else
				_debug_print("Found unregistered callback for state change by name: (%s)", reference_name)
			end
		end

		ferror("[GameStateMachine] - Trying to terminate state machine without cleaning up registered callbacks.")
	end

	if self._state and self._state.on_exit then
		self._state:on_exit(...)
	end
end

GameStateMachine.current_state_name = function (self)
	if self._state then
		return self._state.__class_name
	else
		return ""
	end
end

GameStateMachine.current_state = function (self)
	return self._state
end

return GameStateMachine
