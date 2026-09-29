-- chunkname: @scripts/settings/live_event/play_spillway.lua

local settings = {
	description = "loc_live_event_play_spillway_description",
	event_context = "loc_live_event_play_spillway_event_context",
	id = "play_spillway",
	lore = "loc_live_event_play_spillway_description_lore",
	name = "loc_live_event_play_spillway_name",
	objectives = {
		{
			condition = "loc_live_event_play_spillway_objective_01",
			stat = "live_event_play_spillway_mission_01_won",
			tiers = 1,
		},
		{
			condition = "loc_live_event_play_spillway_objective_02",
			stat = "live_event_play_spillway_mission_02_won",
			tiers = 1,
		},
		{
			condition = "loc_live_event_play_spillway_objective_03",
			stat = "live_event_play_spillway_mission_03_won",
			tiers = 1,
		},
		{
			condition = "loc_live_event_play_spillway_objective_04",
			stat = "live_event_play_spillway_mission_any",
		},
	},
	item_rewards = {
		"content/items/2d/insignias/insignia_event_play_spillway",
	},
}

return settings
