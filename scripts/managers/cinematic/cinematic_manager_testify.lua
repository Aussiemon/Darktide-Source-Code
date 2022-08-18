local CinematicManagerTestify = {
	deactivate_testify_camera = function (_, cinematic_manager)
		cinematic_manager:deactivate_testify_camera()
	end,
	set_active_testify_camera = function (camera, cinematic_manager)
		cinematic_manager:set_active_testify_camera(camera)
	end,
	wait_for_cinematic_to_be_over = function (_, cinematic_manager)
		if cinematic_manager:active() then
			return Testify.RETRY
		end
	end
}

return CinematicManagerTestify
