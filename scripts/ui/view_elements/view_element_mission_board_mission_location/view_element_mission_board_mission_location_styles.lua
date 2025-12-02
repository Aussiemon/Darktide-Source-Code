-- chunkname: @scripts/ui/view_elements/view_element_mission_board_mission_location/view_element_mission_board_mission_location_styles.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local MissionBoardViewSettings = require("scripts/ui/views/mission_board_view/mission_board_view_settings")
local Dimensions = MissionBoardViewSettings.dimensions
local default_colors = MissionBoardViewSettings.colors.default_colors
local color_by_mission_type = MissionBoardViewSettings.colors.color_by_mission_type
local Styles = {}

Styles.colors = {}
Styles.colors.default = default_colors
Styles.colors.color_by_mission_type = color_by_mission_type
Styles.mission_area_info = {}
Styles.mission_area_info.image = {
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	size = {
		480,
		270,
	},
	offset = {
		0,
		0,
		1,
	},
	material_values = {
		texture_map = "content/ui/textures/missions/quickplay",
	},
}
Styles.mission_area_info.inner_shadow = {
	horizontal_alignment = "center",
	scale_to_material = true,
	vertical_alignment = "bottom",
	color = {
		255,
		0,
		0,
		0,
	},
	offset = {
		0,
		0,
		2,
	},
}
Styles.mission_area_info.lock = {
	horizontal_alignment = "center",
	scale_to_material = true,
	vertical_alignment = "bottom",
	size = {
		252,
		252,
	},
	offset = {
		0,
		-10,
		5,
	},
	color = {
		125,
		255,
		255,
		255,
	},
}
Styles.mission_area_info.outer_frame = {
	scale_to_material = true,
	color = table.shallow_copy(default_colors.terminal_frame),
	offset = {
		0,
		0,
		10,
	},
}
Styles.mission_area_info.title_frame = {
	horizontal_alignment = "center",
	scale_to_material = true,
	vertical_alignment = "top",
	size = {
		Dimensions.details_width,
		66,
	},
	color = Color.terminal_frame(nil, true),
	offset = {
		0,
		0,
		2,
	},
}
Styles.mission_area_info.title_background = {
	horizontal_alignment = "center",
	scale_to_material = true,
	vertical_alignment = "top",
	size = {
		Dimensions.details_width,
		66,
	},
	color = Color.black(165, true),
	offset = {
		0,
		0,
		-1,
	},
}
Styles.mission_area_info.mission_title = {
	font_size = 20,
	font_type = "kode_mono_bold",
	horizontal_alignment = "center",
	text_horizontal_alignment = "left",
	text_vertical_alignment = "top",
	vertical_alignment = "top",
	size = {
		Dimensions.details_width,
		78,
	},
	text_color = table.shallow_copy(default_colors.terminal_header_text),
	offset = {
		20,
		8,
		2,
	},
}
Styles.mission_area_info.mission_sub_title = {
	font_size = 14,
	font_type = "kode_mono_medium",
	horizontal_alignment = "center",
	text_horizontal_alignment = "left",
	text_vertical_alignment = "top",
	vertical_alignment = "top",
	size = {
		Dimensions.details_width,
		78,
	},
	text_color = table.shallow_copy(default_colors.text_sub_header),
	offset = {
		20,
		34,
		2,
	},
}
Styles.mission_area_info.timer = {}
Styles.mission_area_info.timer.timer_bar_frame = {
	horizontal_alignment = "right",
	scale_to_material = true,
	vertical_alignment = "top",
	offset = {
		0,
		-28,
		4,
	},
	size = {
		364,
		28,
	},
	color = table.shallow_copy(default_colors.terminal_frame),
}
Styles.mission_area_info.timer.timer_frame = {
	horizontal_alignment = "right",
	scale_to_material = true,
	vertical_alignment = "top",
	offset = {
		-20,
		-(Dimensions.sidebar_small_buffer - 8 + 13),
		4,
	},
	size = {
		320,
		8,
	},
	color = table.shallow_copy(default_colors.terminal_frame),
}
Styles.mission_area_info.timer.timer_bar = {
	horizontal_alignment = "right",
	vertical_alignment = "top",
	offset = {
		-20,
		-(Dimensions.sidebar_small_buffer - 8 + 13),
		3,
	},
	size = {
		320,
		8,
	},
	material_values = {
		progress = 1,
	},
	color = table.shallow_copy(default_colors.main),
}
Styles.mission_area_info.timer.timer_text_frame = {
	horizontal_alignment = "left",
	scale_to_material = true,
	vertical_alignment = "top",
	offset = {
		0,
		-28,
		4,
	},
	size = {
		120,
		28,
	},
	color = table.shallow_copy(default_colors.terminal_frame),
}
Styles.mission_area_info.timer.timer_icon = {
	horizontal_alignment = "left",
	vertical_alignment = "top",
	size = {
		19,
		19,
	},
	offset = {
		16,
		-(19 + Dimensions.sidebar_small_buffer - 8),
		3,
	},
	color = table.shallow_copy(default_colors.terminal_header_text),
}
Styles.mission_area_info.timer.timer_text = {
	drop_shadow = true,
	font_size = 18,
	font_type = "kode_mono_bold",
	horizontal_alignment = "left",
	text_vertical_alignment = "bottom",
	vertical_alignment = "top",
	size = {
		nil,
		24,
	},
	offset = {
		40,
		-(Dimensions.sidebar_small_buffer - 8 + 21),
		3,
	},
	text_color = table.shallow_copy(default_colors.terminal_header_text),
}
Styles.mission_area_info.timer.infinite_symbol = {
	horizontal_alignment = "left",
	vertical_alignment = "top",
	visible = true,
	size = {
		25.2,
		14.399999999999999,
	},
	offset = {
		46,
		-20,
		10,
	},
	color = table.shallow_copy(default_colors.terminal_header_text),
}

return settings("ViewElementMissionBoardMissionLocationStyles", Styles)
