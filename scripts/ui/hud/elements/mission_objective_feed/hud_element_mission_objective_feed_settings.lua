-- chunkname: @scripts/ui/hud/elements/mission_objective_feed/hud_element_mission_objective_feed_settings.lua

local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local hud_element_mission_objective_feed_settings = {
	description_text_height_offset = 5,
	entry_spacing = 0,
	scan_delay = 0.25,
	header_size = {
		460,
		40,
	},
	events = {
		event_add_mission_objective = "event_add_objective",
		event_remove_mission_objective = "_remove_objective",
	},
	entry_spacing_by_category = {
		default = 0,
		overarching = 0,
		side_mission = 0,
		warning = 0,
	},
	widget_padding_by_category = {
		default = 10,
		overarching = 10,
		side_mission = 10,
		warning = 0,
	},
	entry_order_by_objective_category = {
		default = 2,
		overarching = 1,
		side_mission = 3,
		warning = 4,
	},
	base_color = UIHudSettings.color_tint_main_1,
	muted_color = UIHudSettings.color_tint_4,
	darkened_color = Color.terminal_text_body_sub_header(255, true),
	alert_color = {
		230,
		255,
		151,
		29,
	},
	colors_by_category = {
		overarching = {
			bar = UIHudSettings.color_tint_main_2,
			bar_frame = UIHudSettings.color_tint_main_2,
			bar_background = UIHudSettings.color_tint_0,
			icon = UIHudSettings.color_tint_main_1,
			header_text = UIHudSettings.color_tint_main_1,
			counter_text = UIHudSettings.color_tint_main_1,
		},
		default = {
			bar = UIHudSettings.color_tint_main_1,
			bar_frame = UIHudSettings.color_tint_main_1,
			bar_background = UIHudSettings.color_tint_0,
			icon = UIHudSettings.color_tint_main_1,
			header_text = UIHudSettings.color_tint_main_1,
			counter_text = UIHudSettings.color_tint_main_1,
		},
		side_mission = {
			bar = UIHudSettings.color_tint_6,
			bar_frame = UIHudSettings.color_tint_6,
			bar_background = UIHudSettings.color_tint_0,
			icon = UIHudSettings.color_tint_6,
			header_text = UIHudSettings.color_tint_6,
			counter_text = UIHudSettings.color_tint_6,
		},
		warning = {
			bar = UIHudSettings.color_tint_main_1,
			bar_frame = UIHudSettings.color_tint_main_1,
			bar_background = UIHudSettings.color_tint_0,
			icon = UIHudSettings.color_tint_main_1,
			header_text = UIHudSettings.color_tint_main_1,
			counter_text = UIHudSettings.color_tint_main_1,
		},
	},
	size_by_category = {
		overarching = {
			icon = {
				32,
				32,
			},
		},
		default = {
			icon = {
				32,
				32,
			},
		},
		side_mission = {
			icon = {
				20,
				20,
			},
		},
		warning = {
			icon = {
				0,
				0,
			},
		},
	},
	offsets_by_category = {
		overarching = {
			icon = {
				10,
				0,
				6,
			},
		},
		default = {
			icon = {
				10,
				0,
				6,
			},
		},
		side_mission = {
			icon = {
				16,
				0,
				6,
			},
		},
		warning = {
			icon = {
				0,
				0,
				6,
			},
		},
	},
}

return settings("HudElementMissionObjectiveFeedSettings", hud_element_mission_objective_feed_settings)
