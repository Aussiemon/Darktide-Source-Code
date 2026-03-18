-- chunkname: @scripts/settings/live_event/play_expeditions.lua

local settings = {
	condition = "loc_play_expeditions_condition",
	description = "loc_play_expeditions_description",
	event_context = "loc_play_expeditions_event_context",
	id = "play_expeditions",
	lore = "loc_play_expeditions_description_lore",
	name = "loc_play_expeditions_name",
	stat = "live_event_expeditions_loot_extracted",
	item_rewards = {
		"content/items/2d/portrait_frames/events_play_expeditions",
	},
}

return settings
