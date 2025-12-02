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
		81,
		90,
	},
	CHARACTER_INSIGNIA = {
		36,
		90,
	},
}
Settings.ui_item_display_offsets = {
	default = {
		0,
		8,
		12,
	},
	PORTRAIT_FRAME = {
		12,
		7.5,
		12,
	},
	CHARACTER_INSIGNIA = {
		34.5,
		7.5,
		12,
	},
}

return settings("LiveEventsViewSettings", Settings)
