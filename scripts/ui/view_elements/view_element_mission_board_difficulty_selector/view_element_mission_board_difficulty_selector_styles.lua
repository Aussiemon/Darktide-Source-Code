-- chunkname: @scripts/ui/view_elements/view_element_mission_board_difficulty_selector/view_element_mission_board_difficulty_selector_styles.lua

local MissionBoardViewSettings = require("scripts/ui/views/mission_board_view/mission_board_view_settings")
local Dimensions = MissionBoardViewSettings.dimensions
local default_colors = MissionBoardViewSettings.colors.default_colors
local color_by_mission_type = MissionBoardViewSettings.colors.color_by_mission_type
local Styles = {}

Styles.difficulty_progress_tooltip = {}
Styles.difficulty_progress_tooltip.background = {
	scale_to_material = true,
	size = {
		Dimensions.threat_tooltip_size[1],
		Dimensions.threat_tooltip_size[2],
	},
	offset = {
		0,
		0,
		3,
	},
	color = Color.black(255, true),
}
Styles.difficulty_progress_tooltip.frame = {
	scale_to_material = true,
	size = {
		Dimensions.threat_tooltip_size[1],
		Dimensions.threat_tooltip_size[2],
	},
	offset = {
		0,
		0,
		4,
	},
	color = {
		255,
		169,
		211,
		158,
	},
}
Styles.difficulty_progress_tooltip.text = {
	font_size = 14,
	font_type = "mono_tide_medium",
	horizontal_alignment = "center",
	text_horizontal_alignment = "center",
	text_vertical_alignment = "center",
	vertical_alignment = "center",
	size = {
		Dimensions.threat_tooltip_size[1] - 20,
		Dimensions.threat_tooltip_size[2] - 10,
	},
	text_color = table.shallow_copy(default_colors.terminal_text_dark),
	offset = {
		0,
		0,
		5,
	},
}
Styles.difficulty_progress_bar = {}
Styles.difficulty_progress_bar.frame = {
	scale_to_material = true,
	size = {
		nil,
		8,
	},
	offset = {
		0,
		0,
		5,
	},
	color = Color.white(nil, true),
}
Styles.difficulty_progress_bar.progress_bar = {
	scale_to_material = true,
	size = {
		Dimensions.threat_level_progress_bar_size[1],
		Dimensions.threat_level_progress_bar_size[2],
	},
	default_size = {
		Dimensions.threat_level_progress_bar_size[1],
		Dimensions.threat_level_progress_bar_size[2],
	},
	offset = {
		0,
		0,
		4,
	},
	color = Color.white(nil, true),
}

return settings("ViewElementMissionBoardDifficultySelectorStyles", Styles)
