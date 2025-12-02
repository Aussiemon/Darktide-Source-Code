-- chunkname: @scripts/utilities/game_state_debug.lua

local GameStateDebug = class("GameStateDebug")

GameStateDebug.DEBUG = false

local function _debug_print(format, ...)
	if GameStateDebug.DEBUG then
		Log.info("GameStateDebug", format, ...)
	end
end

local function _debug_warn(format, ...)
	if GameStateDebug.DEBUG then
		Log.warning("GameStateDebug", format, ...)
	end
end

GameStateDebug.init = function (self)
	self._state_machines = {}
	self._cached_description = ""
	self._dirty = true
end

GameStateDebug.on_state_machine_created = function (self, parent_sm_name, sm_name, initial_state)
	_debug_print("[%s] Init statemachine with '%s'", sm_name, initial_state)

	local _, sm = self:_find_state_machine(parent_sm_name, self._state_machines)
	local state = {
		parent_name = parent_sm_name,
		name = sm_name,
		state_name = initial_state,
		children = {},
	}

	if sm then
		local children = sm.children

		children[sm_name] = state
	else
		self._state_machines[sm_name] = state
	end

	self._dirty = true

	_debug_print("Updated State: %s", self:get_current_state_description())
end

GameStateDebug.on_change_state = function (self, sm_name, state_name)
	local _, sm = self:_find_state_machine(sm_name, self._state_machines)

	if not sm then
		return
	end

	_debug_print("[%s] Changing state '%s' -> '%s'", sm_name, sm.state_name, state_name)

	sm.state_name = state_name
	self._dirty = true

	_debug_print("Updated State: %s", self:get_current_state_description())
end

GameStateDebug.on_destroy_state_machine = function (self, sm_name)
	local parent_sm, sm = self:_find_state_machine(sm_name, self._state_machines)

	if not sm then
		return
	end

	_debug_print("[%s] Exit statemachine from '%s'", sm.name, sm.state_name)

	if parent_sm then
		parent_sm.children[sm_name] = nil
	else
		self._state_machines[sm_name] = nil
	end

	self._dirty = true

	_debug_print("Updated State: %s", self:get_current_state_description())
end

GameStateDebug._find_state_machine = function (self, sm_name, sms)
	for name, sm in pairs(sms) do
		if name == sm_name then
			return nil, sm
		else
			local parent_sm, ret_sm = self:_find_state_machine(sm_name, sm.children)

			if ret_sm then
				parent_sm = parent_sm or sm

				return parent_sm, ret_sm
			end
		end
	end
end

GameStateDebug._create_descriptions = function (self, sm)
	if table.is_empty(sm.children) then
		return {
			(string.format("%s(%s)", sm.name, sm.state_name)),
		}
	else
		local descs_out = {}

		for _, child_sm in pairs(sm.children) do
			local descs = self:_create_descriptions(child_sm)

			for __, desc in ipairs(descs) do
				descs_out[#descs_out + 1] = string.format("%s(%s)> %s", sm.name, sm.state_name, desc)
			end
		end

		return descs_out
	end
end

GameStateDebug.get_current_state_description = function (self)
	if not self._dirty then
		return self._cached_description, self._num_lines
	end

	local full_description = ""
	local sms = self._state_machines
	local num_lines = 0

	for _, sm in pairs(sms) do
		local branches = self:_create_descriptions(sm)

		for _, branch in ipairs(branches) do
			full_description = full_description .. branch .. "\n"
			num_lines = num_lines + 1
		end
	end

	self._dirty = false

	if num_lines > 1 then
		full_description = "\t\n" .. full_description
		num_lines = num_lines + 1
	end

	self._cached_description = full_description
	self._num_lines = num_lines

	return full_description, num_lines
end

return GameStateDebug
