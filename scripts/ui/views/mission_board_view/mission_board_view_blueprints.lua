local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local ViewSettings = require("scripts/ui/views/mission_board_view/mission_board_view_settings")
local ViewStyles = require("scripts/ui/views/mission_board_view/mission_board_view_styles")
local blueprint_styles = ViewStyles.blueprints
local mission_board_blueprints = {}
local _fallback_difficulty_materials = {
	resistance = {},
	challenge = {}
}

local function _init_function(widget, mission_data, zone_data, column, row, on_select_callback, right_pressed_callback)
	local style = widget.style
	local difficulty_materials = style.difficulty_materials or _fallback_difficulty_materials
	local resistance = mission_data.resistance
	local challenge = mission_data.challenge
	local mission_xp = mission_data.mission_xp
	local mission_reward = mission_data.mission_reward
	local circumstance_id = mission_data.circumstance
	local circumstance = CircumstanceTemplates[circumstance_id]
	local circumstance_ui = circumstance and circumstance.ui
	local circumstance_icon = (circumstance_ui and circumstance_ui.mission_board_icon) or "content/ui/materials/mission_board/badges/addons/circumstance_rain"
	local node_name_format = ViewSettings.node_name_format
	widget.visible = false
	local widget_content = widget.content
	widget_content.alpha_multiplier = 0
	widget_content.zone_line_progress = 0
	widget_content.node_name = string.format(node_name_format, column, row)
	widget_content.order_nr = (row - 1) * ViewSettings.grid_size[1] + column
	widget_content.column = column
	widget_content.row = row
	widget_content.mission_data = mission_data
	widget_content.zone_data = zone_data
	widget_content.timer = mission_data.timer or 1
	widget_content.mission_xp = mission_xp
	widget_content.tag_xp = string.format(ViewSettings.xp_format, mission_xp)
	widget_content.mission_reward = mission_reward
	widget_content.tag_reward = string.format(ViewSettings.reward_format, mission_reward)
	widget_content.resistance = difficulty_materials.resistance[resistance]
	widget_content.challenge = difficulty_materials.challenge[challenge]
	widget_content.circumstance_id = circumstance_id
	widget_content.circumstance_icon = circumstance_icon
	widget_content.anchor_point_offset = {
		style.anchor_point_offset[1],
		style.anchor_point_offset[2]
	}
	widget_content.info_anchor_point_offset = {
		style.info_anchor_point_offset[1],
		style.info_anchor_point_offset[2]
	}
	local hotspot_content = widget_content.hotspot
	hotspot_content.disabled = true
	hotspot_content.pressed_callback = on_select_callback
	hotspot_content.selected_callback = on_select_callback
	hotspot_content.right_pressed_callback = right_pressed_callback
	local hotspot_style = style.hotspot
	hotspot_style.orig_size = {
		hotspot_style.size[1],
		hotspot_style.size[2]
	}
	hotspot_style.orig_offset = {
		hotspot_style.offset[1],
		hotspot_style.offset[2],
		hotspot_style.offset[3]
	}
end

local function _selection_visibility_function(content, style)
	local hotspot = content.hotspot

	return hotspot.is_selected or hotspot.is_focused or hotspot.anim_select_progress > 0 or hotspot.anim_focus_progress > 0
end

local function _change_function(content, style)
	local hotspot = content.hotspot
	local progress = math.max(hotspot.anim_select_progress, hotspot.anim_focus_progress)
	progress = math.easeOutCubic(progress)
	style.color[1] = 255 * progress
	local vertical_size_offset = (content.anchor_point_offset[2] + content.size[2]) * 0.5
	style.size_addition[1] = content.size[1] * (-1 + progress)
	style.size_addition[2] = vertical_size_offset * (-1 + progress)
end

