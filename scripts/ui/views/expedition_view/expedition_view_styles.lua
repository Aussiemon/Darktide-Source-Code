-- chunkname: @scripts/ui/views/expedition_view/expedition_view_styles.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local Settings = require("scripts/ui/views/expedition_view/expedition_view_settings")
local Dimensions = Settings.dimensions
local Colors = Settings.colors
local ExpeditionViewStyles = {}

ExpeditionViewStyles.play_button = {}
ExpeditionViewStyles.play_button.default = {
	scale_to_material = true,
	offset = {
		0,
		0,
		3,
	},
}
ExpeditionViewStyles.play_button.hover = {
	horizontal_alignment = "center",
	scale_to_material = true,
	vertical_alignment = "center",
	offset = {
		0,
		1,
		4,
	},
	color = {
		125,
		255,
		255,
		255,
	},
}
ExpeditionViewStyles.play_button.hotspot = {
	horizontal_alignment = "center",
	vertical_alignment = "center",
	on_hover_sound = UISoundEvents.default_mouse_hover,
	on_pressed_sound = UISoundEvents.default_click,
	offset = {
		0,
		0,
		2,
	},
	size = {
		268,
		40,
	},
	color = {
		255,
		255,
		255,
		0,
	},
}
ExpeditionViewStyles.play_button.disabled = {
	hdr = true,
	scale_to_material = true,
	offset = {
		0,
		0,
		3,
	},
}
ExpeditionViewStyles.play_button.default_text = {
	font_size = 28,
	font_type = "mono_tide_medium",
	horizontal_alignment = "center",
	text_horizontal_alignment = "center",
	text_vertical_alignment = "center",
	vertical_alignment = "center",
	offset = {
		0,
		0,
		5,
	},
	size_addition = {
		0,
		0,
	},
	text_color = Color.light_green(nil, true),
}
ExpeditionViewStyles.play_button.selected_text = {
	font_size = 32,
	font_type = "proxima_nova_bold",
	horizontal_alignment = "center",
	text_horizontal_alignment = "center",
	text_vertical_alignment = "center",
	vertical_alignment = "center",
	offset = {
		0,
		0,
		5,
	},
	size_addition = {
		0,
		0,
	},
	text_color = Color.black(nil, true),
}
ExpeditionViewStyles.play_button.disabled_text = {
	font_size = 18,
	font_type = "proxima_nova_medium",
	horizontal_alignment = "center",
	text_horizontal_alignment = "center",
	text_vertical_alignment = "center",
	vertical_alignment = "center",
	size = {
		345,
		72,
	},
	offset = {
		0,
		0,
		5,
	},
	size_addition = {
		0,
		0,
	},
	text_color = Color.ui_interaction_critical(255, true),
}
ExpeditionViewStyles.mapwide_stats = {}
ExpeditionViewStyles.mapwide_stats.frame = {
	scale_to_material = true,
	offset = {
		0,
		0,
		20,
	},
	color = Colors.terminal_frame,
}
ExpeditionViewStyles.mapwide_stats.background = {
	horizontal_alignment = "center",
	vertical_alignment = "top",
	color = {
		255,
		0,
		0,
		0,
	},
}
ExpeditionViewStyles.mapwide_stats.title = {
	font_size = 20,
	font_type = "mono_tide_bold",
	horizontal_alignment = "left",
	text_horizontal_alignment = "left",
	text_vertical_alignment = "center",
	vertical_alignment = "top",
	text_color = Colors.text_light,
	offset = {
		10,
		10,
		5,
	},
	size = {
		Dimensions.sidebar_size[1] - 20,
		20,
	},
}
ExpeditionViewStyles.mapwide_stats.divider_line = {
	horizontal_alignment = "left",
	vertical_alignment = "top",
	size = {
		Dimensions.sidebar_size[1],
		1,
	},
	color = Colors.terminal_frame,
	offset = {
		0,
		40,
		5,
	},
	size_addition = {
		0,
		0,
	},
}
ExpeditionViewStyles.mapwide_stats.personal_total_text = {
	font_size = 16,
	font_type = "mono_tide_medium",
	horizontal_alignment = "left",
	text_horizontal_alignment = "left",
	text_vertical_alignment = "center",
	vertical_alignment = "top",
	text_color = Colors.text_dark,
	offset = {
		10,
		50,
		5,
	},
	size = {
		Dimensions.sidebar_size[1] - 65,
		20,
	},
}
ExpeditionViewStyles.mapwide_stats.personal_total_number = {
	font_size = 16,
	font_type = "mono_tide_medium",
	horizontal_alignment = "right",
	text_horizontal_alignment = "right",
	text_vertical_alignment = "center",
	vertical_alignment = "top",
	text_color = Colors.text_dark,
	offset = {
		-55,
		50,
		5,
	},
	size = {
		Dimensions.sidebar_size[1] - 65,
		20,
	},
}
ExpeditionViewStyles.mapwide_stats.personal_total_icon = {
	horizontal_alignment = "right",
	vertical_alignment = "top",
	size = Settings.loot_icon_size,
	offset = {
		-10,
		45,
		5,
	},
	color = Colors.text_dark,
}
ExpeditionViewStyles.mapwide_stats.divider_line_2 = {
	horizontal_alignment = "left",
	vertical_alignment = "top",
	size = {
		Dimensions.sidebar_size[1],
		1,
	},
	color = Colors.terminal_frame,
	offset = {
		0,
		80,
		5,
	},
	size_addition = {
		0,
		0,
	},
}
ExpeditionViewStyles.mapwide_stats.personal_best_text = {
	font_size = 16,
	font_type = "mono_tide_medium",
	horizontal_alignment = "left",
	text_horizontal_alignment = "left",
	text_vertical_alignment = "center",
	vertical_alignment = "top",
	text_color = Colors.text_dark,
	offset = {
		10,
		90,
		5,
	},
	size = {
		Dimensions.sidebar_size[1] - 65,
		20,
	},
}
ExpeditionViewStyles.mapwide_stats.personal_best_number = {
	font_size = 16,
	font_type = "mono_tide_medium",
	horizontal_alignment = "right",
	text_horizontal_alignment = "right",
	text_vertical_alignment = "center",
	vertical_alignment = "top",
	text_color = Colors.text_dark,
	offset = {
		-55,
		90,
		5,
	},
	size = {
		Dimensions.sidebar_size[1] - 65,
		20,
	},
}
ExpeditionViewStyles.mapwide_stats.personal_best_icon = {
	horizontal_alignment = "right",
	vertical_alignment = "top",
	size = Settings.loot_icon_size,
	offset = {
		-10,
		85,
		5,
	},
	color = Colors.text_dark,
}
ExpeditionViewStyles.sidebar_fade = {
	color = {
		255,
		0,
		0,
		0,
	},
	offset = {
		0,
		0,
		1,
	},
}

return ExpeditionViewStyles
