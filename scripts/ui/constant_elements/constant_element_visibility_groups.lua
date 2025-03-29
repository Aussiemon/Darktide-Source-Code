-- chunkname: @scripts/ui/constant_elements/constant_element_visibility_groups.lua

local CinematicSceneTemplates = require("scripts/settings/cinematic_scene/cinematic_scene_templates")

local function _is_in_hub()
	local game_mode_manager = Managers.state.game_mode
	local game_mode_name = game_mode_manager and game_mode_manager:game_mode_name()
	local is_in_hub = game_mode_name == "hub"

	return is_in_hub
end

local visibility_groups = {
	{
		name = "disabled",
		validation_function = function (element)
			return false
		end,
	},
	{
		name = "testify",
		validation_function = function (element)
			return Managers.state.cinematic and Managers.state.cinematic:active_camera() and Managers.state.cinematic._active_testify_camera ~= nil
		end,
	},
	{
		name = "tactical_overlay",
		validation_function = function (element)
			local hud = Managers.ui:get_hud()

			return hud and hud:tactical_overlay_active() or false
		end,
	},
	{
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
		end,
	},
	{
		name = "cutscene",
		validation_function = function (element)
			return Managers.state.cinematic and Managers.state.cinematic:active_camera()
		end,
	},
	{
		name = "mission_lobby",
		validation_function = function (element)
			return Managers.ui:view_active("lobby_view")
		end,
	},
	{
		name = "end_of_round",
		validation_function = function (element)
			return Managers.ui:view_active("end_view")
		end,
	},
	{
		name = "in_loading",
		validation_function = function (element)
			local current_state_name = Managers.ui:get_current_state_name()

			if current_state_name and current_state_name == "StateLoading" or current_state_name == "GameplayStateInit" or current_state_name == "StateExitToMainMenu" or current_state_name == "StateMissionServerExit" then
				return true
			end

			return false
		end,
	},
	{
		name = "in_hub_view",
		validation_function = function (hud)
			if _is_in_hub() then
				return not Managers.ui:allow_hud()
			end

			return false
		end,
	},
	{
		name = "in_view",
		validation_function = function (element)
			return Managers.ui:has_active_view()
		end,
	},
	{
		name = "in_hub",
		validation_function = function (element)
			return _is_in_hub()
		end,
	},
	{
		name = "in_mission",
		validation_function = function (element)
			local view_open = Managers.ui:has_active_view()
			local mechanism_manager = Managers.mechanism
			local mechanism_name = mechanism_manager:mechanism_name()
			local in_cinematic = Managers.state.cinematic and Managers.state.cinematic:active_camera()

			return mechanism_name == "adventure" and not view_open and not in_cinematic
		end,
	},
	{
		name = "default",
		validation_function = function (element)
			return true
		end,
	},
}

return visibility_groups
