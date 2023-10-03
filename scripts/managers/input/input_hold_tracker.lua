local InputUtils = require("scripts/managers/input/input_utils")
local InputHoldTracker = class("InputHoldTracker")

InputHoldTracker.init = function (self, input_service_name)
	self._input_service_name = input_service_name
	self._input_service = Managers.input:get_input_service(input_service_name)
	self._track_id = 0
	self._tracked_actions = {}
	self._has_delayed_actions = false
	self._delayed_actions = {}
end

InputHoldTracker.start_tracking = function (self, action_name, time_completed, cb_completed)
	local action_type = self._input_service:get_action_type(action_name)
	local id = self._track_id + 1
	self._track_id = id
	self._tracked_actions[id] = {
		time_held = 0,
		action_name = action_name,
		time_completed = time_completed,
		cb_completed = cb_completed
	}

	return id
end

InputHoldTracker.stop_tracking = function (self, id)
	self._tracked_actions[id] = nil
end

InputHoldTracker.update = function (self, dt)
	local input_service = self._input_service

	if self._has_delayed_actions then
		self:_reset_delayed_actions()
	end

	local has_input = false

	for id, data in pairs(self._tracked_actions) do
		local action_name = data.action_name
		local time_held = data.time_held

		if input_service:get(action_name) then
			time_held = time_held + dt

			if data.time_completed <= time_held then
				data.cb_completed()

				self._tracked_actions[id] = nil
			end

			has_input = true
		elseif time_held > 0 then
			time_held = 0

			self:_trigger_delayed_actions(action_name)
		end

		data.time_held = time_held
	end

	return has_input
end

InputHoldTracker._reset_delayed_actions = function (self)
	local input_service_name = self._input_service_name
	local delayed_actions = self._delayed_actions

	for action_name, _ in pairs(delayed_actions) do
		InputUtils.stop_simulate_action(input_service_name, action_name)
	end

	table.clear(delayed_actions)

	self._has_delayed_actions = false
end

InputHoldTracker._trigger_delayed_actions = function (self, action_name)
	local found_actions = self:_lookup_actions_with_same_input_key(action_name)

	for name, action in pairs(found_actions) do
		if action.type == "pressed" then
			InputUtils.start_simulate_action(self._input_service_name, name, true)

			self._delayed_actions[name] = true
			self._has_delayed_actions = true
		end
	end
end

local temp_found_actions = {}

InputHoldTracker._lookup_actions_with_same_input_key = function (self, action_name)
	table.clear(temp_found_actions)

	local input_service = self._input_service
	local keys = input_service:reverse_lookup(action_name)

	if keys then
		for i = 1, #keys do
			local key = keys[i]

			for name, action in pairs(input_service:actions()) do
				if name ~= action_name then
					local k = input_service:reverse_lookup(name)

					if k and table.index_of(k, key) > 0 then
						temp_found_actions[name] = action
					end
				end
			end
		end
	end

	return temp_found_actions
end

return InputHoldTracker
