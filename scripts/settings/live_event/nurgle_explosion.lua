﻿-- chunkname: @scripts/settings/live_event/nurgle_explosion.lua

local nurgle_explosion = {
	condition = "loc_nurgle_explosion_condition",
	description = "loc_nurgle_explosion_event_description",
	icon = "",
	id = "nurgle-explosion",
	name = "loc_nurgle_explosion_event_name",
	stat = "live_event_nurgle_explosion_won",
	item_rewards = {
		"content/items/2d/portrait_frames/events_poxwalker",
	},
}

return nurgle_explosion
