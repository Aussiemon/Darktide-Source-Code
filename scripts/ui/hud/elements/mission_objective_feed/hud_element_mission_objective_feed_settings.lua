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
	critical_color = {
		230,
		255,
		0,
		0,
	},
	alert_text_color = {
		255,
		70,
		38,
		0,
	},
	critical_text_color = Color.ui_hud_red_super_light(255, true),
	colors_by_category = {
		overarching = {
			bar = UIHudSettings.color_tint_main_2,
			bar_frame = UIHudSettings.color_tint_main_2,
			bar_background = UIHudSettings.color_tint_0,
			icon = UIHudSettings.color_tint_main_1,
			header_text = UIHudSettings.color_tint_main_1,
			counter_text = UIHudSettings.color_tint_main_1,
			hazard_above = UIHudSettings.color_tint_main_1,
		},
		default = {
			bar = UIHudSettings.color_tint_main_1,
			bar_frame = UIHudSettings.color_tint_main_1,
			bar_background = UIHudSettings.color_tint_0,
			icon = UIHudSettings.color_tint_main_1,
			header_text = UIHudSettings.color_tint_main_1,
			counter_text = UIHudSettings.color_tint_main_1,
			player_icons_background = {
				125,
				0,
				0,
				0,
			},
			player_icons = Color.terminal_text_header(255, true),
			objective_progress_indicators_background = {
				125,
				0,
				0,
				0,
			},
			objective_progress_indicators = Color.terminal_text_header(255, true),
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
			hazard_above = UIHudSettings.color_tint_main_2,
		},
		alert_info = {
			bar = UIHudSettings.color_tint_main_2,
			bar_frame = UIHudSettings.color_tint_main_2,
			bar_background = UIHudSettings.color_tint_0,
			icon = UIHudSettings.color_tint_main_1,
			header_text = UIHudSettings.color_tint_main_1,
			counter_text = UIHudSettings.color_tint_main_1,
			hazard_above = UIHudSettings.color_tint_main_1,
		},
		alert = {
			bar = UIHudSettings.color_tint_main_1,
			bar_frame = UIHudSettings.color_tint_main_1,
			bar_background = UIHudSettings.color_tint_0,
			icon = UIHudSettings.color_tint_1,
			header_text = UIHudSettings.color_tint_1,
			counter_text = UIHudSettings.color_tint_1,
			hazard_above = {
				230,
				255,
				151,
				29,
			},
		},
		critical = {
			bar = UIHudSettings.color_tint_main_1,
			bar_frame = UIHudSettings.color_tint_main_1,
			bar_background = UIHudSettings.color_tint_0,
			icon = UIHudSettings.color_tint_1,
			header_text = UIHudSettings.color_tint_1,
			counter_text = UIHudSettings.color_tint_1,
			hazard_above = {
				230,
				255,
				0,
				0,
			},
			alert_background = {
				230,
				255,
				0,
				0,
			},
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
		alert_info = {
			icon = {
				32,
				32,
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
		alert_info = {
			icon = {
				10,
				0,
				6,
			},
		},
	},
	alert_text_by_state = {
		alert = "loc_objective_op_train_alert_header",
		critical = "loc_game_mode_expedition_timer_popup_warning_title_final",
		default = "",
	},
	color_by_state = {
		default = {
			body = UIHudSettings.color_tint_main_1,
			text = UIHudSettings.color_tint_main_1,
		},
		alert = {
			body = {
				230,
				255,
				151,
				29,
			},
			text = {
				255,
				70,
				38,
				0,
			},
		},
		critical = {
			body = {
				230,
				255,
				0,
				0,
			},
			text = Color.ui_hud_red_super_light(255, true),
		},
	},
}

return settings("HudElementMissionObjectiveFeedSettings", hud_element_mission_objective_feed_settings)
