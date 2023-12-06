local view_settings = {
	package = "packages/ui/views/story_mission_play_view/story_mission_play_view",
	state_bound = true,
	class = "StoryMissionPlayView",
	disable_game_world = true,
	load_in_hub = true,
	path = "scripts/ui/views/story_mission_play_view/story_mission_play_view",
	testify_flags = {
		ui_views = false
	}
}

return settings("StoryMissionPlayViewDeclarationSettings", view_settings)
