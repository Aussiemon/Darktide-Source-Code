local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local title_text_style = table.clone(UIFontSettings.header_2)
title_text_style.text_vertical_alignment = "top"
title_text_style.text_horizontal_alignment = "left"
title_text_style.material = "content/ui/materials/font_gradients/slug_font_gradient_header"
title_text_style.text_color = Color.white(255, true)
local sub_title_text_style = table.clone(UIFontSettings.body)
sub_title_text_style.text_vertical_alignment = "bottom"
sub_title_text_style.text_horizontal_alignment = "left"
local character_name_style = table.clone(UIFontSettings.body)
character_name_style.text_horizontal_alignment = "center"
character_name_style.text_vertical_alignment = "top"
character_name_style.offset = {
	0,
	115,
	0
}
character_name_style.default_color = Color.ui_grey_light(255, true)
character_name_style.text_color = Color.ui_grey_light(255, true)
character_name_style.hover_color = Color.ui_brown_super_light(255, true)
local character_name_hover_style = table.clone(UIFontSettings.body)
character_name_style.text_horizontal_alignment = "center"
character_name_style.text_vertical_alignment = "top"
character_name_style.offset = {
	0,
	115,
	1
}
character_name_style.text_color = Color.ui_brown_super_light(255, true)
local character_title_style = table.clone(UIFontSettings.body_small)
character_title_style.text_horizontal_alignment = "center"
character_title_style.text_vertical_alignment = "top"
character_title_style.offset = {
	0,
	140,
	0
}
character_title_style.default_color = Color.ui_grey_medium(255, true)
character_title_style.text_color = Color.ui_grey_medium(255, true)
character_title_style.hover_color = Color.ui_brown_super_light(255, true)
local guild_name_style = table.clone(UIFontSettings.body_small)
guild_name_style.text_horizontal_alignment = "center"
guild_name_style.text_vertical_alignment = "top"
guild_name_style.offset = {
	0,
	185,
	0
}
guild_name_style.default_color = Color.ui_grey_light(255, true)
guild_name_style.text_color = Color.ui_grey_light(255, true)
guild_name_style.hover_color = Color.ui_brown_super_light(255, true)
local ready_text_style = table.clone(UIFontSettings.header_3)
ready_text_style.text_vertical_alignment = "center"
ready_text_style.text_horizontal_alignment = "center"
ready_text_style.vertical_alignment = "bottom"
ready_text_style.horizontal_alignment = "center"
ready_text_style.material = "content/ui/materials/base/ui_slug_hdr"
ready_text_style.offset = {
	0,
	30,
	2
}
ready_text_style.size = {
	400,
	40
}
local loading_text_style = table.clone(UIFontSettings.body_small)
loading_text_style.text_color = Color.ui_chalk_grey(255, true)
loading_text_style.font_type = "proxima_nova_medium"
loading_text_style.text_vertical_alignment = "bottom"
loading_text_style.text_horizontal_alignment = "center"
loading_text_style.vertical_alignment = "bottom"
loading_text_style.horizontal_alignment = "center"
loading_text_style.offset = {
	10,
	40,
	2
}
loading_text_style.size = {
	800,
	20
}
local weapon_text_style = table.clone(UIFontSettings.header_3)
weapon_text_style.text_vertical_alignment = "top"
weapon_text_style.text_horizontal_alignment = "center"
weapon_text_style.material = "content/ui/materials/font_gradients/slug_font_gradient_header"
weapon_text_style.horizontal_alignment = "center"
weapon_text_style.text_color = Color.white(255, true)
local weapon_hover_text_style = table.clone(UIFontSettings.header_3)
weapon_hover_text_style.text_vertical_alignment = "top"
weapon_hover_text_style.text_horizontal_alignment = "center"
weapon_hover_text_style.horizontal_alignment = "center"
weapon_hover_text_style.offset = {
	0,
	0,
	1
}
weapon_hover_text_style.text_color = Color.ui_brown_super_light(255, true)
local inspect_text_style = table.clone(UIFontSettings.button_primary)
inspect_text_style.text_vertical_alignment = "bottom"
inspect_text_style.text_horizontal_alignment = "center"
inspect_text_style.offset = {
	0,
	40,
	1
}
inspect_text_style.vertical_alignment = "bottom"

return {
	title_text_style = title_text_style,
	sub_title_text_style = sub_title_text_style,
	character_name_style = character_name_style,
	character_name_hover_style = character_name_hover_style,
	guild_name_style = guild_name_style,
	character_title_style = character_title_style,
	ready_text_style = ready_text_style,
	loading_text_style = loading_text_style,
	weapon_text_style = weapon_text_style,
	weapon_hover_text_style = weapon_hover_text_style,
	inspect_text_style = inspect_text_style
}
