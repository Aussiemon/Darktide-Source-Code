-- chunkname: @scripts/ui/views/contracts_view/contracts_view_styles.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ViewSettings = require("scripts/ui/views/contracts_view/contracts_view_settings")
local WalletSettings = require("scripts/settings/wallet_settings")
local wallet_settings = WalletSettings[ViewSettings.wallet_type]
local _math_lerp = math.lerp
local _math_max = math.max
local _color_copy = ColorUtilities.color_copy
local _color_lerp = ColorUtilities.color_lerp
local left_column_width = 640
local contract_info_margin = 38
local contracts_view_styles = {}

contracts_view_styles.contract_info_header = {}

local contract_info_header_style = contracts_view_styles.contract_info_header

contract_info_header_style.size = {
	left_column_width,
	246
}
contract_info_header_style.margin = contract_info_margin
contract_info_header_style.list_header_text = table.clone(UIFontSettings.header_2)

local contract_info_header_list_header_text_style = contract_info_header_style.list_header_text

contract_info_header_list_header_text_style.offset = {
	0,
	60,
	4
}
contract_info_header_list_header_text_style.text_color = Color.terminal_text_header(nil, true)
contract_info_header_list_header_text_style.text_horizontal_alignment = "center"
contract_info_header_list_header_text_style.text_vertical_alignment = "center"
contract_info_header_list_header_text_style.horizontal_alignment = "center"
contract_info_header_list_header_text_style.vertical_alignment = "center"
contract_info_header_style.background_candles = {
	offset = {
		0,
		0,
		5
	}
}
contracts_view_styles.list_padding = {
	size = {
		left_column_width,
		10
	}
}
contracts_view_styles.contract_info = {}

local contract_info_style = contracts_view_styles.contract_info

contract_info_style.size = {
	left_column_width,
	246
}
contract_info_style.label = table.clone(UIFontSettings.body)

local contract_info_label_style = contract_info_style.label

contract_info_label_style.text_vertical_alignment = "bottom"
contract_info_label_style.offset = {
	10,
	-40,
	4
}
contract_info_label_style.text_color = Color.terminal_text_header(nil, true)
contract_info_style.reward_icon = {}

local reward_icon_style = contract_info_style.reward_icon

reward_icon_style.size = {
	52,
	44
}
reward_icon_style.horizontal_alignment = "right"
reward_icon_style.vertical_alignment = "center"
reward_icon_style.offset = {
	-6,
	0,
	5
}
reward_icon_style.default_offset = table.clone(reward_icon_style.offset)
contract_info_style.reward_text = table.clone(UIFontSettings.currency_title)

local reward_text_style = contract_info_style.reward_text

reward_text_style.font_size = 40
reward_text_style.material = wallet_settings.font_gradient_material
reward_text_style.text_horizontal_alignment = "right"
reward_text_style.text_vertical_alignment = "center"
reward_text_style.offset = {
	-65,
	0,
	2
}
contract_info_style.background_highlight = {}

local contract_info_background_highlight_style = contract_info_style.background_highlight

contract_info_background_highlight_style.color = Color.ui_hud_green_light(100, true)
contract_info_style.frame = {}

local contract_info_frame_style = contract_info_style.frame

contract_info_frame_style.color = Color.terminal_frame(nil, true)
contract_info_frame_style.size_addition = {
	19,
	19
}
contract_info_frame_style.offset = {
	0,
	0,
	5
}
contract_info_frame_style.horizontal_alignment = "center"
contract_info_frame_style.vertical_alignment = "center"
contract_info_frame_style.scale_to_material = true
contract_info_style.background = {}

local contract_info_background_style = contract_info_style.background

contract_info_background_style.color = Color.terminal_background(150, true)
contract_info_background_style.offset = {
	0,
	0,
	-1
}
contract_info_background_style.horizontal_alignment = "center"
contract_info_background_style.vertical_alignment = "center"
contracts_view_styles.contract_progress = {}

local contract_progress_style = contracts_view_styles.contract_progress

contract_progress_style.size = {
	contract_info_style.size[1] - contract_info_margin * 2,
	20
}
contract_progress_style.margin = contract_info_margin
contract_progress_style.progress_text = table.clone(UIFontSettings.body_small)

local contract_progress_text_style = contract_progress_style.progress_text

