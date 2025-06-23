-- chunkname: @scripts/ui/views/story_mission_lore_view/story_mission_lore_view_declaration_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local view_settings = {
	display_name = "loc_crafting_view_display_name",
	state_bound = true,
	path = "scripts/ui/views/story_mission_lore_view/story_mission_lore_view",
	package = "packages/ui/views/story_mission_lore_view/story_mission_lore_view",
	class = "StoryMissionLoreView",
	disable_game_world = true,
	load_in_hub = true,
	enter_sound_events = {
		UISoundEvents.story_mission_lore_screen_enter
	},
	exit_sound_events = {
		UISoundEvents.story_mission_lore_screen_exit
	},
	testify_flags = {
		ui_views = false
	}
}

return settings("StoryMissionLoreViewDeclarationSettings", view_settings)
