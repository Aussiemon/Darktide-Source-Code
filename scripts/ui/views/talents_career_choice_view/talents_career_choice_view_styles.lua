-- chunkname: @scripts/ui/views/talents_career_choice_view/talents_career_choice_view_styles.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local talents_career_choice_view_styles = {}

talents_career_choice_view_styles.banner_offset_y = 50
talents_career_choice_view_styles.mask_margins = {
	20,
	25
}
talents_career_choice_view_styles.confirm_button_size = ButtonPassTemplates.default_button.size
talents_career_choice_view_styles.confirm_button_offset_y = -40
talents_career_choice_view_styles.career_banner = {}

local career_banner = talents_career_choice_view_styles.career_banner

career_banner.size = {
	540,
	730
}
career_banner.background = {
	color = {
		255,
		255,
		255,
		255
	},
	material_values = {
		saturation = 1
	}
}
career_banner.background_blurred = {
	offset = {
		0,
		0,
		1
	},
	color = {
		0,
		128,
		128,
		128
	}
}
career_banner.fade_top = {
	offset = {
		0,
		0,
		2
	},
	size = {
		career_banner.size[1],
		50
	},
	uvs = {
		{
			0,
			1
		},
		{
			1,
			0
		}
	},
	color = Color.black(255, true)
}
career_banner.fade_bottom = {
	vertical_alignment = "bottom",
	offset = {
		0,
		0,
		2
	},
	size = {
		career_banner.size[1],
		50
	},
	color = Color.black(255, true)
}
career_banner.title = table.clone(UIFontSettings.header_2)

local career_banner_title = career_banner.title

career_banner_title.offset = {
	0,
	517,
	2
}
career_banner_title.text_horizontal_alignment = "center"

local short_desc_offset_y = 55

career_banner.short_description = table.clone(UIFontSettings.body)

local career_banner_short_description = career_banner.short_description

career_banner_short_description.offset = {
	50,
	career_banner_title.offset[2] + short_desc_offset_y,
	2
}
career_banner_short_description.size = {
	career_banner.size[1] - 100
}
career_banner_short_description.text_horizontal_alignment = "center"
career_banner.description = table.clone(career_banner_short_description)

local career_banner_description = career_banner.description

career_banner_description.offset[2] = 155
career_banner_description.text_color[1] = 0
career_banner.show_details_button_hint = table.clone(UIFontSettings.button_legend_description)

local career_banner_show_details_button_hint = career_banner.show_details_button_hint

career_banner_show_details_button_hint.offset = {
	0,
	-5,
	5
}
career_banner_show_details_button_hint.text_horizontal_alignment = "center"
career_banner_show_details_button_hint.text_vertical_alignment = "bottom"
career_banner_show_details_button_hint.text_color[1] = 0
career_banner.hide_details_button_hint = table.clone(career_banner_show_details_button_hint)

local career_banner_hide_details_button_hint = career_banner.hide_details_button_hint

career_banner_hide_details_button_hint.offset[1] = 50
career_banner_hide_details_button_hint.text_horizontal_alignment = "left"
career_banner.description_button_hint = table.clone(career_banner_show_details_button_hint)

local career_banner_description_button_hint = career_banner.description_button_hint

career_banner_description_button_hint.offset[1] = -50
career_banner_description_button_hint.text_horizontal_alignment = "right"
career_banner.information_button_hint = table.clone(career_banner.description_button_hint)
career_banner.talents_list = {}

local talents_list = career_banner.talents_list

talents_list.size = {
	career_banner.size[1] - 100,
	450
}
talents_list.offset = {
	0,
	-40,
	1
}
talents_list.item_spacing = {
	size = {
		talents_list.size[1],
		30
	}
}
talents_list.list_padding = {
	size = {
		talents_list.size[1],
		talents_career_choice_view_styles.mask_margins[2]
	}
}
talents_career_choice_view_styles.career_banner_greyed_out = table.clone(career_banner)

