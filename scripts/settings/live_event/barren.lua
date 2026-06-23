-- chunkname: @scripts/settings/live_event/barren.lua

local settings = {
	condition = "loc_live_event_barren_condition",
	description = "loc_live_event_barren_description",
	event_context = "loc_live_event_barren_event_context",
	id = "barren",
	lore = "loc_live_event_barren_description_lore",
	name = "loc_live_event_barren_name",
	stat = "live_event_barren_mission_won",
	item_rewards = {
		"content/items/2d/insignias/insignia_event_barren",
	},
}

return settings
