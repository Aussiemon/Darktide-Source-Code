local CameraHandlerTestify = {
	set_force_spectate = function (spectate_value, camera_handler)
		camera_handler._testify_force_spectate = spectate_value
	end
}

return CameraHandlerTestify
