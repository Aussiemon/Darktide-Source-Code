local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local ViewSettings = require("scripts/ui/views/contracts_view/contracts_view_settings")
local WalletSettings = require("scripts/settings/wallet_settings")
local wallet_settings = WalletSettings[ViewSettings.wallet_type]
local color_lerp = ColorUtilities.color_lerp
local left_column_width = 640
local contract_info_margin = 38
local contracts_view_styles = {
	contract_info_header = {}
}
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
contract_info_background_style.color = Color.ui_hud_green_medium(80, true)
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
contract_progress_bar_style = {
	255,
	0,
	255,
	0
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
	1
}
contract_progress_bar_edge_style.vertical_alignment = "center"
contract_progress_bar_edge_style.default_offset = table.clone(contract_progress_bar_edge_style.offset)
contracts_view_styles.contract_fulfilled = {}
local contract_fulfilled_style = contracts_view_styles.contract_fulfilled
contract_fulfilled_style.text = table.clone(UIFontSettings.header_1)
local contract_fulfilled_text_style = contract_fulfilled_style.text
contract_fulfilled_text_style.text_horizontal_alignment = "center"
contract_fulfilled_text_style.offset = {
	0,
	18,
	0
}
contract_fulfilled_text_style.material = "content/ui/materials/font_gradients/slug_font_gradient_header"
contract_fulfilled_text_style.text_color = Color.white(255, true)
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
contracts_view_styles.task_list_item = {}
local task_list_item_style = contracts_view_styles.task_list_item
task_list_item_style.size = {
	task_grid_size[1] - 10,
	84
}
task_list_item_style.double_size = {
	task_grid_size[1] - 10,
	114
}
task_list_item_style.text_vertical_margin = 45
task_list_item_style.background = {}
local task_list_item_background_style = task_list_item_style.background
task_list_item_background_style.default_color = Color.terminal_background(nil, true)
task_list_item_background_style.selected_color = Color.terminal_background_selected(nil, true)
task_list_item_style.background_gradient = {}
local task_list_item_background_gradient_style = task_list_item_style.background_gradient
task_list_item_background_gradient_style.default_color = Color.terminal_background_gradient(nil, true)
task_list_item_background_gradient_style.selected_color = Color.terminal_background_gradient_selected(nil, true)
task_list_item_background_gradient_style.offset = {
	0,
	0,
	1
}
task_list_item_background_gradient_style.scale_to_material = true
task_list_item_style.frame = {}
local task_list_item_frame_style = task_list_item_style.frame
task_list_item_frame_style.default_color = Color.terminal_frame(nil, true)
task_list_item_frame_style.selected_color = Color.terminal_frame_selected(nil, true)
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
task_list_item_icon_style.fulfilled_color = Color.ui_grey_medium(255, true)
task_list_item_icon_style.default_color = Color.terminal_icon(nil, true)
task_list_item_icon_style.hover_color = Color.terminal_icon_selected(nil, true)
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
task_name_style.fulfilled_color = Color.ui_grey_medium(255, true)
task_name_style.default_color = Color.terminal_text_header(nil, true)
task_name_style.hover_color = Color.terminal_text_header_selected(nil, true)
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
task_list_item_style.task_reward_text = table.clone(task_list_item_style.task_name)
local task_reward_text_style = task_list_item_style.task_reward_text
task_reward_text_style.text_horizontal_alignment = "right"
task_reward_text_style.text_vertical_alignment = "top"
task_reward_text_style.offset[1] = -60
task_reward_text_style.text_color = Color.white(255, true)
task_reward_text_style.material = wallet_settings.font_gradient_material
task_reward_text_style.size = nil
task_list_item_style.task_reward_background = {}
local task_reward_background_style = task_list_item_style.task_reward_background
task_reward_background_style.size = {
	32,
	30
}
task_reward_background_style.horizontal_alignment = "right"
task_reward_background_style.vertical_alignment = "top"
task_reward_background_style.offset = {
	-19,
	13,
	2
}
task_reward_background_style.color = {
	120,
	0,
	0,
	0
}
task_reward_background_style.default_offset = table.clone(reward_icon_style.offset)
task_list_item_style.progress_bar_frame = {}
progress_bar_frame_style = task_list_item_style.progress_bar_frame
progress_bar_frame_style.vertical_alignment = "bottom"
progress_bar_frame_style.offset = {
	task_list_item_icon_style.size[1] + 20 - 1,
	-23,
	3
}
progress_bar_frame_style.size = {
	task_list_item_style.size[1] - 40 + 2 - task_list_item_icon_style.size[1],
	8
}
progress_bar_frame_style.default_color = Color.terminal_frame(nil, true)
progress_bar_frame_style.selected_color = Color.terminal_frame_selected(nil, true)
task_list_item_style.progress_bar_background = {}
progress_bar_background_style = task_list_item_style.progress_bar_background
progress_bar_background_style.vertical_alignment = "bottom"
progress_bar_background_style.offset = {
	task_list_item_icon_style.size[1] + 20,
	-24,
	4
}
progress_bar_background_style.size = {
	task_list_item_style.size[1] - 40 - task_list_item_icon_style.size[1],
	6
}
progress_bar_background_style.color = Color.terminal_background(255, true)
task_list_item_style.progress_bar = table.clone(task_list_item_style.progress_bar_background)
local task_progress_bar_style = task_list_item_style.progress_bar
task_progress_bar_style.offset = {
	progress_bar_background_style.offset[1],
	progress_bar_background_style.offset[2],
	5
}
task_progress_bar_style.size = {
	progress_bar_background_style.size[1],
	6
}
task_progress_bar_style.color = {
	255,
	255,
	255,
	255
}
task_list_item_style.progress_bar_edge = {}
local task_progress_bar_edge_style = task_list_item_style.progress_bar_edge
task_progress_bar_edge_style.size = {
	12,
	22
}
task_progress_bar_edge_style.vertical_alignment = "bottom"
task_progress_bar_edge_style.offset = {
	progress_bar_background_style.offset[1] - 6,
	progress_bar_background_style.offset[2] + 8,
	6
}
task_list_item_style.completed_overlay = {}
local task_completed_overlay_style = task_list_item_style.completed_overlay
task_completed_overlay_style.offset = {
	0,
	0,
	8
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
	-12,
	4
}
task_completed_text_style.size = {
	task_list_item_style.size[1] - 40 - task_list_item_icon_style.size[1],
	30
}
task_completed_text_style.text_color = Color.terminal_text_body(255, true)

