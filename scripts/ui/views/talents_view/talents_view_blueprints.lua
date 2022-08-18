local ColorUtilities = require("scripts/utilities/ui/colors")
local ViewStyles = require("scripts/ui/views/talents_view/talents_view_styles")

local function icon_frame_focus_change_function(content, style, animation, dt)
	local hotspot_content = content.hotspot
	local focus_progress = math.max(hotspot_content.anim_hover_progress, hotspot_content.anim_focus_progress)
	local color = style.color or style.text_color
	color[1] = 255 * focus_progress
end

local function icon_frame_select_change_function(content, style, animation, dt)
	local hotspot_content = content.hotspot
	local select_progress = hotspot_content.anim_select_progress
	style.color[1] = 255 * select_progress
end

local function icon_frame_focus_and_selected_change_function(content, style, animation, dt)
	local hotspot_content = content.hotspot
	local alpha_multiplier = hotspot_content.anim_select_progress * math.max(hotspot_content.anim_hover_progress, hotspot_content.anim_focus_progress)
	local color = style.color or style.text_color
	color[1] = 255 * alpha_multiplier
end

local function icon_focus_change_function(content, style, animations, dt)
	local hotspot_content = content.hotspot
	local focus_progress = math.max(hotspot_content.anim_hover_progress, hotspot_content.anim_focus_progress)

	ColorUtilities.color_lerp(style.idle_color, style.focused_color, focus_progress, style.color)
end

local function icon_select_change_function(content, style, animation, dt)
	local hotspot_content = content.hotspot
	local select_progress = hotspot_content.anim_select_progress

	ColorUtilities.color_lerp(style.idle_color, style.selected_color, select_progress, style.color)
end

local function group_change_function(content, style, animation, dt)
	local color = style.color or style.text_color

	ColorUtilities.color_lerp(style.color_default, style.color_focused, content.hotspot.anim_focus_progress, color)
end

