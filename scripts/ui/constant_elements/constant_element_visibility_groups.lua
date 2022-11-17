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
	},
	{
		name = "tactical_overlay",
		validation_function = function (element)
			local hud = Managers.ui:get_hud()

			return hud and hud:tactical_overlay_active() or false
		end
	},
	{
		name = "cutscene",
		validation_function = function (element)
			return Managers.state.cinematic and Managers.state.cinematic:active_camera()
		end
	},
	{
		name = "mission_lobby",
		validation_function = function (element)
			return Managers.ui:view_active("lobby_view")
		end
	},
	{
		name = "end_of_round",
		validation_function = function (element)
			return Managers.ui:view_active("end_view")
		end
	},
	{
		name = "in_view",
		validation_function = function (element)
			return Managers.ui:has_active_view()
		end
	},
	{
		name = "default",
		validation_function = function (element)
			return true
		end
	}
}

return visibility_groups