contracts_view_styles.task_list_item_background_hover_change_function = function (content, style)
	local hotspot = content.hotspot
	local is_selected = hotspot.is_selected
	local color = style.color
	local default_color = style.default_color
	local selected_color = style.selected_color
	local anim_progress = math.max(hotspot.anim_hover_progress, content.hotspot.anim_select_progress)
	style.color[1] = default_color[1] + anim_progress * (selected_color[1] - default_color[1])
	style.color[2] = is_selected and selected_color[2] or default_color[2]
	style.color[3] = is_selected and selected_color[3] or default_color[3]
	style.color[4] = is_selected and selected_color[4] or default_color[4]
end

contracts_view_styles.task_list_item_background_change_function = function (content, style)
	local hotspot = content.hotspot
	local is_selected = hotspot.is_selected
	local color = style.color
	local default_color = style.default_color
	local selected_color = style.selected_color
	style.color[1] = is_selected and selected_color[1] or default_color[1]
	style.color[2] = is_selected and selected_color[2] or default_color[2]
	style.color[3] = is_selected and selected_color[3] or default_color[3]
	style.color[4] = is_selected and selected_color[4] or default_color[4]
end

contracts_view_styles.task_list_item_background_frame_change_function = function (content, style)
	local entry = content.entry
	local fulfilled = entry.fulfilled
	local hotspot = content.hotspot
	local is_selected = hotspot.is_selected
	local color = style.color
	local default_color = style.default_color
	local selected_color = style.selected_color
	style.color[2] = is_selected and selected_color[2] or default_color[2]
	style.color[3] = is_selected and selected_color[3] or default_color[3]
	style.color[4] = is_selected and selected_color[4] or default_color[4]
end

contracts_view_styles.task_list_item_progress_bar_edge_change_function = function (content, style)
	local entry = content.entry
	local progress = entry.task_progress_normalized or 0
	local bar_length = content.bar_length or 0
	local alpha_multiplier = math.clamp(progress / 0.2, 0, 1)
	style.color[1] = 255 * alpha_multiplier
end

contracts_view_styles.task_list_completion_visibility_function = function (content, style)
	local entry = content.entry
	local fulfilled = entry.fulfilled

	return fulfilled
end

contracts_view_styles.task_list_progress_bar_visibility_function = function (content, style)
	local entry = content.entry
	local fulfilled = entry.fulfilled

	return not fulfilled
end

contracts_view_styles.task_list_item_task_name_change_function = function (content, style)
	local default_color = content.hotspot.disabled and style.disabled_color or style.default_color
	local hotspot = content.hotspot
	local hover_progress = hotspot.anim_hover_progress
	local select_progress = hotspot.anim_select_progress
	local progress = math.max(hover_progress, select_progress)

	color_lerp(default_color, style.hover_color, progress, style.text_color or style.color)
end

contracts_view_styles.task_list_item_highlight_change_function = function (content, style)
	local hotspot = content.hotspot
	local progress = math.max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)
	style.color[1] = 255 * math.easeOutCubic(progress)
end

