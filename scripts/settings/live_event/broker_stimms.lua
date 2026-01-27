-- chunkname: @scripts/settings/live_event/broker_stimms.lua

local broker_stimms = {
	condition = "loc_broker_stimms_condition",
	description = "loc_broker_stimms_description",
	event_context = "loc_broker_stimms_event_context",
	id = "broker_stimms",
	lore = "loc_broker_stimms_description_lore",
	name = "loc_broker_stimms_name",
	stat = "broker_stimms_points_acquired",
	item_rewards = {
		"content/items/2d/insignias/insignia_event_stimms",
	},
}

return broker_stimms
