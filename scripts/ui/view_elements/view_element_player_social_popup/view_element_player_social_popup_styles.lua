-- chunkname: @scripts/ui/view_elements/view_element_player_social_popup/view_element_player_social_popup_styles.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local SocialMenuSettings = require("scripts/ui/views/social_menu_view/social_menu_view_settings")
local RosterViewStyles = require("scripts/ui/views/social_menu_roster_view/social_menu_roster_view_styles")
local ColorUtilities = require("scripts/utilities/ui/colors")
local DefaultPassStyles = require("scripts/ui/default_pass_styles")
local column_width = 480
local column_margin = {
	30,
	70
}
local portrait_size = {
	140,
	160
}
local view_element_player_popup_style = {
	extra_text_padding = 10,
	column_width = column_width,
	column_margin = column_margin,
	player_info_area_size = {
		column_width * 2 - (portrait_size[1] + column_margin[1] * 3),
		portrait_size[2]
	},
	player_info_header_size = {
		column_width - portrait_size[1] / 2,
		RosterViewStyles.panel_header_height
	},
	menu_item_spacing = {
		column_width,
		0
	},
	menu_padding = {
		column_width,
		ButtonPassTemplates.list_button_default_height
	}
}

view_element_player_popup_style.background = {}

local background_style = view_element_player_popup_style.background

background_style.icon = {
	horizontal_alignment = "center",
	offset = {
		0,
		0,
		2
	},
	color = Color.terminal_background(255, true),
	uvs = {
		{
			0,
			0
		},
		{
			1,
			0
		}
	},
	size = {
		1822,
		0
	},
	full_size = {
		1822,
		430
	}
}
background_style.terminal = {
	vertical_alignment = "center",
	scale_to_material = true,
	horizontal_alignment = "center",
	offset = {
		0,
		0,
		1
	},
	size_addition = {
		130,
		25
	},
	uvs = {
		{
			0,
			0
		},
		{
			1,
			1
		}
	},
	color = Color.terminal_grid_background(255, true)
}
background_style.top_border = {
	vertical_alignment = "top",
	size = {
		nil,
		10
	},
	offset = {
		0,
		-5,
		2
	}
}
background_style.top_border_decoration = {
	vertical_alignment = "top",
	horizontal_alignment = "center",
	offset = {
		0,
		-9,
		3
	},
	size = {
		140,
		18
	}
}
background_style.bottom_border = {
	vertical_alignment = "bottom",
	size = {
		nil,
		10
	},
	offset = {
		0,
		5,
		2
	}
}
background_style.bottom_border_decoration = {
	vertical_alignment = "bottom",
	horizontal_alignment = "center",
	offset = {
		0,
		33,
		3
	},
	size = {
		306,
		48
	}
}
view_element_player_popup_style.player_header = {}

local player_header_style = view_element_player_popup_style.player_header

player_header_style.player_display_name = table.clone(UIFontSettings.header_2)

local player_display_name_style = player_header_style.player_display_name

player_display_name_style.material = "content/ui/materials/font_gradients/slug_font_gradient_header"
player_display_name_style.text_color = Color.white(255, true)
player_display_name_style.offset = {
	0,
	-3,
	0
}
player_display_name_style.text_vertical_alignment = "center"
player_header_style.user_display_name = table.clone(UIFontSettings.header_3)

local user_display_name_style = player_header_style.user_display_name

user_display_name_style.offset = {
	0,
	45,
	0
}
user_display_name_style.text_vertical_alignment = "bottom"
player_header_style.user_fatshark_id = table.clone(UIFontSettings.header_3)

local user_fatshark_id_style = player_header_style.user_fatshark_id

user_fatshark_id_style.offset = {
	0,
	100,
	0
}
user_fatshark_id_style.text_vertical_alignment = "center"
player_header_style.user_activity = table.clone(UIFontSettings.body_small)

local user_activity_style = player_header_style.user_activity

user_activity_style.offset = {
	-150,
	170,
	0
}
user_activity_style.text_vertical_alignment = nil
player_header_style.divider = {
	vertical_alignment = "bottom",
	offset = {
		0,
		15,
		1
	},
	size = {
		nil,
		18
	}
}
player_header_style.portrait = {
	size = portrait_size,
	offset = {
		-150,
		0,
		1
	},
	material_values = {
		use_placeholder_texture = 1,
		rows = 1,
		columns = 1,
		grid_index = 1
	}
}
view_element_player_popup_style.blueprints = {}

local blueprint_styles = view_element_player_popup_style.blueprints

blueprint_styles.button = {}

local button_style = blueprint_styles.button

button_style.hotspot = {
	on_hover_sound = UISoundEvents.social_menu_popup_button_hovered,
	on_pressed_sound = UISoundEvents.social_menu_popup_button_pressed
}
blueprint_styles.disabled_button_with_explanation = {}