contract_progress_text_style.text_horizontal_alignment = "left"
contract_progress_text_style.text_vertical_alignment = "center"
contract_progress_text_style.offset = {
	-20,
	-50,
	2
}
contract_progress_text_style.text_color = Color.terminal_text_body(nil, true)
contract_progress_style.progress_bar_background = {}

local progress_bar_background_style = contract_progress_style.progress_bar_background

progress_bar_background_style.size = {
	501,
	22
}
progress_bar_background_style.color = {
	255,
	0,
	0,
	0
}
contract_progress_style.progress_bar = {}

local contract_progress_bar_style = contract_progress_style.progress_bar

contract_progress_bar_style.size = {
	501,
	22
}
contract_progress_bar_style.default_size = table.clone(contract_progress_bar_style.size)
contract_progress_bar_style.offset = {
	0,
	0,
	1
}
contract_progress_style.progress_bar_edge = {}

local contract_progress_bar_edge_style = contract_progress_style.progress_bar_edge

contract_progress_bar_edge_style.size = {
	16,
	32
}
contract_progress_bar_edge_style.offset = {
	-7,
	2,
	20
}
contract_progress_bar_edge_style.vertical_alignment = "center"
contract_progress_bar_edge_style.default_offset = table.clone(contract_progress_bar_edge_style.offset)
contract_progress_bar_edge_style.visible = false

local grid_margin = 10
local task_grid_size = {
	left_column_width - 2 * grid_margin,
	600
}

contracts_view_styles.task_grid = {
	size = task_grid_size,
	grid_margin = grid_margin,
	spacing = {
		task_grid_size[1],
		10
	}
}
contracts_view_styles.task_grid_background = {}
contracts_view_styles.task_grid_background.background = {
	color = Color.terminal_background(180, true),
	offset = {
		4,
		0,
		0
	},
	size_addition = {
		-8,
		0
	}
}
contracts_view_styles.task_list_item = {}

local task_list_item_style = contracts_view_styles.task_list_item

task_list_item_style.size = {
	task_grid_size[1] - 10,
	74
}
task_list_item_style.text_vertical_margin = 45
task_list_item_style.hotspot = {}

local task_list_item_hotspot_style = task_list_item_style.hotspot

task_list_item_hotspot_style.on_hover_sound = UISoundEvents.default_mouse_hover
task_list_item_hotspot_style.on_pressed_sound = UISoundEvents.default_click
task_list_item_hotspot_style.on_select_sound = UISoundEvents.default_click
task_list_item_style.background = {}

local task_list_item_background_style = task_list_item_style.background

task_list_item_background_style.color = Color.terminal_background_selected(nil, true)
task_list_item_background_style.selected_alpha = 24
task_list_item_background_style.hover_alpha = 64
task_list_item_background_style.scale_to_material = true
task_list_item_style.background_gradient = {}

local task_list_item_background_gradient_style = task_list_item_style.background_gradient

task_list_item_background_gradient_style.color = Color.terminal_background_gradient(0, true)
task_list_item_background_gradient_style.default_color = table.clone(task_list_item_background_gradient_style.color)
task_list_item_background_gradient_style.hover_color = Color.terminal_background_gradient(255, true)
task_list_item_background_gradient_style.selected_color = Color.terminal_background_gradient_selected(150, true)
task_list_item_background_gradient_style.max_alpha = 255
task_list_item_background_gradient_style.offset = {
	0,
	0,
	4
}
task_list_item_background_gradient_style.scale_to_material = true
task_list_item_style.frame = {}

local task_list_item_frame_style = task_list_item_style.frame

task_list_item_frame_style.default_color = Color.terminal_frame(nil, true)
task_list_item_frame_style.hover_color = Color.terminal_frame_hover(nil, true)
task_list_item_frame_style.selected_color = Color.terminal_frame_selected(nil, true)
task_list_item_frame_style.max_alpha = 255
task_list_item_frame_style.offset = {
	0,
	0,
	10
}
task_list_item_frame_style.horizontal_alignment = "center"
task_list_item_frame_style.vertical_alignment = "center"
task_list_item_frame_style.scale_to_material = true
task_list_item_style.corner = {}

local task_list_item_corner_style = task_list_item_style.corner

task_list_item_corner_style.default_color = Color.terminal_corner(nil, true)
task_list_item_corner_style.hover_color = Color.terminal_corner_hover(nil, true)
task_list_item_corner_style.selected_color = Color.terminal_corner_selected(nil, true)
task_list_item_corner_style.offset = {
	0,
	0,
	11
}
task_list_item_corner_style.horizontal_alignment = "center"
task_list_item_corner_style.vertical_alignment = "center"
task_list_item_corner_style.scale_to_material = true
task_list_item_style.icon = {}

