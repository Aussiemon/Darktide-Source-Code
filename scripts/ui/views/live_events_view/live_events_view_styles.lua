-- chunkname: @scripts/ui/views/live_events_view/live_events_view_styles.lua

require("scripts/foundation/utilities/color")

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local Styles = {}
local sizes = {
	entry_height = 880,
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
	collected_resource_box_size = {
		252.8,
		80,
	},
	faction_progress_bar_size = {
		380,
		30,
	},
	faction_button_size = {
		420,
		68,
	},
	tug_of_war_bar_size = {
		1206,
		81,
	},
	tug_o_war_bar_fill_size = {
		1162.88,
		42.32,
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
Styles.texts.active_text = {
	font_size = 12,
	font_type = "proxima_nova_bold",
	horizontal_alignment = "center",
	text_horizontal_alignment = "left",
	text_vertical_alignment = "top",
	vertical_alignment = "center",
	text_color = Color.golden_rod(255, true),
	offset = {
		0,
		0,
		2,
	},
	size = sizes.event_button_size,
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
		30,
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
		31,
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
		30,
	},
}
Styles.entry.event_view_button = {}
Styles.entry.event_view_button.hotspot = {
	horizontal_alignment = "center",
	vertical_alignment = "top",
	size = sizes.event_button_size,
	on_hover_sound = UISoundEvents.default_mouse_hover,
	on_pressed_sound = UISoundEvents.default_click,
	offset = {
		0,
		0,
		2,
	},
}
Styles.entry.event_view_button.background = {
	horizontal_alignment = "center",
	scale_to_material = true,
	vertical_alignment = "top",
	size = sizes.event_button_size,
	size_addition = {
		24,
		24,
	},
	color = Color.terminal_grid_background(255, true),
	offset = {
		-1,
		0,
		2,
	},
}
Styles.entry.event_view_button.gradient = {
	horizontal_alignment = "center",
	scale_to_material = true,
	vertical_alignment = "top",
	size = sizes.event_button_size,
	default_color = Color.terminal_background_gradient(nil, true),
	selected_color = Color.terminal_frame_selected(nil, true),
	offset = {
		0,
		0,
		3,
	},
}
Styles.entry.event_view_button.frame = {
	horizontal_alignment = "center",
	scale_to_material = true,
	vertical_alignment = "top",
	size = sizes.event_button_size,
	default_color = Color.terminal_frame(nil, true),
	hover_color = Color.terminal_frame_hover(nil, true),
	offset = {
		0,
		0,
		4,
	},
}
Styles.entry.event_view_button.corner = {
	horizontal_alignment = "center",
	scale_to_material = true,
	vertical_alignment = "top",
	size = sizes.event_button_size,
	default_color = Color.terminal_corner(nil, true),
	hover_color = Color.terminal_corner_hover(nil, true),
	offset = {
		0,
		0,
		5,
	},
}
Styles.entry.event_view_button.rect = {
	horizontal_alignment = "center",
	vertical_alignment = "top",
	size = sizes.event_button_size,
	color = {
		150,
		0,
		0,
		0,
	},
	offset = {
		0,
		0,
		4,
	},
}
Styles.entry.event_view_button.text = {
	drop_shadow = true,
	font_size = 24,
	font_type = "proxima_nova_bold",
	horizontal_alignment = "center",
	text_horizontal_alignment = "center",
	text_vertical_alignment = "center",
	vertical_alignment = "top",
	default_color = Color.terminal_text_header(255, true),
	text_color = Color.terminal_text_header(255, true),
	hover_color = Color.white(255, true),
	disabled_color = Color.ui_grey_light(255, true),
	default_color = Color.terminal_text_header(255, true),
	size = sizes.event_button_size,
	offset = {
		0,
		0,
		6,
	},
}
Styles.entry.resource_decoration_icon = {
	horizontal_alignment = "center",
	vertical_alignment = "center",
	size = {
		120,
		196.8,
	},
	color = Color.white(255, true),
	offset = {
		0,
		-170,
		12,
	},
}
Styles.entry.resource_counter_frame = {
	horizontal_alignment = "center",
	scale_to_material = true,
	vertical_alignment = "center",
	size = sizes.collected_resource_box_size,
	color = Color.white(255, true),
	offset = {
		0,
		0,
		12,
	},
}
Styles.entry.resource_counter_background = {
	horizontal_alignment = "center",
	scale_to_material = true,
	vertical_alignment = "center",
	size = sizes.collected_resource_box_size,
	color = Color.black(185, true),
	offset = {
		0,
		0,
		11,
	},
}
Styles.entry.resource_counter_text = {
	font_size = 46,
	font_type = "machine_medium",
	horizontal_alignment = "center",
	text_horizontal_alignment = "center",
	text_vertical_alignment = "center",
	vertical_alignment = "center",
	text_color = Color.terminal_text_header(255, true),
	size = sizes.collected_resource_box_size,
	offset = {
		0,
		0,
		20,
	},
}
Styles.entry.resource_counter_label = {
	font_size = 18,
	font_type = "proxima_nova_bold",
	horizontal_alignment = "center",
	text_horizontal_alignment = "center",
	text_vertical_alignment = "bottom",
	vertical_alignment = "center",
	text_color = Color.ui_terminal(255, true),
	size = {
		400,
		200,
	},
	offset = {
		0,
		-10,
		20,
	},
}
Styles.entry.resource_counted_right_detail = {
	horizontal_alignment = "center",
	vertical_alignment = "center",
	size = {
		12,
		21,
	},
	color = Color.golden_rod(255, true),
	offset = {
		sizes.collected_resource_box_size[1] * 0.5 + 4,
		0,
		11,
	},
}
Styles.entry.resource_counted_left_detail = {
	horizontal_alignment = "center",
	vertical_alignment = "center",
	angle = math.degrees_to_radians(180),
	size = {
		12,
		21,
	},
	color = Color.golden_rod(255, true),
	offset = {
		-sizes.collected_resource_box_size[1] * 0.5 - 4,
		0,
		11,
	},
}

local side_decoration_default_layer = 20
local resource_button_base_y_offset = -80
local progress_bar_base_y_offset = -180

Styles.entry.tug_of_war_bar_frame = {
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	size = sizes.tug_of_war_bar_size,
	color = Color.white(255, true),
	offset = {
		0,
		progress_bar_base_y_offset,
		25,
	},
}
Styles.entry.tug_of_war_bar_fill_left = {
	horizontal_alignment = "left",
	vertical_alignment = "bottom",
	size = {
		sizes.tug_o_war_bar_fill_size[1],
		sizes.tug_o_war_bar_fill_size[2] + 4,
	},
	default_size = {
		sizes.tug_o_war_bar_fill_size[1],
		sizes.tug_o_war_bar_fill_size[2] + 4,
	},
	color = Color.white(255, true),
	offset = {
		(sizes.entry_width - sizes.tug_o_war_bar_fill_size[1]) * 0.5 + 2,
		progress_bar_base_y_offset - 20,
		11,
	},
	uvs = {
		{
			0,
			0,
		},
		{
			1,
			1,
		},
	},
	size_addition = {
		0,
		0,
	},
}
Styles.entry.tug_of_war_bar_fill_right = {
	horizontal_alignment = "left",
	vertical_alignment = "bottom",
	size = {
		sizes.tug_o_war_bar_fill_size[1],
		sizes.tug_o_war_bar_fill_size[2] + 4,
	},
	default_size = {
		sizes.tug_o_war_bar_fill_size[1] - 4,
		sizes.tug_o_war_bar_fill_size[2] + 4,
	},
	color = Color.white(255, true),
	offset = {
		(sizes.entry_width - sizes.tug_o_war_bar_fill_size[1]) * 0.5 + 2,
		progress_bar_base_y_offset - 20,
		10,
	},
	uvs = {
		{
			0,
			0,
		},
		{
			1,
			1,
		},
	},
	size_addition = {
		0,
		0,
	},
}
Styles.entry.tug_of_war_bar_background = {
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	size = sizes.tug_of_war_bar_size,
	color = Color.black(200, true),
	offset = {
		0,
		progress_bar_base_y_offset,
		8,
	},
}
Styles.entry.tug_of_war_bar_text_left = {
	font_size = 26,
	font_type = "proxima_nova_bold",
	horizontal_alignment = "left",
	text_horizontal_alignment = "left",
	text_vertical_alignment = "center",
	vertical_alignment = "bottom",
	text_color = Color.ui_terminal(255, true),
	size = sizes.tug_of_war_bar_size,
	offset = {
		(sizes.entry_width - sizes.tug_of_war_bar_size[1]) * 0.5 + 8 + 45,
		progress_bar_base_y_offset - 2,
		12,
	},
}
Styles.entry.tug_of_war_bar_text_right = {
	font_size = 26,
	font_type = "proxima_nova_bold",
	horizontal_alignment = "left",
	text_horizontal_alignment = "right",
	text_vertical_alignment = "center",
	vertical_alignment = "bottom",
	text_color = Color.ui_terminal(255, true),
	size = sizes.tug_of_war_bar_size,
	offset = {
		(sizes.entry_width - sizes.tug_of_war_bar_size[1]) * 0.5 - 8 - 45,
		progress_bar_base_y_offset - 2,
		12,
	},
}
Styles.entry.tug_of_war_bar_divider = {
	horizontal_alignment = "left",
	vertical_alignment = "bottom",
	size = {
		38.4,
		59.85,
	},
	color = Color.white(255, true),
	offset = {
		0,
		progress_bar_base_y_offset - 10,
		24,
	},
}
Styles.entry.side_table = {}
Styles.entry.side_table.hotspot = {
	anim_hover_speed = 5,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	size = {
		sizes.entry_width * 0.5,
		sizes.entry_height,
	},
	on_hover_sound = UISoundEvents.default_mouse_hover,
	on_pressed_sound = UISoundEvents.default_click,
	offset = {
		0,
		0,
		2,
	},
}
Styles.entry.side_table.background = {
	horizontal_alignment = "left",
	scale_to_material = true,
	vertical_alignment = "top",
	size = {
		sizes.entry_width * 0.5,
		sizes.entry_height,
	},
	uvs = {
		{
			0,
			0,
		},
		{
			1,
			1,
		},
	},
	size_addition = {
		0,
		0,
	},
	color = Color.white(255, true),
	offset = {
		0,
		0,
		3,
	},
	material_values = {
		texture_map = "content/ui/textures/backgrounds/live_events/leftover_event_faction_a",
	},
}
Styles.entry.side_table.title_text = {
	drop_shadow = true,
	font_size = 55,
	font_type = "machine_medium",
	horizontal_alignment = "left",
	text_horizontal_alignment = "center",
	text_vertical_alignment = "center",
	vertical_alignment = "top",
	text_color = Color.terminal_text_header(255, true),
	size = {
		sizes.entry_width * 0.5,
		120,
	},
	offset = {
		0,
		0,
		4,
	},
}
Styles.entry.side_table.resource_collected_text = {
	font_size = 24,
	font_type = "proxima_nova_bold",
	horizontal_alignment = "left",
	text_horizontal_alignment = "center",
	text_vertical_alignment = "top",
	vertical_alignment = "top",
	text_color = Color.ui_terminal(255, true),
	size = {
		sizes.entry_width * 0.5,
		50,
	},
	offset = {
		0,
		spacing.text_top_padding + spacing.event_name_height + 30,
		4,
	},
}
Styles.entry.side_table.boons_text = {
	drop_shadow = true,
	font_size = 24,
	font_type = "proxima_nova_bold",
	horizontal_alignment = "left",
	text_horizontal_alignment = "center",
	text_vertical_alignment = "top",
	vertical_alignment = "top",
	text_color = Color.ui_terminal(255, true),
	size = {
		sizes.entry_width * 0.5,
		50,
	},
	offset = {
		0,
		spacing.text_top_padding + spacing.event_name_height + 28,
		8,
	},
}
Styles.entry.side_table.boons_description = {
	drop_shadow = true,
	font_size = 18,
	font_type = "proxima_nova_bold",
	horizontal_alignment = "left",
	text_horizontal_alignment = "center",
	text_vertical_alignment = "top",
	vertical_alignment = "top",
	text_color = Color.ui_achievement_icon_completed(255, true),
	size = {
		sizes.entry_width * 0.4,
		300,
	},
	offset = {
		sizes.entry_width * 0.5 * 0.5 - sizes.entry_width * 0.4 * 0.5,
		spacing.text_top_padding + spacing.event_name_height + 28 + 60,
		8,
	},
}

local divider_size_multiplier = 0.5

Styles.entry.side_table.boons_text_divider = {
	drop_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	size = {
		936 * divider_size_multiplier,
		44 * divider_size_multiplier,
	},
	color = Color.ui_terminal(255, true),
	offset = {
		sizes.entry_width * 0.5 * 0.5 - 936 * divider_size_multiplier * 0.5,
		spacing.text_top_padding + spacing.event_name_height + 30 + 28,
		10,
	},
}

local resource_button_x_offset_correction = 12

Styles.entry.side_table.resource_button_background = {
	horizontal_alignment = "left",
	scale_to_material = true,
	vertical_alignment = "bottom",
	size = sizes.faction_button_size,
	size_addition = {
		24,
		24,
	},
	color = Color.terminal_grid_background(255, true),
	offset = {
		sizes.entry_width * 0.5 * 0.5 - sizes.faction_button_size[1] * 0.5 - resource_button_x_offset_correction,
		resource_button_base_y_offset,
		side_decoration_default_layer,
	},
}
Styles.entry.side_table.resource_button_gradient = {
	horizontal_alignment = "center",
	scale_to_material = true,
	vertical_alignment = "top",
	size = sizes.faction_button_size,
	default_color = Color.terminal_background_gradient(nil, true),
	selected_color = Color.terminal_frame_selected(nil, true),
	offset = {
		sizes.entry_width * 0.5 * 0.5 - sizes.faction_button_size[1] * 0.5 - resource_button_x_offset_correction,
		resource_button_base_y_offset,
		side_decoration_default_layer + 1,
	},
}
Styles.entry.side_table.resource_button_frame = {
	horizontal_alignment = "center",
	scale_to_material = true,
	vertical_alignment = "top",
	size = sizes.faction_button_size,
	default_color = Color.terminal_frame(nil, true),
	hover_color = Color.terminal_frame_hover(nil, true),
	offset = {
		sizes.entry_width * 0.5 * 0.5 - sizes.faction_button_size[1] * 0.5 - resource_button_x_offset_correction,
		resource_button_base_y_offset,
		side_decoration_default_layer + 2,
	},
}
Styles.entry.side_table.resource_button_corner = {
	horizontal_alignment = "center",
	scale_to_material = true,
	vertical_alignment = "top",
	size = sizes.faction_button_size,
	default_color = Color.terminal_corner(nil, true),
	hover_color = Color.terminal_corner_hover(nil, true),
	offset = {
		sizes.entry_width * 0.5 * 0.5 - sizes.faction_button_size[1] * 0.5 - resource_button_x_offset_correction,
		resource_button_base_y_offset,
		side_decoration_default_layer + 6,
	},
}
Styles.entry.side_table.resource_button_rect = {
	horizontal_alignment = "center",
	vertical_alignment = "top",
	size = sizes.faction_button_size,
	color = {
		150,
		0,
		0,
		0,
	},
	offset = {
		sizes.entry_width * 0.5 * 0.5 - sizes.faction_button_size[1] * 0.5 - resource_button_x_offset_correction,
		resource_button_base_y_offset,
		side_decoration_default_layer + 4,
	},
}
Styles.entry.side_table.resource_button_text = {
	drop_shadow = true,
	font_size = 22,
	font_type = "proxima_nova_bold",
	horizontal_alignment = "left",
	text_horizontal_alignment = "center",
	text_vertical_alignment = "center",
	vertical_alignment = "bottom",
	text_color = Color.terminal_text_body(255, true),
	hover_color = Color.white(255, true),
	disabled_color = Color.ui_grey_light(255, true),
	default_color = Color.terminal_text_body(255, true),
	size = {
		sizes.faction_button_size[1] - 10,
		sizes.faction_button_size[2] - 10,
	},
	offset = {
		sizes.entry_width * 0.5 * 0.5 - sizes.faction_button_size[1] * 0.5 + 5,
		resource_button_base_y_offset - 17,
		side_decoration_default_layer + 5,
	},
}
Styles.entry.side_table.resource_button_hotspot = {
	horizontal_alignment = "left",
	vertical_alignment = "bottom",
	size = sizes.faction_button_size,
	on_hover_sound = UISoundEvents.default_mouse_hover,
	on_pressed_sound = UISoundEvents.default_click,
	offset = {
		sizes.entry_width * 0.5 * 0.5 - sizes.faction_button_size[1] * 0.5 - resource_button_x_offset_correction,
		resource_button_base_y_offset,
		side_decoration_default_layer,
	},
}
Styles.texts.resource_collected_text = {
	font_size = 24,
	font_type = "proxima_nova_bold",
	horizontal_alignment = "center",
	text_horizontal_alignment = "center",
	text_vertical_alignment = "top",
	vertical_alignment = "center",
	text_color = Color.ui_terminal(255, true),
	offset = {
		0,
		-48,
		20,
	},
	size = {
		sizes.text_max_width,
		50,
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
	color = Color.black(165, true),
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
	vertical_alignment = "bottom",
	size = {
		2,
		50,
	},
	color = Color.terminal_text_body(200, true),
	offset = {
		0,
		-16,
		-2,
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
	vertical_alignment = "bottom",
	text_color = Color.golden_rod(255, true),
	offset = {
		0,
		50,
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