local disabled_button_with_explanation_style = blueprint_styles.disabled_button_with_explanation

disabled_button_with_explanation_style.hotspot = {
	on_hover_sound = UISoundEvents.social_menu_popup_button_hovered,
	on_pressed_sound = UISoundEvents.social_menu_popup_button_pressed
}
disabled_button_with_explanation_style.text = table.clone(UIFontSettings.list_button)
disabled_button_with_explanation_style.text.offset = {
	64,
	-12,
	2
}
disabled_button_with_explanation_style.second_row = table.clone(UIFontSettings.list_button_second_row)

local disabled_button_with_explanation_second_row_style = disabled_button_with_explanation_style.second_row

disabled_button_with_explanation_second_row_style.offset[1] = disabled_button_with_explanation_style.text.offset[1]
disabled_button_with_explanation_second_row_style.text_color = Color.ui_grey_medium(255, true)
disabled_button_with_explanation_style.icon = {
	offset = {
		0,
		0,
		3
	},
	size = {
		64,
		64
	}
}
blueprint_styles.search_header = {}

local search_header_style = blueprint_styles.search_header

search_header_style.size = {
	column_width,
	64
}
search_header_style.search_text = table.clone(UIFontSettings.body)
search_header_style.search_text.text_vertical_alignment = "center"

local search_header_text_style = search_header_style.search_text

search_header_text_style.offset = {
	0,
	0,
	1
}
blueprint_styles.choice_header = {}

local choice_header_style = blueprint_styles.choice_header

choice_header_style.size = {
	column_width,
	64
}
choice_header_style.text = table.clone(UIFontSettings.body)
blueprint_styles.choice_button = {}

local choice_button_style = blueprint_styles.choice_button

choice_button_style.text = table.clone(UIFontSettings.list_button)
choice_button_style.text.offset[1] = 64
choice_button_style.hotspot = {
	on_hover_sound = UISoundEvents.social_menu_popup_button_hovered,
	on_pressed_sound = UISoundEvents.social_menu_popup_button_pressed
}
choice_button_style.arrow_highlight = {
	visible = false
}
choice_button_style.icon = {
	vertical_alignment = "top",
	color = {
		255,
		200,
		200,
		200
	},
	default_color = {
		255,
		200,
		200,
		200
	},
	disabled_color = {
		255,
		128,
		128,
		128
	},
	hover_color = {
		255,
		255,
		255,
		255
	},
	offset = {
		0,
		0,
		1
	},
	size = {
		64,
		64
	}
}
blueprint_styles.checkbox_button = {}

local checkbox_button_style = blueprint_styles.checkbox_button

checkbox_button_style.hotspot = {
	anim_select_speed = 8,
	anim_hover_speed = 8,
	anim_input_speed = 8,
	anim_focus_speed = 8,
	on_hover_sound = UISoundEvents.social_menu_popup_button_hovered
}
checkbox_button_style.background_selected = {
	color = Color.terminal_corner_hover(0, true),
	offset = {
		0,
		0,
		0
	}
}
checkbox_button_style.highlight = {
	hdr = true,
	color = Color.terminal_corner_hover(255, true),
	offset = {
		0,
		0,
		3
	},
	size_addition = {
		0,
		0
	}
}
checkbox_button_style.text = table.clone(UIFontSettings.list_button)

local checkbox_button_text_style = checkbox_button_style.text

checkbox_button_text_style.offset[1] = 64
checkbox_button_style.checkbox_background = {
	color = {
		255,
		200,
		200,
		200
	},
	default_color = {
		255,
		200,
		200,
		200
	},
	disabled_color = {
		255,
		128,
		128,
		128
	},
	hover_color = {
		255,
		255,
		255,
		255
	},
	offset = {
		0,
		0,
		1
	},
	size = {
		64,
		64
	}
}
checkbox_button_style.check_mark = {
	color = {
		255,
		200,
		200,
		200
	},
	default_color = {
		255,
		200,
		200,
		200
	},
	disabled_color = {
		255,
		128,
		128,
		128
	},
	hover_color = {
		255,
		255,
		255,
		255
	},
	offset = {
		0,
		0,
		2
	},
	size = {
		64,
		64
	}
}
blueprint_styles.group_divider = {}

local group_divider_style = blueprint_styles.group_divider

group_divider_style.size = {
	column_width,
	18
}

local color_lerp = ColorUtilities.color_lerp

local function color_copy(source, target)
	target[1] = source[1]
	target[2] = source[2]
	target[3] = source[3]
	target[4] = source[4]
end

local white = Color.white(255, true)

