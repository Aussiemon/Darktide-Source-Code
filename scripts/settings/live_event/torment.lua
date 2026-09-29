-- chunkname: @scripts/settings/live_event/torment.lua

local torment = {
	condition = "loc_torment_condition",
	description = "loc_torment_description",
	event_context = "loc_torment_event_context",
	id = "torment",
	lore = "loc_torment_description_lore",
	name = "loc_torment_name",
	stat = "live_event_torment_witch_kills",
	item_rewards = {
		"content/items/weapons/player/trinkets/live_event/trinket_live_event_torment_01",
		"content/items/2d/portrait_frames/events_torment_global_01",
	},
	global_stats = {
		category = "lw-mb",
	},
	objective = {
		widgets = {
			{
				template = "live_event_global_reward_counter",
				context = {
					mission_circumstance_family = "torment",
					stat_category = "lw-mb",
					stat_name = "live_event_torment_witch_damage_dealt",
					title = "loc_torment_condition_community",
					track_name = "torment_global-2026",
				},
			},
		},
	},
}

return torment
