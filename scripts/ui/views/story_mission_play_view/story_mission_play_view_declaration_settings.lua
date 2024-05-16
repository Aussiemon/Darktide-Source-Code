-- chunkname: @scripts/ui/views/story_mission_play_view/story_mission_play_view_declaration_settings.lua

local view_settings = {
	class = "StoryMissionPlayView",
	disable_game_world = true,
	load_in_hub = true,
	package = "packages/ui/views/story_mission_play_view/story_mission_play_view",
	path = "scripts/ui/views/story_mission_play_view/story_mission_play_view",
	state_bound = true,
	testify_flags = {
		ui_views = false,
	},
}

return settings("StoryMissionPlayViewDeclarationSettings", view_settings)
