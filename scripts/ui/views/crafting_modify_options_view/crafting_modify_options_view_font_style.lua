-- chunkname: @scripts/ui/views/crafting_modify_options_view/crafting_modify_options_view_font_style.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local loading_style = table.clone(UIFontSettings.header_1)

loading_style.text_horizontal_alignment = "center"
loading_style.text_vertical_alignment = "center"

local text_style = table.clone(UIFontSettings.header_2)

text_style.text_horizontal_alignment = "left"
text_style.text_vertical_alignment = "center"

local weapon_name_style = table.clone(UIFontSettings.header_2)

weapon_name_style.text_horizontal_alignment = "left"
weapon_name_style.text_vertical_alignment = "center"

local rarity_style = table.clone(UIFontSettings.header_2)

rarity_style.text_horizontal_alignment = "left"
rarity_style.text_vertical_alignment = "center"

local weapon_info_style = table.clone(UIFontSettings.header_2)

weapon_info_style.text_horizontal_alignment = "left"
weapon_info_style.text_vertical_alignment = "center"

local wallet_text_font_style = table.clone(UIFontSettings.currency_title)

wallet_text_font_style.text_horizontal_alignment = "right"
wallet_text_font_style.text_vertical_alignment = "center"

local display_name_style = table.clone(UIFontSettings.header_2)

display_name_style.text_horizontal_alignment = "center"
display_name_style.text_vertical_alignment = "center"
display_name_style.text_color = Color.white(255, true)
display_name_style.material = "content/ui/materials/font_gradients/slug_font_gradient_header"

local upgrade_title_style = table.clone(UIFontSettings.header_2)

upgrade_title_style.text_horizontal_alignment = "center"
upgrade_title_style.text_vertical_alignment = "center"
upgrade_title_style.offset = {
	0,
	-12,
	0,
}
upgrade_title_style.text_color = Color.white(255, true)
upgrade_title_style.material = "content/ui/materials/font_gradients/slug_font_gradient_header"

local upgrade_text_style = table.clone(UIFontSettings.body_small)

upgrade_text_style.text_horizontal_alignment = "center"
upgrade_text_style.text_vertical_alignment = "center"

local sub_display_name_style = table.clone(UIFontSettings.body)

sub_display_name_style.text_horizontal_alignment = "center"
sub_display_name_style.text_vertical_alignment = "center"

local price_text_font_style = table.clone(UIFontSettings.currency_title)

price_text_font_style.text_horizontal_alignment = "left"
price_text_font_style.text_vertical_alignment = "center"

local trait_tooltip_text_style = table.clone(UIFontSettings.body_small)

trait_tooltip_text_style.horizontal_alignment = "center"
trait_tooltip_text_style.vertical_alignment = "top"
trait_tooltip_text_style.text_horizontal_alignment = "left"
trait_tooltip_text_style.text_vertical_alignment = "top"
trait_tooltip_text_style.offset = {
	0,
	0,
	3,
}
trait_tooltip_text_style.text_color = Color.ui_grey_medium(255, true)

local trait_action_style = table.clone(UIFontSettings.header_2)

trait_action_style.horizontal_alignment = "center"
trait_action_style.vertical_alignment = "top"
trait_action_style.text_horizontal_alignment = "center"
trait_action_style.text_vertical_alignment = "top"
trait_action_style.offset = {
	0,
	0,
	3,
}

local fuse_description_font_style = table.clone(UIFontSettings.body_small)

fuse_description_font_style.horizontal_alignment = "center"
fuse_description_font_style.vertical_alignment = "top"
fuse_description_font_style.text_horizontal_alignment = "left"
fuse_description_font_style.text_vertical_alignment = "top"
fuse_description_font_style.offset = {
	40,
	10,
	0,
}
fuse_description_font_style.text_color = Color.ui_grey_medium(255, true)

local count_font_style = table.clone(UIFontSettings.body_small)

count_font_style.horizontal_alignment = "center"
count_font_style.vertical_alignment = "top"
count_font_style.text_horizontal_alignment = "right"
count_font_style.text_vertical_alignment = "bottom"
count_font_style.offset = {
	-20,
	0,
	0,
}
count_font_style.text_color = Color.ui_grey_medium(255, true)

local fuse_action_font_style = table.clone(UIFontSettings.button_medium)

fuse_action_font_style.text_horizontal_alignment = "left"
fuse_action_font_style.text_vertical_alignment = "bottom"
fuse_action_font_style.vertical_alignment = "bottom"
fuse_action_font_style.horizontal_alignment = "left"
fuse_action_font_style.offset = {
	20,
	-10,
	0,
}
fuse_action_font_style.size = {
	100,
	20,
}

return {
	text_style = text_style,
	weapon_name_style = weapon_name_style,
	rarity_style = rarity_style,
	weapon_info_style = weapon_info_style,
	wallet_text_font_style = wallet_text_font_style,
	display_name_style = display_name_style,
	upgrade_title_style = upgrade_title_style,
	upgrade_text_style = upgrade_text_style,
	sub_display_name_style = sub_display_name_style,
	price_text_font_style = price_text_font_style,
	trait_tooltip_text_style = trait_tooltip_text_style,
	trait_action_style = trait_action_style,
	loading_style = loading_style,
	fuse_description_font_style = fuse_description_font_style,
	count_font_style = count_font_style,
	fuse_action_font_style = fuse_action_font_style,
}
