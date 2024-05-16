-- chunkname: @scripts/managers/cinematic/cinematic_manager_testify.lua

local CinematicManagerTestify = {
	deactivate_testify_camera = function (cinematic_manager)
		cinematic_manager:deactivate_testify_camera()
	end,
	set_active_testify_camera = function (cinematic_manager, camera)
		cinematic_manager:set_active_testify_camera(camera)
	end,
	wait_for_mission_intro = function (cinematic_manager)
		local has_mission_intro_played = cinematic_manager:mission_intro_played()

		if not has_mission_intro_played then
			return Testify.RETRY
		end
	end,
}

return CinematicManagerTestify
