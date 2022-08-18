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
contracts_view_styles.contract_info = {}
local contract_info_style = contracts_view_styles.contract_info
contract_info_style.size = {
	left_column_width,
	246
}
contract_info_style.background_candles = {
	offset = {
		0,
		0,
		5
	}
}
contract_info_style.label = table.clone(UIFontSettings.body)
local contract_info_label_style = contract_info_style.label
contract_info_label_style.text_vertical_alignment = "bottom"
contract_info_style.reward_icon = {}
local reward_icon_style = contract_info_style.reward_icon
reward_icon_style.size = {
	52,
	44
}
reward_icon_style.horizontal_alignment = "right"
reward_icon_style.offset = {
	-6,
	-5,
	0
}
reward_icon_style.default_offset = table.clone(reward_icon_style.offset)
contract_info_style.reward_text = table.clone(UIFontSettings.currency_title)
local reward_text_style = contract_info_style.reward_text
reward_text_style.font_size = 40
reward_text_style.material = wallet_settings.font_gradient_material
reward_text_style.text_horizontal_alignment = "right"
reward_text_style.text_vertical_alignment = "bottom"
reward_text_style.offset = {
	0,
	5,
	1
}
contracts_view_styles.contract_progress = {}
local contract_progress_style = contracts_view_styles.contract_progress
contract_progress_style.size = {
	contract_info_style.size[1] - contract_info_margin * 2,
	22
}
contract_progress_style.margin = contract_info_margin
contract_progress_style.progress_text = table.clone(UIFontSettings.body)
local contract_progress_text_style = contract_progress_style.progress_text
contract_progress_text_style.text_horizontal_alignment = "right"
contract_progress_text_style.text_vertical_alignment = "center"
contract_progress_style.progress_bar_background = {}
local progress_bar_background_style = contract_progress_style.progress_bar_background
progress_bar_background_style.size = {
	478,
	22
}
contract_progress_style.progress_bar = {}
local contract_progress_bar_style = contract_progress_style.progress_bar
contract_progress_bar_style.size = {
	468,
	12
}
contract_progress_bar_style.default_size = table.clone(contract_progress_bar_style.size)
contract_progress_bar_style.offset = {
	5,
	5,
	1
}
contract_progress_style.progress_bar_edge = {}
local contract_progress_bar_edge_style = contract_progress_style.progress_bar_edge
contract_progress_bar_edge_style.size = {
	12,
	24
}
contract_progress_bar_edge_style.offset = {
	-1,
	-1,
	1
}
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
local grid_margin = 30
local task_grid_size = {
	left_column_width - 2 * grid_margin,
	613
}
contracts_view_styles.task_grid = {
	size = task_grid_size,
	grid_margin = grid_margin,
	spacing = {
		task_grid_size[1],
		5
	}
}
contracts_view_styles.task_list_item = {}
local task_list_item_style = contracts_view_styles.task_list_item
task_list_item_style.size = {
	task_grid_size[1],
	64
}
task_list_item_style.double_size = {
	task_grid_size[1],
	94
}
task_list_item_style.text_vertical_margin = 45
task_list_item_style.background = {}
local task_list_item_background_style = task_list_item_style.background
task_list_item_background_style.color = Color.ui_terminal(255, true)
task_list_item_style.task_name = table.clone(UIFontSettings.list_button)
local task_name_style = task_list_item_style.task_name
task_name_style.text_vertical_alignment = "top"
task_name_style.offset = {
	12,
	15,
	1
}
task_name_style.size = {
	440,
	30
}
task_name_style.fulfilled_color = Color.ui_grey_medium(255, true)
task_list_item_style.task_reward_icon = {}
local task_reward_icon_style = task_list_item_style.task_reward_icon
task_reward_icon_style.size = {
	28,
	20
}
task_reward_icon_style.horizontal_alignment = "right"
task_reward_icon_style.offset = {
	-16,
	18,
	0
}
task_reward_icon_style.default_offset = table.clone(reward_icon_style.offset)
task_list_item_style.task_reward_text = table.clone(task_list_item_style.task_name)
local task_reward_text_style = task_list_item_style.task_reward_text
task_reward_text_style.text_horizontal_alignment = "right"
task_reward_text_style.offset[1] = -12
task_reward_text_style.text_color = Color.white(255, true)
task_reward_text_style.material = wallet_settings.font_gradient_material
task_reward_text_style.size = nil
task_list_item_style.progress_bar_background = {}
progress_bar_background_style = task_list_item_style.progress_bar_background
progress_bar_background_style.vertical_alignment = "bottom"
progress_bar_background_style.offset = {
	8,
	-6,
	0
}
progress_bar_background_style.size = {
	task_list_item_style.size[1] - 16,
	10
}
task_list_item_style.progress_bar = table.clone(task_list_item_style.progress_bar_background)
local task_progress_bar_style = task_list_item_style.progress_bar
task_progress_bar_style.offset = {
	progress_bar_background_style.offset[1] + 3,
	progress_bar_background_style.offset[2] - 3,
	2
}
task_progress_bar_style.size = {
	progress_bar_background_style.size[1] - 6,
	4
}
task_list_item_style.progress_bar_edge = {}
local task_progress_bar_edge_style = task_list_item_style.progress_bar_edge
task_progress_bar_edge_style.size = {
	12,
	16
}
task_progress_bar_edge_style.vertical_alignment = "bottom"
task_progress_bar_edge_style.offset = {
	progress_bar_background_style.offset[1] - 3,
	-3,
	3
}
task_list_item_style.highlight = {
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
local task_list_item_highlight_size_addition = 10

contracts_view_styles.task_list_item_background_change_function = function (content, style)
	local hotspot = content.hotspot
	style.color[1] = 255 * math.max(hotspot.anim_select_progress)
end

contracts_view_styles.task_list_item_task_name_change_function = function (content, style)
	local default_color = (content.hotspot.disabled and style.disabled_color) or style.default_color
	local hotspot = content.hotspot
	local hover_progress = hotspot.anim_hover_progress
	local select_progress = hotspot.anim_select_progress
	local progress = math.max(hover_progress, select_progress)

	color_lerp(default_color, style.hover_color, progress, style.text_color)

	style.hdr = progress == 1
end

contracts_view_styles.task_list_item_highlight_change_function = function (content, style)
	local hotspot = content.hotspot
	local progress = math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress)
	style.color[1] = 255 * math.easeOutCubic(progress)
	local size_addition = task_list_item_highlight_size_addition * math.easeInCubic(1 - progress)
	local style_size_additon = style.size_addition
	style_size_additon[1] = size_addition * 2
	style.size_addition[2] = size_addition * 2
	local offset = style.offset
	offset[1] = -size_addition
	offset[2] = -size_addition
	style.hdr = progress == 1
