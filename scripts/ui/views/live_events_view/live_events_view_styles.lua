-- chunkname: @scripts/ui/views/live_events_view/live_events_view_styles.lua

require("scripts/foundation/utilities/color")

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local Styles = {}
local sizes = {
	entry_width = 1420,
	text_max_width = 1040,
	reward_size = {
		96.6,
		96.6,
	},
	reward_icon_size = {
		52,
		44,
	},
	reward_currency_icon_size = {
		57.2,
		48.400000000000006,
	},
	reward_icon_size_addition = {
		0,
		0,
	},
	event_button_size = {
		380,
		50,
	},
	tooltip_size = {
		400,
		120,
	},
}
local spacing = {
	button_spacing = 60,
	entry_padding = 60,
	event_name_height = 60,
	reward_track_spacing = 300,
	text_top_padding = 30,
}

Styles.texts = {}
Styles.texts.event_name = {
	font_size = 36,
	font_type = "proxima_nova_bold",
	horizontal_alignment = "center",
	text_horizontal_alignment = "center",
	text_vertical_alignment = "center",
	vertical_alignment = "top",
	text_color = Color.terminal_text_header(255, true),
	offset = {
		0,
		spacing.text_top_padding,
		10,
	},
	size = {
		sizes.text_max_width,
		50,
	},
}
Styles.texts.event_name_divider = {
	horizontal_alignment = "center",
	vertical_alignment = "top",
	size = {
		468,
		22,
	},
	color = Color.terminal_text_body(255, true),
	offset = {
		0,
		spacing.text_top_padding + spacing.event_name_height,
		10,
	},
}
Styles.texts.event_lore = {
	font_size = 18,
	font_type = "proxima_nova_medium",
	horizontal_alignment = "center",
	text_horizontal_alignment = "left",
	text_vertical_alignment = "center",
	vertical_alignment = "top",
	text_color = Color.terminal_text_body(255, true),
	offset = {
		0,
		spacing.text_top_padding + spacing.event_name_height + 40,
		10,
	},
	size = {
		sizes.text_max_width,
		1000,
	},
}
Styles.texts.event_context = {
	font_size = 18,
	font_type = "proxima_nova_bold",
	horizontal_alignment = "center",
	text_horizontal_alignment = "lwft",
	text_vertical_alignment = "center",
	vertical_alignment = "top",
	text_color = Color.golden_rod(255, true),
	offset = {
		0,
		spacing.text_top_padding + 60,
		10,
	},
	size = {
		sizes.text_max_width,
		1000,
	},
}
Styles.texts.event_description = {
	font_size = 20,
	font_type = "proxima_nova_bold",
	horizontal_alignment = "center",
	text_horizontal_alignment = "center",
	text_vertical_alignment = "top",
	vertical_alignment = "top",
	text_color = Color.terminal_text_body(255, true),
	offset = {
		0,
		spacing.entry_padding + 200,
		10,
	},
	size = {
		sizes.text_max_width - 100,
		400,
	},
}
Styles.texts.rewards_track_text = {
	font_size = 28,
	font_type = "proxima_nova_bold",
	horizontal_alignment = "center",
	text_horizontal_alignment = "center",
	text_vertical_alignment = "center",
	vertical_alignment = "top",
	text_color = Color.terminal_text_header(255, true),
	offset = {
		0,
		0,
		10,
	},
	size = {
		sizes.text_max_width,
		50,
	},
}
Styles.entry = {}
Styles.entry.background = {
	horizontal_alignment = "center",
	scale_to_material = true,
	color = Color.terminal_grid_background(nil, true),
	offset = {
		0,
		-12,
		-4,
	},
	size_addition = {
		20,
		26,
	},
}
Styles.entry.background_rect = {
	horizontal_alignment = "center",
	scale_to_material = true,
	color = Color.terminal_background(150, true),
	offset = {
		0,
		0,
		-5,
	},
	size_addition = {
		-2,
		-2,
	},
}
Styles.entry.top_detail = {
	horizontal_alignment = "center",
	vertical_alignment = "top",
	size = {
		nil,
		32,
	},
	color = Color.white(255, true),
	offset = {
		0,
		-14,
		2,
	},
}
Styles.entry.top_center_detail = {
	horizontal_alignment = "center",
	vertical_alignment = "top",
	size = {
		288,
		102,
	},
	color = Color.white(255, true),
	offset = {
		0,
		-55.080000000000005,
		2,
	},
}
Styles.entry.bottom_detail = {
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	size = {
		nil,
		32,
	},
	color = Color.white(255, true),
	offset = {
		0,
		14,
		2,
	},
}
Styles.reward = {}
Styles.reward.background = {
	horizontal_alignment = "left",
	size = sizes.reward_size,
	offset = {
		0,
		0,
		10,
	},
	color = Color.black(225, true),
}
Styles.reward.hotspot = {
	on_hover_sound = UISoundEvents.default_mouse_hover,
	on_pressed_sound = UISoundEvents.default_click,
	size = sizes.reward_size,
	offset = {
		0,
		0,
		11,
	},
}
Styles.reward.frame = {
	horizontal_alignment = "left",
	size = sizes.reward_size,
	offset = {
		0,
		0,
		11,
	},
	color = Color.terminal_frame(255, true),
	default_color = Color.terminal_frame(255, true),
	hover_color = Color.terminal_frame_hover(255, true),
	selected_color = Color.terminal_frame_selected(255, true),
}
Styles.reward.frame_corner = {
	horizontal_alignment = "left",
	size = sizes.reward_size,
	offset = {
		0,
		0,
		12,
	},
	color = Color.terminal_corner(255, true),
	hover_color = Color.terminal_corner_hover(255, true),
	selected_color = Color.terminal_corner_selected(255, true),
	default_color = Color.terminal_corner(255, true),
}
Styles.reward.icon = {
	horizontal_alignment = "left",
	size = sizes.reward_icon_size,
	offset = {
		0,
		8,
		12,
	},
	color = {
		255,
		255,
		255,
		255,
	},
	size_addition = sizes.reward_icon_size_addition,
	material_values = {},
}
Styles.reward.currency_icon = {
	horizontal_alignment = "left",
	size = sizes.reward_currency_icon_size,
	offset = {
		20,
		8,
		12,
	},
	color = {
		255,
		255,
		255,
		255,
	},
	size_addition = sizes.reward_icon_size_addition,
	material_values = {},
}
Styles.reward.amount = {
	font_size = 20,
	font_type = "proxima_nova_bold",
	horizontal_alignment = "left",
	text_horizontal_alignment = "center",
	vertical_alignment = "center",
	text_color = {
		255,
		255,
		255,
		255,
	},
	offset = {
		0,
		sizes.reward_icon_size[2] + 20,
		15,
	},
	size = {
		sizes.reward_size[1],
		40,
	},
}
Styles.reward.bar_connection_line = {
	horizontal_alignment = "left",
	vertical_alignment = "center",
	size = {
		2,
		50,
	},
	color = Color.terminal_text_body(200, true),
	offset = {
		0,
		-30,
		2,
	},
}
Styles.event_progress_bar = {}
Styles.event_progress_bar.background = {
	horizontal_alignment = "center",
	vertical_alignment = "center",
	size = {
		1200,
		40,
	},
	color = Color.black(200, true),
	offset = {
		0,
		0,
		0,
	},
}
Styles.event_progress_bar.fill = {
	horizontal_alignment = "left",
	vertical_alignment = "center",
	size = {
		0,
		32,
	},
	default_size = {
		1192,
		32,
	},
	color = Color.terminal_text_header(255, true),
	offset = {
		4,
		0,
		1,
	},
}
Styles.event_progress_bar.progress_text = {
	font_size = 20,
	font_type = "proxima_nova_bold",
	horizontal_alignment = "center",
	text_horizontal_alignment = "center",
	text_vertical_alignment = "center",
	vertical_alignment = "center",
	text_color = Color.golden_rod(255, true),
	offset = {
		0,
		40,
		2,
	},
	size = {
		200,
		40,
	},
}
Styles.event_progress_bar.frame = {
	horizontal_alignment = "center",
	vertical_alignment = "center",
	size = {
		1200,
		40,
	},
	color = Color.terminal_frame(255, true),
	offset = {
		0,
		0,
		2,
	},
}
Styles.tooltip = {}
Styles.tooltip.background_rect = {
	horizontal_alignment = "center",
	scale_to_material = true,
	vertical_alignment = "center",
	size = sizes.tooltip_size,
	color = Color.terminal_background(185, true),
	offset = {
		0,
		0,
		-2,
	},
	size_addition = {
		-2,
		-2,
	},
}
Styles.tooltip.reward_tooltip_background = {
	horizontal_alignment = "center",
	scale_to_material = true,
	vertical_alignment = "center",
	size = sizes.tooltip_size,
	color = Color.terminal_grid_background(nil, true),
	offset = {
		0,
		0,
		-1,
	},
	size_addition = {
		20,
		26,
	},
}
Styles.tooltip.item_info_upper = {
	horizontal_alignment = "center",
	vertical_alignment = "center",
	size = {
		424,
		28.8,
	},
	color = Color.white(255, true),
	offset = {
		0,
		-(sizes.tooltip_size[2] * 0.5),
		0,
	},
}
Styles.tooltip.item_info_lower = {
	horizontal_alignment = "center",
	vertical_alignment = "center",
	size = {
		424,
		28.8,
	},
	color = Color.white(255, true),
	offset = {
		0,
		sizes.tooltip_size[2] * 0.5,
		0,
	},
}
Styles.tooltip.reward_tooltip_type = {
	font_size = 20,
	font_type = "proxima_nova_bold",
	horizontal_alignment = "center",
	text_horizontal_alignment = "left",
	text_vertical_alignment = "center",
	vertical_alignment = "center",
	text_color = Color.white(255, true),
	offset = {
		10,
		-(sizes.tooltip_size[2] * 0.5) + 20,
		2,
	},
	size = {
		380,
		20,
	},
}
Styles.tooltip.reward_tooltip_info = {
	font_size = 18,
	font_type = "proxima_nova_medium",
	horizontal_alignment = "center",
	text_horizontal_alignment = "left",
	text_vertical_alignment = "center",
	vertical_alignment = "center",
	text_color = Color.white(255, true),
	offset = {
		10,
		-(sizes.tooltip_size[2] * 0.5) + 46,
		2,
	},
	size = {
		380,
		20,
	},
}
Styles.tooltip.reward_tooltip_rarity = {
	font_size = 18,
	font_type = "proxima_nova_medium",
	horizontal_alignment = "center",
	text_horizontal_alignment = "left",
	text_vertical_alignment = "center",
	vertical_alignment = "center",
	text_color = Color.white(255, true),
	offset = {
		10,
		8,
		2,
	},
	size = {
		380,
		20,
	},
}
Styles.tooltip.reward_tooltip_target_xp = {
	font_size = 20,
	font_type = "proxima_nova_bold",
	horizontal_alignment = "center",
	text_horizontal_alignment = "left",
	text_vertical_alignment = "center",
	vertical_alignment = "center",
	text_color = Color.golden_rod(255, true),
	offset = {
		10,
		32,
		2,
	},
	size = {
		380,
		20,
	},
}
Styles.sizes = sizes
Styles.spacing = spacing

return settings("LiveEventsViewStyles", Styles)
