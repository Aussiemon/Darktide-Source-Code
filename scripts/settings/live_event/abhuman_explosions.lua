-- chunkname: @scripts/settings/live_event/abhuman_explosions.lua

local abhuman_explosions = {
	condition = "loc_abhuman_explosions_condition",
	description = "loc_abhuman_explosions_description",
	event_context = "loc_abhuman_explosions_event_context",
	id = "abhuman_explosions",
	lore = "loc_abhuman_explosions_description_lore",
	name = "loc_abhuman_explosions_name",
	stat = "abhuman_explosions_mission_won",
	item_rewards = {
		"content/items/2d/insignias/insignia_event_abhuman_explosions",
	},
}

return abhuman_explosions
