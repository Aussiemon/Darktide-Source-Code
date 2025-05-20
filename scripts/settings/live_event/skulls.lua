-- chunkname: @scripts/settings/live_event/skulls.lua

local skulls = {
	condition = "loc_skulls_01_condition",
	description = "loc_skulls_01_description",
	id = "skulls",
	name = "loc_skulls_01_name",
	stat = "live_event_skulls_count",
	item_rewards = {
		"content/items/2d/insignias/insignia_skull_week_2025",
	},
	combat_feed = {
		loc_key = "loc_skulls_01_notification",
		stat_id = "live_event_skulls_forward",
	},
}

return skulls
