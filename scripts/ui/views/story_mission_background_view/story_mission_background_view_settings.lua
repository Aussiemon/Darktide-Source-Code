-- chunkname: @scripts/ui/views/story_mission_background_view/story_mission_background_view_settings.lua

local story_mission_background_view_settings = {
	vo_event_greeting = {
		"hub_interact_explicator_likes_character"
	},
	vo_event_twins_epilogue = {
		"twins_epilogue_02_a",
		"twins_epilogue_02_b",
		"twins_epilogue_02_c",
		"twins_epilogue_02_d",
		"twins_epilogue_02_e",
		"twins_epilogue_02_f",
		"twins_epilogue_02_g",
		"twins_epilogue_02_h",
		"twins_epilogue_02_i",
		"twins_epilogue_02_j",
		"twins_epilogue_02_k"
	}
}

return settings("StoryMissionBackgroundViewSettings", story_mission_background_view_settings)
