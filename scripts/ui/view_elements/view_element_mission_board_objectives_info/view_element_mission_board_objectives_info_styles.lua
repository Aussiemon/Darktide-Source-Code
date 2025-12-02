-- chunkname: @scripts/ui/view_elements/view_element_mission_board_objectives_info/view_element_mission_board_objectives_info_styles.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local MissionBoardViewSettings = require("scripts/ui/views/mission_board_view/mission_board_view_settings")
local MissionBoardViewStyles = require("scripts/ui/views/mission_board_view/mission_board_view_styles")
local Dimensions = MissionBoardViewSettings.dimensions
local default_colors = MissionBoardViewSettings.colors.default_colors
local color_by_mission_type = MissionBoardViewSettings.colors.color_by_mission_type
local gradient_by_category = MissionBoardViewStyles.gradient_by_category
local Styles = {}

Styles.colors = {}
Styles.colors.default = default_colors
Styles.colors.color_by_mission_type = color_by_mission_type
Styles.gradient_by_category = gradient_by_category
Styles.colors.theme_colors = {}
Styles.colors.theme_colors.default = table.shallow_copy(default_colors.terminal_frame)
Styles.colors.theme_colors.circumstance = table.shallow_copy(default_colors.accent)
Styles.colors.theme_colors.story = table.shallow_copy(default_colors.story)
Styles.objectives_panel = {}
Styles.objectives_panel.background = {
	horizontal_alignment = "center",
	vertical_alignment = "center",
	offset = {
		0,
		0,
		0,
	},
	color = {
		255,
		0,
		0,
		0,
	},
}
Styles.objectives_panel.frame = {
	horizontal_alignment = "left",
	scale_to_material = true,
	vertical_alignment = "bottom",
	offset = {
		0,
		0,
		5,
	},
	color = table.shallow_copy(default_colors.terminal_frame),
}
Styles.objectives_panel.sub_title = {
	font_size = 14,
	font_type = "kode_mono_medium",
	horizontal_alignment = "center",
	text_horizontal_alignment = "left",
	text_vertical_alignment = "top",
	vertical_alignment = "top",
	text_color = default_colors.text_sub_header,
	offset = {
		68,
		16,
		5,
	},
}
Styles.objectives_panel.title = {
	font_size = 16,
	font_type = "kode_mono_bold",
	horizontal_alignment = "left",
	text_horizontal_alignment = "left",
	text_vertical_alignment = "top",
	vertical_alignment = "top",
	text_color = table.shallow_copy(default_colors.terminal_header_text),
	offset = {
		68,
		34,
		5,
	},
}
Styles.objectives_panel.icon = {
	horizontal_alignment = "left",
	vertical_alignment = "center",
	size = {
		55.199999999999996,
		55.199999999999996,
	},
	active_size = {
		55.199999999999996,
		55.199999999999996,
	},
	inactive_size = {
		36,
		36,
	},
	size_addition = {
		-4,
		-4,
	},
	color = Color.white(255, true),
	offset = {
		10,
		0,
		5,
	},
}
Styles.objectives_panel.background_gradient = {
	horizontal_alignment = "left",
	vertical_alignment = "center",
	offset = {
		0,
		0,
		2,
	},
	color = table.shallow_copy(default_colors.terminal_header_text),
}
Styles.objectives_panel.hotspot = {
	anim_select_speed = 5,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	offset = {
		0,
		0,
		1,
	},
	on_hover_sound = UISoundEvents.default_mouse_hover,
	on_pressed_sound = UISoundEvents.default_click,
}
Styles.mission_objective_info = {}
Styles.mission_objective_info.frame = {
	scale_to_material = true,
	offset = {
		0,
		0,
		20,
	},
	color = table.shallow_copy(default_colors.terminal_frame),
}
Styles.mission_objective_info.objective_description = {
	font_size = 16,
	font_type = "kode_mono_medium",
	hdr = true,
	text_horizontal_alignment = "left",
	text_vertical_alignment = "top",
	text_color = table.shallow_copy(default_colors.text_body),
	offset = {
		20,
		20,
		7,
	},
	size_addition = {
		-40,
		0,
	},
}
Styles.mission_objective_info.background = {
	horizontal_alignment = "center",
	vertical_alignment = "center",
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
Styles.mission_objective_info.mission_giver_frame = {
	horizontal_alignment = "right",
	scale_to_material = true,
	vertical_alignment = "bottom",
	size = {
		Dimensions.details_width * 0.52,
		Dimensions.rewards_height,
	},
	offset = {
		0,
		0,
		5,
	},
	color = table.shallow_copy(default_colors.terminal_frame),
}
Styles.mission_objective_info.mission_giver_name = {
	font_size = 12,
	font_type = "kode_mono_medium",
	horizontal_alignment = "right",
	text_horizontal_alignment = "right",
	text_vertical_alignment = "center",
	vertical_alignment = "bottom",
	size = {
		Dimensions.details_width * 0.52,
		Dimensions.rewards_height,
	},
	text_color = table.shallow_copy(default_colors.terminal_text_dark),
	offset = {
		-36,
		0,
		5,
	},
}
Styles.mission_objective_info.mission_giver_icon = {
	horizontal_alignment = "right",
	vertical_alignment = "bottom",
	size = {
		26.8,
		32.160000000000004,
	},
	color = Color.white(255, true),
	offset = {
		-2,
		-2,
		30,
	},
}
Styles.mission_objective_info.background_fade = {
	horizontal_alignment = "left",
	vertical_alignment = "bottom",
	color = {
		125,
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
		Dimensions.details_width,
		2,
	},
	size = {
		Dimensions.details_height,
		Dimensions.details_width,
	},
	angle = math.degrees_to_radians(90),
}
Styles.mission_objective_info.reward = {}
Styles.mission_objective_info.reward.frame = {
	scale_to_material = true,
	offset = {
		0,
		0,
		5,
	},
	color = table.shallow_copy(default_colors.terminal_frame),
}
Styles.mission_objective_info.reward.amount = {
	font_size = 16,
	font_type = "kode_mono_bold",
	horizontal_alignment = "left",
	text_horizontal_alignment = "left",
	text_vertical_alignment = "center",
	vertical_alignment = "bottom",
	text_color = table.shallow_copy(default_colors.terminal_text_dark),
	offset = {
		10,
		0,
		5,
	},
}
Styles.mission_objective_info.reward.icon = {
	horizontal_alignment = "right",
	vertical_alignment = "center",
	size = {
		32,
		32,
	},
	size_addition = {
		-4,
		-4,
	},
	color = Color.white(255, true),
	offset = {
		-6,
		0,
		5,
	},
}

return settings("ViewElementMissionBoardObjectivesInfoStyles", Styles)
