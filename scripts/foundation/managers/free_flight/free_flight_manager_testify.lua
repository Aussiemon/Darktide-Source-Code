﻿-- chunkname: @scripts/foundation/managers/free_flight/free_flight_manager_testify.lua

local function _active_camera_id(free_flight_manager)
	local free_flight_cameras = free_flight_manager._free_flight_cameras
	local active_camera = table.filter(free_flight_cameras, function (data)
		return data.active
	end)
	local camera_id, _ = next(active_camera)

	return camera_id
end

local FreeFlightManagerTestify = {
	enter_free_flight = function (free_flight_manager)
		local global_camera = free_flight_manager._free_flight_cameras.global

		if not global_camera.active then
			free_flight_manager:_enter_global_free_flight(global_camera)
		end
	end,
	set_free_flight_camera_position = function (free_flight_manager, camera_data)
		local camera_id = _active_camera_id(free_flight_manager)
		local pos = camera_data.position
		local rot = camera_data.rotation
		local position = pos:unbox()
		local rotation = rot:unbox()

		free_flight_manager:teleport_camera(camera_id, position, rotation)
	end,
	free_flight_camera_follow_main_path = function (free_flight_manager, speed)
		free_flight_manager:toggle_follow_path()
		free_flight_manager:set_follow_path_speed(speed)
	end,
	free_flight_camera_is_arrived_end_of_main_path = function (free_flight_manager)
		return free_flight_manager._follow_path:is_arrived()
	end,
}

return FreeFlightManagerTestify