local task_list_item_icon_style = task_list_item_style.icon

task_list_item_icon_style.offset = {
	10,
	12,
	5
}
task_list_item_icon_style.size = {
	60,
	60
}
task_list_item_icon_style.horizontal_alignment = "left"
task_list_item_icon_style.vertical_alignment = "top"
task_list_item_icon_style.default_color = Color.terminal_icon(nil, true)
task_list_item_icon_style.selected_color = Color.terminal_icon_selected(nil, true)
task_list_item_icon_style.fulfilled_color = Color.terminal_icon(180, true)
task_list_item_icon_style.fulfilled_selected_color = Color.terminal_icon_selected(200, true)
task_list_item_icon_style.material_values = {
	checkmark_color = table.clone(task_list_item_icon_style.fulfilled_color)
}
task_list_item_icon_style.checkmark_default_color = Color.terminal_text_body_sub_header(nil, true)
task_list_item_icon_style.checkmark_hover_color = Color.terminal_text_header_selected(200, true)
task_list_item_style.task_name = table.clone(UIFontSettings.list_button)

local task_name_style = task_list_item_style.task_name

task_name_style.text_vertical_alignment = "top"
task_name_style.offset = {
	task_list_item_icon_style.size[1] + 20,
	15,
	5
}
task_name_style.size = {
	400,
	30
}
task_name_style.default_color = Color.terminal_text_header(nil, true)
task_name_style.selected_color = Color.terminal_text_header_selected(nil, true)
task_name_style.fulfilled_color = Color.terminal_text_body_sub_header(nil, true)
task_name_style.fulfilled_selected_color = Color.terminal_text_header_selected(200, true)
task_list_item_style.task_reward_icon = {}

local task_reward_icon_style = task_list_item_style.task_reward_icon

task_reward_icon_style.size = {
	28,
	20
}
task_reward_icon_style.horizontal_alignment = "right"
task_reward_icon_style.offset = {
	-26,
	18,
	5
}
task_reward_icon_style.default_offset = table.clone(reward_icon_style.offset)
task_reward_icon_style.fulfilled_color = {
	255,
	160,
	160,
	160
}
task_list_item_style.task_reward_text = table.clone(task_list_item_style.task_name)

local task_reward_text_style = task_list_item_style.task_reward_text

task_reward_text_style.text_horizontal_alignment = "right"
task_reward_text_style.text_vertical_alignment = "top"
task_reward_text_style.offset[1] = -60
task_reward_text_style.text_color = Color.white(255, true)
task_reward_text_style.fulfilled_color = {
	255,
	200,
	200,
	200
}
task_reward_text_style.material = wallet_settings.font_gradient_material
task_reward_text_style.size = nil
task_list_item_style.progress_bar_frame = {}
progress_bar_frame_style = task_list_item_style.progress_bar_frame
progress_bar_frame_style.vertical_alignment = "bottom"
progress_bar_frame_style.offset = {
	task_list_item_icon_style.size[1] + 22,
	-12,
	5
}
progress_bar_frame_style.size = {
	task_list_item_style.size[1] - task_list_item_icon_style.size[1] - 34,
	12
}
progress_bar_frame_style.default_color = Color.terminal_frame(nil, true)
progress_bar_frame_style.hover_color = Color.terminal_frame_hover(nil, true)
progress_bar_frame_style.selected_color = Color.terminal_frame_selected(nil, true)
progress_bar_frame_style.max_alpha = 255
task_list_item_style.progress_bar_background = {}
progress_bar_background_style = task_list_item_style.progress_bar_background
progress_bar_background_style.vertical_alignment = "bottom"
progress_bar_background_style.offset = {
	progress_bar_frame_style.offset[1] + 1,
	progress_bar_frame_style.offset[2] - 1,
	6
}
progress_bar_background_style.size = {
	progress_bar_frame_style.size[1] - 2,
	progress_bar_frame_style.size[2] - 2
}
progress_bar_background_style.color = Color.terminal_background_dark(192, true)
task_list_item_style.progress_bar = table.clone(progress_bar_background_style)

local task_progress_bar_style = task_list_item_style.progress_bar

