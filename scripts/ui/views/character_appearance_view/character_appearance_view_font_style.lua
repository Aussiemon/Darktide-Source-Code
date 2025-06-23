-- chunkname: @scripts/ui/views/character_appearance_view/character_appearance_view_font_style.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local header_text_style = table.clone(UIFontSettings.header_3)

header_text_style.text_horizontal_alignment = "center"
header_text_style.text_vertical_alignment = "top"
header_text_style.offset = {
	0,
	0,
	1
}
header_text_style.text_color = Color.terminal_frame_selected(255, true)

local header_final_title_style = table.clone(UIFontSettings.body)

header_final_title_style.text_horizontal_alignment = "left"
header_final_title_style.horizontal_alignment = "left"
header_final_title_style.text_vertical_alignment = "top"
header_final_title_style.offset = {
	0,
	0,
	1
}
header_final_title_style.font_size = 24
header_final_title_style.text_color = Color.terminal_text_header(255, true)

local header_final_text_style = table.clone(UIFontSettings.body)

header_final_text_style.text_horizontal_alignment = "left"
header_final_text_style.horizontal_alignment = "left"
header_final_text_style.text_vertical_alignment = "top"
header_final_text_style.offset = {
	0,
	0,
	1
}
header_final_text_style.font_size = 36
header_final_text_style.text_color = Color.terminal_text_body(255, true)

local header_choice_text_style = table.clone(UIFontSettings.header_2)

header_choice_text_style.text_horizontal_alignment = "center"
header_choice_text_style.text_vertical_alignment = "top"
header_choice_text_style.offset = {
	0,
	0,
	1
}

local option_title_style = table.clone(UIFontSettings.header_3)

option_title_style.text_horizontal_alignment = "left"
option_title_style.text_vertical_alignment = "top"
option_title_style.offset = {
	0,
	0,
	1
}
option_title_style.text_color = Color.terminal_text_header(255, true)

local name_style = table.clone(UIFontSettings.header_2)

name_style.text_horizontal_alignment = "left"
name_style.text_vertical_alignment = "top"
name_style.offset = {
	0,
	-80,
	1
}

local class_style = table.clone(UIFontSettings.header_4)

class_style.text_horizontal_alignment = "left"
class_style.text_vertical_alignment = "top"
class_style.offset = {
	0,
	-50,
	1
}

local description_style = table.clone(UIFontSettings.body)

description_style.text_horizontal_alignment = "left"
description_style.text_vertical_alignment = "top"
description_style.offset = {
	0,
	0,
	1
}
description_style.text_color = Color.terminal_text_body(255, true)
description_style.font_size = 20

local list_description_style = table.clone(UIFontSettings.body)

list_description_style.text_horizontal_alignment = "center"
list_description_style.text_vertical_alignment = "center"
list_description_style.vertical_alignment = "top"
list_description_style.offset = {
	0,
	0,
	1
}
list_description_style.font_size = 20
list_description_style.text_color = Color.terminal_text_body(255, true)
list_description_style.horizontal_alignment = "center"

local overlay_text_style = table.clone(UIFontSettings.header_2)

overlay_text_style.text_vertical_alignment = "center"
overlay_text_style.text_horizontal_alignment = "center"
overlay_text_style.offset = {
	0,
	0,
	201
}

local effect_title_style = table.clone(UIFontSettings.header_3)

effect_title_style.text_horizontal_alignment = "left"
effect_title_style.text_vertical_alignment = "top"
effect_title_style.offset = {
	0,
	0,
	1
}
effect_title_style.font_size = 20
effect_title_style.text_color = Color.terminal_text_header(255, true)

local effect_description_style = table.clone(UIFontSettings.body)

effect_description_style.text_horizontal_alignment = "left"
effect_description_style.text_vertical_alignment = "center"
effect_description_style.offset = {
	25,
	0,
	1
}
effect_description_style.text_color = Color.white(255, true)

local effect_description_not_selected_style = table.clone(UIFontSettings.body)

effect_description_not_selected_style.text_horizontal_alignment = "left"
effect_description_not_selected_style.text_vertical_alignment = "center"
effect_description_not_selected_style.offset = {
	25,
	30,
	1
}
effect_description_not_selected_style.text_color = Color.ui_hud_red_light(255, true)
effect_description_not_selected_style.font_size = 18

local button_font_style = table.clone(UIFontSettings.button_2)

button_font_style.offset = {
	60,
	0,
	3
}
button_font_style.text_horizontal_alignment = "left"
button_font_style.text_vertical_alignment = "center"
button_font_style.hover_color = Color.terminal_text_header_selected(255, true)
button_font_style.text_color = Color.terminal_text_body(255, true)
button_font_style.default_color = Color.terminal_text_body(255, true)
button_font_style.selected_color = Color.terminal_text_header_selected(255, true)

