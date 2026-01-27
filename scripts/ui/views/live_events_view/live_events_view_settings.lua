-- chunkname: @scripts/ui/views/live_events_view/live_events_view_settings.lua

local InputDevice = require("scripts/managers/input/input_device")
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
Settings.input_legend_entries = {
	{
		alignment = "right_alignment",
		display_name = "loc_lobby_legend_tooltip_visibility_on",
		input_action = "mission_board_group_finder_open",
		on_pressed_callback = "_callback_show_reward_tooltip",
		visibility_function = function (parent)
			if not InputDevice.gamepad_active then
				return false
			end

			local active_view_instance = parent._active_view_instance

			return active_view_instance and not active_view_instance._show_reward_tooltip
		end,
	},
	{
		alignment = "right_alignment",
		display_name = "loc_lobby_legend_tooltip_visibility_off",
		input_action = "mission_board_group_finder_open",
		on_pressed_callback = "_callback_hide_reward_tooltip",
		visibility_function = function (parent)
			if not InputDevice.gamepad_active then
				return false
			end

			local active_view_instance = parent._active_view_instance

			return active_view_instance and active_view_instance._show_reward_tooltip
		end,
	},
}

return settings("LiveEventsViewSettings", Settings)