task_progress_bar_style.offset[3] = 8
task_progress_bar_style.color = Color.white(255, true)
task_list_item_style.progress_bar_edge = {}

local task_progress_bar_edge_style = task_list_item_style.progress_bar_edge

task_progress_bar_edge_style.size = {
	12,
	28
}
task_progress_bar_edge_style.vertical_alignment = "bottom"
task_progress_bar_edge_style.relative_negative_offset_x = -6
task_progress_bar_edge_style.offset = {
	progress_bar_background_style.offset[1] + task_progress_bar_edge_style.relative_negative_offset_x,
	progress_bar_background_style.offset[2] + 9,
	10
}
task_list_item_style.completed_overlay = {}

local task_completed_overlay_style = task_list_item_style.completed_overlay

task_completed_overlay_style.offset = {
	0,
	0,
	3
}
task_completed_overlay_style.color = {
	150,
	0,
	0,
	0
}
task_list_item_style.task_completed_text = table.clone(UIFontSettings.body_small)

local task_completed_text_style = task_list_item_style.task_completed_text

task_completed_text_style.text_vertical_alignment = "top"
task_completed_text_style.vertical_alignment = "bottom"
task_completed_text_style.offset = {
	task_list_item_icon_style.size[1] + 20,
	-8,
	5
}
task_completed_text_style.size = {
	task_list_item_style.size[1] - 40 - task_list_item_icon_style.size[1],
	30
}
task_completed_text_style.default_color = Color.terminal_text_body_sub_header(255, true)
task_completed_text_style.selected_color = Color.terminal_text_header_selected(200, true)

contracts_view_styles.task_list_item_background_change_function = function (content, style)
	local hotspot = content.hotspot
	local select_progress = hotspot.anim_select_progress or 0
	local hover_progress = _math_max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)
	local color = style.color
	local hover_alpha = style.hover_alpha
	local selected_alpha = style.selected_alpha
	local alpha = _math_lerp(selected_alpha, hover_alpha, hover_progress)

	color[1] = alpha * select_progress
end

contracts_view_styles.task_list_item_hover_change_function = function (content, style)
	local color_lerp = _color_lerp
	local hotspot = content.hotspot
	local select_progress = hotspot.anim_select_progress
	local hover_progress = hotspot.anim_hover_progress
	local color = style.color
	local default_color = style.default_color
	local hover_color = style.hover_color
	local selected_color = style.selected_color
	local target_color, color_progress

	if hover_progress <= select_progress then
		target_color = selected_color
		color_progress = select_progress
	else
		target_color = hover_color
		color_progress = hover_progress
	end

	color_lerp(default_color, target_color, color_progress, color)

	local min_alpha = style.min_alpha or color[1]
	local max_alpha = style.max_alpha or color[1]

	if min_alpha ~= max_alpha then
		color[1] = _math_lerp(min_alpha, max_alpha, hover_progress)
	end
end

contracts_view_styles.task_list_completion_visibility_function = function (content, style)
	local fulfilled = content.task_is_fulfilled

	return fulfilled
end

contracts_view_styles.task_list_progress_bar_visibility_function = function (content, style)
	local fulfilled = content.task_is_fulfilled

	return not fulfilled
end

contracts_view_styles.task_list_item_task_name_change_function = function (content, style)
	local fulfilled = content.task_is_fulfilled
	local hotspot = content.hotspot
	local hover_progress = hotspot.anim_hover_progress
	local select_progress = hotspot.anim_select_progress
	local progress = math.max(hover_progress, select_progress)
	local default_color = fulfilled and style.fulfilled_color or style.default_color
	local selected_color = fulfilled and style.fulfilled_selected_color or style.selected_color
	local text_color = style.text_color

	_color_lerp(default_color, selected_color, progress, text_color)
end

contracts_view_styles.task_list_item_task_icon_change_function = function (content, style)
	local color_lerp = _color_lerp
	local fulfilled = content.task_is_fulfilled
	local hotspot = content.hotspot
	local hover_progress = hotspot.anim_hover_progress
	local select_progress = hotspot.anim_select_progress
	local progress = math.max(hover_progress, select_progress)
	local default_color = fulfilled and style.fulfilled_color or style.default_color
	local selected_color = fulfilled and style.fulfilled_selected_color or style.selected_color
	local color = style.color

	color_lerp(default_color, selected_color, progress, color)

	local checkmark_default_color = style.checkmark_default_color
	local checkmark_hover_color = style.checkmark_hover_color
	local checkmark_color = style.material_values.checkmark_color

	color_lerp(checkmark_default_color, checkmark_hover_color, progress, checkmark_color)
