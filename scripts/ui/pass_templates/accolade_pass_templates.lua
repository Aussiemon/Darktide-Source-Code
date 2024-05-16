-- chunkname: @scripts/ui/pass_templates/accolade_pass_templates.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local AccoladePassTemplates = {}
local title_text_style = table.clone(UIFontSettings.header_3)

title_text_style.offset = {
	190,
	0,
	2,
}
title_text_style.size = {
	270,
	60,
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
	2,
}
sub_title_text_style.size = {
	270,
	60,
}
sub_title_text_style.vertical_alignment = "center"
sub_title_text_style.horizontal_alignment = "center"
sub_title_text_style.text_vertical_alignment = "bottom"
sub_title_text_style.text_horizontal_alignment = "left"
AccoladePassTemplates.player_of_the_game = {
	{
		pass_type = "text",
		value = "n/a",
		value_id = "title",
		style = title_text_style,
	},
	{
		pass_type = "text",
		value = "n/a",
		value_id = "sub_title",
		style = sub_title_text_style,
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/placeholders/accolades/accolade_placeholder",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.white(255, true),
			size = {
				256,
				256,
			},
			offset = {
				0,
				0,
				1,
			},
		},
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/placeholders/accolades/accolade_background_placeholder",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.white(255, true),
			size = {
				326,
				60,
			},
			offset = {
				180,
				0,
				0,
			},
		},
	},
}

return AccoladePassTemplates
