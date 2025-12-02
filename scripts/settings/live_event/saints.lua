-- chunkname: @scripts/settings/live_event/saints.lua

local saints = {
	condition = "loc_saints_condition",
	description = "loc_saints_description",
	event_context = "loc_saints_event_context",
	id = "saints",
	lore = "loc_saint_description_lore",
	name = "loc_saints_name",
	stat = "saint_points_acquired",
	item_rewards = {
		"content/items/2d/insignias/insignia_event_saint_b",
	},
}

return saints
