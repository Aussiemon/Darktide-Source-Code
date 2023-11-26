-- chunkname: @scripts/extension_systems/input/human_unit_input.lua

local HumanUnitInput = class("HumanUnitInput")

HumanUnitInput.init = function (self, player, input_handler, fixed_frame)
	self._player = player
	self._input_handler = input_handler
	self._frame = fixed_frame
end

HumanUnitInput.fixed_update = function (self, unit, dt, t, frame)
	self._frame = frame
end

HumanUnitInput.get_orientation = function (self)
	local frame = self._frame

	return self._input_handler:get_orientation(frame)
end

HumanUnitInput.get = function (self, action)
	local frame = self._frame

	if action == "move" then
		local input = self._input_handler
		local right, left, forward, backward = input:get("move_right", frame), input:get("move_left", frame), input:get("move_forward", frame), input:get("move_backward", frame)

		return Vector3(right - left, forward - backward, 0)
	else
		return self._input_handler:get(action, frame)
	end
end

HumanUnitInput.had_received_input = function (self, fixed_frame)
	return self._input_handler:had_received_input(fixed_frame)
end

return HumanUnitInput
