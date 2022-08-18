local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local end_view_styles = {
	panel_size = {
		270,
		200
	},
	page_corner_decoration = {}
}
local page_corner_decoration_style = end_view_styles.page_corner_decoration
page_corner_decoration_style.corner_decoration = {
	offset = {
		0,
		0,
		1
	}
}
page_corner_decoration_style.candles = {
	offset = {
		0,
		0,
		2
	}
}
end_view_styles.page_bottom_decoration = {}
local page_bottom_decoration_style = end_view_styles.page_bottom_decoration
page_bottom_decoration_style.bottom_decoration = {
	vertical_alignment = "bottom",
	horizontal_alignment = "center",
	offset = {
		0,
		0,
		0
	},
	size = {
		nil,
		106
	}
}
end_view_styles.page_bottom_center_decoration = {}
local page_page_bottom_center_decoration = end_view_styles.page_bottom_center_decoration
page_page_bottom_center_decoration.bottom_center_decoration = {
	offset = {
		0,
		0,
		2
	}
}
end_view_styles.defeat_page_overlay = {}
local defeat_page_overlay_styles = end_view_styles.defeat_page_overlay
defeat_page_overlay_styles.overlay = {
	color = Color.black(64, true)
}
end_view_styles.mission_header_victory = {}
local mission_header_victory_style = end_view_styles.mission_header_victory
mission_header_victory_style.mission_header = table.clone(UIFontSettings.header_2)
local mission_header_title_style_victory = mission_header_victory_style.mission_header
mission_header_title_style_victory.text_horizontal_alignment = "center"
mission_header_title_style_victory.offset = {
	0,
	10,
	0
}
mission_header_title_style_victory.text_color = Color.white(255, true)
mission_header_title_style_victory.material = "content/ui/materials/font_gradients/slug_font_gradient_header"
mission_header_victory_style.divider = {}
local mission_header_divider_style_victory = mission_header_victory_style.divider
mission_header_divider_style_victory.size = {
	512,
	2
}
mission_header_divider_style_victory.horizontal_alignment = "center"
mission_header_divider_style_victory.offset = {
	0,
	50,
	0
}
mission_header_divider_style_victory.color = Color.ui_brown_light(255, true)
mission_header_victory_style.mission_sub_header = table.clone(UIFontSettings.body)
local mission_sub_header_victory_style = mission_header_victory_style.mission_sub_header
mission_sub_header_victory_style.text_horizontal_alignment = "center"
mission_sub_header_victory_style.text_vertical_alignment = "center"
mission_sub_header_victory_style.offset = {
	0,
	55,
	0
}
mission_sub_header_victory_style.text_color = Color.ui_grey_medium(255, true)
end_view_styles.mission_header_defeat = table.clone(mission_header_victory_style)
local mission_header_defeat_style = end_view_styles.mission_header_defeat
local mission_header_title_style_defeat = mission_header_defeat_style.mission_header
mission_header_title_style_defeat.material = "content/ui/materials/font_gradients/slug_font_gradient_insufficient_funds"
local mission_header_divider_style_defeat = mission_header_defeat_style.divider
mission_header_divider_style_defeat.color = Color.ui_red_medium(255, true)
mission_header_defeat_style.mission_sub_header = table.clone(mission_header_title_style_defeat)
local mission_sub_header_defeat_style = mission_header_defeat_style.mission_sub_header
mission_sub_header_defeat_style.offset[2] = 62
end_view_styles.player_panel_victory = {}
local player_panel_victory_style = end_view_styles.player_panel_victory
player_panel_victory_style.character_portrait = {
	horizontal_alignment = "center",
	size = {
		90,
		100
	},
	material_values = {
		use_placeholder_texture = 1,
		texture_frame = end_view_styles.default_frame_material
	}
}
player_panel_victory_style.checkmark = table.clone(UIFontSettings.symbol)
local checkmark_style_victory = player_panel_victory_style.checkmark
checkmark_style_victory.font_size = 40
checkmark_style_victory.size = player_panel_victory_style.character_portrait.size
checkmark_style_victory.horizontal_alignment = "center"
checkmark_style_victory.offset = {
	92,
	0,
	2
}
checkmark_style_victory.hdr = true
checkmark_style_victory.text_color = Color.ui_terminal(255, true)
checkmark_style_victory.visible = false
player_panel_victory_style.party_status = table.clone(checkmark_style_victory)
local party_status_text_style_victory = player_panel_victory_style.party_status
party_status_text_style_victory.text_vertical_alignment = "bottom"
player_panel_victory_style.character_insignia = {
	horizontal_alignment = "center",
	size = {
		40,
		100
	},
	offset = {
		-65,
		0,
		0
	},
	material_values = {}
}
player_panel_victory_style.character_name = table.clone(UIFontSettings.body)
local character_name_style_victory = player_panel_victory_style.character_name
character_name_style_victory.text_horizontal_alignment = "center"
character_name_style_victory.offset = {
	0,
	115,
	0
}
character_name_style_victory.own_player_text_color = Color.ui_brown_light(255, true)
player_panel_victory_style.character_title = table.clone(UIFontSettings.body_small)
local character_title_style_victory = player_panel_victory_style.character_title
character_title_style_victory.text_horizontal_alignment = "center"
character_title_style_victory.offset = {
	0,
	140,
	0
}
player_panel_victory_style.account_divider = {
	horizontal_alignment = "center",
	size = {
		nil,
		1
	},
	offset = {
		0,
		166,
		0
	},
	color = Color.ui_grey_medium(255, true)
}
player_panel_victory_style.account_name = table.clone(UIFontSettings.body_small)
local account_name_style_victory = player_panel_victory_style.account_name
account_name_style_victory.text_horizontal_alignment = "center"
account_name_style_victory.offset = {
	0,
	170,
	0
}
account_name_style_victory.text_color = Color.ui_grey_medium(255, true)
end_view_styles.player_panel_defeat = table.clone(player_panel_victory_style)
local player_panel_defeat_style = end_view_styles.player_panel_defeat
local character_portrait_style_defeat = player_panel_defeat_style.character_portrait
character_portrait_style_defeat.color = {
	255,
	128,
	128,
	128
}
local character_insignia_style_defeat = player_panel_defeat_style.character_insignia
character_insignia_style_defeat.color = table.clone(player_panel_defeat_style.character_portrait.color)

return settings("EndViewStyles", end_view_styles)
