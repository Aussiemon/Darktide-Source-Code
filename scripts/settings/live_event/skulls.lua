-- chunkname: @scripts/settings/live_event/skulls.lua

local skulls = {
	description = "loc_skulls_01_description",
	name = "loc_skulls_01_name",
	id = "skulls",
	stat = "live_event_skulls_count",
	condition = "loc_skulls_01_condition",
	item_rewards = {
		"content/items/2d/insignias/insignia_skull_week_2025"
	},
	combat_feed = {
		loc_key = "loc_skulls_01_notification",
		stat_id = "live_event_skulls_forward"
	}
}

return skulls
