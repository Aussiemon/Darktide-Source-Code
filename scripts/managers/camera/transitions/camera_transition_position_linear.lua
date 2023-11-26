-- chunkname: @scripts/managers/camera/transitions/camera_transition_position_linear.lua

local CameraTransitionBase = require("scripts/managers/camera/transitions/camera_transition_base")
local CameraTransitionPositionLinear = class("CameraTransitionPositionLinear", "CameraTransitionBase")

CameraTransitionPositionLinear.init = function (self, node_1, node_2, duration, speed, settings)
	CameraTransitionBase.init(self, node_1, node_2, duration, speed, settings)

	self._freeze_node_1 = settings.freeze_start_node

	if self._freeze_node_1 then
		local node_1_pos = node_1:position()

		self._node_1_pos_table = Vector3Box(node_1_pos)
	end

	self._transition_func = settings.transition_func
end

CameraTransitionPositionLinear.use_collision = function (self)
	return self._node_1:use_collision()
end

CameraTransitionPositionLinear.safe_position_offset = function (self)
	return self._node_1:safe_position_offset()
end

CameraTransitionPositionLinear.update = function (self, dt, position, update_time)
	CameraTransitionBase.update(self, dt, update_time)

	local node_1_position = self._freeze_node_1 and self._node_1_pos_table:unbox() or position
	local node_2_position = self._node_2:position()
	local duration = self._duration
	local speed = self._speed
	local time = self._time
	local pos, done

	if speed and duration then
		-- Nothing
	elseif speed then
		local target_vec = node_2_position - node_1_position
		local max_length = Vector3.length(target_vec)
		local dist_moved = time * speed

		if max_length <= dist_moved then
			pos = node_2_position
			done = true
		else
			local dir = Vector3.normalize(target_vec)

			pos = node_1_position + dir * dist_moved
		end
	elseif duration then
		local t = time / duration

		t = math.min(t, 1)

		if self._transition_func then
			t = self._transition_func(t)
		end

		pos = node_1_position * (1 - t) + node_2_position * t
		done = duration < time
	end

	return pos, done
end

return CameraTransitionPositionLinear