view_element_player_popup_style.change_function = function (content, style)
	local hotspot_content = content.hotspot
	local default_color = white
	local color = style.color or style.text_color
	local highlight_color = style.highlight_color
	local interaction_color = style.interaction_color or highlight_color
	local hover_progress = math.max(hotspot_content.anim_hover_progress or 0, hotspot_content.anim_select_progress or 0)
	local input_progress = hotspot_content.anim_input_progress or 0

	if hover_progress == 1 then
		color = interaction_color
	end

	if hotspot_content.disabled then
		color_copy(style.disabled_color, color)
	else
		color_lerp(default_color, highlight_color, hover_progress, color)
		color_lerp(color, interaction_color, input_progress, color)
	end
end

local social_menu_roster_view_styles = {
	default_frame_material = "content/ui/textures/nameplates/portrait_frames/default",
	roster_grid_mask_expansion = 20,
	default_insignia_material = "content/ui/textures/nameplates/insignias/default",
	panel_header_height = 58,
	roster_panel_size = {
		1030,
		680
	},
	grid_margin = {
		20,
		20
	},
	grid_spacing = {
		30,
		20
	},
	player_panel_size = {
		480,
		80
	},
	portrait_size = {
		72,
		80
	},
	insignia_size = {
		32,
		80
	}
}

blueprint_styles.player_plaque = {}

local player_plaque_style = blueprint_styles.player_plaque

player_plaque_style.size = {
	480,
	80
}
player_plaque_style.hotspot = DefaultPassStyles.hotspot
player_plaque_style.background = {
	offset = {
		0,
		0,
		0
	},
	color = Color.terminal_corner(120, true),
	default_color = Color.terminal_corner(120, true),
	hover_color = Color.terminal_corner_hover(255, true)
}
player_plaque_style.portrait = {
	size = social_menu_roster_view_styles.portrait_size,
	offset = {
		0,
		0,
		1
	},
	material_values = {
		use_placeholder_texture = 1,
		rows = 1,
		columns = 1,
		grid_index = 1
	}
}
player_plaque_style.portrait_overlay = {
	size = social_menu_roster_view_styles.portrait_size,
	offset = {
		0,
		0,
		5
	},
	color = Color.terminal_corner_hover(255, true)
}
player_plaque_style.character_insignia = {
	horizontal_alignment = "left",
	size = social_menu_roster_view_styles.insignia_size,
	offset = {
		-40,
		0,
		1
	},
	material_values = {}
}
player_plaque_style.name_or_activity = table.clone(UIFontSettings.body)

local player_name_style = player_plaque_style.name_or_activity

player_name_style.default_color = Color.ui_grey_light(255, true)
player_name_style.not_in_party_color = Color.ui_grey_light(255, true)
player_name_style.party_member_color = Color.ui_brown_light(255, true)
player_name_style.own_player_color = Color.white(255, true)
player_name_style.own_player_material = "content/ui/materials/font_gradients/slug_font_gradient_header"
player_name_style.hover_color = Color.ui_brown_super_light(255, true)
player_name_style.font_size_default = player_name_style.font_size
player_name_style.font_size_small = UIFontSettings.body_small.font_size
player_name_style.offset = {
	85,
	14,
	1
}
player_plaque_style.search_status_text = table.clone(UIFontSettings.body)

local search_status_style = player_plaque_style.search_status_text

search_status_style.default_color = Color.ui_grey_light(255, true)
search_status_style.text_horizontal_alignment = "center"
search_status_style.text_vertical_alignment = "center"
search_status_style.font_size_default = player_name_style.font_size
player_plaque_style.account_name = table.clone(UIFontSettings.body_small)

local account_name_style = player_plaque_style.account_name

account_name_style.default_color_default = Color.ui_grey_medium(255, true)
account_name_style.default_color_large = Color.ui_grey_light(255, true)
account_name_style.hover_color = Color.ui_brown_super_light(255, true)
account_name_style.font_size_default = account_name_style.font_size
account_name_style.font_size_large = UIFontSettings.body.font_size
account_name_style.offset = {
	85,
	48,
	1
}
account_name_style.vertical_offset_default = 47
account_name_style.vertical_offset_large = 40
player_plaque_style.party_membership = table.clone(UIFontSettings.body)

local party_membership_style = player_plaque_style.party_membership

party_membership_style.default_color = Color.ui_grey_light(255, true)
party_membership_style.hover_color = Color.ui_brown_super_light(255, true)
party_membership_style.text_horizontal_alignment = "right"
party_membership_style.offset = {
	-16,
	14,
	1
}
player_plaque_style.highlight = {
	highlight_size_addition = 10,
	color = Color.terminal_corner_hover(0, true),
	size_addition = {
		0,
		0
	},
	offset = {
		0,
		0,
		3
	}
}

return settings("ViewElementPlayerPopupStyle", view_element_player_popup_style)
