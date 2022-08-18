local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local ViewStyles = require("scripts/ui/views/contracts_view/contracts_view_styles")
local ViewSettings = require("scripts/ui/views/contracts_view/contracts_view_settings")
local WalletSettings = require("scripts/settings/wallet_settings")
local wallet_settings = WalletSettings[ViewSettings.wallet_type]
local task_grid_style = ViewStyles.task_grid
local grid_size = task_grid_style.size
local grid_margin = task_grid_style.grid_margin
local visible_area_margins = {
	180,
	150
}
local contract_info_margin = ViewStyles.contract_info_header.margin
local screen_size = UIWorkspaceSettings.screen.size
local visible_area_size = {
	screen_size[1] - 2 * visible_area_margins[1],
	screen_size[2] - 2 * visible_area_margins[2]
}
local contract_info_header_size = ViewStyles.contract_info_header.size
local contract_info_size = {
	contract_info_header_size[1] - contract_info_margin * 2,
	40
}
local contract_progress_size = ViewStyles.contract_progress.size
local task_grid_size = grid_size
local task_grid_mask_size = {
	grid_size[1] + 2 * grid_margin,
	grid_size[2]
}
local reroll_button_size = ButtonPassTemplates.default_button.size
local task_info_size = ViewStyles.task_info.size
local task_info_nugget_size = {
	150,
	60
}
local task_info_cost_size = {
	reroll_button_size[1],
	ViewStyles.task_info.reroll_cost_icon.size[2]
}
local contract_info_header_position = {
	0,
	-66,
	0
}
local contract_progress_position = {
	0,
	-30,
	1
}
local contract_info_position = {
	0,
	contract_progress_position[2] - contract_progress_size[2],
	1
}
local task_grid_position = {
	0,
	168,
	1
}
local reroll_button_position = {
	-contract_info_margin,
	-80,
	1
}
local task_info_completion_position = {
	contract_info_margin,
	-87,
	1
}
local task_info_complexity_position = {
	200,
	-87,
	1
}
local task_info_cost_position = {
	-contract_info_margin,
	-22,
	1
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	visible_area = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = visible_area_size,
		position = {
			0,
			0,
			0
		}
	},
	contract_info_header = {
		vertical_alignment = "top",
		parent = "visible_area",
		horizontal_alignment = "left",
		size = contract_info_header_size,
		position = contract_info_header_position
	},
	contract_info = {
		vertical_alignment = "bottom",
		parent = "contract_info_header",
		horizontal_alignment = "center",
		size = contract_info_size,
		position = contract_info_position
	},
	contract_progress = {
		vertical_alignment = "bottom",
		parent = "contract_info_header",
		horizontal_alignment = "center",
		size = contract_progress_size,
		position = contract_progress_position
	},
	task_grid = {
		vertical_alignment = "top",
		parent = "visible_area",
		horizontal_alignment = "left",
		size = task_grid_size,
		position = task_grid_position
	},
	task_info_plate = {
		vertical_alignment = "bottom",
		parent = "visible_area",
		horizontal_alignment = "right",
		size = task_info_size,
		position = {
			0,
			0,
			0
		}
	},
	task_info_completion = {
		vertical_alignment = "bottom",
		parent = "task_info_plate",
		horizontal_alignment = "left",
		size = task_info_nugget_size,
		position = task_info_completion_position
	},
	task_info_complexity = {
		vertical_alignment = "bottom",
		parent = "task_info_plate",
		horizontal_alignment = "left",
		size = task_info_nugget_size,
		position = task_info_complexity_position
	},
	task_info_cost = {
		vertical_alignment = "bottom",
		parent = "task_info_plate",
		horizontal_alignment = "right",
		size = task_info_cost_size,
		position = task_info_cost_position
	},
	reroll_button = {
		vertical_alignment = "bottom",
		parent = "task_info_plate",
		horizontal_alignment = "right",
		size = reroll_button_size,
		position = reroll_button_position
	}
}
local widget_definitions = {
	contract_info_header = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/contracts_top",
			style_id = "background",
			pass_type = "texture"
		},
		{
			value = "content/ui/materials/effects/contracts_top_candles",
			style_id = "background_candles",
			pass_type = "texture"
		}
	}, "contract_info_header", nil),
	contract_info = UIWidget.create_definition({
		{
			value_id = "label",
			pass_type = "text",
			style_id = "label",
			value = Localize("loc_contracts_contract_reward_label")
		},
		{
			value_id = "reward_icon",
			pass_type = "texture",
			style_id = "reward_icon",
			value = wallet_settings.icon_texture_big
		},
		{
			value = "N/A",
			value_id = "reward_text",
			pass_type = "text",
			style_id = "reward_text"
		}
	}, "contract_info", {
		visible = false
	}, nil, ViewStyles.contract_info),
	contract_progress = UIWidget.create_definition({
		{
			value = "N/A",
			value_id = "progress_text",
			pass_type = "text",
			style_id = "progress_text"
		},
		{
			value = "content/ui/materials/bars/medium/frame",
			style_id = "progress_bar_background",
			pass_type = "texture"
		},
		{
			value = "content/ui/materials/bars/medium/fill",
			style_id = "progress_bar",
			pass_type = "texture"
		},
		{
			value = "content/ui/materials/bars/medium/end",
			style_id = "progress_bar_edge",
			pass_type = "texture"
		}
	}, "contract_progress", {
		visible = false
	}, nil, ViewStyles.contract_progress),
	contract_fulfilled = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			style_id = "text",
			value = Localize("loc_contracts_contract_fulfilled")
		}
	}, "contract_info", {
		visible = false
	}, nil, ViewStyles.contract_fulfilled),
	task_info = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/line_medium_inner_shadow",
			style_id = "background",
			pass_type = "texture"
		},
		{
			value = "",
			value_id = "label",
			pass_type = "text",
			style_id = "label"
		},
		{
			value_id = "reward_icon",
			pass_type = "texture",
			style_id = "reward_icon",
			value = wallet_settings.icon_texture_big
		},
		{
			style_id = "reward_text",
			value_id = "reward_text",
			pass_type = "text"
		},
		{
			value = "content/ui/materials/dividers/skull_rendered_left_01",
			style_id = "divider",
			pass_type = "texture"
		},
		{
			style_id = "description",
			value_id = "description",
			pass_type = "text"
		},
		{
			value_id = "completion_label",
			style_id = "completion_label",
			pass_type = "text",
			scenegraph_id = "task_info_completion",
			value = Localize("loc_contracts_contract_task_info_completion_label")
		},
		{
			value_id = "completion_text",
			style_id = "completion_text",
			pass_type = "text",
			scenegraph_id = "task_info_completion",
			value = Localize("loc_contracts_contract_task_info_completion_label")
		},
		{
			value_id = "complexity_label",
			style_id = "complexity_label",
			pass_type = "text",
			scenegraph_id = "task_info_complexity",
			value = Localize("loc_contracts_contract_task_info_complexity_label")
		},
		{
			value_id = "complexity_icon",
			style_id = "complexity_icon",
			pass_type = "texture",
			scenegraph_id = "task_info_complexity",
			value = "content/ui/materials/icons/contracts/complexity_tutorial"
		},
		{
			value_id = "complexity_text",
			style_id = "complexity_text",
			pass_type = "text",
			scenegraph_id = "task_info_complexity",
			value = Localize("loc_contracts_contract_task_info_complexity_label")
		},
		{
			value_id = "reroll_cost_icon",
			style_id = "reroll_cost_icon",
			pass_type = "texture",
			scenegraph_id = "task_info_cost",
			value = WalletSettings.credits.icon_texture_big
		},
		{
			value_id = "reroll_cost_text",
			style_id = "reroll_cost_text",
			pass_type = "text",
			scenegraph_id = "task_info_cost",
			value = "0"
		}
	}, "task_info_plate", {
		visible = false
	}, nil, ViewStyles.task_info),
	reroll_button = UIWidget.create_definition(ButtonPassTemplates.default_button, "reroll_button", {
		text = "",
		visible = false
	})
}
local widget_blueprints = {
	task_list_item = {
		size_function = function (parent, config)
			return config.size
		end,
		pass_template = {
			{
				style_id = "hotspot",
				pass_type = "hotspot",
				content_id = "hotspot",
				content = {
					use_is_focused = true
				}
			},
			{
				value = "content/ui/materials/buttons/background_selected",
				style_id = "background",
				pass_type = "texture",
				change_function = ViewStyles.task_list_item_background_change_function
			},
			{
				style_id = "task_name",
				pass_type = "text",
				value_id = "task_name",
				value = "N/A",
				change_function = ViewStyles.task_list_item_task_name_change_function
			},
			{
				value_id = "task_reward_icon",
				pass_type = "texture",
				style_id = "task_reward_icon",
				value = wallet_settings.icon_texture_small
			},
			{
				value = "",
				value_id = "task_reward_text",
				pass_type = "text",
				style_id = "task_reward_text"
			},
			{
				value = "content/ui/materials/bars/simple/frame",
				style_id = "progress_bar_background",
				pass_type = "texture"
			},
			{
				value = "content/ui/materials/bars/simple/fill",
				style_id = "progress_bar",
				pass_type = "texture"
			},
			{
				value = "content/ui/materials/bars/simple/end",
				style_id = "progress_bar_edge",
				pass_type = "texture"
			},
			{
				style_id = "highlight",
				pass_type = "texture",
				value = "content/ui/materials/frames/hover",
				visibility_function = ButtonPassTemplates.list_button_focused_visibility_function,
				change_function = ViewStyles.task_list_item_highlight_change_function
			}
		},
		style = ViewStyles.task_list_item,
		init = function (parent, widget, config, callback_name, secondary_callback_name, ui_renderer)
			local task_info = config.task_info
			local task_is_fulfilled = task_info.fulfilled
			local task_name = config.task_name
			local normalized_progress = config.task_progress_normalized
			local reward_amount = task_info.reward.amount
			local reward_text = (task_is_fulfilled and ViewSettings.task_fulfilled_check_mark) or string.format(ViewSettings.contract_reward_string_format, reward_amount)
			local widget_content = widget.content
			widget_content.task_name = task_name
			widget_content.task_description = config.task_description
			widget_content.task_target = config.task_target
			widget_content.task_reward_text = reward_text
			local hotspot = widget_content.hotspot
			hotspot.pressed_callback = callback(parent, callback_name, widget, config)
			hotspot.selected_callback = callback(config.selected_callback, widget, task_info)
			local widget_style = widget.style
			local progress_bar_style = widget_style.progress_bar
			local progress_bar_width = normalized_progress * progress_bar_style.size[1]
			progress_bar_style.size[1] = progress_bar_width
			local task_progress_bar_edge_style = widget_style.progress_bar_edge
			task_progress_bar_edge_style.offset[1] = task_progress_bar_edge_style.offset[1] + progress_bar_width
			local task_name_style = widget_style.task_name
			local reward_text_style = widget_style.task_reward_text
			local reward_icon_style = widget_style.task_reward_icon

			if task_is_fulfilled then
				reward_icon_style.visible = false
				task_name_style.default_color = task_name_style.fulfilled_color
				reward_text_style.material = nil
				reward_text_style.text_color = reward_text_style.fulfilled_color
			else
				local reward_text_width = UIRenderer.text_size(ui_renderer, reward_text, reward_text_style.font_type, reward_text_style.font_size)
				reward_icon_style.offset[1] = reward_icon_style.offset[1] - reward_text_width
			end
		end
	}
}
local task_grid_settings = {
	scrollbar_vertical_margin = 20,
	timer_loc_string = "loc_contracts_time_left",
	title_height = 0,
	grid_spacing = {
		task_grid_size[1],
		5
	},
	grid_size = task_grid_size,
	mask_size = task_grid_mask_size,
	scrollbar_pass_templates = ScrollbarPassTemplates.metal_scrollbar,
	scrollbar_width = ScrollbarPassTemplates.metal_scrollbar.default_width,
	edge_padding = grid_margin * 2
}
local contracts_view_definitions = {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	widget_blueprints = widget_blueprints,
	task_grid_settings = task_grid_settings
}

return settings("ContractsViewDefinitions", contracts_view_definitions)
