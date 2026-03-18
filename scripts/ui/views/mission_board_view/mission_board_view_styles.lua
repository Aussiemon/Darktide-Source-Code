-- chunkname: @scripts/ui/views/mission_board_view/mission_board_view_styles.lua

local Settings = require("scripts/ui/views/mission_board_view/mission_board_view_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local Dimensions = Settings.dimensions
local MissionBoardViewStyles = {}
local default_colors = Settings.colors.default_colors
local color_by_mission_type = Settings.colors.color_by_mission_type

MissionBoardViewStyles.colors = {}
MissionBoardViewStyles.colors.default = default_colors
MissionBoardViewStyles.colors.color_by_mission_type = color_by_mission_type
MissionBoardViewStyles.screen_frame = {
	scale_to_material = true,
	size = {},
	offset = {
		0,
		0,
		-50,
	},
	color = Color.white(nil, true),
}
MissionBoardViewStyles.screen_frame_glow = {
	horizontal_alignment = "center",
	scale_to_material = true,
	vertical_alignment = "bottom",
	size = {
		1330,
		308,
	},
	offset = {
		-705,
		0,
		1,
	},
	color = Color.white(nil, true),
}
MissionBoardViewStyles.play_button = {}
MissionBoardViewStyles.play_button.default = {
	scale_to_material = true,
	offset = {
		0,
		0,
		3,
	},
}
MissionBoardViewStyles.play_button.hover = {
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
MissionBoardViewStyles.play_button.hotspot = {
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
MissionBoardViewStyles.play_button.disabled = {
	hdr = true,
	scale_to_material = true,
	offset = {
		0,
		0,
		3,
	},
}
MissionBoardViewStyles.play_button.default_text = {
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
MissionBoardViewStyles.play_button.selected_text = {
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
MissionBoardViewStyles.play_button.disabled_text = {
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
MissionBoardViewStyles.gradient_by_category = {
	default = {
		default_gradient = "content/ui/textures/mission_board/gradient_farme_selected_green",
		disabled_gradient = "content/ui/textures/mission_board/gradient_digital_disabled_green",
		selected_gradient = "content/ui/textures/mission_board/gradient_digital_green",
	},
	story = {
		default_gradient = "content/ui/textures/mission_board/gradient_digital_frame_red",
		disabled_gradient = "content/ui/textures/mission_board/gradient_digital_disabled_red",
		selected_gradient = "content/ui/textures/mission_board/gradient_farme_selected_red",
	},
	circumstance = {
		default_gradient = "content/ui/textures/mission_board/gradient_digital_circumnstance_default",
		disabled_gradient = "content/ui/textures/mission_board/gradient_digital_circumstances_locked",
		selected_gradient = "content/ui/textures/mission_board/gradient_digital_circumstances",
	},
}
MissionBoardViewStyles.colors.auric = setmetatable({
	corner = {
		255,
		249,
		231,
		115,
	},
	frame = {
		255,
		164,
		139,
		86,
	},
	main = {
		255,
		228,
		197,
		130,
	},
	green_faded = {
		255,
		171,
		146,
		92,
	},
}, {
	__index = MissionBoardViewStyles.colors.default,
})

local function _get_color_by_name(color_name, palette_name)
	palette_name = palette_name or "default"

	return MissionBoardViewStyles.colors[palette_name][color_name]
end

MissionBoardViewStyles.screen_decorations_widget_style_function = function (mission_type)
	return {
		overlay = {
			color = {
				75,
				0,
				0,
				0,
			},
			offset = {
				0,
				0,
				-1,
			},
		},
		overlay_top = {
			color = {
				0,
				0,
				0,
				0,
			},
			offset = {
				0,
				0,
				500,
			},
		},
		corner_right = {
			uvs = {
				{
					1,
					0,
				},
				{
					0,
					1,
				},
			},
		},
	}
end

MissionBoardViewStyles.info_box_widget_style_function = function (mission_type)
	return {
		background = {
			color = {
				150,
				58,
				15,
				15,
			},
		},
		frame = {
			scale_to_material = true,
			color = {
				0,
				0,
				0,
				0,
			},
			color_info = _get_color_by_name("accent", mission_type),
			color_warning = Color.ui_interaction_critical(255, true),
			offset = {
				0,
				0,
				1,
			},
		},
		text = {
			font_size = 18,
			font_type = "proxima_nova_bold",
			text_horizontal_alignment = "center",
			text_vertical_alignment = "center",
			text_color = Color.ui_interaction_critical(255, true),
			offset = {
				0,
				0,
				2,
			},
			size_addition = {
				-10,
				0,
			},
		},
	}
end

return settings("MissionBoardViewStyles", MissionBoardViewStyles)
