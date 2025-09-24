-- chunkname: @scripts/ui/views/player_survey_view/player_survey_view_declaration_settings.lua

local view_settings = {
	class = "PlayerSurveyView",
	disable_game_world = true,
	display_name = "loc_player_survey_view",
	package = "packages/ui/views/player_survey_view/player_survey_view",
	path = "scripts/ui/views/player_survey_view/player_survey_view",
	state_bound = false,
	use_transition_ui = false,
	testify_flags = {
		ui_views = false,
	},
}

return settings("PlayerSurveyViewDeclarationSettings", view_settings)
