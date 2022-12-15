local CinematicSceneTemplates = require("scripts/settings/cinematic_scene/cinematic_scene_templates")
local visibility_groups = {
	{
		name = "disabled",
		validation_function = function (element)
			return false
		end
	},
	{
		name = "testify",
		validation_function = function (element)
			return Managers.state.cinematic and Managers.state.cinematic:active_camera() and Managers.state.cinematic._active_testify_camera ~= nil
		end
	}
}
visibility_groups[3] = {
	name = "tactical_overlay",
	validation_function = function (element)
		local hud = Managers.ui:get_hud()

		return hud and hud:tactical_overlay_active() or false
	end
}
visibility_groups[4] = {
	name = "skippable_cinematic",
	validation_function = function (element)
		if Managers.state.cinematic and Managers.state.cinematic:active_camera() then
			local cinematic_scene_system = Managers.state.extension:system("cinematic_scene_system")

			if not cinematic_scene_system then
				return false
			end

			local cinematic_name = cinematic_scene_system:current_cinematic_name()
			local template = CinematicSceneTemplates[cinematic_name]

			return template and template.is_skippable
		else
			return false
		end
	end
}
visibility_groups[5] = {
	name = "cutscene",
	validation_function = function (element)
		return Managers.state.cinematic and Managers.state.cinematic:active_camera()
	end
}
visibility_groups[6] = {
	name = "mission_lobby",
	validation_function = function (element)
		return Managers.ui:view_active("lobby_view")
	end
}
visibility_groups[7] = {
	name = "end_of_round",
	validation_function = function (element)
		return Managers.ui:view_active("end_view")
	end
}
visibility_groups[8] = {
	name = "in_loading",
	validation_function = function (element)
		local current_state_name = Managers.ui:get_current_state_name()

		if current_state_name and current_state_name == "StateLoading" or current_state_name == "GameplayStateInit" or current_state_name == "StateExitToMainMenu" or current_state_name == "StateMissionServerExit" then
			return true
		end

		return false
	end
}
visibility_groups[9] = {
	name = "in_view",
	validation_function = function (element)
		return Managers.ui:has_active_view()
	end
}
visibility_groups[10] = {
	name = "default",
	validation_function = function (element)
		return true
	end
}

return visibility_groups
