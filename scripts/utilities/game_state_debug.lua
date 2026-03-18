-- chunkname: @scripts/utilities/game_state_debug.lua

local GameStateDebug = class("GameStateDebug")

local function _debug_print(format, ...)
	Log.debug("GameStateDebug", format, ...)
end

local function _debug_warn(format, ...)
	Log.warning("GameStateDebug", format, ...)
end

GameStateDebug.init = function (self)
	self._state_machines = {}
	self._dirty = true
	self._cached_description = ""
	self._top_level_cache = {}
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

GameStateDebug._update_cache = function (self)
	self._dirty = false

	local lines = {}

	for name, sm in pairs(self._state_machines) do
		local branches = self:_create_descriptions(sm)

		self._top_level_cache[name] = {
			table.concat(branches, "\n"),
			#branches,
		}

		table.append(lines, branches)
	end

	if #lines <= 1 then
		self._cached_description, self._num_lines = table.concat(lines, "\n"), #lines

		return
	end

	self._cached_description, self._num_lines = "\t\n" .. table.concat(lines, "\n"), 1 + #lines
end

GameStateDebug.get_current_state_description = function (self, name)
	if self._dirty then
		self:_update_cache()
	end

	if name then
		return unpack(self._top_level_cache[name] or {})
	end

	return self._cached_description, self._num_lines
end

return GameStateDebug
