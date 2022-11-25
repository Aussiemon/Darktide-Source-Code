local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
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
wallet_text_font_style.text_horizontal_alignment = "center"
wallet_text_font_style.text_vertical_alignment = "center"
local fuse_description_font_style = table.clone(UIFontSettings.body)
fuse_description_font_style.text_horizontal_alignment = "left"
fuse_description_font_style.text_vertical_alignment = "top"
local price_text_font_style = table.clone(UIFontSettings.currency_title)
price_text_font_style.text_horizontal_alignment = "left"
price_text_font_style.text_vertical_alignment = "center"
local loading_style = table.clone(UIFontSettings.header_1)
loading_style.text_horizontal_alignment = "center"
loading_style.text_vertical_alignment = "center"
local fuse_action_font_style = table.clone(UIFontSettings.button_medium)
fuse_action_font_style.text_horizontal_alignment = "center"
fuse_action_font_style.text_vertical_alignment = "bottom"
fuse_action_font_style.vertical_alignment = "bottom"
fuse_action_font_style.horizontal_alignment = "center"
fuse_action_font_style.offset = {
	20,
	-10,
	0
}
fuse_action_font_style.size = {
	100,
	20
}
local count_font_style = table.clone(UIFontSettings.body_small)
count_font_style.horizontal_alignment = "center"
count_font_style.vertical_alignment = "top"
count_font_style.text_horizontal_alignment = "right"
count_font_style.text_vertical_alignment = "bottom"
count_font_style.offset = {
	-20,
	0,
	0
}
count_font_style.text_color = Color.ui_grey_medium(255, true)
local trait_tooltip_text_style = table.clone(UIFontSettings.body_small)
trait_tooltip_text_style.horizontal_alignment = "center"
trait_tooltip_text_style.vertical_alignment = "top"
trait_tooltip_text_style.text_horizontal_alignment = "left"
trait_tooltip_text_style.text_vertical_alignment = "top"
trait_tooltip_text_style.offset = {
	0,
	0,
	3
}
trait_tooltip_text_style.text_color = Color.ui_grey_medium(255, true)
local trait_text_style = table.clone(UIFontSettings.body_small)
trait_text_style.horizontal_alignment = "center"
trait_text_style.vertical_alignment = "top"
trait_text_style.text_horizontal_alignment = "left"
trait_text_style.text_vertical_alignment = "top"
trait_text_style.offset = {
	40,
	10,
	0
}
trait_text_style.text_color = Color.ui_grey_medium(255, true)

return {
	text_style = text_style,
	weapon_name_style = weapon_name_style,
	rarity_style = rarity_style,
	weapon_info_style = weapon_info_style,
	wallet_text_font_style = wallet_text_font_style,
	fuse_description_font_style = fuse_description_font_style,
	price_text_font_style = price_text_font_style,
	loading_style = loading_style,
	fuse_action_font_style = fuse_action_font_style,
	count_font_style = count_font_style,
	trait_tooltip_text_style = trait_tooltip_text_style,
	trait_text_style = trait_text_style
}
