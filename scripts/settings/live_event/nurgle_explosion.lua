-- chunkname: @scripts/settings/live_event/nurgle_explosion.lua

local nurgle_explosion = {
	description = "loc_nurgle_explosion_event_description",
	name = "loc_nurgle_explosion_event_name",
	stat = "live_event_nurgle_explosion_won",
	id = "nurgle-explosion",
	icon = "",
	condition = "loc_nurgle_explosion_condition",
	item_rewards = {
		"content/items/2d/portrait_frames/events_poxwalker"
	}
}

return nurgle_explosion
