-- chunkname: @scripts/ui/pass_templates/accolade_pass_templates.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local AccoladePassTemplates = {}
local title_text_style = table.clone(UIFontSettings.header_3)

title_text_style.offset = {
	190,
	0,
	2
}
title_text_style.size = {
	270,
	60
}
title_text_style.text_color = Color.ui_grey_light(255, true)
title_text_style.vertical_alignment = "center"
title_text_style.horizontal_alignment = "center"
title_text_style.text_vertical_alignment = "top"
title_text_style.text_horizontal_alignment = "left"

local sub_title_text_style = table.clone(UIFontSettings.body)

sub_title_text_style.offset = {
	190,
	0,
	2
}
sub_title_text_style.size = {
	270,
	60
}
sub_title_text_style.vertical_alignment = "center"
sub_title_text_style.horizontal_alignment = "center"
sub_title_text_style.text_vertical_alignment = "bottom"
sub_title_text_style.text_horizontal_alignment = "left"
AccoladePassTemplates.player_of_the_game = {
	{
		value = "n/a",
		value_id = "title",
		pass_type = "text",
		style = title_text_style
	},
	{
		value = "n/a",
		value_id = "sub_title",
		pass_type = "text",
		style = sub_title_text_style
	},
	{
		value = "content/ui/materials/placeholders/accolades/accolade_placeholder",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = Color.white(255, true),
			size = {
				256,
				256
			},
			offset = {
				0,
				0,
				1
			}
		}
	},
	{
		value = "content/ui/materials/placeholders/accolades/accolade_background_placeholder",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = Color.white(255, true),
			size = {
				326,
				60
			},
			offset = {
				180,
				0,
				0
			}
		}
	}
}

return AccoladePassTemplates
