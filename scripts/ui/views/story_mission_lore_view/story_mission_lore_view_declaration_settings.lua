-- chunkname: @scripts/ui/views/story_mission_lore_view/story_mission_lore_view_declaration_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local view_settings = {
	class = "StoryMissionLoreView",
	disable_game_world = true,
	display_name = "loc_crafting_view_display_name",
	package = "packages/ui/views/story_mission_lore_view/story_mission_lore_view",
	path = "scripts/ui/views/story_mission_lore_view/story_mission_lore_view",
	state_bound = true,
	enter_sound_events = {
		UISoundEvents.story_mission_lore_screen_enter,
	},
	exit_sound_events = {
		UISoundEvents.story_mission_lore_screen_exit,
	},
}

return settings("StoryMissionLoreViewDeclarationSettings", view_settings)
