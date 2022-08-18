local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ColorUtilities = require("scripts/utilities/ui/colors")
local talents_view_styles = {}
local class_icon_size = 128
local large_icon_size = {
	220,
	192
}
local large_icon_inner_size = {
	190,
	166
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
local class_header = {
	class_icon = {
		offset = {
			-class_icon_size,
			0,
			1
		},
		size = {
			class_icon_size,
			class_icon_size
		},
		color = Color.ui_brown_light(255, true)
	}
}
local class_name = table.clone(UIFontSettings.body)
class_name.text_vertical_alignment = "center"
class_name.offset = {
	0,
	-20,
	1
}
class_header.class_name = class_name
local specialization_name = table.clone(UIFontSettings.header_2)
specialization_name.text_vertical_alignment = "center"
specialization_name.offset = {
	0,
	10,
	1
}
class_header.specialization_name = specialization_name
class_header.divider = {
	vertical_alignment = "bottom",
	offset = {
		0,
		-5,
		1
	},
	size = {
		300,
		18
	}
}
class_header.text = table.clone(UIFontSettings.body)
class_header.text.visible = false
talents_view_styles.class_header = class_header
local category_header = table.clone(UIFontSettings.header_3)
category_header.text_horizontal_alignment = "center"
talents_view_styles.category_header = category_header
local details_talent_name = table.clone(UIFontSettings.header_3)
details_talent_name.size = {
	nil,
	22
}
local details_talent_description = table.clone(UIFontSettings.body)
details_talent_description.offset = {
	2,
	31,
	2
}
talents_view_styles.details = {
	fade_time = 0.2,
	talent_name = details_talent_name,
	talent_description = details_talent_description
}
local large_icon = {
	hotspot = {
		on_pressed_sound = UISoundEvents.talents_choose_talent
	},
	offset = {
		-55,
		-41,
		0
	},
	size = large_icon_size,
	frame = {
		hdr = true,
		offset = {
			0,
			0,
			2
		},
		size = large_icon_size,
		color = Color.ui_terminal(255, true)
	},
	frame_hover = table.clone(large_icon.frame),
	talent_icon = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		offset = {
			0,
			0,
			3
		},
		size = large_icon_inner_size
	},
	talent_name = table.clone(UIFontSettings.header_3),
	talent_description = table.clone(UIFontSettings.body)
}
talents_view_styles.large_icon = large_icon
talents_view_styles.highlight_ring = {
	hdr = true,
	color = Color.ui_terminal(255, true)
}
local talent_icon = {
	size = talent_icon_size,
	hotspot = {
		on_pressed_sound = UISoundEvents.talents_choose_talent
	},
	background = {
		offset = {
			0,
			0,
			0
		},
		color = Color.ui_blue_light(255, true)
	},
	background_hover = {
		offset = {
			0,
			0,
			1
		},
		color = Color.ui_blue_light(255, true)
	},
	frame = {
		offset = {
			0,
			0,
			3
		},
		color = Color.ui_blue_light(255, true)
	},
	frame_selected = table.clone(talent_icon.frame)
}
talent_icon.frame_selected.offset[3] = 4
talent_icon.frame_selected.color = Color.ui_terminal(255, true)
talent_icon.frame_selected.hdr = true
talent_icon.frame_hover = table.clone(talent_icon.frame)
talent_icon.frame_hover.offset[3] = 5
talent_icon.frame_hover.hdr = true
talent_icon.frame_selected_hover = table.clone(talent_icon.frame_selected)
talent_icon.frame_selected_hover.offset[3] = 6
talent_icon.talent_icon = {
	vertical_alignment = "center",
	horizontal_alignment = "center",
	offset = {
		0,
		0,
		2
	},
	size = {
		90,
		90
	},
	idle_color = Color.ui_grey_light(255, true),
	selected_color = Color.white(255, true)
}
talents_view_styles.talent_icon = talent_icon
local locked_talent_icon = {
	size = talent_icon_size,
	background = {
		offset = {
			0,
			0,
			0
		},
		color = Color.ui_grey_light(255, true)
	},
	background_hover = {
		offset = {
			0,
			0,
			1
		},
		color = Color.ui_grey_light(255, true)
	},
	frame = {
		offset = {
			0,
			0,
			3
		},
		color = Color.ui_grey_light(255, true)
	},
	frame_hover = table.clone(locked_talent_icon.frame)
}
locked_talent_icon.frame_hover.offset[3] = 4
locked_talent_icon.frame_hover.hdr = true
locked_talent_icon.talent_icon = {
	vertical_alignment = "center",
	horizontal_alignment = "center",
	offset = {
		0,
		0,
		2
	},
	size = {
		80,
		80
	},
	idle_color = Color.ui_grey_medium(255, true),
	focused_color = Color.ui_grey_light(255, true)
}
locked_talent_icon.talent_name = table.clone(UIFontSettings.header_3)
locked_talent_icon.talent_description = table.clone(UIFontSettings.body)
locked_talent_icon.focus_frame = talent_icon.frame_selected_hover
talents_view_styles.locked_talent_icon = locked_talent_icon
local talent_group_label = table.clone(UIFontSettings.header_3)
talent_group_label.text_horizontal_alignment = "center"
talent_group_label.text_vertical_alignment = "bottom"
talent_group_label.offset = {
	0,
	-20,
	0
}
talent_group_label.color_locked = Color.ui_grey_light(255, true)
talent_group_label.color_default = Color.ui_blue_light(255, true)
talent_group_label.color_focused = Color.ui_terminal(255, true)
talent_group_label.text_color = table.clone(talent_group_label.color_default)
local talent_group_level_label = table.clone(UIFontSettings.body_small)
talent_group_level_label.text_horizontal_alignment = "center"
talent_group_level_label.text_vertical_alignment = "bottom"
local talent_group_base = {
	outline = {
		color_locked = Color.ui_grey_light(128, true),
		color_default = Color.ui_grey_light(0, true),
		color_focused = Color.ui_blue_light(128, true)
	},
	talent_type = talent_group_label,
	level = talent_group_level_label
}
local talent_group_main_specialization = table.clone(talent_group_base)
talent_group_main_specialization.offset = {
	-60,
	-96,
	0
}
talent_group_main_specialization.talent_type.text_vertical_alignment = "top"
talent_group_main_specialization.talent_type.offset = {
	0,
	0,
	0
}
talent_group_main_specialization.level.text_vertical_alignment = "top"
talent_group_main_specialization.level.offset = {
	0,
	20,
	0
}
talents_view_styles.talent_group_main_specialization = talent_group_main_specialization
local talent_group_diagonal_left = table.clone(talent_group_base)
talent_group_diagonal_left.size = {
	220,
	300
}
talent_group_diagonal_left.talent_type.offset = {
	110,
	30,
	0
}
talent_group_diagonal_left.talent_type.text_vertical_alignment = "top"
talent_group_diagonal_left.talent_type.text_horizontal_alignment = "left"
talent_group_diagonal_left.level.offset = {
	110,
	50,
	0
}
talent_group_diagonal_left.level.text_vertical_alignment = "top"
talent_group_diagonal_left.level.text_horizontal_alignment = "left"
talents_view_styles.talent_group_diagonal_left = talent_group_diagonal_left
local talent_group_diagonal_right = table.clone(talent_group_base)
talent_group_diagonal_right.size = {
	220,
	300
}
talent_group_diagonal_right.outline.uvs = {
	{
		1,
		0
	},
	{
		0,
		1
	}
}
talent_group_diagonal_right.talent_type.offset = {
	-110,
	30,
	0
}
talent_group_diagonal_right.talent_type.text_vertical_alignment = "top"
talent_group_diagonal_right.talent_type.text_horizontal_alignment = "right"
talent_group_diagonal_right.level.offset = {
	-110,
	50,
	0
}
talent_group_diagonal_right.level.text_vertical_alignment = "top"
talent_group_diagonal_right.level.text_horizontal_alignment = "right"
talents_view_styles.talent_group_diagonal_right = talent_group_diagonal_right
local talent_group_horizontal_row = table.clone(talent_group_base)
talent_group_horizontal_row.size = {
	330,
	165
}
talent_group_horizontal_row.outline.size = {
	330,
	110
}
talent_group_horizontal_row.talent_type.offset = {
	0,
	-25,
	0
}
talents_view_styles.talent_group_horizontal_row = talent_group_horizontal_row
local talent_group_horizontal_bend_left_down = table.clone(talent_group_base)
talent_group_horizontal_bend_left_down.size = {
	275,
	205
}
talent_group_horizontal_bend_left_down.offset = {
	-55,
	0,
	0
}
talent_group_horizontal_bend_left_down.outline.uvs = {
	{
		1,
		1
	},
	{
		0,
		0
	}
}
talent_group_horizontal_bend_left_down.talent_type.offset = {
	130,
	-55,
	0
}
talent_group_horizontal_bend_left_down.talent_type.text_horizontal_alignment = "left"
talent_group_horizontal_bend_left_down.level.offset = {
	130,
	-30,
	0
}
talent_group_horizontal_bend_left_down.level.text_horizontal_alignment = "left"
talents_view_styles.talent_group_horizontal_bend_left_down = talent_group_horizontal_bend_left_down
local talent_group_horizontal_bend_left_up = table.clone(talent_group_base)
talent_group_horizontal_bend_left_up.size = {
	275,
	205
}
talent_group_horizontal_bend_left_up.outline.uvs = {
	{
		1,
		0
	},
	{
		0,
		1
	}
}
talent_group_horizontal_bend_left_up.talent_type.offset = {
	130,
	30,
	0
}
talent_group_horizontal_bend_left_up.talent_type.text_vertical_alignment = "top"
talent_group_horizontal_bend_left_up.talent_type.text_horizontal_alignment = "left"
talent_group_horizontal_bend_left_up.level.offset = {
	130,
	50,
	0
}
talent_group_horizontal_bend_left_up.level.text_vertical_alignment = "top"
talent_group_horizontal_bend_left_up.level.text_horizontal_alignment = "left"
talents_view_styles.talent_group_horizontal_bend_left_up = talent_group_horizontal_bend_left_up
local talent_group_horizontal_bend_right_down = table.clone(talent_group_base)
talent_group_horizontal_bend_right_down.size = {
	275,
	205
}
talent_group_horizontal_bend_right_down.outline.uvs = {
	{
		0,
		1
	},
	{
		1,
		0
	}
}
talent_group_horizontal_bend_right_down.talent_type.offset = {
	-130,
	-55,
	0
}
talent_group_horizontal_bend_right_down.talent_type.text_horizontal_alignment = "right"
talent_group_horizontal_bend_right_down.level.offset = {
	-130,
	-30,
	0
}
talent_group_horizontal_bend_right_down.level.text_horizontal_alignment = "right"
talents_view_styles.talent_group_horizontal_bend_right_down = talent_group_horizontal_bend_right_down
local talent_group_horizontal_bend_right_up = table.clone(talent_group_base)
talent_group_horizontal_bend_right_up.offset = {
	55,
	0,
	0
}
talent_group_horizontal_bend_right_up.size = {
	275,
	205
}
talent_group_horizontal_bend_right_up.talent_type.offset = {
	-130,
	30,
	0
}
talent_group_horizontal_bend_right_up.talent_type.text_vertical_alignment = "top"
talent_group_horizontal_bend_right_up.talent_type.text_horizontal_alignment = "right"
talent_group_horizontal_bend_right_up.level.offset = {
	-130,
	50,
	0
}
talent_group_horizontal_bend_right_up.level.text_vertical_alignment = "top"
talent_group_horizontal_bend_right_up.level.text_horizontal_alignment = "right"
talents_view_styles.talent_group_horizontal_bend_right_up = talent_group_horizontal_bend_right_up
local talent_group_triangle_up = table.clone(talent_group_base)
talent_group_triangle_up.offset = {
	-55,
	0,
	0
}
talent_group_triangle_up.outline.size = {
	220,
	205
}
talents_view_styles.talent_group_triangle_up = talent_group_triangle_up
local talent_group_triangle_down = table.clone(talent_group_base)
talent_group_triangle_down.outline.uvs = {
	{
		0,
		1
	},
	{
		1,
		0
	}
}
talent_group_triangle_down.outline.size = {
	220,
	205
}
talents_view_styles.talent_group_triangle_down = talent_group_triangle_down
local talent_group_vertical_bend_left = table.clone(talent_group_base)
talent_group_vertical_bend_left.offset = {
	-55,
	0,
	0
}
talent_group_vertical_bend_left.outline.size = {
	165,
	300
}
talent_group_vertical_bend_left.talent_type.offset = {
	130,
	-10,
	0
}
talent_group_vertical_bend_left.talent_type.text_horizontal_alignment = "left"
talent_group_vertical_bend_left.talent_type.text_vertical_alignment = "center"
talent_group_vertical_bend_left.level.offset = {
	130,
	15,
	0
}
talent_group_vertical_bend_left.level.text_horizontal_alignment = "left"
talent_group_vertical_bend_left.level.text_vertical_alignment = "center"
talents_view_styles.talent_group_vertical_bend_left = talent_group_vertical_bend_left
local talent_group_vertical_bend_right = table.clone(talent_group_base)
talent_group_vertical_bend_right.offset = {
	-55,
	0,
	0
}
talent_group_vertical_bend_right.outline.offset = {
	55,
	0,
	0
}
talent_group_vertical_bend_right.outline.size = {
	165,
	300
}
talent_group_vertical_bend_right.outline.uvs = {
	{
		1,
		0
	},
	{
		0,
		1
	}
}
talent_group_vertical_bend_right.talent_type.offset = {
	-130,
	-10,
	0
}
talent_group_vertical_bend_right.talent_type.text_horizontal_alignment = "right"
talent_group_vertical_bend_right.talent_type.text_vertical_alignment = "center"
talent_group_vertical_bend_right.level.offset = {
	-130,
	15,
	0
}
talent_group_vertical_bend_right.level.text_horizontal_alignment = "right"
talent_group_vertical_bend_right.level.text_vertical_alignment = "center"
talents_view_styles.talent_group_vertical_bend_right = talent_group_vertical_bend_right
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
talent_group_single_slot.outline.offset = {
	55,
	0,
	0
}
talent_group_single_slot.outline.size = {
	110,
	110
}
talents_view_styles.talent_group_single_slot = talent_group_single_slot
local talent_group_horizontal_row_2_slots = table.clone(talent_group_base)
talent_group_horizontal_row_2_slots.size = {
	220,
	165
}
talent_group_horizontal_row_2_slots.outline.size = {
	220,
	110
}
talent_group_horizontal_row_2_slots.talent_type.offset = {
	0,
	-25,
	0
}
talents_view_styles.talent_group_horizontal_row_2_slots = talent_group_horizontal_row_2_slots
local talent_group_diamond_4_slots = table.clone(talent_group_base)
talent_group_diamond_4_slots.size = {
	220,
	355
}
talent_group_diamond_4_slots.offset = {
	-55,
	0,
	0
}
talent_group_diamond_4_slots.outline.size = {
	220,
	300
}
talents_view_styles.talent_group_diamond_4_slots = talent_group_diamond_4_slots

return settings("TalentsViewStyles", talents_view_styles)
