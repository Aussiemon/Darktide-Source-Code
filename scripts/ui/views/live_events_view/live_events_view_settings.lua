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
	PORTRAIT_FRAME = "content/ui/materials/icons/items/containers/item_container_square",
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
	{
		alignment = "right_alignment",
		display_name = "loc_alias_view_next",
		input_action = "navigate_primary_right_pressed",
		on_pressed_callback = "_on_next_page_pressed",
		visibility_function = function (parent)
			local active_view_instance = parent._active_view_instance

			if active_view_instance and active_view_instance.view_name == "live_events_view" then
				local entries = active_view_instance._entry_data
				local pages = entries and #entries

				return pages and pages > 1
			end
		end,
	},
	{
		alignment = "right_alignment",
		display_name = "loc_previous",
		input_action = "navigate_primary_left_pressed",
		on_pressed_callback = "_on_previous_page_pressed",
		visibility_function = function (parent)
			local active_view_instance = parent._active_view_instance

			if active_view_instance and active_view_instance.view_name == "live_events_view" then
				local entries = active_view_instance._entry_data
				local pages = entries and #entries

				return pages and pages > 1
			end
		end,
	},
}
Settings.faction_settings = {
	leftover = {
		pure = {
			buff = "live_event_leftover_buff_faction_a",
			display_name = "loc_leftover_faction_a_name",
			id = "pure",
			texture = "content/ui/textures/backgrounds/live_events/leftover_event_faction_a",
			color = Color.citadel_jokaero_orange(255, true),
		},
		impure = {
			buff = "live_event_leftover_buff_faction_b",
			display_name = "loc_leftover_faction_b_name",
			id = "impure",
			texture = "content/ui/textures/backgrounds/live_events/leftover_event_faction_b",
			color = Color.citadel_guilliman_blue(255, true),
		},
	},
}
Settings.global_stats_settings = {
	leftover = {
		category = "lw-mb",
		stats = {
			heretical_artifacts_impure = "impure",
			heretical_artifacts_pure = "pure",
			impure = "heretical_artifacts_impure",
			pure = "heretical_artifacts_pure",
		},
	},
}
Settings.default_entry_width = 1420
Settings.default_progress_bar_size = {
	1200,
	20,
}
Settings.live_events_history_limit = 5
Settings.live_events_history_entries = {
	"skulls_guns",
	"elite_army",
	"play_expeditions",
	"abhuman_explosions",
	"broker_stimms",
	"saints",
}

return settings("LiveEventsViewSettings", Settings)