local career_banner_greyed_out = talents_career_choice_view_styles.career_banner_greyed_out

career_banner_greyed_out.background.material_values.saturation = 0
career_banner_greyed_out.background.color = {
	255,
	64,
	64,
	64
}
career_banner_greyed_out.description.offset[2] = career_banner_short_description.offset[2]
career_banner_greyed_out.talents_list.size[2] = 0
talents_career_choice_view_styles.career_banner_focused = table.clone(career_banner)

local career_banner_focused = talents_career_choice_view_styles.career_banner_focused

career_banner_focused.title.text_color = Color.ui_terminal(255, true)
career_banner_focused.title.material = "content/ui/materials/base/ui_slug_hdr"
career_banner_focused.description.offset[2] = career_banner_short_description.offset[2]
career_banner_focused.show_details_button_hint.text_color[1] = 255
career_banner_focused.talents_list.size[2] = 0
talents_career_choice_view_styles.career_banner_show_talents = table.clone(career_banner)

local career_banner_show_talents = talents_career_choice_view_styles.career_banner_show_talents

career_banner_show_talents.show_talents = true
career_banner_show_talents.background_blurred.color[1] = 255
career_banner_show_talents.title.text_color = Color.ui_terminal(255, true)
career_banner_show_talents.title.material = "content/ui/materials/base/ui_slug_hdr"
career_banner_show_talents.title.offset[2] = 100
career_banner_show_talents.short_description.offset[2] = career_banner.description.offset[2]
career_banner_show_talents.hide_details_button_hint.text_color[1] = 255
career_banner_show_talents.description_button_hint.text_color[1] = 255
talents_career_choice_view_styles.career_banner_show_description = table.clone(career_banner)

local career_banner_show_description = talents_career_choice_view_styles.career_banner_show_description

career_banner_show_description.background_blurred.color[1] = 255
career_banner_show_description.title.text_color = Color.ui_terminal(255, true)
career_banner_show_description.title.material = "content/ui/materials/base/ui_slug_hdr"
career_banner_show_description.title.offset[2] = 100
career_banner_show_description.short_description.text_color[1] = 0
career_banner_show_description.short_description.offset[2] = career_banner.description.offset[2]
career_banner_show_description.description.text_color[1] = 255
career_banner_show_description.hide_details_button_hint.text_color[1] = 255
career_banner_show_description.information_button_hint.text_color[1] = 255
talents_career_choice_view_styles.list_entry_no_icon = {}

local list_entry_no_icon = talents_career_choice_view_styles.list_entry_no_icon

list_entry_no_icon.label = table.clone(UIFontSettings.header_3)
list_entry_no_icon.label.offset = {
	0,
	16,
	2
}
list_entry_no_icon.description = table.clone(UIFontSettings.body)
list_entry_no_icon.description.offset = {
	0,
	50,
	2
}
list_entry_no_icon.description.size = {
	career_banner.talents_list.size[1]
}
talents_career_choice_view_styles.list_entry_with_icon = table.clone(list_entry_no_icon)

local list_entry_with_icon = talents_career_choice_view_styles.list_entry_with_icon

list_entry_with_icon.label.offset[1] = 110
list_entry_with_icon.description.offset[1] = 110
list_entry_with_icon.description.size[1] = 395
list_entry_with_icon.icon = {
	size = {
		72,
		72
	},
	offset = {
		-3,
		19,
		2
	}
}
list_entry_with_icon.icon_frame = {
	size = {
		110,
		110
	},
	offset = {
		-22,
		0,
		3
	}
}
talents_career_choice_view_styles.vertical_divider = {}

local vertical_divider = talents_career_choice_view_styles.vertical_divider

vertical_divider.size = {
	42,
	career_banner.size[2]
}

return settings("AbilitiesCarrerChoiceViewStyles", talents_career_choice_view_styles)
