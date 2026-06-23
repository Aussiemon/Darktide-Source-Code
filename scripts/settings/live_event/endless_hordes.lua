-- chunkname: @scripts/settings/live_event/endless_hordes.lua

local settings = {
	condition = "loc_live_event_barren_condition",
	description = "loc_live_event_endless_hordes_description",
	event_context = "loc_live_event_endless_hordes_event_context",
	id = "endless_hordes",
	lore = "loc_live_event_endless_hordes_description_lore",
	name = "loc_live_event_endless_hordes_name",
	stat = "live_event_endless_hordes_mission_won",
	item_rewards = {
		"content/items/2d/insignias/insignia_event_endless_hordes",
	},
}

return settings
