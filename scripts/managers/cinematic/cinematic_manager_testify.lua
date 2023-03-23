local CinematicManagerTestify = {
	deactivate_testify_camera = function (_, cinematic_manager)
		cinematic_manager:deactivate_testify_camera()
	end,
	set_active_testify_camera = function (camera, cinematic_manager)
		cinematic_manager:set_active_testify_camera(camera)
	end,
	wait_for_mission_intro = function (_, cinematic_manager)
		local has_mission_intro_played = cinematic_manager:mission_intro_played()

		if not has_mission_intro_played then
			return Testify.RETRY
		end
	end
}

return CinematicManagerTestify
