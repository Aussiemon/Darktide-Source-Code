-- chunkname: @scripts/ui/views/live_events_view/live_events_view_settings.lua

local Settings = {}

Settings.currency_reward_icons = {
	aquilas = "content/ui/materials/icons/currencies/premium_big",
	credits = "content/ui/materials/icons/currencies/credits_big",
	diamantine = "content/ui/materials/icons/currencies/diamantine_big",
	plasteel = "content/ui/materials/icons/currencies/plasteel_big",
}
Settings.ui_item_display_materials = {
	CHARACTER_INSIGNIA = "content/ui/materials/nameplates/insignias/default",
	PORTRAIT_FRAME = "content/ui/materials/base/ui_portrait_frame_base",
	default = "content/ui/materials/icons/items/containers/item_container_square",
}
Settings.ui_item_display_sizes = {
	default = {
		104,
		88,
	},
	PORTRAIT_FRAME = {
		72,
		80,
	},
	CHARACTER_INSIGNIA = {
		32,
		80,
	},
}
Settings.ui_item_display_offsets = {
	default = {
		0,
		8,
		12,
	},
	PORTRAIT_FRAME = {
		12.299999999999997,
		8.299999999999997,
		12,
	},
	CHARACTER_INSIGNIA = {
		32.3,
		8.299999999999997,
		12,
	},
}

return settings("LiveEventsViewSettings", Settings)