end

contracts_view_styles.task_info = {}
local task_info_style = contracts_view_styles.task_info
task_info_style.size = {
	850,
	320
}
task_info_style.background = {}
local task_info_background_style = task_info_style.background
task_info_background_style.color = Color.black(255, true)
task_info_style.divider = {}
local task_info_divider_style = task_info_style.divider
task_info_divider_style.offset = {
	30,
	62,
	0
}
task_info_divider_style.default_offset = table.clone(task_info_divider_style.offset)
task_info_divider_style.size = {
	task_info_style.size[1] - 2 * task_info_divider_style.offset[1],
	18
}
task_info_style.label = table.clone(UIFontSettings.header_2)
local task_info_label_style = task_info_style.label
task_info_label_style.offset = {
	contract_info_margin,
	22,
	1
}
task_info_label_style.size = {
	630,
	30
}
task_info_label_style.default_size = table.clone(task_info_label_style.size)
task_info_label_style.material = "content/ui/materials/font_gradients/slug_font_gradient_header"
task_info_label_style.text_color = Color.white(255, true)
task_info_style.reward_icon = {}
local task_info_reward_icon_style = task_info_style.reward_icon
task_info_reward_icon_style.size = {
	52,
	44
}
task_info_reward_icon_style.horizontal_alignment = "right"
task_info_reward_icon_style.offset = {
	-contract_info_margin - 6,
	10,
	0
}
task_info_reward_icon_style.default_offset = table.clone(task_info_reward_icon_style.offset)
task_info_style.reward_text = table.clone(UIFontSettings.currency_title)
local task_info_reward_text_style = task_info_style.reward_text
task_info_reward_text_style.horizontal_alignment = "right"
task_info_reward_text_style.text_horizontal_alignment = "right"
task_info_reward_text_style.text_vertical_alignment = "top"
task_info_reward_text_style.offset = {
	-contract_info_margin,
	14,
	1
}
task_info_reward_text_style.size = {
	task_info_style.size[1] - 2 * contract_info_margin - task_info_label_style.size[1],
	task_info_label_style.size[2]
}
task_info_reward_text_style.material = wallet_settings.font_gradient_material
task_info_reward_text_style.default_material = task_info_reward_text_style.material
task_info_reward_text_style.fulfilled_color = Color.ui_grey_medium(255, true)
task_info_reward_text_style.default_color = table.clone(task_info_reward_text_style.text_color)
task_info_style.description = table.clone(UIFontSettings.body)
local task_info_description_style = task_info_style.description
task_info_description_style.offset = {
	contract_info_margin,
	task_info_divider_style.offset[2] + contract_info_margin,
	0
}
task_info_description_style.default_offset = table.clone(task_info_description_style.offset)
task_info_description_style.size = {
	task_info_style.size[1] - 2 * contract_info_margin,
	30
}
task_info_style.completion_label = table.clone(UIFontSettings.header_5)
task_info_style.completion_text = table.clone(UIFontSettings.body)
task_info_style.completion_text.text_vertical_alignment = "bottom"
task_info_style.complexity_label = table.clone(UIFontSettings.header_5)
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
	1
}
task_info_style.reroll_cost_icon = {}
local task_info_reroll_cost_icon_style = task_info_style.reroll_cost_icon
task_info_reroll_cost_icon_style.size = {
	52,
	44
}
task_info_style.reroll_cost_text = table.clone(UIFontSettings.currency_title)
local task_info_reroll_cost_text_style = task_info_style.reroll_cost_text
task_info_reroll_cost_text_style.text_horizontal_alignment = "left"
task_info_reroll_cost_text_style.material = WalletSettings.credits.font_gradient_material
task_info_reroll_cost_text_style.default_material = task_info_reroll_cost_text_style.material
task_info_reroll_cost_text_style.insufficient_funds_material = WalletSettings.credits.font_gradient_material_insufficient_funds
task_info_reroll_cost_text_style.offset = {
	6,
	0,
	0
}
task_info_reroll_cost_text_style.default_offset = table.clone(task_info_reroll_cost_text_style.offset)

return settings("ContractsViewStyles", contracts_view_styles)
