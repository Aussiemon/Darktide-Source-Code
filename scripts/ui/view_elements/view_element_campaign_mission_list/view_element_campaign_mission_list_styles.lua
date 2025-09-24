-- chunkname: @scripts/ui/view_elements/view_element_campaign_mission_list/view_element_campaign_mission_list_styles.lua

local Settings = require("scripts/ui/view_elements/view_element_campaign_mission_list/view_element_campaign_mission_list_settings")
local Styles = {}
local DebriefSettings = Settings.debrief_settings

Styles.top_detail = {}
Styles.top_detail.detail_texture = {
	horizontal_alignment = "center",
	vertical_alignment = "center",
	color = {
		255,
		255,
		88,
		27,
	},
	offset = {
		0,
		0,
		2,
	},
	size_addition = {
		0,
		0,
	},
	size = {
		100,
		100,
	},
	material_values = {
		gradient_map = "content/ui/textures/mission_board/gradient_digital_frame_red",
	},
}
Styles.list_background = {}
Styles.list_background.list_background_fade = {
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	color = {
		90,
		255,
		88,
		27,
	},
	size = {
		380,
		1120,
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
		-370,
		1100,
		1,
	},
	angle = math.degrees_to_radians(90),
}
Styles.bottom_detail = {}
Styles.bottom_detail.background = {
	color = {
		255,
		0,
		0,
		0,
	},
	offset = {
		0,
		0,
		0,
	},
	size_addition = {
		0,
		0,
	},
}
Styles.bottom_detail.frame = {
	horizontal_alignment = "center",
	vertical_alignment = "center",
	color = {
		255,
		255,
		88,
		27,
	},
	offset = {
		0,
		0,
		10,
	},
	size_addition = {
		0,
		0,
	},
}
Styles.bottom_detail.flavor_text_1 = {
	font_size = 22,
	font_type = "trim_mono_medium",
	horizontal_alignment = "left",
	text_horizontal_alignment = "left",
	text_vertical_alignment = "center",
	vertical_alignment = "center",
	text_color = {
		255,
		255,
		88,
		27,
	},
	offset = {
		770,
		0,
		10,
	},
	size = {
		300,
		38,
	},
}
Styles.campaign_header = {}
Styles.campaign_header.header_text = {
	font_size = 30,
	font_type = "trim_mono_medium",
	horizontal_alignment = "center",
	text_horizontal_alignment = "center",
	text_vertical_alignment = "center",
	vertical_alignment = "center",
	text_color = {
		255,
		255,
		88,
		27,
	},
	offset = {
		0,
		0,
		10,
	},
}
Styles.debrief_video = {}
Styles.debrief_video.background = {
	horizontal_alignment = "center",
	vertical_alignment = "center",
	color = {
		255,
		0,
		0,
		0,
	},
	offset = {
		0,
		0,
		10,
	},
	default_size = DebriefSettings.size,
	size = DebriefSettings.size,
}
Styles.debrief_video.hotspot = {
	anim_hover_speed = 10,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	offset = {
		0,
		0,
		10,
	},
	size = DebriefSettings.size,
	default_size = DebriefSettings.size,
}
Styles.debrief_video.debrief_icon = {
	horizontal_alignment = "center",
	vertical_alignment = "center",
	color = {
		255,
		255,
		255,
		255,
	},
	default_color = {
		255,
		255,
		255,
		255,
	},
	disabled_color = {
		165,
		255,
		255,
		255,
	},
	offset = {
		0,
		0,
		12,
	},
	size = DebriefSettings.icon_size,
	default_size = DebriefSettings.icon_size,
}
Styles.debrief_video.frame = {
	horizontal_alignment = "center",
	vertical_alignment = "center",
	color = {
		255,
		255,
		88,
		27,
	},
	default_color = {
		255,
		255,
		88,
		27,
	},
	disabled_color = {
		165,
		255,
		88,
		27,
	},
	offset = {
		0,
		0,
		14,
	},
	size = DebriefSettings.size,
	default_size = DebriefSettings.size,
}
Styles.debrief_video.line = {
	horizontal_alignment = "center",
	vertical_alignment = "center",
	color = {
		255,
		255,
		88,
		27,
	},
	default_color = {
		255,
		255,
		88,
		27,
	},
	disabled_color = {
		165,
		255,
		88,
		27,
	},
	offset = {
		-DebriefSettings.size[1],
		0,
		-20,
	},
	size = {
		DebriefSettings.size[1],
		2,
	},
}
Styles.debrief_video.gamepad_input_hint = {
	font_size = 32,
	font_type = "proxima_nova_medium",
	horizontal_alignment = "center",
	text_horizontal_alignment = "center",
	text_vertical_alignment = "center",
	vertical_alignment = "center",
	text_color = {
		255,
		255,
		88,
		27,
	},
	offset = {
		0,
		DebriefSettings.size[2] - 16,
		12,
	},
	size = {
		40,
		40,
	},
}

return settings("ViewElementCampaignMissionListStyles", Styles)
