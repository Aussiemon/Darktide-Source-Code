local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local ClassSelectionViewSettings = require("scripts/ui/views/class_selection_view/class_selection_view_settings")
local main_title_style = table.clone(UIFontSettings.header_1)
main_title_style.text_horizontal_alignment = "center"
main_title_style.text_vertical_alignment = "top"
local archetype_title_style = table.clone(UIFontSettings.grid_title)
archetype_title_style.text_horizontal_alignment = "center"
archetype_title_style.text_vertical_alignment = "top"
archetype_title_style.font_size = 40
archetype_title_style.size_addition = {
	-40,
	0
}
archetype_title_style.horizontal_alignment = "center"
archetype_title_style.offset = {
	0,
	20,
	1
}
local archetype_description_style = table.clone(UIFontSettings.body)
archetype_description_style.text_horizontal_alignment = "center"
archetype_description_style.text_vertical_alignment = "top"
archetype_description_style.color = Color.white(255, true)
archetype_description_style.offset = {
	0,
	120,
	1
}
archetype_description_style.size_addition = {
	-40,
	0
}
archetype_description_style.horizontal_alignment = "center"
archetype_description_style.font_size = 22
local select_style = table.clone(UIFontSettings.symbol)
select_style.text_horizontal_alignment = "center"
select_style.text_vertical_alignment = "center"
select_style.size = {
	50,
	90
}
local class_archetype_title_style = table.clone(UIFontSettings.grid_title)
class_archetype_title_style.text_horizontal_alignment = "center"
class_archetype_title_style.text_vertical_alignment = "top"
class_archetype_title_style.offset = {
	0,
	0,
	1
}
class_archetype_title_style.line_spacing = 1
class_archetype_title_style.text_color = class_archetype_title_style.disabled_color
local class_title_style = table.clone(UIFontSettings.grid_title)
class_title_style.text_horizontal_alignment = "center"
class_title_style.text_vertical_alignment = "bottom"
class_title_style.offset = {
	0,
	0,
	1
}
local class_attributes_style = table.clone(UIFontSettings.grid_title)
class_attributes_style.text_horizontal_alignment = "center"
class_attributes_style.horizontal_alignment = "left"
class_attributes_style.text_vertical_alignment = "top"
class_attributes_style.offset = {
	0,
	0,
	2
}
class_attributes_style.font_size = 20
local class_description_style = table.clone(UIFontSettings.body)
class_description_style.text_horizontal_alignment = "center"
class_description_style.horizontal_alignment = "left"
class_description_style.text_vertical_alignment = "top"
class_description_style.offset = {
	0,
	0,
	0
}
class_description_style.font_size = 22
local class_option_title = table.clone(UIFontSettings.grid_title)
class_option_title.text_horizontal_alignment = "center"
class_option_title.vertical_alignment = "bottom"
class_option_title.text_vertical_alignment = "bottom"
class_option_title.offset = {
	0,
	60,
	1
}
local class_abilities_group = table.clone(UIFontSettings.header_3)
class_abilities_group.offset = {
	0,
	0,
	0
}
class_abilities_group.horizontal_alignment = "center"
class_abilities_group.text_horizontal_alignment = "center"
class_abilities_group.text_size = 20
local class_abilities_title = table.clone(UIFontSettings.header_3)
class_abilities_title.text_horizontal_alignment = "left"
class_abilities_title.text_vertical_alignment = "top"
class_abilities_title.offset = {
	140,
	0,
	1
}
class_abilities_title.text_size = 22
class_abilities_title.vertical_alignment = "top"
local class_abilities_description = table.clone(UIFontSettings.body_small)
class_abilities_description.text_horizontal_alignment = "left"
class_abilities_description.text_vertical_alignment = "top"
class_abilities_description.vertical_alignment = "top"
class_abilities_description.offset = {
	140,
	10,
	1
}
local class_weapon_title = table.clone(UIFontSettings.body)
class_weapon_title.offset = {
	280,
	0,
	0
}
class_weapon_title.text_horizontal_alignment = "left"
class_weapon_title.text_vertical_alignment = "center"
class_weapon_title.vertical_alignment = "top"

return {
	class_title_style = class_title_style,
	class_attributes_style = class_attributes_style,
	archetype_description_style = archetype_description_style,
	class_description_style = class_description_style,
	select_style = select_style,
	class_option_title = class_option_title,
	archetype_title_style = archetype_title_style,
	class_archetype_title_style = class_archetype_title_style,
	class_abilities_group = class_abilities_group,
	class_abilities_title = class_abilities_title,
	class_abilities_description = class_abilities_description,
	class_weapon_title = class_weapon_title,
	main_title_style = main_title_style
}
