-- chunkname: @scripts/ui/view_elements/view_element_mission_info_panel/view_element_mission_info_panel_styles.lua

local ColorUtilities = require("scripts/utilities/ui/colors")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local mission_info_panel_style = {}
local default_screen_size = UIWorkspaceSettings.screen.size

mission_info_panel_style.panel = {}

local panel = mission_info_panel_style.panel

panel.top_margin = 150
panel.bottom_margin = 187
panel.size = {
	530,
	0,
}
panel.default_size = {
	530,
	430,
}
panel.max_size = {
	530,
	default_screen_size[2] - (panel.top_margin + panel.bottom_margin),
}

local background_color_default = {
	255,
	46,
	46,
	46,
}
local background_color_green = {
	255,
	15,
	46,
	15,
}
local background_color_red = {
	255,
	46,
	15,
	15,
}
local background_color_yellow = {
	255,
	46,
	46,
	15,
}

panel.background = {
	color = background_color_default,
	color_default = background_color_default,
	color_normal = background_color_green,
	color_circumstance = background_color_green,
	color_event = background_color_yellow,
	color_flash = background_color_green,
	color_locked = background_color_red,
}
panel.top = {
	size = {
		552,
		96,
	},
	offset = {
		0,
		-23,
		10,
	},
}
panel.bottom = {
	size = {
		552,
		38,
	},
	offset = {
		0,
		15,
		10,
	},
}
panel.scroll_bar = {}

local scrollbar_style = panel.scroll_bar

scrollbar_style.offset = {
	0,
	panel.top.size[2] + panel.top.offset[2],
	5,
}
scrollbar_style.height_addition = panel.bottom.offset[2] - panel.bottom.size[2] - scrollbar_style.offset[2]
panel.event_frame = {
	anim_lower_alpha = 32,
	anim_speed = 1,
	visible = false,
	size = {
		520,
	},
	offset = {
		5,
		0,
		5,
	},
	color = background_color_default,
	color_default = background_color_default,
	color_event = {
		64,
		255,
		244,
		0,
	},
	color_flash = {
		64,
		255,
		0,
		0,
	},
}
panel.frame_top_regular = {
	anim_lower_alpha = 128,
	anim_speed = 0.15,
	visible = true,
	offset = {
		0,
		0,
		1,
	},
}
panel.frame_top_event = table.clone(panel.frame_top_regular)

local frame_top_event_style = panel.frame_top_event

frame_top_event_style.offset[3] = 2
frame_top_event_style.visible = false
panel.frame_top_red = table.clone(panel.frame_top_event)

local frame_top_red_style = panel.frame_top_red

frame_top_red_style.offset[3] = 3
frame_top_red_style.visible = false
frame_top_red_style.anim_flash_speed = 1
mission_info_panel_style.panel_header = {}

local panel_header_style = mission_info_panel_style.panel_header

panel_header_style.size = {
	460,
	260,
}
panel_header_style.zone_image = {
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
}
panel_header_style.fade = {
	horizontal_alignment = "left",
	vertical_alignment = "top",
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
	uvs = {
		{
			0,
			1,
		},
		{
			1,
			0,
		},
	},
}
panel_header_style.mission_title = table.clone(UIFontSettings.mission_detail_header_1)

local mission_title_style = panel_header_style.mission_title

mission_title_style.text_horizontal_alignment = "center"
mission_title_style.offset = {
	0,
	25,
	2,
}
mission_title_style.text_color = Color.ui_green_super_light(255, true)
panel_header_style.type_and_zone = table.clone(UIFontSettings.mission_detail_header_2)

local type_and_zone_style = panel_header_style.type_and_zone

type_and_zone_style.offset = {
	0,
	53,
	2,
}
type_and_zone_style.text_horizontal_alignment = "center"
type_and_zone_style.font_size = 24
type_and_zone_style.text_color = Color.ui_grey_light(255, true)
panel_header_style.time_left = table.clone(UIFontSettings.mission_board_icon_info)

local time_left_style = panel_header_style.time_left

time_left_style.text_horizontal_alignment = "center"
time_left_style.text_vertical_alignment = "top"
time_left_style.offset = {
	0,
	87,
	2,
}
mission_info_panel_style.header_banner = {}

local header_banner_style = mission_info_panel_style.header_banner

