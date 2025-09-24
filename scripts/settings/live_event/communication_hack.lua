-- chunkname: @scripts/settings/live_event/communication_hack.lua

local communication_hack = {
	condition = "loc_communication_hack_condition",
	description = "loc_communication_hack_description",
	icon = "",
	id = "communication_hack",
	name = "loc_communication_hack_name",
	stat = "side_communication_hack_device_end_of_round",
	item_rewards = {
		"content/items/2d/insignias/insignia_event_hack",
	},
}

return communication_hack