end

contracts_view_styles.task_info = {}

local task_info_style = contracts_view_styles.task_info

task_info_style.size = {
	850,
	200
}
task_info_style.frame = {}

local task_info_frame_style = task_info_style.frame

task_info_frame_style.color = Color.terminal_frame(nil, true)
task_info_frame_style.size_addition = {
	19,
	19
}
task_info_frame_style.offset = {
	0,
	0,
	10
}
task_info_frame_style.horizontal_alignment = "center"
task_info_frame_style.vertical_alignment = "center"
task_info_frame_style.scale_to_material = true
task_info_style.background_rect = {}

local task_info_background_rect_style = task_info_style.background_rect

task_info_background_rect_style.size_addition = {
	-8,
	0
}
task_info_background_rect_style.offset = {
	4,
	0,
	0
}
task_info_background_rect_style.color = Color.terminal_background(150, true)
task_info_style.background = {}

local task_info_background_style = task_info_style.background

task_info_background_style.color = Color.terminal_grid_background(nil, true)
task_info_background_style.offset = {
	0,
	0,
	1
}
task_info_background_style.horizontal_alignment = "center"
task_info_background_style.vertical_alignment = "center"
task_info_background_style.size_addition = {
	20,
	22
}
task_info_background_style.scale_to_material = true
task_info_style.completed_overlay = {}

local task_info_completed_overlay_style = task_info_style.completed_overlay

task_info_completed_overlay_style.offset = {
	4,
	0,
	3
}
task_info_completed_overlay_style.size_addition = {
	-8,
	0
}
task_info_completed_overlay_style.color = {
	64,
	0,
	0,
	0
}
task_info_style.edge_top = {}

local task_info_edge_top_style = task_info_style.edge_top

task_info_edge_top_style.size = {
	nil,
	36
}
task_info_edge_top_style.size_addition = {
	4,
	0
}
task_info_edge_top_style.offset = {
	0,
	-15,
	11
}
task_info_edge_top_style.horizontal_alignment = "center"
task_info_edge_top_style.vertical_alignment = "top"
task_info_edge_top_style.scale_to_material = true
task_info_style.edge_bottom = {}

local task_info_edge_bottom_style = task_info_style.edge_bottom

task_info_edge_bottom_style.size = {
	nil,
	36
}
task_info_edge_bottom_style.size_addition = {
	4,
	0
}
task_info_edge_bottom_style.offset = {
	0,
	15,
	11
}
task_info_edge_bottom_style.horizontal_alignment = "center"
task_info_edge_bottom_style.vertical_alignment = "bottom"
task_info_edge_top_style.scale_to_material = true
task_info_style.icon = {}

local task_info_icon_style = task_info_style.icon

task_info_icon_style.offset = {
	contract_info_margin,
	22,
	5
}
task_info_icon_style.size = {
	80,
	80
}
task_info_icon_style.default_color = Color.terminal_icon(nil, true)
task_info_icon_style.fulfilled_color = Color.terminal_icon(180, true)
task_info_icon_style.material_values = {
	checkbox = 0
}
task_info_style.label = table.clone(UIFontSettings.header_2)

local task_info_label_style = task_info_style.label

task_info_label_style.offset = {
	contract_info_margin + task_info_icon_style.size[1] + 22,
	22,
	5
}
task_info_label_style.size = {
	650,
	30
}
task_info_label_style.default_size = table.clone(task_info_label_style.size)
task_info_label_style.fulfilled_size = {
	465,
	30
}
task_info_label_style.default_color = Color.terminal_text_header(nil, true)
task_info_label_style.fulfilled_color = Color.terminal_text_body_sub_header(nil, true)
task_info_style.description = table.clone(UIFontSettings.body)

local task_info_description_style = task_info_style.description

task_info_description_style.offset = {
	task_info_label_style.offset[1],
	contract_info_margin + 30,
	5
}
task_info_description_style.default_offset = table.clone(task_info_description_style.offset)
task_info_description_style.size = table.clone(task_info_label_style.size)
task_info_description_style.text_color = Color.terminal_text_body(255, true)
task_info_description_style.default_color = table.clone(task_info_description_style.text_color)
task_info_description_style.fulfilled_color = Color.terminal_text_body_dark(255, true)
task_info_style.reward_icon = {}