contracts_view_styles.task_list_item_selected_change_function = function (content, style)
	local hotspot = content.hotspot
	local progress = hotspot.anim_select_progress
	style.color[1] = 255 * math.easeOutCubic(progress)
	local entry = content.entry
	local fulfilled = entry.fulfilled

	if fulfilled then
		style.size_addition[2] = 0
	end
end

contracts_view_styles.task_info = {}
local task_info_style = contracts_view_styles.task_info
task_info_style.size = {
	850,
	200
}
task_info_style.background_highlight = {}
local task_info_background_highlight_style = task_info_style.background_highlight
task_info_background_highlight_style.color = Color.terminal_background_gradient(nil, true)
task_info_background_highlight_style.scale_to_material = true
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
task_info_style.background = {}
local task_info_background_style = task_info_style.background
task_info_background_style.color = Color.terminal_background(nil, true)
task_info_background_style.offset = {
	0,
	0,
	-1
}
task_info_background_style.horizontal_alignment = "center"
task_info_background_style.vertical_alignment = "center"
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
task_info_style.label = table.clone(UIFontSettings.header_2)
local task_info_label_style = task_info_style.label
task_info_label_style.offset = {
	contract_info_margin,
	22,
	5
}
task_info_label_style.size = {
	630,
	30
}
task_info_label_style.default_size = table.clone(task_info_label_style.size)
task_info_label_style.text_color = Color.terminal_text_header(nil, true)
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
task_info_reward_text_style.default_material = task_info_reward_text_style.material
task_info_reward_text_style.fulfilled_color = Color.ui_grey_medium(255, true)
task_info_reward_text_style.default_color = table.clone(task_info_reward_text_style.text_color)
task_info_style.reward_label = table.clone(UIFontSettings.header_5)
task_info_style.reward_label.text_color = Color.terminal_text_body_sub_header(255, true)
task_info_style.reward_label.text_horizontal_alignment = "right"
task_info_style.reward_background = {}
local task_info_reward_background_style = task_info_style.reward_background
task_info_reward_background_style.size = {
	52,
	54
}
task_info_reward_background_style.horizontal_alignment = "right"
task_info_reward_background_style.vertical_alignment = "top"
task_info_reward_background_style.color = {
	120,
	0,
	0,
	0
}
task_info_reward_background_style.offset = {
	-contract_info_margin + 5,
	10,
	3
}
task_info_reward_background_style.default_offset = table.clone(task_info_reward_background_style.offset)
task_info_style.description = table.clone(UIFontSettings.body)
local task_info_description_style = task_info_style.description
task_info_description_style.offset = {
	contract_info_margin,
	contract_info_margin + 30,
	5
}
task_info_description_style.default_offset = table.clone(task_info_description_style.offset)
task_info_description_style.size = {
	task_info_style.size[1] - 2 * contract_info_margin,
	30
}
task_info_description_style.text_color = Color.terminal_text_body(255, true)
task_info_style.completion_label = table.clone(UIFontSettings.header_5)
task_info_style.completion_label.text_color = Color.terminal_text_body_sub_header(255, true)
task_info_style.completion_text = table.clone(UIFontSettings.body)
task_info_style.completion_text.text_vertical_alignment = "bottom"
task_info_style.completion_text.text_color = Color.terminal_text_body(255, true)
task_info_style.complexity_label = table.clone(UIFontSettings.header_5)
task_info_style.complexity_label.text_color = Color.terminal_text_body_sub_header(255, true)
task_info_style.complexity_icon = {}
local task_info_complexity_icon = task_info_style.complexity_icon
task_info_complexity_icon.vertical_alignment = "bottom"
task_info_complexity_icon.horizontal_alignment = "left"
task_info_complexity_icon.size = {
	28,
	28
}
task_info_style.complexity_text = table.clone(task_info_style.completion_text)
local task_info_complexity_text_style = task_info_style.complexity_text
task_info_complexity_text_style.offset = {
	task_info_complexity_icon.size[1],
	0,
	5
}
task_info_style.completed_text = table.clone(UIFontSettings.header_2)
local task_info_completed_text_style = task_info_style.completed_text
task_info_completed_text_style.offset = {
	-contract_info_header_style.margin,
	-30,
	2
}
task_info_completed_text_style.size = ButtonPassTemplates.terminal_button.size
task_info_completed_text_style.text_color = Color.terminal_text_header(255, true)
task_info_completed_text_style.vertical_alignment = "bottom"
task_info_completed_text_style.horizontal_alignment = "right"
task_info_completed_text_style.text_vertical_alignment = "center"
task_info_completed_text_style.text_horizontal_alignment = "right"
task_info_style.completed_overlay = {}
local task_info_completed_overlay_style = task_info_style.completed_overlay
task_info_completed_overlay_style.offset = {
	0,
	0,
	9
}
task_info_completed_overlay_style.color = {
	100,
	0,
	0,
	0
}

return settings("ContractsViewStyles", contracts_view_styles)
