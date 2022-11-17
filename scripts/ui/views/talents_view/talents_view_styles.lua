local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ColorUtilities = require("scripts/utilities/ui/colors")
local talents_view_styles = {}
local large_icon_size = {
	176,
	154
}
local talent_icon_size = {
	110,
	110
}
talents_view_styles.archetype_header = {}
local archetype_header_style = talents_view_styles.archetype_header
archetype_header_style.text = table.clone(UIFontSettings.header_1)
local archetype_name_text_style = archetype_header_style.text
archetype_name_text_style.text_horizontal_alignment = "center"
talents_view_styles.main_panel = {}
local main_panel_style = talents_view_styles.main_panel
main_panel_style.main = {}
local main_panel_main_style = main_panel_style.main
main_panel_main_style.offset = {
	0,
	0,
	5
}
main_panel_style.level_bar_fill = {}
local main_panel_level_bar_fill_style = main_panel_style.level_bar_fill
main_panel_level_bar_fill_style.size = {
	1169,
	28
}
main_panel_level_bar_fill_style.offset = {
	50,
	616
}
main_panel_level_bar_fill_style.scale_to_material = true
main_panel_level_bar_fill_style.material_values = {
	progression = 0
}
main_panel_level_bar_fill_style.plate_big_width = 69
main_panel_level_bar_fill_style.plate_small_width = 38
main_panel_level_bar_fill_style.distance_between_big_plates = 220
local details_panel_margin = 34
talents_view_styles.details_panel = {}
local details_panel_style = talents_view_styles.details_panel
details_panel_style.size = {
	462,
	607
}
details_panel_style.background = {}
local details_panel_background_style = details_panel_style.background
details_panel_background_style.color = Color.terminal_grid_background(255, true)
details_panel_background_style.scale_to_material = true
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
	details_panel_margin,
	43,
	2
}
details_talent_name_style.size = {
	details_panel_style.size[1] - details_panel_margin * 2,
	30
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
details_talent_icon_style.offset_to_text_above = 11
details_talent_icon_style.horizontal_alignment = "center"
details_talent_icon_style.material_values = {}
details_styles.talent_icon_frame = {}
local details_talent_icon_frame_style = details_styles.talent_icon_frame
details_talent_icon_frame_style.visible = false
details_talent_icon_frame_style.size = {
	104,
	80
}
details_talent_icon_frame_style.offset = {
	0,
	100,
	3
}
details_talent_icon_frame_style.offset_to_text_above = 26
details_talent_icon_frame_style.horizontal_alignment = "center"
details_talent_icon_frame_style.color = Color.terminal_frame(255, true)
details_styles.large_icon = table.clone(details_talent_icon_style)
local details_large_icon_style = details_styles.large_icon
details_large_icon_style.size = large_icon_size
details_styles.large_icon_frame = table.clone(details_talent_icon_frame_style)
local details_large_icon_frame_style = details_styles.large_icon_frame
details_large_icon_frame_style.size = {
	256,
	135
}
details_large_icon_frame_style.offset_to_text_above = 20
details_styles.talent_description = table.clone(UIFontSettings.body)
local details_talent_description_style = details_styles.talent_description
details_talent_description_style.offset_to_icon_above = 8
details_talent_description_style.offset = {
	details_panel_margin,
	details_talent_description_style.normal_offset_y,
	2
}
details_talent_description_style.size = {
	details_talent_name_style.size[1]
}
details_talent_description_style.text_color = Color.terminal_text_body(255, true)
talents_view_styles.equip_button = {}
local equip_button_styles = talents_view_styles.equip_button
equip_button_styles.equip_sound = UISoundEvents.talents_equip_talent
equip_button_styles.unequip_sound = UISoundEvents.talents_unequip_talent
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
highlight_ring_style.size_addition = {
	20,
	20
}
highlight_ring_style.offset = {
	-10,
	-10,
	10
}
highlight_ring_style.color = Color.terminal_corner_selected(255, true)
talents_view_styles.large_icon = {}
local large_icon_style = talents_view_styles.large_icon
large_icon_style.offset = {
	-33,
	-34,
	0
}
large_icon_style.size = large_icon_size
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
talent_icon_style.equip_sound = UISoundEvents.talents_equip_talent
talent_icon_style.unequip_sound = UISoundEvents.talents_unequip_talent
talent_icon_style.icon = {
	selected = "content/ui/textures/icons/talents/menu/frame_active",
	pulse_time = 1.5,
	unselected = "content/ui/textures/icons/talents/menu/frame_inactive",
	selected_hover_intensity = 0.25,
	material_values = {
		intensity = 0,
		frame_texture = "content/ui/textures/icons/talents/menu/frame_inactive"
	},
	selected_color = Color.white(255, true),
	hover_color = Color.terminal_corner_hover(255, true),
	unselected_color = {
		255,
		98,
		103,
		77
	}
}
talents_view_styles.passive_talent_icon = {}
local passive_talent_icon_style = talents_view_styles.passive_talent_icon
passive_talent_icon_style.size = talent_icon_size
passive_talent_icon_style.hotspot = {}
passive_talent_icon_style.icon = {
	selected = "content/ui/textures/icons/talents/menu/frame_active",
	selected_hover_intensity = 0.25,
	material_values = {},
	selected_color = Color.white(255, true)
}
talents_view_styles.locked_talent_icon = {}
local locked_talent_icon_style = talents_view_styles.locked_talent_icon
locked_talent_icon_style.size = talent_icon_size
locked_talent_icon_style.icon = {
	selected_hover_intensity = 0.25,
	offset = {
		0,
		0,
		1
	},
	material_values = {
		saturation = 0
	},
	unselected_color = {
		255,
		102,
		82,
		72
	},
	hover_color = {
		255,
		142,
		92,
		84
	}
}
locked_talent_icon_style.frame = {
	offset = {
		0,
		0,
		3
	}
}
local talent_group_label = table.clone(UIFontSettings.body_small)
talent_group_label.horizontal_alignment = "center"
talent_group_label.vertical_alignment = "bottom"
talent_group_label.offset = {
	0,
	12,
	0
}
talent_group_label.size = {
	200,
	20
}
talent_group_label.text_horizontal_alignment = "center"
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
	34,
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
talents_view_styles.talent_group_tier = table.clone(talent_group_base)
local talent_group_tier_style = talents_view_styles.talent_group_tier
talent_group_tier_style.size = {
	152,
	400
}
talent_group_tier_style.offset = {
	-21,
	-59,
	-15
}
talent_group_tier_style.level = table.clone(UIFontSettings.talent_group_level)
local tier_group_level_style = talent_group_tier_style.level
tier_group_level_style.vertical_alignment = "bottom"
tier_group_level_style.size = {
	nil,
	22
}
tier_group_level_style.offset = {
	0,
	34,
	15
}
talent_group_tier_style.level_bar_fill = {}
local locked_tier_group_level_bar_fill_style = talent_group_tier_style.level_bar_fill
locked_tier_group_level_bar_fill_style.size = {
	80,
	46
}
locked_tier_group_level_bar_fill_style.offset = {
	36,
	47,
	10
}
locked_tier_group_level_bar_fill_style.vertical_alignment = "bottom"
talent_group_tier_style.window_new = {}
talent_tier_group_window_new_style = talent_group_tier_style.window_new
talent_tier_group_window_new_style.offset = {
	0,
	0,
	1
}
talent_tier_group_window_new_style.alpha = 255
talent_group_tier_style.new = table.clone(UIFontSettings.talent_group_level)
local talent_tier_group_new_style = talent_group_tier_style.new
talent_tier_group_new_style.vertical_alignment = "bottom"
talent_tier_group_new_style.size = {
	nil,
	22
}
talent_tier_group_new_style.offset = {
	0,
	92,
	15
}
talent_tier_group_new_style.alpha = 255
talent_group_tier_style.new_background = {}
local tier_group_new_background_style = talent_group_tier_style.new_background
tier_group_new_background_style.size = {
	130,
	96
}
tier_group_new_background_style.vertical_alignment = "bottom"
tier_group_new_background_style.horizontal_alignment = "center"
tier_group_new_background_style.offset = {
	0,
	128,
	14
}
tier_group_new_background_style.color = Color.terminal_text_body(nil, true)
tier_group_new_background_style.alpha = 100
tier_group_new_background_style.scale_to_material = true
talent_group_tier_style.new_effect = table.clone(tier_group_new_background_style)
local talent_tier_group_new_effect_style = talent_group_tier_style.new_effect
talent_tier_group_new_effect_style.size = {
	200,
	200
}
talent_tier_group_new_effect_style.offset = {
	0,
	123,
	12
}
talent_tier_group_new_effect_style.alpha = 255
talents_view_styles.talent_group_tier_locked = table.clone(talent_group_tier_style)
local locked_tier_group_style = talents_view_styles.talent_group_tier_locked
local locked_tier_group_level_style = locked_tier_group_style.level
locked_tier_group_level_style.text_color = tier_group_level_style.locked_color
locked_tier_group_style.level_bar_lock = {}
local locked_tier_group_level_bar_lock_style = locked_tier_group_style.level_bar_lock
locked_tier_group_level_bar_lock_style.size = {
	40,
	56
}
locked_tier_group_level_bar_lock_style.offset = {
	0,
	90,
	15
}
locked_tier_group_level_bar_lock_style.horizontal_alignment = "center"
locked_tier_group_level_bar_lock_style.vertical_alignment = "bottom"

return settings("TalentsViewStyles", talents_view_styles)