mission_board_blueprints.mission_icon = {
	size = table.clone(blueprint_styles.mission_icon.size),
	pass_template = {
		{
			style_id = "hotspot",
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			value = "content/ui/materials/mission_board/badges/frames/normal_effect",
			value_id = "frame_effect",
			pass_type = "texture",
			style_id = "frame_effect"
		},
		{
			value = "content/ui/materials/mission_board/badges/frames/normal",
			value_id = "frame",
			pass_type = "texture",
			style_id = "frame"
		},
		{
			style_id = "resistance",
			value_id = "resistance",
			pass_type = "texture"
		},
		{
			style_id = "challenge",
			value_id = "challenge",
			pass_type = "texture"
		},
		{
			style_id = "selection",
			pass_type = "texture",
			value = "content/ui/materials/mission_board/badges/addons/selection_green",
			value_id = "selection",
			visibility_function = _selection_visibility_function,
			change_function = _change_function
		}
	},
	style = blueprint_styles.mission_icon,
	init = _init_function
}
mission_board_blueprints.circumstance_mission_icon = {
	size = table.clone(blueprint_styles.circumstance_mission_icon.size),
	pass_template = {
		{
			style_id = "hotspot",
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			value = "content/ui/materials/mission_board/badges/frames/circumstance_effect",
			value_id = "frame_effect",
			pass_type = "texture",
			style_id = "frame_effect"
		},
		{
			value = "content/ui/materials/mission_board/badges/frames/circumstance",
			value_id = "frame",
			pass_type = "texture",
			style_id = "frame"
		},
		{
			style_id = "circumstance_icon",
			value_id = "circumstance_icon",
			pass_type = "texture"
		},
		{
			style_id = "resistance",
			value_id = "resistance",
			pass_type = "texture"
		},
		{
			style_id = "challenge",
			value_id = "challenge",
			pass_type = "texture"
		},
		{
			style_id = "selection",
			pass_type = "texture",
			value = "content/ui/materials/mission_board/badges/addons/selection_green",
			value_id = "selection",
			visibility_function = _selection_visibility_function,
			change_function = _change_function
		}
	},
	style = blueprint_styles.circumstance_mission_icon,
	init = _init_function
}
mission_board_blueprints.happening_mission_icon = {
	size = table.clone(blueprint_styles.happening_mission_icon.size),
	pass_template = {
		{
			style_id = "hotspot",
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			value = "content/ui/materials/mission_board/badges/frames/event_effect",
			value_id = "frame_effect",
			pass_type = "texture",
			style_id = "frame_effect"
		},
		{
			value = "content/ui/materials/mission_board/badges/frames/event",
			value_id = "frame",
			pass_type = "texture",
			style_id = "frame"
		},
		{
			style_id = "resistance",
			value_id = "resistance",
			pass_type = "texture"
		},
		{
			style_id = "challenge",
			value_id = "challenge",
			pass_type = "texture"
		},
		{
			style_id = "selection",
			pass_type = "texture",
			value = "content/ui/materials/mission_board/badges/addons/selection_yellow",
			value_id = "selection",
			visibility_function = _selection_visibility_function,
			change_function = _change_function
		}
	},
	style = blueprint_styles.happening_mission_icon,
	init = _init_function
}
mission_board_blueprints.flash_mission_icon = {
	size = table.clone(blueprint_styles.flash_mission_icon.size),
	pass_template = {
		{
			style_id = "hotspot",
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			value = "content/ui/materials/mission_board/badges/frames/flash",
			value_id = "frame",
			pass_type = "texture",
			style_id = "frame"
		},
		{
			style_id = "resistance",
			value_id = "resistance",
			pass_type = "texture"
		},
		{
			style_id = "challenge",
			value_id = "challenge",
			pass_type = "texture"
		},
		{
			style_id = "selection",
			pass_type = "texture",
			value = "content/ui/materials/mission_board/badges/addons/selection_red",
			value_id = "selection",
			visibility_function = _selection_visibility_function,
			change_function = _change_function
		}
	},
	style = blueprint_styles.flash_mission_icon,
	init = _init_function
}
mission_board_blueprints.locked_mission_icon = {
	size = table.clone(blueprint_styles.locked_mission_icon.size),
	pass_template = {
		{
			style_id = "hotspot",
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			value = "content/ui/materials/mission_board/badges/frames/locked",
			value_id = "frame",
			pass_type = "texture",
			style_id = "frame"
		},
		{
			style_id = "selection",
			pass_type = "texture",
			value = "content/ui/materials/mission_board/badges/addons/selection_red",
			value_id = "selection",
			visibility_function = _selection_visibility_function,
			change_function = _change_function
		}
	},
	style = blueprint_styles.locked_mission_icon,
	init = _init_function
}
mission_board_blueprints.test_rect = {
	pass_template = {
		{
			pass_type = "rect",
			style = {
				color = {
					64,
					255,
					0,
					255
				}
			}
		}
	}
}

return settings("MissionBoardViewBlueprints", mission_board_blueprints)
