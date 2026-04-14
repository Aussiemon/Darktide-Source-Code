-- chunkname: @scripts/ui/view_elements/view_element_expedition_view_mission_info/view_element_expedition_view_mission_info_styles.lua

local Settings = require("scripts/ui/view_elements/view_element_expedition_view_mission_info/view_element_expedition_view_mission_info_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local Dimensions = Settings.dimensions
local SettingsColors = Settings.colors
local Styles = {}

Styles.mission_info_tab = {}
Styles.mission_info_tab.frame = {
	horizontal_alignment = "left",
	scale_to_material = true,
	vertical_alignment = "bottom",
	offset = {
		0,
		0,
		11,
	},
	color = SettingsColors.terminal_frame,
}
Styles.mission_info_tab.background = {
	horizontal_alignment = "left",
	vertical_alignment = "bottom",
	offset = {
		0,
		0,
		0,
	},
	color = SettingsColors.tab_unselected,
}
Styles.mission_info_tab.background_bottom_edge = {
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	size = {
		nil,
		2,
	},
	size_addition = {
		-2,
		0,
	},
	offset = {
		0,
		0,
		12,
	},
	color = {
		255,
		0,
		0,
		0,
	},
}
Styles.mission_info_tab.gradient = {
	horizontal_alignment = "right",
	vertical_alignment = "center",
	offset = {
		0,
		0,
		1,
	},
	color = SettingsColors.tab_selected,
}
Styles.mission_info_tab.mission_info_tab = {
	horizontal_alignment = "left",
	vertical_alignment = "bottom",
	offset = {
		0,
		0,
		0,
	},
	color = SettingsColors.tab_unselected,
}
Styles.mission_info_tab.icon = {
	horizontal_alignment = "center",
	vertical_alignment = "center",
	size = Dimensions.tab_icon_size,
	offset = {
		0,
		0,
		12,
	},
	size_addition = {
		-4,
		-4,
	},
	color = SettingsColors.terminal,
	material_values = {
		gradient_map = "content/ui/textures/mission_board/gradient_digital_green",
	},
}
Styles.mission_info_tab.hotspot = {
	horizontal_alignment = "left",
	vertical_alignment = "bottom",
	offset = {
		0,
		0,
		0,
	},
	on_hover_sound = UISoundEvents.default_mouse_hover,
	on_pressed_sound = UISoundEvents.default_click,
}
Styles.mission_info_page = {}
Styles.mission_info_page.frame = {
	scale_to_material = true,
	size = Dimensions.page_min_size,
	offset = {
		0,
		0,
		10,
	},
	color = SettingsColors.terminal_frame,
}
Styles.mission_info_page.background = {
	horizontal_alignment = "center",
	vertical_alignment = "top",
	size = Dimensions.page_min_size,
	offset = {
		0,
		0,
		1,
	},
	color = {
		255,
		0,
		0,
		0,
	},
}
Styles.mission_info_page.background_fade = {
	horizontal_alignment = "left",
	vertical_alignment = "top",
	color = {
		100,
		101,
		145,
		102,
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
	pivot = {
		0,
		0,
	},
	offset = {
		0,
		Dimensions.page_min_size[2],
		2,
	},
	size = {
		Dimensions.page_min_size[2] / 3,
		Dimensions.page_min_size[1],
	},
	angle = math.degrees_to_radians(90),
}
Styles.mission_info_page.icon = {
	horizontal_alignment = "left",
	vertical_alignment = "top",
	size = {
		50,
		50,
	},
	offset = {
		5,
		5,
		5,
	},
	color = SettingsColors.terminal,
	material_values = {
		symbol_atlas_index = 24,
	},
}
Styles.mission_info_page.icon_frame = {
	scale_to_material = true,
	size = {
		32,
		32,
	},
	offset = {
		15,
		15,
		2,
	},
	color = SettingsColors.terminal_frame,
}
Styles.mission_info_page.title = {
	font_size = 14,
	font_type = "mono_tide_medium",
	horizontal_alignment = "left",
	text_horizontal_alignment = "left",
	text_vertical_alignment = "center",
	vertical_alignment = "top",
	text_color = SettingsColors.text_dark,
	offset = {
		65,
		10,
		5,
	},
	size = {
		Dimensions.page_min_size[1] - 140,
		20,
	},
}
Styles.mission_info_page.subtitle = {
	font_size = 20,
	font_type = "mono_tide_bold",
	horizontal_alignment = "left",
	text_horizontal_alignment = "left",
	text_vertical_alignment = "center",
	vertical_alignment = "top",
	text_color = SettingsColors.text_light,
	offset = {
		65,
		30,
		5,
	},
	size = {
		Dimensions.page_min_size[1] - 140,
		20,
	},
}
Styles.mission_info_page.footer_line = {
	horizontal_alignment = "left",
	scale_to_material = false,
	vertical_alignment = "top",
	size = {
		Dimensions.page_min_size[1],
		1,
	},
	color = SettingsColors.terminal_frame,
	offset = {
		0,
		60,
		1,
	},
	size_addition = {
		0,
		0,
	},
}
Styles.mission_info_page.unlock_requirements = {}
Styles.mission_info_page.unlock_requirements.checkbox = {
	horizontal_alignment = "left",
	scale_to_material = true,
	vertical_alignment = "top",
	size = {
		44,
		44,
	},
	color = SettingsColors.terminal_frame,
	offset = {
		21,
		0,
		2,
	},
	size_addition = {
		-22,
		-22,
	},
}
Styles.mission_info_page.unlock_requirements.checkmark = {
	horizontal_alignment = "left",
	scale_to_material = true,
	vertical_alignment = "top",
	size = {
		44,
		44,
	},
	color = Color.white(255, true),
	offset = {
		10,
		0,
		2,
	},
	size_addition = {
		0,
		0,
	},
}
Styles.mission_info_page.unlock_requirements.text = {
	extra_y_margin = 20,
	font_size = 16,
	font_type = "mono_tide_medium",
	horizontal_alignment = "left",
	line_spacing = 1.2,
	text_horizontal_alignment = "left",
	text_vertical_alignment = "center",
	vertical_alignment = "top",
	text_color = SettingsColors.text_light,
	offset = {
		60,
		0,
		2,
	},
	size = {
		Dimensions.page_min_size[1] - 80,
		44,
	},
}
Styles.mission_info_page.unlock_requirements.divider_left_line = {
	horizontal_alignment = "left",
	scale_to_material = false,
	vertical_alignment = "top",
	size = {
		Dimensions.page_min_size[1] * Dimensions.divider_left_line_portion,
		2,
	},
	color = SettingsColors.terminal_frame,
	offset = {
		0,
		0,
		2,
	},
	size_addition = {
		0,
		0,
	},
}
Styles.mission_info_page.unlock_requirements.divider_center_text = {
	font_size = 16,
	font_type = "mono_tide_medium",
	horizontal_alignment = "center",
	text_horizontal_alignment = "center",
	text_vertical_alignment = "center",
	vertical_alignment = "top",
	text_color = SettingsColors.text_dark,
	offset = {
		0,
		0,
		2,
	},
	size = {
		Dimensions.page_min_size[1] * Dimensions.divider_center_text_portion,
		20,
	},
}
Styles.mission_info_page.unlock_requirements.divider_right_line = {
	horizontal_alignment = "right",
	scale_to_material = false,
	vertical_alignment = "top",
	size = {
		Dimensions.page_min_size[1] * Dimensions.divider_right_line_portion,
		2,
	},
	color = SettingsColors.terminal_frame,
	offset = {
		0,
		0,
		2,
	},
	size_addition = {
		0,
		0,
	},
}
Styles.mission_info_page.unlock_requirements.unlock_status = {
	font_size = 16,
	font_type = "mono_tide_medium",
	horizontal_alignment = "right",
	text_horizontal_alignment = "right",
	text_vertical_alignment = "center",
	vertical_alignment = "top",
	text_color = SettingsColors.text_light,
	offset = {
		-10,
		30,
		5,
	},
	size = {
		Dimensions.page_min_size[1] - 140,
		20,
	},
}
Styles.mission_info_page.major_modifier = {}
Styles.mission_info_page.major_modifier.description = {
	font_size = 16,
	font_type = "mono_tide_medium",
	horizontal_alignment = "left",
	line_spacing = 1.2,
	text_horizontal_alignment = "left",
	text_vertical_alignment = "top",
	vertical_alignment = "top",
	text_color = SettingsColors.text_dark,
	offset = {
		20,
		80,
		2,
	},
	size = {
		Dimensions.page_min_size[1] - 40,
		Dimensions.page_min_size[2],
	},
}
Styles.mission_info_page.minor_modifiers = {}
Styles.mission_info_page.minor_modifiers.modifiers = {
	font_size = 16,
	font_type = "mono_tide_medium",
	horizontal_alignment = "left",
	line_spacing = 1.2,
	text_horizontal_alignment = "left",
	text_vertical_alignment = "top",
	vertical_alignment = "top",
	text_color = SettingsColors.text_dark,
	offset = {
		20,
		80,
		2,
	},
	size = {
		Dimensions.page_min_size[1] - 40,
		Dimensions.page_min_size[2],
	},
}
Styles.mission_info_page.quickplay_page = {}
Styles.mission_info_page.quickplay_page.icon = {
	horizontal_alignment = "left",
	vertical_alignment = "top",
	size = Dimensions.quickplay_icon_size,
	offset = {
		10,
		6,
		5,
	},
	color = SettingsColors.terminal_frame,
}
Styles.mission_info_page.quickplay_page.title = {
	font_size = 16,
	font_type = "mono_tide_bold",
	horizontal_alignment = "left",
	text_horizontal_alignment = "left",
	text_vertical_alignment = "center",
	vertical_alignment = "top",
	text_color = SettingsColors.text_light,
	offset = {
		60,
		20,
		5,
	},
	size = {
		Dimensions.page_min_size[1] - 70,
		20,
	},
}
Styles.mission_info_page.quickplay_page.description = {
	font_size = 16,
	font_type = "mono_tide_medium",
	horizontal_alignment = "left",
	text_horizontal_alignment = "left",
	text_vertical_alignment = "top",
	vertical_alignment = "top",
	text_color = SettingsColors.text_dark,
	offset = {
		20,
		80,
		2,
	},
	size = {
		Dimensions.page_min_size[1] - 40,
		Dimensions.page_min_size[2],
	},
}
Styles.mission_info_stats = {}
Styles.mission_info_stats.frame = {
	scale_to_material = true,
	offset = {
		0,
		0,
		2,
	},
	color = SettingsColors.terminal_frame,
}
Styles.mission_info_stats.background = {
	horizontal_alignment = "center",
	vertical_alignment = "top",
	size = {
		Dimensions.page_min_size[1],
		80,
	},
	offset = {
		0,
		0,
		1,
	},
	color = {
		255,
		0,
		0,
		0,
	},
}
Styles.mission_info_stats.personal_total_text = {
	font_size = 16,
	font_type = "mono_tide_medium",
	horizontal_alignment = "left",
	text_horizontal_alignment = "left",
	text_vertical_alignment = "center",
	vertical_alignment = "top",
	text_color = SettingsColors.text_dark,
	offset = {
		10,
		10,
		5,
	},
	size = {
		Dimensions.page_min_size[1] - 20,
		20,
	},
}
Styles.mission_info_stats.personal_total_number = {
	font_size = 16,
	font_type = "mono_tide_bold",
	horizontal_alignment = "right",
	text_horizontal_alignment = "right",
	text_vertical_alignment = "center",
	vertical_alignment = "top",
	text_color = SettingsColors.text_dark,
	offset = {
		-55,
		10,
		5,
	},
	size = {
		Dimensions.page_min_size[1] - 65,
		20,
	},
}
Styles.mission_info_stats.personal_total_icon = {
	horizontal_alignment = "right",
	vertical_alignment = "top",
	size = Dimensions.loot_icon_size,
	offset = {
		-10,
		6,
		5,
	},
	color = SettingsColors.text_dark,
}
Styles.mission_info_stats.divider_line = {
	horizontal_alignment = "center",
	vertical_alignment = "top",
	size = {
		Dimensions.page_min_size[1],
		1,
	},
	color = SettingsColors.terminal_frame,
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
Styles.mission_info_stats.personal_best_text = {
	font_size = 16,
	font_type = "mono_tide_medium",
	horizontal_alignment = "left",
	text_horizontal_alignment = "left",
	text_vertical_alignment = "center",
	vertical_alignment = "top",
	text_color = SettingsColors.text_dark,
	offset = {
		10,
		50,
		5,
	},
	size = {
		Dimensions.page_min_size[1] - 20,
		20,
	},
}
Styles.mission_info_stats.personal_best_number = {
	font_size = 16,
	font_type = "mono_tide_bold",
	horizontal_alignment = "right",
	text_horizontal_alignment = "right",
	text_vertical_alignment = "center",
	vertical_alignment = "top",
	text_color = SettingsColors.text_dark,
	offset = {
		-55,
		50,
		5,
	},
	size = {
		Dimensions.page_min_size[1] - 65,
		20,
	},
}
Styles.mission_info_stats.personal_best_icon = {
	horizontal_alignment = "right",
	vertical_alignment = "top",
	size = Dimensions.loot_icon_size,
	offset = {
		-10,
		46,
		5,
	},
	color = SettingsColors.text_dark,
}

return settings("ViewElementExpeditionViewMissionInfoStyles", Styles)
