-- chunkname: @scripts/settings/live_event/skulls_guns.lua

local settings = {
	condition = "loc_skulls_guns_01_condition",
	description = "loc_skulls_guns_01_description",
	event_context = "loc_skulls_guns_event_context",
	id = "skulls_guns",
	lore = "loc_skulls_guns_description_lore",
	name = "loc_skulls_guns_01_name",
	stat = "live_event_skulls_count",
	item_rewards = {
		"content/items/2d/portrait_frames/events_skulls_guns",
	},
	objective = {
		widgets = {
			{
				template = "live_event_global_reward_counter",
				context = {
					mission_circumstance_family = "skulls_guns",
					stat_category = "lw-mb",
					stat_name = "live_event_skulls_guns_recovered",
					title = "loc_skulls_guns_01_name",
					track_name = "skulls_guns_global-2026",
				},
			},
		},
	},
}

return settings
