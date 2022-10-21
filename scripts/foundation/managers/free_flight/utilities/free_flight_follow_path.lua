local MainPathQueries = require("scripts/utilities/main_path_queries")
local FreeFlightFollowPath = class("FreeFlightFollowPath")

FreeFlightFollowPath.init = function (self)
	self._active = false
	self._current_path_index = 0
	self._current_position = nil
	self._speed = 7.4
	self._path = nil
end

FreeFlightFollowPath.destroy = function (self)
	self:stop()
end

FreeFlightFollowPath.start = function (self)
	local main_path_manager = Managers.state.main_path
	local is_in_free_flight = Managers.free_flight and Managers.free_flight:is_in_free_flight()

	if not is_in_free_flight then
		Log.warning("FreeFlightFollowPath", "[start] Free Flight is not active.")
	elseif not self._is_active then
		local main_path_segments = main_path_manager:main_path_segments()
		local unified_path, _, _, _, _ = MainPathQueries.generate_unified_main_path(main_path_segments)
		self._active = true
		self._current_path_index = 1
		self._current_position = unified_path[1]
		self._path = unified_path
	end
end

FreeFlightFollowPath.stop = function (self)
	if self._active then
		self._active = false
		self._current_path_index = 0
		self._current_position = nil
		self._path = nil
	end
end

FreeFlightFollowPath.update = function (self, dt, camera_pose)
	if not self:is_arrived() then
		local current_index = self._current_path_index
		local path = self._path
		local vertical_offset = Vector3(0, 0, 2.2)
		local end_pos = path[current_index + 1]:unbox()
		end_pos = end_pos + vertical_offset
		local current_position = self._current_position:unbox()
		local speed = self._speed * dt
		local direction = Vector3.normalize(end_pos - current_position)
		local distance_to_end = Vector3.length(end_pos - current_position)
		local new_position = nil

		if distance_to_end < speed then
			self._current_path_index = current_index + 1
			new_position = end_pos
		else
			new_position = current_position + direction * speed
		end

		if distance_to_end > 0 then
			local current_rotation = Matrix4x4.rotation(camera_pose)
			local target_rotation = Quaternion.look(direction, Vector3(0, 0, 1))
			local final_rotation = Quaternion.lerp(current_rotation, target_rotation, 0.1)

			Matrix4x4.set_rotation(camera_pose, final_rotation)
		end

		self._current_position:store(new_position)
		Matrix4x4.set_translation(camera_pose, new_position)
	end
end

FreeFlightFollowPath.active = function (self)
	return self._active
end

FreeFlightFollowPath.is_arrived = function (self)
	return self._current_path_index == #self._path
end

FreeFlightFollowPath.set_speed = function (self, speed)
	self._speed = speed
end

return FreeFlightFollowPath
