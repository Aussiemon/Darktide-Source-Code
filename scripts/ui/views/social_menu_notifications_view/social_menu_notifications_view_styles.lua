local DefaultPassStyles = require("scripts/ui/default_pass_styles")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ColorUtilities = require("scripts/utilities/ui/colors")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ListHeaderPassTemplates = require("scripts/ui/pass_templates/list_header_templates")
local SocialMenuSettings = require("scripts/ui/views/social_menu_view/social_menu_view_settings")
local social_menu_notification_view_styles = {
	scenegraph = {}
}
local scenegraph_styles = social_menu_notification_view_styles.scenegraph
scenegraph_styles.grid_width = 1696
scenegraph_styles.grid_height = 526
scenegraph_styles.grid_mask_expansion = 18
scenegraph_styles.scrollbar_width = 10
scenegraph_styles.button_bar_height = ButtonPassTemplates.secondary_button_default_height
scenegraph_styles.button_bar_position = {
	0,
	48,
	1
}
scenegraph_styles.grid_position = {
	0,
	scenegraph_styles.button_bar_position[2] + scenegraph_styles.button_bar_height + 20,
	1
}
scenegraph_styles.scrollbar_position = {
	0,
	0,
	3
}
social_menu_notification_view_styles.button_bar = {}
local button_bar_styles = social_menu_notification_view_styles.button_bar
button_bar_styles.button_size = {
	230,
	scenegraph_styles.button_bar_height
}
social_menu_notification_view_styles.grid_spacing = {
	scenegraph_styles.grid_width,
	20
}
local notification_height = 100
social_menu_notification_view_styles.invitation_notification_size = {
	scenegraph_styles.grid_width,
	notification_height
}
social_menu_notification_view_styles.invitation_notification = {}
local invitation_notification_style = social_menu_notification_view_styles.invitation_notification
invitation_notification_style.background_selected = {
	color = Color.ui_terminal(0, true),
	offset = {
		0,
		0,
		0
	},
	size = {
		1150,
		notification_height
	}
}
invitation_notification_style.frame_highlight = {
	hdr = true,
	color = Color.ui_terminal(255, true),
	offset = {
		0,
		0,
		11
	},
	size_addition = {
		0,
		0
	},
	highlight_size_addition = ListHeaderPassTemplates.highlight_size_addition,
	size = {
		4,
		notification_height
	}
}
invitation_notification_style.new_notification_marker = {
	vertical_alignment = "center",
	hdr = true,
	horizontal_alignment = "left",
	size = {
		30,
		30
	},
	offset = {
		10,
		0,
		0
	},
	color = Color.ui_hud_red_light(255, true)
}
invitation_notification_style.new_notification_ring = {
	anim_time = 1,
	horizontal_alignment = "left",
	hdr = true,
	vertical_alignment = "center",
	pause_time = 1,
	size = {
		30,
		30
	},
	offset = {
		10,
		0,
		0
	},
	color = Color.ui_hud_red_light(255, true),
	size_addition = {
		0,
		0
	}
}
invitation_notification_style.label = table.clone(UIFontSettings.header_3)
local invitation_notification_label = invitation_notification_style.label
invitation_notification_label.offset = {
	50,
	-18,
	0
}
invitation_notification_label.text_vertical_alignment = "center"
invitation_notification_style.text = table.clone(UIFontSettings.body)
local invitation_notification_text = invitation_notification_style.text
invitation_notification_text.offset = {
	50,
	18,
	0
}
invitation_notification_text.text_vertical_alignment = "center"
invitation_notification_style.age = table.clone(UIFontSettings.body)
local invitation_notification_age = invitation_notification_style.age
invitation_notification_age.size = table.clone(invitation_notification_style.background_selected.size)
invitation_notification_age.offset = {
	0,
	-18,
	0
}
invitation_notification_age.text_horizontal_alignment = "right"
invitation_notification_age.text_vertical_alignment = "center"
invitation_notification_style.age_debug = table.clone(UIFontSettings.body)
local invitation_notification_age_debug = invitation_notification_style.age_debug
invitation_notification_age_debug.size = {
	500
}
invitation_notification_age_debug.offset = {
	0,
	-18,
	0
}
invitation_notification_age_debug.horizontal_alignment = "right"
invitation_notification_age_debug.text_horizontal_alignment = "left"
invitation_notification_age_debug.text_vertical_alignment = "center"
local join_button_base_style = {
	vertical_alignment = "center",
	horizontal_alignment = "right",
	size = {
		230,
		ButtonPassTemplates.secondary_button_default_height
	},
	offset = {
		-270,
		0,
		0
	}
}
invitation_notification_style.join_hotspot = table.clone(join_button_base_style)
invitation_notification_style.join_idle = table.clone(join_button_base_style)
local join_idle_style = invitation_notification_style.join_idle
join_idle_style.color = Color.ui_terminal(255, true)
invitation_notification_style.join_highlight = table.clone(join_button_base_style)
local join_highlight_style = invitation_notification_style.join_highlight
join_highlight_style.offset[3] = 3
join_highlight_style.default_offset = table.clone(join_highlight_style.offset)
join_highlight_style.size_addition = {
	0,
	0
}
join_highlight_style.highlight_size_addition = ListHeaderPassTemplates.highlight_size_addition
join_highlight_style.color = Color.ui_terminal(255, true)
join_highlight_style.hdr = true
invitation_notification_style.join_text = table.clone(UIFontSettings.button_primary)
local join_text_style = invitation_notification_style.join_text
join_text_style.size = join_button_base_style.size
join_text_style.offset[1] = join_text_style.offset[1] + join_button_base_style.offset[1]
join_text_style.offset[2] = join_text_style.offset[2] + join_button_base_style.offset[2]
join_text_style.horizontal_alignment = join_button_base_style.horizontal_alignment
join_text_style.vertical_alignment = join_button_base_style.vertical_alignment
local remove_button_base_style = {
	vertical_alignment = "center",
	horizontal_alignment = "right",
	size = {
		230,
		ButtonPassTemplates.secondary_button_default_height
	},
	offset = {
		-15,
		0,
		0
	}
}
invitation_notification_style.remove_hotspot = table.clone(remove_button_base_style)
invitation_notification_style.remove_highlight = table.clone(remove_button_base_style)
local remove_highlight_style = invitation_notification_style.remove_highlight
remove_highlight_style.offset[3] = 3
remove_highlight_style.default_offset = table.clone(remove_highlight_style.offset)
remove_highlight_style.size_addition = {
	0,
	0
}
remove_highlight_style.highlight_size_addition = ListHeaderPassTemplates.highlight_size_addition
remove_highlight_style.color = Color.ui_terminal(255, true)
remove_highlight_style.hdr = true
invitation_notification_style.remove_text = table.clone(UIFontSettings.button_primary)
local remove_text_style = invitation_notification_style.remove_text
remove_text_style.size = remove_button_base_style.size
remove_text_style.offset[1] = remove_text_style.offset[1] + remove_button_base_style.offset[1]
remove_text_style.offset[2] = remove_text_style.offset[2] + remove_button_base_style.offset[2]
remove_text_style.horizontal_alignment = remove_button_base_style.horizontal_alignment
remove_text_style.vertical_alignment = remove_button_base_style.vertical_alignment

return settings("SocialMenuNotificationViewStyles", social_menu_notification_view_styles)
