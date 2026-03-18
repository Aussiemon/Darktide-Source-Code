-- chunkname: @scripts/settings/live_event/elite_army.lua

local elite_army = {
	condition = "loc_elite_army_condition",
	description = "loc_elite_army_description",
	event_context = "loc_elite_army_event_context",
	id = "elite_army",
	lore = "loc_elite_army_description_lore",
	name = "loc_elite_army_name",
	stat = "elite_army_mission_won",
	item_rewards = {
		"content/items/2d/insignias/insignia_event_elite_army",
	},
}

return elite_army
