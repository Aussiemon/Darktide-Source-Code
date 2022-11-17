local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local ViewStyles = require("scripts/ui/views/contracts_view/contracts_view_styles")
local ViewSettings = require("scripts/ui/views/contracts_view/contracts_view_settings")
local WalletSettings = require("scripts/settings/wallet_settings")
local UISettings = require("scripts/settings/ui/ui_settings")
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
	80
}
local contract_progress_size = ViewStyles.contract_progress.size
local task_grid_size = {
	grid_size[1] + 2 * grid_margin,
	grid_size[2]
}
local task_grid_mask_size = {
	grid_size[1] + 40,
	grid_size[2]
}
local reroll_button_size = ButtonPassTemplates.default_button.size
local task_info_size = ViewStyles.task_info.size
local task_info_nugget_size = {
	150,
	60
}
local contract_info_header_position = {
	0,
	-contract_info_header_size[2] + 14,
	0
}
local contract_progress_position = {
	71,
	123,
	1
}
local contract_info_position = {
	40,
	90,
	1
}
local task_grid_position = {
	0,
	80,
	1
}
local reroll_button_position = {
	0,
	100,
	10
}
local task_info_reward_position = {
	-contract_info_margin,
	-27,
	1
}
local task_info_completion_position = {
	contract_info_margin,
	-27,
	1
}
local task_info_complexity_position = {
	200,
	-27,
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
		parent = "task_grid",
		horizontal_alignment = "left",
		size = contract_info_header_size,
		position = contract_info_header_position
	},
	contract_info = {
		vertical_alignment = "bottom",
		parent = "task_grid",
		horizontal_alignment = "left",
		size = contract_info_size,
		position = contract_info_position
	},
	contract_progress = {
		vertical_alignment = "bottom",
		parent = "task_grid",
		horizontal_alignment = "left",
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
		parent = "task_grid",
		horizontal_alignment = "left",
		size = task_info_size,
		position = {
			grid_size[1] + 60,
			-16,
			0
		}
	},
	task_info_reward = {
		vertical_alignment = "bottom",
		parent = "task_info_plate",
		horizontal_alignment = "right",
		size = task_info_nugget_size,
		position = task_info_reward_position
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
			value_id = "list_header_text",
			pass_type = "text",
			style_id = "list_header_text",
			value = Localize("loc_contracts_list_title")
		},
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
	}, "contract_info_header", nil, nil, ViewStyles.contract_info_header),
	contract_info = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "background"
		},
		{
			value = "content/ui/materials/backgrounds/headline_terminal",
			value_id = "background_highlight",
			pass_type = "texture",
			style_id = "background_highlight"
		},
		{
			value = "content/ui/materials/frames/frame_glow_01",
			value_id = "frame",
			pass_type = "texture",
			style_id = "frame"
		},
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
	}, "contract_info", nil, nil, ViewStyles.contract_info),
	contract_progress = UIWidget.create_definition({
		{
			value = "N/A",
			value_id = "progress_text",
			pass_type = "text",
			style_id = "progress_text"
		},
		{
			value = "content/ui/materials/backgrounds/default_square",
			style_id = "progress_bar_background",
			pass_type = "texture"
		},
		{
			value = "content/ui/materials/bars/contracts_progress_overall_fill",
			style_id = "progress_bar",
			pass_type = "texture"
		},
		{
			value = "content/ui/materials/bars/medium/end",
			style_id = "progress_bar_edge",
			pass_type = "texture"
		}
	}, "contract_progress", nil, nil, ViewStyles.contract_progress),
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
	task_grid_background = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "background"
		}
	}, "task_grid", nil, nil, ViewStyles.task_grid_background),
	task_info = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "background_rect"
		},
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			value_id = "background",
			pass_type = "texture",
			style_id = "background"
		},
		{
			value = "content/ui/materials/dividers/horizontal_frame_big_upper",
			value_id = "edge_top",
			pass_type = "texture",
			style_id = "edge_top"
		},
		{
			value = "content/ui/materials/dividers/horizontal_frame_big_lower",
			value_id = "edge_bottom",
			pass_type = "texture",
			style_id = "edge_bottom"
		},
		{
			style_id = "icon",
			pass_type = "texture",
			value_id = "icon",
			value = "content/ui/materials/icons/contracts/contract_task",
			change_function = ViewStyles.task_info_change_function
		},
		{
			style_id = "label",
			pass_type = "text",
			value_id = "label",
			value = "",
			change_function = ViewStyles.task_info_change_function
		},
		{
			style_id = "description",
			pass_type = "text",
			value_id = "description",
			value = "",
			change_function = ViewStyles.task_info_change_function
		},
		{
			value_id = "reward_label",
			style_id = "reward_label",
			pass_type = "text",
			scenegraph_id = "task_info_reward",
			value = Localize("loc_contracts_contract_task_info_reward_label")
		},
		{
			style_id = "reward_icon",
			pass_type = "texture",
			value_id = "reward_icon",
			value = wallet_settings.icon_texture_big,
			change_function = ViewStyles.task_info_change_function
		},
		{
			value_id = "reward_text",
			pass_type = "text",
			style_id = "reward_text",
			change_function = ViewStyles.task_info_change_function
		},
		{
			value_id = "completion_label",
			style_id = "completion_label",
			pass_type = "text",
			scenegraph_id = "task_info_completion",
			value = Localize("loc_contracts_contract_task_info_completion_label")
		},
		{
			style_id = "completion_text",
			pass_type = "text",
			scenegraph_id = "task_info_completion",
			value = "",
			value_id = "completion_text",
			change_function = ViewStyles.task_info_change_function
		},
		{
			value_id = "complexity_label",
			style_id = "complexity_label",
			pass_type = "text",
			scenegraph_id = "task_info_complexity",
			value = Localize("loc_contracts_contract_task_info_complexity_label")
		},
		{
			style_id = "complexity_icon",
			pass_type = "texture",
			scenegraph_id = "task_info_complexity",
			value = "content/ui/materials/icons/contracts/complexity_tutorial",
			value_id = "complexity_icon",
			change_function = ViewStyles.task_info_change_function
		},
		{
			style_id = "complexity_text",
			pass_type = "text",
			scenegraph_id = "task_info_complexity",
			value = "",
			value_id = "complexity_text",
			change_function = ViewStyles.task_info_change_function
		},
		{
			value_id = "completed_text",
			style_id = "completed_text",
			pass_type = "text",
			value = Localize("loc_contracts_task_completed"),
			visibility_function = ViewStyles.task_info_fulfilled_visibility
		},
		{
			style_id = "completed_overlay",
			pass_type = "rect",
			visibility_function = ViewStyles.task_info_fulfilled_visibility
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
	list_padding = {
		size = ViewStyles.list_padding.size
	},
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
				style_id = "background",
				pass_type = "texture",
				value_id = "background",
				value = "content/ui/materials/backgrounds/default_square",
				change_function = ViewStyles.task_list_item_background_change_function
			},
			{
				style_id = "background_gradient",
				pass_type = "texture",
				value_id = "background_gradient",
				value = "content/ui/materials/masks/gradient_horizontal_sides_dynamic_02",
				change_function = ViewStyles.task_list_item_hover_change_function
			},
			{
				style_id = "frame",
				pass_type = "texture",
				value_id = "frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				change_function = ViewStyles.task_list_item_hover_change_function
			},
			{
				style_id = "corner",
				pass_type = "texture",
				value_id = "corner",
				value = "content/ui/materials/frames/frame_corner_2px",
				change_function = ViewStyles.task_list_item_hover_change_function
			},
			{
				style_id = "icon",
				pass_type = "texture",
				value_id = "icon",
				value = "content/ui/materials/icons/contracts/contract_task",
				change_function = ViewStyles.task_list_item_task_icon_change_function
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
				value = "content/ui/materials/backgrounds/default_square",
				style_id = "progress_bar_background",
				pass_type = "texture",
				visibility_function = ViewStyles.task_list_progress_bar_visibility_function
			},
			{
				style_id = "progress_bar_frame",
				pass_type = "texture",
				value = "content/ui/materials/backgrounds/default_square",
				change_function = ViewStyles.task_list_item_hover_change_function,
				visibility_function = ViewStyles.task_list_progress_bar_visibility_function
			},
			{
				value = "content/ui/materials/bars/simple/fill",
				style_id = "progress_bar",
				pass_type = "texture",
				visibility_function = ViewStyles.task_list_progress_bar_visibility_function
			},
			{
				value = "content/ui/materials/bars/simple/end",
				style_id = "progress_bar_edge",
				pass_type = "texture",
				visibility_function = ViewStyles.task_list_progress_bar_visibility_function
			},
			{
				style_id = "completed_overlay",
				pass_type = "rect",
				visibility_function = ViewStyles.task_list_completion_visibility_function
			},
			{
				style_id = "task_completed_text",
				pass_type = "text",
				value_id = "task_completed_text",
				value = "Completed",
				change_function = ViewStyles.task_list_item_task_name_change_function,
				visibility_function = ViewStyles.task_list_completion_visibility_function
			}
		},
		style = ViewStyles.task_list_item,
		init = function (parent, widget, config, callback_name, secondary_callback_name, ui_renderer)
			local task_info = config.task_info
			local task_type = task_info.criteria.taskType
			local task_is_fulfilled = task_info.fulfilled
			local task_name = config.task_name
			local normalized_progress = config.task_progress_normalized
			local reward_amount = task_info.reward.amount
			local reward_text = string.format(ViewSettings.contract_reward_string_format, reward_amount)
			local widget_content = widget.content
			widget_content.task_name = task_name
			widget_content.task_description = config.task_description
			widget_content.task_target = config.task_target
			widget_content.task_reward_text = reward_text
			widget_content.task_info = task_info
			widget_content.task_is_fulfilled = task_is_fulfilled
			local hotspot = widget_content.hotspot
			hotspot.pressed_callback = callback(parent, callback_name, widget, config)
			local widget_style = widget.style
			local progress_bar_style = widget_style.progress_bar
			local progress_bar_width = normalized_progress * progress_bar_style.size[1]
			progress_bar_style.size[1] = progress_bar_width
			local material_values = widget_style.icon.material_values
			material_values.contract_type = task_type and UISettings.contracts_icons_by_type[task_type] or UISettings.contracts_icons_by_type.default
			material_values.checkbox = task_is_fulfilled and 1 or 0
			local task_progress_bar_edge_style = widget_style.progress_bar_edge
			task_progress_bar_edge_style.offset[1] = task_progress_bar_edge_style.offset[1] + progress_bar_width
			local alpha_multiplier = math.clamp(normalized_progress / 0.2, 0, 1)
			task_progress_bar_edge_style.color[1] = 255 * alpha_multiplier

			if task_is_fulfilled then
				local reward_icon_style = widget_style.task_reward_icon
				reward_icon_style.color = reward_icon_style.fulfilled_color
				local reward_text_style = widget_style.task_reward_text
				reward_text_style.text_color = reward_text_style.fulfilled_color
			end
		end
	}
}
local task_grid_settings = {
	scrollbar_vertical_margin = 20,
	timer_loc_string = "loc_contracts_time_left",
	use_terminal_background = true,
	title_height = 0,
	grid_spacing = {
		grid_size[1],
		8
	},
	grid_size = grid_size,
	mask_size = task_grid_mask_size,
	scrollbar_pass_templates = ScrollbarPassTemplates.terminal_scrollbar,
	scrollbar_width = ScrollbarPassTemplates.terminal_scrollbar.default_width,
	edge_padding = grid_margin * 2
}
local contracts_view_definitions = {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	widget_blueprints = widget_blueprints,
	task_grid_settings = task_grid_settings
}

return settings("ContractsViewDefinitions", contracts_view_definitions)
