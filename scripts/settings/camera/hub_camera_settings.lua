﻿-- chunkname: @scripts/settings/camera/hub_camera_settings.lua

local hub_camera_settings = {
	camera_speed_zoom_in_speed = 1,
	camera_speed_zoom_out_speed = 1,
	idle_camera_zoom_delay = 1,
	idle_camera_zoom_out_speed = 0.7,
	idle_camera_zoom_speed = 0.5,
	move_state_speed_zoom_targets = {
		idle = 0,
		jog = 0.25,
		sprint = 1,
		walk = 0,
	},
}

return settings("HubCameraSettings", hub_camera_settings)