local task_info_reward_icon_style = task_info_style.reward_icon

task_info_reward_icon_style.size = {
	52,
	44
}
task_info_reward_icon_style.horizontal_alignment = "right"
task_info_reward_icon_style.vertical_alignment = "bottom"
task_info_reward_icon_style.offset = {
	-contract_info_margin,
	-15,
	5
}
task_info_reward_icon_style.default_offset = table.clone(task_info_reward_icon_style.offset)
task_info_reward_icon_style.default_color = Color.white(255, true)
task_info_reward_icon_style.fulfilled_color = {
	255,
	160,
	160,
	160
}
task_info_style.reward_text = table.clone(UIFontSettings.currency_title)

local task_info_reward_text_style = task_info_style.reward_text

task_info_reward_text_style.horizontal_alignment = "right"
task_info_reward_text_style.vertical_alignment = "bottom"
task_info_reward_text_style.text_horizontal_alignment = "right"
task_info_reward_text_style.text_vertical_alignment = "top"
task_info_reward_text_style.offset = {
	-contract_info_margin - 60,
	-28,
	5
}
task_info_reward_text_style.size = {
	task_info_style.size[1] - 2 * contract_info_margin - task_info_label_style.size[1],
	task_info_label_style.size[2]
}
task_info_reward_text_style.material = wallet_settings.font_gradient_material
task_info_reward_text_style.default_color = table.clone(task_info_reward_text_style.text_color)
task_info_reward_text_style.fulfilled_color = {
	255,
	200,
	200,
	200
}
task_info_style.reward_label = table.clone(UIFontSettings.header_5)

local task_info_reward_label = task_info_style.reward_label

task_info_reward_label.offset = {
	0,
	0,
	5
}
task_info_reward_label.text_color = Color.terminal_text_body_sub_header(255, true)
task_info_style.completion_label = table.clone(task_info_style.reward_label)
task_info_style.completion_text = table.clone(UIFontSettings.body)

local task_info_completion_text_style = task_info_style.completion_text

task_info_completion_text_style.offset = {
	0,
	0,
	5
}
task_info_completion_text_style.text_vertical_alignment = "bottom"
task_info_completion_text_style.default_color = Color.terminal_text_body(255, true)
task_info_completion_text_style.fulfilled_color = Color.terminal_text_body_dark(255, true)
task_info_style.complexity_label = table.clone(task_info_style.reward_label)
task_info_style.complexity_icon = {}

local task_info_complexity_icon = task_info_style.complexity_icon

task_info_complexity_icon.offset = {
	0,
	0,
	5
}
task_info_complexity_icon.vertical_alignment = "bottom"
task_info_complexity_icon.horizontal_alignment = "left"
task_info_complexity_icon.size = {
	28,
	28
}
task_info_complexity_icon.default_color = Color.white(255, true)
task_info_complexity_icon.fulfilled_color = {
	255,
	160,
	160,
	160
}
task_info_style.complexity_text = table.clone(task_info_completion_text_style)

local task_info_complexity_text_style = task_info_style.complexity_text

task_info_complexity_text_style.offset = {
	task_info_complexity_icon.size[1],
	0,
	5
}
task_info_style.completed_text = table.clone(UIFontSettings.header_3)

local task_info_completed_text_style = task_info_style.completed_text

task_info_completed_text_style.offset = {
	-contract_info_header_style.margin,
	16,
	5
}
task_info_completed_text_style.size = ButtonPassTemplates.terminal_button.size
task_info_completed_text_style.text_color = Color.terminal_text_header(255, true)
task_info_completed_text_style.vertical_alignment = "top"
task_info_completed_text_style.horizontal_alignment = "right"
task_info_completed_text_style.text_vertical_alignment = "center"
task_info_completed_text_style.text_horizontal_alignment = "right"

contracts_view_styles.task_info_change_function = function (content, style)
	local is_fulfilled = content.task_is_fulfilled
	local color = style.text_color or style.color

	if is_fulfilled then
		_color_copy(style.fulfilled_color, color)
	else
		_color_copy(style.default_color, color)
	end
end

contracts_view_styles.task_info_fulfilled_visibility = function (content, style)
	local is_fulfilled = content.task_is_fulfilled

	return is_fulfilled
end

return settings("ContractsViewStyles", contracts_view_styles)
