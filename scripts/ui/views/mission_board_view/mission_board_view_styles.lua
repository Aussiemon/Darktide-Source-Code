local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ViewSettings = require("scripts/ui/views/mission_board_view/mission_board_view_settings")
local slug_hdr_material = "content/ui/materials/base/ui_slug_hdr"
local ui_terminal = Color.ui_terminal(255, true)
local mission_board_style = {
	background = {}
}
local background_style = mission_board_style.background
background_style.radial_grid = {}
background_style.corner_right = {
	uvs = {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}
}
mission_board_style.header = {}
local header_style = mission_board_style.header
header_style.sub_header = table.clone(UIFontSettings.mission_board_sub_header)
header_style.board_header = table.clone(UIFontSettings.mission_board_header)
mission_board_style.icon_info = {}
local icon_info_style = mission_board_style.icon_info
icon_info_style.info_plate = {
	offset = {
		0,
		0,
		75
	},
	color = Color.black(128, true)
}
icon_info_style.tag_xp = table.clone(UIFontSettings.mission_board_icon_info)
local icon_info_tag_xp_style = icon_info_style.tag_xp
icon_info_tag_xp_style.offset = {
	-5,
	3,
	icon_info_style.info_plate.offset[3] + 5
}
icon_info_style.tag_reward = table.clone(icon_info_tag_xp_style)
local icon_info_tag_reward_style = icon_info_style.tag_reward
icon_info_tag_reward_style.offset[2] = 26
icon_info_style.tag_timer = table.clone(icon_info_tag_xp_style)
local icon_info_tag_timer_style = icon_info_style.tag_timer
icon_info_tag_timer_style.text_vertical_alignment = "bottom"
icon_info_tag_timer_style.offset[2] = -4
icon_info_style.info_plate_divider = {
	vertical_alignment = "bottom",
	size = {
		nil,
		2
	},
	offset = {
		0,
		-30,
		icon_info_tag_xp_style.offset[3]
	},
	color = Color.black(255, true)
}
mission_board_style.legend_text = table.clone(UIFontSettings.body)
local legend_text_style = mission_board_style.legend_text
legend_text_style.text_horizontal_alignment = "center"
legend_text_style.text_color = Color.ui_brown_super_light(255, true)
mission_board_style.blueprints = {}
local blueprint_styles = mission_board_style.blueprints
blueprint_styles.mission_icon = {}
local mission_icon_style = blueprint_styles.mission_icon
mission_icon_style.size = {
	192,
	192
}
mission_icon_style.anchor_point_offset = {
	-96,
	-170,
	0
}
mission_icon_style.info_anchor_point_offset = {
	-26,
	-10,
	0
}
mission_icon_style.difficulty_materials = {
	resistance = {
		"content/ui/materials/mission_board/badges/numbers/green_1_upper",
		"content/ui/materials/mission_board/badges/numbers/green_2_upper",
		"content/ui/materials/mission_board/badges/numbers/green_3_upper",
		"content/ui/materials/mission_board/badges/numbers/green_4_upper",
		"content/ui/materials/mission_board/badges/numbers/green_5_upper"
	},
	challenge = {
		"content/ui/materials/mission_board/badges/numbers/green_1_lower",
		"content/ui/materials/mission_board/badges/numbers/green_2_lower",
		"content/ui/materials/mission_board/badges/numbers/green_3_lower",
		"content/ui/materials/mission_board/badges/numbers/green_4_lower",
		"content/ui/materials/mission_board/badges/numbers/green_5_lower"
	}
}
mission_icon_style.hotspot = {
	anim_select_speed = 8,
	anim_hover_speed = 8,
	horizontal_alignment = "center",
	anim_focus_speed = 8,
	vertical_alignment = "bottom",
	anim_input_speed = 8,
	size = {
		60,
		104
	},
	offset = {
		0,
		-22,
		0
	},
	on_hover_sound = UISoundEvents.mission_board_node_hover,
	on_pressed_sound = UISoundEvents.mission_board_node_pressed
}
mission_icon_style.frame_effect = {
	offset = {
		0,
		0,
		-1
	}
}
mission_icon_style.frame = {
	offset = {
		0,
		0,
		0
	}
}
mission_icon_style.resistance = {
	offset = {
		0,
		0,
		1
	}
}
mission_icon_style.challenge = {
	offset = {
		0,
		0,
		1
	}
}
mission_icon_style.selection = {
	horizontal_alignment = "center",
	offset = {
		0,
		0,
		0
	},
	size_addition = {
		0,
		0
	}
}
blueprint_styles.circumstance_mission_icon = table.clone(mission_icon_style)
local circumstance_mission_icon_style = blueprint_styles.circumstance_mission_icon
circumstance_mission_icon_style.anchor_point_offset = {
	-96,
	-170,
	0
}
circumstance_mission_icon_style.info_anchor_point_offset = {
	-38,
	-10,
	0
}
local circumstance_mission_icon_hotspot_style = circumstance_mission_icon_style.hotspot
circumstance_mission_icon_hotspot_style.size = {
	84,
	104
}
blueprint_styles.happening_mission_icon = table.clone(circumstance_mission_icon_style)
local happening_mission_icon_style = blueprint_styles.happening_mission_icon
happening_mission_icon_style.difficulty_materials = {
	resistance = {
		"content/ui/materials/mission_board/badges/numbers/red_1_upper",
		"content/ui/materials/mission_board/badges/numbers/red_2_upper",
		"content/ui/materials/mission_board/badges/numbers/red_3_upper",
		"content/ui/materials/mission_board/badges/numbers/red_4_upper",
		"content/ui/materials/mission_board/badges/numbers/red_5_upper"
	},
	challenge = {
		"content/ui/materials/mission_board/badges/numbers/red_1_lower",
		"content/ui/materials/mission_board/badges/numbers/red_2_lower",
		"content/ui/materials/mission_board/badges/numbers/red_3_lower",
		"content/ui/materials/mission_board/badges/numbers/red_4_lower",
		"content/ui/materials/mission_board/badges/numbers/red_5_lower"
	}
}
blueprint_styles.flash_mission_icon = table.clone(happening_mission_icon_style)
blueprint_styles.locked_mission_icon = {}
local locked_mission_icon_style = blueprint_styles.locked_mission_icon
locked_mission_icon_style.size = {
	192,
	192
}
locked_mission_icon_style.anchor_point_offset = {
	-96,
	-170,
	0
}
locked_mission_icon_style.info_anchor_point_offset = {
	-26,
	-20,
	0
}
locked_mission_icon_style.hotspot = table.clone(mission_icon_style.hotspot)
local locked_mission_icon_hotspot_style = locked_mission_icon_style.hotspot
locked_mission_icon_hotspot_style.size = {
	60,
	65
}
locked_mission_icon_style.selection = table.clone(mission_icon_style.selection)
mission_board_style.circumstances_frame_material = "content/ui/materials/mission_board/badges/frame_circumstance"
mission_board_style.circumstances_highlight_material = "content/ui/materials/mission_board/badges/highlight_circumstance"
mission_board_style.main_objective_type_materials = {
	fortification_objective = "content/ui/materials/icons/mission_type/fortification_objective",
	demolition_objective = "content/ui/materials/icons/mission_type/demolition_objective",
	kill_objective = "content/ui/materials/icons/mission_type/kill_objective",
	control_objective = "content/ui/materials/icons/mission_type/control_objective",
	default = "content/ui/materials/icons/mission_type/default",
	decode_objective = "content/ui/materials/icons/mission_type/decode_objective",
	luggable_objective = "content/ui/materials/icons/mission_type/luggable_objective"
}
mission_board_style.header_divider_style = {
	scale_to_material = true,
	hdr = true,
	color = ui_terminal
}
mission_board_style.debug_text_main = {
	horizontal_alignment = "left",
	font_size = 15,
	text_vertical_alignment = "center",
	text_horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "proxima_nova_medium",
	offset = {
		150,
		20,
		4
	},
	size = {
		180,
		20
	},
	text_color = Color.pale_green(255, true),
	material = slug_hdr_material
}
mission_board_style.zone_line = {
	line = {
		offset = {
			0,
			-11,
			5
		},
		size = {
			22,
			22
		},
		color = {
			164,
			64,
			255,
			0
		},
		pivot = {
			0,
			11
		}
	},
	line_end = {
		offset = {
			-11,
			-11,
			5
		},
		size = {
			22,
			22
		},
		color = {
			164,
			255,
			64,
			0
		}
	}
}

return settings("MissionBoardViewStyles", mission_board_style)