local category_button_font_style = table.clone(UIFontSettings.list_button)

category_button_font_style.offset = {
	30,
	0,
	3
}

local entry_no_icon_style = {}

entry_no_icon_style.label = table.clone(UIFontSettings.header_3)
entry_no_icon_style.label.offset = {
	0,
	16,
	2
}
entry_no_icon_style.description = table.clone(UIFontSettings.body)
entry_no_icon_style.description.offset = {
	0,
	50,
	2
}

local slider_top_font_style = table.clone(UIFontSettings.list_button)

slider_top_font_style.size = {
	140,
	25
}
slider_top_font_style.text_horizontal_alignment = "center"
slider_top_font_style.text_vertical_alignment = "center"
slider_top_font_style.vertical_alignment = "top"
slider_top_font_style.horizontal_alignment = "center"
slider_top_font_style.offset = {
	0,
	0,
	0
}

local slider_bottom_font_style = table.clone(UIFontSettings.list_button)

slider_bottom_font_style.size = {
	140,
	25
}
slider_bottom_font_style.text_vertical_alignment = "center"
slider_bottom_font_style.text_horizontal_alignment = "center"
slider_bottom_font_style.vertical_alignment = "bottom"
slider_bottom_font_style.horizontal_alignment = "center"
slider_bottom_font_style.offset = {
	0,
	0,
	10
}

local marker_font_style = table.clone(UIFontSettings.symbol)

marker_font_style.font_size = 32
marker_font_style.font_type = "proxima_nova_bold"
marker_font_style.text_color = Color.white(255, true)
marker_font_style.text_vertical_alignment = "center"
marker_font_style.text_horizontal_alignment = "center"
marker_font_style.offset = {
	0,
	0,
	10
}

local marker_icon_font_style = table.clone(UIFontSettings.symbol)

marker_icon_font_style.font_size = 32
marker_icon_font_style.font_type = "proxima_nova_bold"
marker_icon_font_style.text_color = Color.white(255, true)
marker_icon_font_style.text_vertical_alignment = "bottom"
marker_icon_font_style.text_horizontal_alignment = "right"
marker_icon_font_style.offset = {
	-5,
	0,
	10
}

local randomize_button_text_style = table.clone(UIFontSettings.button_primary)

randomize_button_text_style.offset = {
	0,
	0,
	4
}
randomize_button_text_style.text_horizontal_alignment = "left"
randomize_button_text_style.text_vertical_alignment = "center"
randomize_button_text_style.character_spacing = 0.1
randomize_button_text_style.offset = {
	60,
	0,
	1
}

local reward_description_style = table.clone(UIFontSettings.body)

reward_description_style.text_horizontal_alignment = "left"
reward_description_style.text_vertical_alignment = "center"
reward_description_style.offset = {
	80,
	0,
	1
}
reward_description_style.text_color = Color.terminal_text_body(255, true)
reward_description_style.font_size = 20

local reward_description_no_icon_style = table.clone(UIFontSettings.body)

reward_description_no_icon_style.text_horizontal_alignment = "left"
reward_description_no_icon_style.text_vertical_alignment = "center"
reward_description_no_icon_style.offset = {
	0,
	0,
	1
}
reward_description_no_icon_style.text_color = Color.terminal_text_body(255, true)
reward_description_no_icon_style.font_size = 20

local error_style = table.clone(UIFontSettings.body)

error_style.text_horizontal_alignment = "left"
error_style.text_vertical_alignment = "bottom"
error_style.font_size = 18
error_style.text_color = Color.ui_red_medium(255, true)

local companion_input_text_style = table.clone(header_final_text_style)

companion_input_text_style.text_vertical_alignment = "center"

return {
	header_choice_text_style = header_choice_text_style,
	header_text_style = header_text_style,
	header_final_text_style = header_final_text_style,
	header_final_title_style = header_final_title_style,
	option_title_style = option_title_style,
	description_style = description_style,
	list_description_style = list_description_style,
	effect_title_style = effect_title_style,
	overlay_text_style = overlay_text_style,
	button_font_style = button_font_style,
	category_button_font_style = category_button_font_style,
	entry_no_icon_style = entry_no_icon_style,
	slider_top_font_style = slider_top_font_style,
	slider_bottom_font_style = slider_bottom_font_style,
	marker_font_style = marker_font_style,
	marker_icon_font_style = marker_icon_font_style,
	name_style = name_style,
	class_style = class_style,
	randomize_button_text_style = randomize_button_text_style,
	effect_description_style = effect_description_style,
	reward_description_style = reward_description_style,
	reward_description_no_icon_style = reward_description_no_icon_style,
	error_style = error_style,
	effect_description_not_selected_style = effect_description_not_selected_style,
	companion_input_text_style = companion_input_text_style
}
