-- chunkname: @scripts/foundation/utilities/state_machine.lua

local StateMachine = class("StateMachine")

StateMachine.IGNORE_EVENT = StateMachine.IGNORE_EVENT or {}

local function unique_name(name, table)
	return string.format("%s[%s]", name, string.sub(tostring(table), -8))
end

StateMachine.init = function (self, name, parent, ...)
	local parent_name = parent and unique_name(parent._name, parent)

	GameStateDebugInfo:on_state_machine_created(parent_name, unique_name(name, self))

	self._name = name
	self._global_args = {
		...
	}
	self._events = {}
	self._pending_event = nil
	self._pending_args = nil

	if parent then
		self._root_state_machine = parent._root_state_machine
	else
		self._root_state_machine = self
	end

	if parent ~= nil then
		local parent_stack = parent._root_state_machine._state_machine_stack

		self._state_machine_stack = parent_stack
		parent_stack[#parent_stack + 1] = self
	else
		self._state_machine_stack = {
			self
		}
	end

	self._current_state = nil
	self._transitions = {}
end

StateMachine.destroy = function (self)
	GameStateDebugInfo:on_destroy_state_machine(unique_name(self._name, self))

	local state = self._current_state

	self._current_state = nil

	if state ~= nil then
		if state.leave ~= nil then
			state:leave()
		end

		if state.destroy ~= nil then
			state:delete()
		end
	end

	local stack = self._state_machine_stack

	table.remove(stack, #stack)

	self._root_state_machine = nil
	self._state_machine_stack = nil
end

StateMachine.add_transition = function (self, source_class_name, event_name, target_class)
	local transitions = self._transitions

	if transitions[source_class_name] == nil then
		transitions[source_class_name] = {}
	end

	local target_transitions = transitions[source_class_name]

	target_transitions[event_name] = target_class or StateMachine.IGNORE_EVENT
end

StateMachine.remove_transition = function (self, source_class_name, event_name)
	local transitions = self._transitions[source_class_name]

	if transitions == nil then
		return
	end

	transitions[event_name] = nil
end

StateMachine.set_transitions = function (self, source_class_name, transitions)
	self._transitions[source_class_name] = transitions
end

StateMachine.set_initial_state = function (self, state_class, ...)
	self._current_state = self:_enter_state(state_class, {
		...
	})
end

local function pop_first(first, ...)
	if first ~= nil then
		return first, {
			...
		}
	end
end

StateMachine.update = function (self, dt)
	if self._root_state_machine ~= self then
		return
	end

	local stack = self._state_machine_stack
	local leaf_index = #stack

	for ii = 1, #stack do
		local state = stack[ii]._current_state
		local update_func

		if ii == leaf_index then
			if state ~= nil and state.update ~= nil then
				update_func = state.update
			end
		elseif state ~= nil and state.parent_update ~= nil then
			update_func = state.parent_update
		end

		local args, event_name

		if update_func ~= nil then
			event_name, args = pop_first(update_func(state, dt))
		end

		local root_state_machine = self._root_state_machine

		if root_state_machine._pending_event ~= nil then
			event_name = root_state_machine._pending_event
			args = root_state_machine._pending_args
			root_state_machine._pending_event = nil
			root_state_machine._pending_args = nil
		end

		if event_name ~= nil then
			local state_machine_index = self:_received_event(event_name, args)

			if state_machine_index <= ii then
				break
			end
		end
	end
end

StateMachine.event = function (self, event_name, ...)
	local root = self._root_state_machine

	root._pending_event = event_name
	root._pending_args = {
		...
	}
end

StateMachine.state = function (self)
	return self._current_state
end

StateMachine.state_report = function (self)
	local s = ""
	local stack = self._state_machine_stack
	local start_index = table.find(stack, self)

	for ii = start_index, #stack do
		local state_machine = stack[ii]

		s = s .. string.format("State %q waits for:\n", self._current_state_name(state_machine))

		local transitions = state_machine:_transitions_from_state()
		local had_transitions = false

		for kk, vv in pairs(transitions) do
			had_transitions = true
			s = s .. string.format("  %q => %s\n", kk, vv.__class_name)
		end

		if not had_transitions then
			s = s .. "  <nothing>\n"
		end
	end

	return s
end

StateMachine.name = function (self)
	return self._name
end

StateMachine.is_root = function (self)
	return self._state_machine_stack[1] == self
end

StateMachine.stack = function (self)
	return self._state_machine_stack
end

StateMachine.initial_state = function (self)
	return self._initial_state
end

StateMachine.transitions = function (self)
	return self._transitions
end

StateMachine.state_class = function (self)
	return self._current_state_class
end

StateMachine._transitions_from_state = function (self)
	if self._current_state == nil then
		return {}
	end

	local transitions = self._transitions[self._current_state.__class_name]

	if transitions == nil then
		return {}
	end

	return transitions
end

StateMachine._current_state_name = function (state_machine)
	local state_machine_name = state_machine._name
	local state_name = "<no state>"

	if state_machine._current_state ~= nil then
		state_name = state_machine._current_state.__class_name

		if state_machine._current_state.name ~= nil then
			state_name = state_name .. ":" .. state_machine._current_state.name
		end
	end

	return state_machine_name .. ":" .. state_name
end

StateMachine._handle_event = function (self, event_name, args)
	local state = self._current_state

	if state ~= nil then
		local transitions = self._transitions[state.__class_name]

		if transitions ~= nil then
			local target_class = transitions[event_name]

			if target_class == StateMachine.IGNORE_EVENT then
				return true
			elseif target_class ~= nil then
				self:_leave_state()
				self:_enter_state(target_class, args)

				return true
			end
		end
	end

	return false
end

StateMachine._received_event = function (self, event_name, args)
	local stack = self._state_machine_stack

	for ii = #stack, 1, -1 do
		local state_machine = stack[ii]

		if state_machine:_handle_event(event_name, args) then
			return ii
		end
	end

	local state_names = {}

	for i = 1, #stack do
		state_names[i] = self._current_state_name(stack[i])
	end

	local report = string.format("none of the active states (%s) handled the event %q\n", table.concat(state_names, ", "), event_name)

	report = report .. self._root_state_machine:state_report()
end

StateMachine._leave_state = function (self)
	local stack = self._state_machine_stack
	local stack_index = table.find(stack, self)

	for ii = #stack, stack_index, -1 do
		local state_machine = stack[ii]
		local state = state_machine._current_state

		if state.leave then
			state:leave()
		end

		state_machine._current_state = nil

		if state.destroy ~= nil then
			state:delete()
		end
	end
end

StateMachine._enter_state = function (self, state_class, args)
	local state = state_class:new(self, unpack(self._global_args))

	self._current_state = state

	GameStateDebugInfo:on_change_state(unique_name(self._name, self), state.__class_name)

	if state.enter then
		state:enter(unpack(args))
	end

	return state
end

return StateMachine
