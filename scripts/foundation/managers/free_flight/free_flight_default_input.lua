local FreeFlightDefaultInput = class("FreeFlightDefaultInput")

FreeFlightDefaultInput.frustum_toggle = function (self)
	return Keyboard.pressed(Keyboard.button_index("f10"))
end

FreeFlightDefaultInput.global_toggle = function (self)
	return Keyboard.pressed(Keyboard.button_index("f9"))
end

FreeFlightDefaultInput.top_down_toggle = function (self)
	return Keyboard.pressed(Keyboard.button_index("f8"))
end

FreeFlightDefaultInput.look = function (self)
	return Mouse.axis(0) + Pad1.axis(1)
end

FreeFlightDefaultInput.move_right = function (self)
	return Keyboard.button(Keyboard.button_index("d")) + math.min(Vector3.x(Pad1.axis(0)), 0)
end

FreeFlightDefaultInput.move_left = function (self)
	return Keyboard.button(Keyboard.button_index("a")) + math.min(-Vector3.x(Pad1.axis(0)), 0)
end

FreeFlightDefaultInput.move_forward = function (self)
	return Keyboard.button(Keyboard.button_index("w")) + math.min(Vector3.y(Pad1.axis(0)), 0)
end

FreeFlightDefaultInput.move_backward = function (self)
	return Keyboard.button(Keyboard.button_index("s")) + math.min(-Vector3.y(Pad1.axis(0)), 0)
end

FreeFlightDefaultInput.move_up = function (self)
	return Keyboard.button(Keyboard.button_index("e"))
end

FreeFlightDefaultInput.move_down = function (self)
	return Keyboard.button(Keyboard.button_index("q"))
end

FreeFlightDefaultInput.increase_fov = function (self)
	return Keyboard.pressed(Keyboard.button_index("numpad +"))
end

FreeFlightDefaultInput.decrease_fov = function (self)
	return Keyboard.pressed(Keyboard.button_index("num -"))
end

FreeFlightDefaultInput.toggle_dof = function (self)
	return Keyboard.pressed(Keyboard.button_index("f"))
end

FreeFlightDefaultInput.reset_dof = function (self)
	return Keyboard.button(Keyboard.button_index("f")) > 0.5 and Keyboard.button(Keyboard.button_index("left ctrl")) > 0.5
end

FreeFlightDefaultInput.inc_dof_distance = function (self)
	return Keyboard.button(Keyboard.button_index("g")) > 0.5
end

FreeFlightDefaultInput.dec_dof_distance = function (self)
	return Keyboard.button(Keyboard.button_index("b")) > 0.5
end

FreeFlightDefaultInput.inc_dof_region = function (self)
	return Keyboard.button(Keyboard.button_index("h")) > 0.5
end

FreeFlightDefaultInput.dec_dof_region = function (self)
	return Keyboard.button(Keyboard.button_index("n")) > 0.5
end

FreeFlightDefaultInput.inc_dof_padding = function (self)
	return Keyboard.button(Keyboard.button_index("j")) > 0.5
end

FreeFlightDefaultInput.dec_dof_padding = function (self)
	return Keyboard.button(Keyboard.button_index("m")) > 0.5
end

FreeFlightDefaultInput.inc_dof_scale = function (self)
	return Keyboard.button(Keyboard.button_index("k")) > 0.5
end

FreeFlightDefaultInput.dec_dof_scale = function (self)
	return Keyboard.button(Keyboard.button_index("oem_comma (< ,)")) > 0.5
end

FreeFlightDefaultInput.speed_change = function (self)
	local wheel_axis = Mouse.axis_index("wheel")

	return Vector3.y(Mouse.axis(wheel_axis))
end

FreeFlightDefaultInput.get = function (self, action_name)
	local func = FreeFlightDefaultInput[action_name]

	return func(self)
end

local null_service = {
	get = function (self, action_name)
		local input_type = type(self.input:get(action_name))

		if input_type == "number" then
			return 0
		elseif input_type == "boolean" then
			return false
		elseif input_type == "Vector3" then
			return Vector3.zero()
		else
			ferror("unsupported input type %q for action %q", input_type, action_name)
		end
	end
}

FreeFlightDefaultInput.null_service = function (self)
	null_service.input = self

	return null_service
end

return FreeFlightDefaultInput
