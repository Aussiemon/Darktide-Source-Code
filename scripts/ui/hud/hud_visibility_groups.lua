local visibility_groups = {
	{
		name = "disabled",
		validation_function = function (hud)
			return false
		end
	},
	{
		name = "popup",
		validation_function = function (hud)
			return Managers.ui:handling_popups()
		end
	},
	{
		name = "prologue_cutscene",
		validation_function = function (hud)
			if not Managers.state or not Managers.state.cinematic or not Managers.state.game_mode then
				return false
			end

			return Managers.state.cinematic:active_camera() and Managers.state.game_mode:is_prologue()
		end
	},
	{
		name = "cutscene",
		validation_function = function (hud)
			if not Managers.state or not Managers.state.cinematic then
				return false
			end

			return Managers.ui:view_active("cutscene_view") and Managers.state.cinematic:active_camera()
		end
	},
	{
		name = "in_view",
		validation_function = function (hud)
			return not Managers.ui:allow_hud()
		end
	},
	{
		name = "communication_wheel",
		validation_function = function (hud)
			return hud:communication_wheel_active()
		end
	},
	{
		name = "tactical_overlay",
		validation_function = function (hud)
			return hud:tactical_overlay_active()
		end
	},
	{
		name = "testify",
		validation_function = function (hud)
			return Managers.state.cinematic:active_camera() and Managers.state.cinematic._active_testify_camera ~= nil
		end
	},
	{
		name = "dead",
		validation_function = function (hud)
			local player = hud:player()

			return not player:unit_is_alive()
		end
	},
	{
		name = "alive",
		validation_function = function (hud)
			local player_extensions = hud:player_extensions()

			if player_extensions then
				local health_extension = player_extensions.health

				return health_extension:is_alive()
			end

			return false
		end
	}
}

return visibility_groups
