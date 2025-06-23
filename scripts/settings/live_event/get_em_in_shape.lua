-- chunkname: @scripts/settings/live_event/get_em_in_shape.lua

local get_em_in_shape = {
	description = "loc_get_em_in_shape_event_description",
	name = "loc_get_em_in_shape_event_name",
	stat = "live_event_get_em_in_shape_won",
	id = "get-em-in-shape",
	icon = "",
	condition = "loc_get_em_in_shape_condition",
	item_rewards = {
		"content/items/weapons/player/trinkets/trinket_15c"
	}
}

return get_em_in_shape
