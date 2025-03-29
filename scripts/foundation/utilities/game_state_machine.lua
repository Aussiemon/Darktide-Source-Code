-- chunkname: @scripts/foundation/utilities/game_state_machine.lua

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

	if rawget(_G, "Managers") and Managers.server_metrics then
		Managers.server_metrics:add_annotation(string.format("[GameStateMachine] " .. format, ...))
	end
end

GameStateMachine.init = function (self, parent, start_state, params, optional_creation_context, state_change_callbacks, parent_name, name, log_breadcrumbs)
	self._parent = parent
	self._next_state = start_state
	self._next_state_params = params
	self._optional_creation_context = optional_creation_context
	self._name = name
	self._log_breadcrumbs = log_breadcrumbs
	self._state_change_callbacks = {}

	if state_change_callbacks then
		for reference_name, callback in pairs(state_change_callbacks) do
			self:register_on_state_change_callback(reference_name, callback)
		end
	end

	GameStateDebugInfo:on_state_machine_created(parent_name, name, start_state.__class_name)
	self:_change_state()
end

GameStateMachine.register_on_state_change_callback = function (self, reference_name, callback)
	self._state_change_callbacks[reference_name] = callback
end

GameStateMachine.unregister_on_state_change_callback = function (self, reference_name)
	self._state_change_callbacks[reference_name] = nil
end

GameStateMachine.next_state = function (self)
	return self._next_state
end

GameStateMachine._log_state_change = function (self, current_state, next_state)
	local current_state_name = ""

	if current_state then
		current_state_name = current_state.__class_name
	end

	local next_state_name = ""

	if next_state then
		next_state_name = next_state.__class_name
	end

	GameStateDebugInfo:on_change_state(self._name, next_state_name)
	Profiler.send_message(string.format("[%s] Changing state '%s' -> '%s'", self._name, current_state_name, next_state_name))
end

GameStateMachine._change_state = function (self)
	local new_state = self._next_state
	local params = self._next_state_params
	local exit_params = self._exit_params

	self._next_state = nil
	self._next_state_params = nil
	self._exit_params = nil

	local current_state_name = self:current_state_name()

	if self._state and self._state.on_exit then
		self._state:on_exit(exit_params)
		self._state:delete()
	end

	local new_state_name = new_state.__class_name
	local state_change_callbacks = self._state_change_callbacks

	for _, callback in pairs(state_change_callbacks) do
		callback(current_state_name, new_state_name)
	end

	self._state = new_state:new()

	if rawget(_G, "Crashify") and self._log_breadcrumbs then
		Crashify.print_breadcrumb(string.format("Entering Game State %s", new_state_name))
	end

	if self._state.on_enter then
		self._state:on_enter(self._parent, params, self._optional_creation_context)
	end
end

GameStateMachine.force_change_state = function (self, state, params, exit_params)
	if self._state == state then
		return
	end

	self._next_state = state
	self._next_state_params = params
	self._exit_params = exit_params

	self:_log_state_change(self._state, self._next_state)
	self:_change_state()
end

GameStateMachine.update = function (self, dt, t)
	if self._next_state then
		self:_log_state_change(self._state, self._next_state)
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

	GameStateDebugInfo:on_destroy_state_machine(self._name)
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
