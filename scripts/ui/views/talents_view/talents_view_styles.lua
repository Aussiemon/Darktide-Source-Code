local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ColorUtilities = require("scripts/utilities/ui/colors")
local talents_view_styles = {}
local class_icon_size = 128
local large_icon_size = {
	176,
	154
}
local talent_icon_size = {
	110,
	110
}
local background_style = {
	specialization_background = {
		offset = {
			0,
			0,
			-50
		}
	},
	rect = {
		offset = {
			0,
			0,
			1
		},
		color = Color.black(128, true)
	},
	class_icon = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		size = {
			1080,
			1080
		},
		offset = {
			0,
			0,
			2
		},
		color = Color.white(16, true)
	}
}
talents_view_styles.background = background_style
talents_view_styles.archetype_header = {}
local archetype_header_style = talents_view_styles.archetype_header
archetype_header_style.text = table.clone(UIFontSettings.header_1)
local archetype_name_text_style = archetype_header_style.text
archetype_name_text_style.text_horizontal_alignment = "center"
talents_view_styles.details_panel = {}
local details_panel_style = talents_view_styles.details_panel
details_panel_style.background = {}
local details_panel_background_style = details_panel_style.background
details_panel_background_style.color = Color.terminal_frame(255, true)
details_panel_style.frame_upper = {}
local details_panel_frame_upper_style = details_panel_style.frame_upper
details_panel_frame_upper_style.horizontal_alignment = "center"
details_panel_frame_upper_style.vertical_alignment = "top"
details_panel_frame_upper_style.size = {
	454,
	36
}
details_panel_frame_upper_style.offset = {
	0,
	-8,
	3
}
details_panel_style.frame_lower = {}
local details_panel_frame_lower_style = details_panel_style.frame_lower
details_panel_frame_lower_style.horizontal_alignment = "center"
details_panel_frame_lower_style.vertical_alignment = "bottom"
details_panel_frame_lower_style.size = {
	454,
	36
}
details_panel_frame_lower_style.offset = {
	0,
	6,
	3
}
talents_view_styles.details = {}
local details_styles = talents_view_styles.details
details_styles.fade_time = 0.2
details_styles.talent_name = table.clone(UIFontSettings.terminal_header_3)
local details_talent_name_style = details_styles.talent_name
details_talent_name_style.text_horizontal_alignment = "center"
details_talent_name_style.offset = {
	0,
	43,
	2
}
details_styles.talent_icon = {}
local details_talent_icon_style = details_styles.talent_icon
details_talent_icon_style.visible = false
details_talent_icon_style.size = talent_icon_size
details_talent_icon_style.offset = {
	0,
	84,
	2
}
details_talent_icon_style.horizontal_alignment = "center"
details_talent_icon_style.material_values = {}
details_styles.large_icon = table.clone(details_talent_icon_style)
local details_large_icon_style = details_styles.large_icon
details_large_icon_style.size = large_icon_size
details_large_icon_style.material_values.frame_texture = "content/ui/textures/icons/talents/menu/frame_combat"
details_styles.talent_description = table.clone(UIFontSettings.body)
local details_talent_description_style = details_styles.talent_description
details_talent_description_style.normal_offset_y = 198
details_talent_description_style.large_icon_offset_y = 242
details_talent_description_style.offset = {
	34,
	details_talent_description_style.normal_offset_y,
	2
}
details_talent_description_style.size = {
	details_panel_frame_upper_style.size[1] - details_talent_description_style.offset[1] * 2
}
details_talent_description_style.text_color = Color.terminal_text_body(255, true)
talents_view_styles.equip_button = {}
local equip_button_styles = talents_view_styles.equip_button
equip_button_styles.text = table.clone(UIFontSettings.body)
local equip_button_text_style = equip_button_styles.text
equip_button_text_style.offset = {
	-16,
	0,
	1
}
equip_button_text_style.text_horizontal_alignment = "right"
equip_button_text_style.default_color = Color.terminal_text_body(255, true)
equip_button_text_style.hover_color = Color.terminal_text_header(255, true)
talents_view_styles.highlight_ring = {}
local highlight_ring_style = talents_view_styles.highlight_ring
highlight_ring_style.color = Color.terminal_corner_selected(255, true)
talents_view_styles.large_icon = {}
local large_icon_style = talents_view_styles.large_icon
large_icon_style.offset = {
	-33,
	-39,
	0
}
large_icon_style.size = large_icon_size
large_icon_style.hotspot = {
	on_pressed_sound = UISoundEvents.talents_choose_talent
}
large_icon_style.icon = {
	material_values = {
		frame_texture = "content/ui/textures/icons/talents/menu/frame_combat"
	}
}
large_icon_style.frame_hover = {
	size = {
		188,
		166
	},
	offset = {
		-6,
		-6,
		1
	},
	color = Color.terminal_corner_selected(255, true)
}
talents_view_styles.talent_icon = {}
local talent_icon_style = talents_view_styles.talent_icon
talent_icon_style.size = talent_icon_size
talent_icon_style.hotspot = {
	on_pressed_sound = UISoundEvents.talents_choose_talent
}
talent_icon_style.icon = {
	selected = "content/ui/textures/icons/talents/menu/frame_active",
	unselected = "content/ui/textures/icons/talents/menu/frame_inactive",
	material_values = {
		frame_texture = "content/ui/textures/icons/talents/menu/frame_inactive"
	},
	selected_color = Color.white(255, true),
	unselected_color = Color.ui_grey_light(255, true)
}
talents_view_styles.passive_talent_icon = {}
local passive_talent_icon_style = talents_view_styles.passive_talent_icon
passive_talent_icon_style.size = talent_icon_size
passive_talent_icon_style.hotspot = {}
passive_talent_icon_style.icon = {
	material_values = {
		frame_texture = "content/ui/textures/icons/talents/menu/frame_active"
	}
}
talents_view_styles.locked_talent_icon = {}
local locked_talent_icon_style = talents_view_styles.locked_talent_icon
locked_talent_icon_style.size = talent_icon_size
locked_talent_icon_style.icon = {
	offset = {
		0,
		0,
		1
	},
	material_values = {
		saturation = 0
	},
	color = table.clone(talent_icon_style.icon)
}
locked_talent_icon_style.frame = {
	offset = {
		0,
		0,
		3
	}
}
local talent_group_label = table.clone(UIFontSettings.header_3)
talent_group_label.text_horizontal_alignment = "center"
talent_group_label.text_vertical_alignment = "bottom"
talent_group_label.offset = {
	0,
	20,
	0
}
talent_group_label.color_locked = Color.ui_grey_light(255, true)
talent_group_label.color_default = Color.ui_blue_light(255, true)
talent_group_label.color_focused = Color.ui_terminal(255, true)
talent_group_label.text_color = table.clone(talent_group_label.color_default)
local talent_group_base = {
	group_name = talent_group_label
}
talents_view_styles.talent_group_main_specialization = table.clone(talent_group_base)
local talent_group_main_specialization = talents_view_styles.talent_group_main_specialization
talent_group_main_specialization.offset = {
	-33,
	-39,
	0
}
talent_group_main_specialization.group_name.offset = {
	0,
	28,
	0
}
talents_view_styles.talent_group_main_specialization = talent_group_main_specialization
talents_view_styles.talent_group_tactical_aura = table.clone(talent_group_base)
talents_view_styles.talent_group_passive = table.clone(talent_group_base)
local talent_group_passive = talents_view_styles.talent_group_passive
talent_group_passive.size = {
	440,
	110
}
talent_group_passive.offset = {
	-133,
	0,
	0
}
local talent_group_single_slot = table.clone(talent_group_base)
talent_group_single_slot.size = {
	220,
	165
}
talent_group_single_slot.offset = {
	-55,
	0,
	0
}
talents_view_styles.talent_group_single_slot = talent_group_single_slot
local talent_group_horizontal_row_2_slots = table.clone(talent_group_base)
talent_group_horizontal_row_2_slots.size = {
	220,
	165
}
talent_group_horizontal_row_2_slots.group_name.offset = {
	0,
	-25,
	0
}
talents_view_styles.talent_group_horizontal_row_2_slots = talent_group_horizontal_row_2_slots

return settings("TalentsViewStyles", talents_view_styles)