header_banner_style.background = {
	offset = {
		0,
		0,
		3,
	},
	color = {
		192,
		0,
		0,
		0,
	},
}
header_banner_style.text = table.clone(UIFontSettings.mission_detail_header_1)

local header_banner_text_style = header_banner_style.text

header_banner_text_style.offset = {
	0,
	0,
	5,
}
header_banner_text_style.text_horizontal_alignment = "center"
header_banner_text_style.text_vertical_alignment = "center"
header_banner_text_style.text_color = Color.ui_red_light(255, true)
mission_info_panel_style.report_background = {}

local report_background_style = mission_info_panel_style.report_background

report_background_style.size = {
	520,
	402,
}
report_background_style.insignia = {
	horizontal_alignment = "center",
	offset = {
		0,
		0,
		1,
	},
	size = {
		520,
		0,
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
	color = Color.ui_grey_medium(255, true),
	color_default = Color.ui_grey_medium(255, true),
	color_normal = background_color_green,
	color_event = {
		255,
		30,
		46,
		15,
	},
}
mission_info_panel_style.blueprints = {}

local blueprint_styles = mission_info_panel_style.blueprints

blueprint_styles.list_spacing = 46
blueprint_styles.report_header = {}

local report_header_style = blueprint_styles.report_header

report_header_style.size = {
	panel.size[1],
	176,
}
report_header_style.headline = table.clone(UIFontSettings.header_2)

local event_header_headline_style = report_header_style.headline

event_header_headline_style.size = {
	460,
	85,
}
event_header_headline_style.offset = {
	32,
	20,
	2,
}
event_header_headline_style.text_horizontal_alignment = "center"
event_header_headline_style.text_vertical_alignment = "center"
event_header_headline_style.text_color = Color.ui_green_super_light(255, true)
report_header_style.time_left = table.clone(UIFontSettings.mission_detail_header_2)

local report_header_time_left_style = report_header_style.time_left

report_header_time_left_style.text_horizontal_alignment = "center"
report_header_time_left_style.text_vertical_alignment = "top"
report_header_time_left_style.offset = {
	0,
	105,
	2,
}
report_header_time_left_style.text_color = Color.ui_green_light(255, true)
blueprint_styles.risk_and_reward = {}

local risk_and_reward_style = blueprint_styles.risk_and_reward

risk_and_reward_style.size = {
	panel.size[1],
	170,
}
risk_and_reward_style.difficulty_frame = {
	horizontal_alignment = "right",
	size = {
		40,
		80,
	},
	offset = {
		-32,
		36,
		2,
	},
	color = Color.ui_green_medium(255, true),
}
risk_and_reward_style.resistance = {
	horizontal_alignment = "right",
	size = {
		40,
		40,
	},
	offset = {
		-32,
		36,
		2,
	},
	color = Color.ui_green_super_light(255, true),
}
risk_and_reward_style.challenge = {
	horizontal_alignment = "right",
	size = {
		40,
		40,
	},
	offset = {
		-32,
		76,
		2,
	},
	color = Color.ui_green_super_light(255, true),
}
risk_and_reward_style.resistance_label = table.clone(UIFontSettings.mission_detail_label)

local resistance_label_style = risk_and_reward_style.resistance_label

resistance_label_style.text_horizontal_alignment = "right"
resistance_label_style.offset = {
	-80,
	45,
	2,
}
risk_and_reward_style.challenge_label = table.clone(resistance_label_style)

local challenge_label_style = risk_and_reward_style.challenge_label

challenge_label_style.offset[2] = 85
risk_and_reward_style.xp_label = table.clone(UIFontSettings.mission_detail_label)

local xp_label_style = risk_and_reward_style.xp_label

xp_label_style.offset = {
	32,
	resistance_label_style.offset[2],
	2,
}
risk_and_reward_style.reward_label = table.clone(xp_label_style)

local reward_label_style = risk_and_reward_style.reward_label

reward_label_style.offset[2] = challenge_label_style.offset[2]
risk_and_reward_style.tag_xp = table.clone(UIFontSettings.body)
tag_xp_style = risk_and_reward_style.tag_xp
tag_xp_style.text_horizontal_alignment = "right"
tag_xp_style.text_color = Color.ui_green_super_light(255, true)
tag_xp_style.offset = {
	-250,
	41,
	2,
}
risk_and_reward_style.tag_reward = table.clone(tag_xp_style)

local tag_reward_style = risk_and_reward_style.tag_reward

tag_reward_style.offset[2] = 81
blueprint_styles.positive_circumstance_header = {}

local positive_circumstance_header_style = blueprint_styles.positive_circumstance_header

positive_circumstance_header_style.size = {
	panel.size[1] - 60,
	70,
}
positive_circumstance_header_style.icon = {
	horizontal_alignment = "right",
	size = {
		64,
		64,
	},
	offset = {
		32,
		0,
		1,
	},
	color = Color.ui_green_super_light(255, true),
}
positive_circumstance_header_style.label = table.clone(UIFontSettings.mission_detail_label)

local positive_circumstance_label_style = positive_circumstance_header_style.label

positive_circumstance_label_style.offset = {
	32,
	5,
	1,
}
positive_circumstance_header_style.title = table.clone(UIFontSettings.mission_detail_header_3)

local positive_circumstance_header_title_style = positive_circumstance_header_style.title

positive_circumstance_header_title_style.size = {
	positive_circumstance_header_style.size[1] - positive_circumstance_header_style.icon.size[1],
	20,
}
positive_circumstance_header_title_style.offset = {
	32,
	30,
	1,
}
positive_circumstance_header_style.bottom_margin = 18
blueprint_styles.negative_circumstance_header = table.clone(positive_circumstance_header_style)

local negative_circumstance_header_style = blueprint_styles.negative_circumstance_header
local negative_circumstance_header_icon_style = negative_circumstance_header_style.icon

negative_circumstance_header_icon_style.color = Color.ui_red_super_light(255, true)

local negative_circumstance_header_label_style = negative_circumstance_header_style.label

negative_circumstance_header_label_style.text_color = Color.ui_red_medium(255, true)

local negative_circumstance_header_title_style = negative_circumstance_header_style.title

negative_circumstance_header_title_style.text_color = Color.ui_red_light(255, true)
blueprint_styles.circumstance_bullet_point = {}

local circumstance_bullet_point_style = blueprint_styles.circumstance_bullet_point

circumstance_bullet_point_style.size = {
	panel.size[1] - 60,
	24,
}
circumstance_bullet_point_style.bullet = table.clone(UIFontSettings.body)

local circumstance_bulletstyle = circumstance_bullet_point_style.bullet

circumstance_bulletstyle.offset = {
	32,
	0,
	1,
}
circumstance_bullet_point_style.text = table.clone(UIFontSettings.body)

local circumstance_text_style = circumstance_bullet_point_style.text

circumstance_text_style.offset = {
	50,
	0,
	1,
}
circumstance_text_style.size = {
	panel.size[1] - circumstance_text_style.offset[1] - 30,
	24,
}
circumstance_bullet_point_style.bottom_margin = 13
blueprint_styles.side_mission = {}

local side_mission_style = blueprint_styles.side_mission

side_mission_style.size = {
	panel.size[1] - 60,
	88,
}
side_mission_style.label = table.clone(UIFontSettings.mission_detail_label)

local side_mission_label_style = side_mission_style.label

side_mission_label_style.offset = {
	32,
	0,
	1,
}
side_mission_style.title = table.clone(UIFontSettings.mission_detail_header_3)

local side_mission_title_style = side_mission_style.title

side_mission_title_style.offset = {
	32,
	30,
	1,
}
side_mission_style.description = table.clone(UIFontSettings.body)

local side_mission_description_style = side_mission_style.description

side_mission_description_style.offset = {
	32,
	70,
	1,
}
side_mission_description_style.size = {
	panel.size[1] - side_mission_description_style.offset[1] - 30,
	24,
}
side_mission_style.bottom_margin = 13
blueprint_styles.bonus = {}

local bonus_style = blueprint_styles.bonus

bonus_style.size = {
	panel.size[1] - 60,
	64,
}
bonus_style.icon = {
	horizontal_alignment = "right",
	size = {
		64,
		64,
	},
	offset = {
		-32,
		0,
		1,
	},
	color = Color.ui_green_super_light(255, true),
}

return settings("ViewElementMissionInfoPanelStyle", mission_info_panel_style)
