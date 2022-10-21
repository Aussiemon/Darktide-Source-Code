local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local SocialMenuSettings = require("scripts/ui/views/social_menu_view/social_menu_view_settings")
local RosterViewStyles = require("scripts/ui/views/social_menu_roster_view/social_menu_roster_view_styles")
local ColorUtilities = require("scripts/utilities/ui/colors")
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
	},
	background = {}
}
local background_style = view_element_player_popup_style.background
background_style.color = {
	color = Color.black(160, true)
}
background_style.icon = {
	horizontal_alignment = "center",
	offset = {
		0,
		0,
		2
	},
	color = Color.ui_brown_light(70, true),
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
	color = Color.ui_terminal(0, true),
	offset = {
		0,
		0,
		0
	}
}
checkbox_button_style.highlight = {
	hdr = true,
	color = Color.ui_terminal(255, true),
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

return settings("ViewElementPlayerPopupStyle", view_element_player_popup_style)