local blueprints = {
	talent_group_main_specialization = {
		size = {
			230,
			252
		},
		pass_template = {
			{
				style_id = "hotspot",
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				value_id = "talent_type",
				pass_type = "text",
				style_id = "talent_type",
				change_function = group_change_function
			},
			{
				style_id = "level",
				value_id = "level",
				pass_type = "text"
			}
		},
		style = ViewStyles.talent_group_main_specialization,
		offset = ViewStyles.talent_group_main_specialization.offset
	},
	talent_group_diagonal_left = {
		size = ViewStyles.talent_group_diagonal_left.size,
		pass_template = {
			{
				style_id = "hotspot",
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				value = "content/ui/materials/icons/abilities/frames/menu/group_diagonal_left",
				style_id = "outline",
				pass_type = "texture",
				change_function = group_change_function
			},
			{
				value_id = "talent_type",
				pass_type = "text",
				style_id = "talent_type",
				change_function = group_change_function
			},
			{
				style_id = "level",
				value_id = "level",
				pass_type = "text"
			}
		},
		style = ViewStyles.talent_group_diagonal_left
	},
	talent_group_diagonal_right = {
		size = ViewStyles.talent_group_diagonal_right.size,
		pass_template = {
			{
				style_id = "hotspot",
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				value = "content/ui/materials/icons/abilities/frames/menu/group_diagonal_left",
				style_id = "outline",
				pass_type = "texture_uv",
				change_function = group_change_function
			},
			{
				value_id = "talent_type",
				pass_type = "text",
				style_id = "talent_type",
				change_function = group_change_function
			},
			{
				style_id = "level",
				value_id = "level",
				pass_type = "text"
			}
		},
		style = ViewStyles.talent_group_diagonal_right
	},
	talent_group_horizontal_bend_left_down = {
		size = ViewStyles.talent_group_horizontal_bend_left_down.size,
		pass_template = {
			{
				style_id = "hotspot",
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				value = "content/ui/materials/icons/abilities/frames/menu/group_horizontal_bend_right_up",
				style_id = "outline",
				pass_type = "texture_uv",
				change_function = group_change_function
			},
			{
				value_id = "talent_type",
				pass_type = "text",
				style_id = "talent_type",
				change_function = group_change_function
			},
			{
				style_id = "level",
				value_id = "level",
				pass_type = "text"
			}
		},
		style = ViewStyles.talent_group_horizontal_bend_left_down,
		offset = ViewStyles.talent_group_horizontal_bend_left_down.offset
	},
	talent_group_horizontal_bend_left_up = {
		size = ViewStyles.talent_group_horizontal_bend_left_up.size,
		pass_template = {
			{
				style_id = "hotspot",
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				value = "content/ui/materials/icons/abilities/frames/menu/group_horizontal_bend_right_up",
				style_id = "outline",
				pass_type = "texture_uv",
				change_function = group_change_function
			},
			{
				value_id = "talent_type",
				pass_type = "text",
				style_id = "talent_type",
				change_function = group_change_function
			},
			{
				style_id = "level",
				value_id = "level",
				pass_type = "text"
			}
		},
		style = ViewStyles.talent_group_horizontal_bend_left_up
	},
	talent_group_horizontal_bend_right_down = {
		size = ViewStyles.talent_group_horizontal_bend_right_down.size,
		pass_template = {
			{
				style_id = "hotspot",
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				value = "content/ui/materials/icons/abilities/frames/menu/group_horizontal_bend_right_up",
				style_id = "outline",
				pass_type = "texture_uv",
				change_function = group_change_function
			},
			{
				value_id = "talent_type",
				pass_type = "text",
				style_id = "talent_type",
				change_function = group_change_function
			},
			{
				style_id = "level",
				value_id = "level",
				pass_type = "text"
			}
		},
		style = ViewStyles.talent_group_horizontal_bend_right_down
	},
	talent_group_horizontal_bend_right_up = {
		size = ViewStyles.talent_group_horizontal_bend_right_up.size,
		pass_template = {
			{
				style_id = "hotspot",
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				value = "content/ui/materials/icons/abilities/frames/menu/group_horizontal_bend_right_up",
				style_id = "outline",
				pass_type = "texture",
				change_function = group_change_function
			},
			{
				value_id = "talent_type",
				pass_type = "text",
				style_id = "talent_type",
				change_function = group_change_function
			},
			{
				style_id = "level",
				value_id = "level",
				pass_type = "text"
			}
		},
		style = ViewStyles.talent_group_horizontal_bend_right_up,
		offset = ViewStyles.talent_group_horizontal_bend_right_up.offset
	},
	talent_group_horizontal_row = {
		size = ViewStyles.talent_group_horizontal_row.size,
		pass_template = {
			{
				style_id = "hotspot",
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				value = "content/ui/materials/icons/abilities/frames/menu/group_horizontal_row",
				style_id = "outline",
				pass_type = "texture",
				change_function = group_change_function
			},
			{
				value_id = "talent_type",
				pass_type = "text",
				style_id = "talent_type",
				change_function = group_change_function
			},
			{
				style_id = "level",
				value_id = "level",
				pass_type = "text"
			}
		},
		style = ViewStyles.talent_group_horizontal_row
	},
	talent_group_triangle_up = {
		size = {
			220,
			260
		},
		pass_template = {
			{
				style_id = "hotspot",
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				value = "content/ui/materials/icons/abilities/frames/menu/group_triangle_up",
				style_id = "outline",
				pass_type = "texture",
				change_function = group_change_function
			},
			{
				value_id = "talent_type",
				pass_type = "text",
				style_id = "talent_type",
				change_function = group_change_function
			},
			{
				style_id = "level",
				value_id = "level",
				pass_type = "text"
			}
		},
		style = ViewStyles.talent_group_triangle_up,
		offset = ViewStyles.talent_group_triangle_up.offset
	},
	talent_group_triangle_down = {
		size = {
			220,
			260
		},
		pass_template = {
			{
				style_id = "hotspot",
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				value = "content/ui/materials/icons/abilities/frames/menu/group_triangle_up",
				style_id = "outline",
				pass_type = "texture_uv",
				change_function = group_change_function
			},
			{
				value_id = "talent_type",
				pass_type = "text",
				style_id = "talent_type",
				change_function = group_change_function
			},
			{
				style_id = "level",
				value_id = "level",
				pass_type = "text"
			}
		},
		style = ViewStyles.talent_group_triangle_down
	},
	talent_group_vertical_bend_left = {
		size = {
			220,
			290
		},
		pass_template = {
			{
				style_id = "hotspot",
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				value = "content/ui/materials/icons/abilities/frames/menu/group_vertical_bend_left",
				style_id = "outline",
				pass_type = "texture",
				change_function = group_change_function
			},
			{
				value_id = "talent_type",
				pass_type = "text",
				style_id = "talent_type",
				change_function = group_change_function
			},
			{
				style_id = "level",
				value_id = "level",
				pass_type = "text"
			}
		},
		style = ViewStyles.talent_group_vertical_bend_left,
		offset = ViewStyles.talent_group_vertical_bend_left.offset
	},
	talent_group_vertical_bend_right = {
		size = {
			220,
			290
		},
		pass_template = {
			{
				style_id = "hotspot",
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				value = "content/ui/materials/icons/abilities/frames/menu/group_vertical_bend_left",
				style_id = "outline",
				pass_type = "texture_uv",
				change_function = group_change_function
			},
			{
				value_id = "talent_type",
				pass_type = "text",
				style_id = "talent_type",
				change_function = group_change_function
			},
			{
				style_id = "level",
				value_id = "level",
				pass_type = "text"
			}
		},
		style = ViewStyles.talent_group_vertical_bend_right,
		offset = ViewStyles.talent_group_vertical_bend_right.offset
	},
	talent_group_single_slot = {
		size = ViewStyles.talent_group_single_slot.size,
		pass_template = {
			{
				style_id = "hotspot",
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				value_id = "talent_type",
				pass_type = "text",
				style_id = "talent_type",
				change_function = group_change_function
			},
			{
				style_id = "level",
				value_id = "level",
				pass_type = "text"
			}
		},
		style = ViewStyles.talent_group_single_slot,
		offset = ViewStyles.talent_group_single_slot.offset
	},
	talent_group_horizontal_row_2_slots = {
		size = ViewStyles.talent_group_horizontal_row_2_slots.size,
		pass_template = {
			{
				style_id = "hotspot",
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				value = "content/ui/materials/icons/abilities/frames/menu/group_horizontal_row_2_slots",
				style_id = "outline",
				pass_type = "texture",
				change_function = group_change_function
			},
			{
				value_id = "talent_type",
				pass_type = "text",
				style_id = "talent_type",
				change_function = group_change_function
			},
			{
				style_id = "level",
				value_id = "level",
				pass_type = "text"
			}
		},
		style = ViewStyles.talent_group_horizontal_row_2_slots
	},
	talent_group_diamond_4_slots = {
		size = ViewStyles.talent_group_diamond_4_slots.size,
		pass_template = {
			{
				style_id = "hotspot",
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				value = "content/ui/materials/icons/abilities/frames/menu/group_diamond_4_slots",
				style_id = "outline",
				pass_type = "texture",
				change_function = group_change_function
			},
			{
				value_id = "talent_type",
				pass_type = "text",
				style_id = "talent_type",
				change_function = group_change_function
			},
			{
				style_id = "level",
				value_id = "level",
				pass_type = "text"
			}
		},
		style = ViewStyles.talent_group_diamond_4_slots,
		offset = ViewStyles.talent_group_diamond_4_slots.offset
	},
	talent_icon_large = {
		size = ViewStyles.large_icon.size,
		pass_template = {
			{
				pass_type = "hotspot",
				style_id = "hotspot",
				content_id = "hotspot",
				content = {
					hover_type = "circle"
				}
			},
			{
				value = "content/ui/materials/icons/abilities/frames/menu/combat_large_background_idle",
				style_id = "background",
				pass_type = "texture"
			},
			{
				value = "content/ui/materials/icons/abilities/frames/menu/combat_large_background_hover",
				style_id = "background_hover",
				pass_type = "texture",
				change_function = icon_frame_focus_change_function
			},
			{
				value = "content/ui/materials/icons/abilities/frames/menu/combat_large_line_idle",
				style_id = "frame",
				pass_type = "texture"
			},
			{
				value = "content/ui/materials/icons/abilities/frames/menu/combat_large_line_hover",
				style_id = "frame_hover",
				pass_type = "texture",
				change_function = icon_frame_focus_change_function
			},
			{
				style_id = "talent_icon",
				value_id = "talent_icon",
				pass_type = "texture"
			}
		},
		offset = ViewStyles.large_icon.offset,
		style = ViewStyles.large_icon
	},
	talent_icon = {
		has_focus_ring = true,
		pass_template = {
			{
				pass_type = "hotspot",
				style_id = "hotspot",
				content_id = "hotspot",
				content = {
					hover_type = "circle",
					use_is_focused = true
				}
			},
			{
				value = "content/ui/materials/icons/abilities/frames/menu/generic_background_idle",
				style_id = "background",
				pass_type = "texture"
			},
			{
				value = "content/ui/materials/icons/abilities/frames/menu/generic_background_hover",
				style_id = "background_hover",
				pass_type = "texture",
				change_function = icon_frame_focus_change_function
			},
			{
				value = "content/ui/materials/icons/abilities/frames/menu/generic_inactive_line_idle",
				style_id = "frame",
				pass_type = "texture"
			},
			{
				value = "content/ui/materials/icons/abilities/frames/menu/generic_inactive_line_hover",
				style_id = "frame_hover",
				pass_type = "texture",
				change_function = icon_frame_focus_change_function
			},
			{
				value = "content/ui/materials/icons/abilities/frames/menu/generic_line_idle",
				style_id = "frame_selected",
				pass_type = "texture",
				change_function = icon_frame_select_change_function
			},
			{
				value = "content/ui/materials/icons/abilities/frames/menu/generic_line_hover",
				style_id = "frame_selected_hover",
				pass_type = "texture",
				change_function = icon_frame_focus_and_selected_change_function
			},
			{
				value_id = "talent_icon",
				pass_type = "texture",
				style_id = "talent_icon",
				change_function = icon_select_change_function
			}
		},
		style = ViewStyles.talent_icon
	},
	talent_icon_locked = {
		has_focus_ring = true,
		pass_template = {
			{
				pass_type = "hotspot",
				style_id = "hotspot",
				content_id = "hotspot",
				content = {
					hover_type = "circle"
				}
			},
			{
				value = "content/ui/materials/icons/abilities/frames/menu/locked_background_idle",
				style_id = "background",
				pass_type = "texture"
			},
			{
				value = "content/ui/materials/icons/abilities/frames/menu/locked_background_hover",
				style_id = "background_hover",
				pass_type = "texture",
				change_function = icon_frame_focus_change_function
			},
			{
				value = "content/ui/materials/icons/abilities/frames/menu/locked_line_idle",
				style_id = "frame",
				pass_type = "texture"
			},
			{
				value = "content/ui/materials/icons/abilities/frames/menu/locked_line_hover",
				style_id = "frame_hover",
				pass_type = "texture",
				change_function = icon_frame_focus_change_function
			},
			{
				value_id = "talent_icon",
				pass_type = "texture",
				style_id = "talent_icon",
				change_function = icon_focus_change_function
			}
		},
		style = ViewStyles.locked_talent_icon
	}
}

return settings("TalentsViewBlueprints", blueprints)
