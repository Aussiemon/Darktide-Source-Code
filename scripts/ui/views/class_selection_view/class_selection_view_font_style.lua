local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local main_title_style = table.clone(UIFontSettings.grid_title)
main_title_style.text_horizontal_alignment = "center"
main_title_style.text_vertical_alignment = "top"
main_title_style.font_size = 36
local domain_title_style = table.clone(UIFontSettings.grid_title)
domain_title_style.text_horizontal_alignment = "center"
domain_title_style.text_vertical_alignment = "top"
domain_title_style.font_size = 48
local domain_description_style = table.clone(UIFontSettings.body)
domain_description_style.text_horizontal_alignment = "left"
domain_description_style.text_vertical_alignment = "top"
domain_description_style.color = Color.white(255, true)
domain_description_style.offset = {
	0,
	120,
	1
}
local select_style = table.clone(UIFontSettings.symbol)
select_style.text_horizontal_alignment = "center"
select_style.text_vertical_alignment = "center"
select_style.size = {
	50,
	90
}
local class_domain_title_style = table.clone(UIFontSettings.grid_title)
class_domain_title_style.text_horizontal_alignment = "center"
class_domain_title_style.text_vertical_alignment = "top"
class_domain_title_style.offset = {
	0,
	0,
	1
}
class_domain_title_style.material = class_domain_title_style.disabled_material

return {
	domain_description_style = domain_description_style,
	select_style = select_style,
	domain_title_style = domain_title_style,
	class_domain_title_style = class_domain_title_style,
	main_title_style = main_title_style
}
