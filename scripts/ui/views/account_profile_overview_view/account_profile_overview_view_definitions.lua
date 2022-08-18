local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementMenuPanel = require("scripts/ui/view_elements/view_element_menu_panel/view_element_menu_panel")
local ViewStyles = require("scripts/ui/views/account_profile_overview_view/account_profile_overview_view_styles")
local BOONS_COLUMN = "boons_column"
local COMMENDATIONS_COLUMN = "commendations_column"
local CONTRACTS_COLUMN = "contracts_column"
local headline_divider_style = ViewStyles.column_style.headline_divider
local screen_size = UIWorkspaceSettings.screen.size
local top_panel_size = UIWorkspaceSettings.top_panel.size
local bottom_panel_size = UIWorkspaceSettings.bottom_panel.size
local progress_bar_width = ViewStyles.progress_bar_size[1]
local progress_bar_height = ViewStyles.progress_bar_size[2]
local reward_icon_size = ViewStyles.reward_icon_outer_size
local list_item_size = ViewStyles.list_item.size
local column_width = ViewStyles.column_width
local column_height = ViewStyles.column_height
local column_header_height = headline_divider_style.offset[2] + headline_divider_style.size[2] + 4
local list_height = column_height - column_header_height
local list_offset_x = (column_width - list_item_size[1]) / 2
local mask_margin = ViewStyles.grid_mask_expansion
local scrollbar_width = 10
local scrollbar_height = list_height
local scrollbar_offset = {
	scrollbar_width + 10,
	0,
	6
}
local visible_area_width = screen_size[1]
local visible_area_height = screen_size[2] - (top_panel_size[2] + bottom_panel_size[2])
local scenegraph = {
	screen = UIWorkspaceSettings.screen,
	visible_area = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			visible_area_width,
			visible_area_height
		},
		position = {
			0,
			top_panel_size[2],
			1
		}
	},
	header = {
		vertical_alignment = "top",
		parent = "visible_area",
		horizontal_alignment = "left",
		size = {
			visible_area_width,
			250
		},
		position = {
			0,
			0,
			1
		}
	},
	header_inner = {
		vertical_alignment = "top",
		parent = "header",
		horizontal_alignment = "center",
		size = {
			1577,
			176
		},
		position = {
			8,
			54,
			1
		}
	},
	player_name = {
		vertical_alignment = "top",
		parent = "header_inner",
		horizontal_alignment = "left",
		size = {
			progress_bar_width,
			70
		},
		position = {
			0,
			12,
			1
		}
	},
	account_rank = {
		vertical_alignment = "top",
		parent = "header_inner",
		horizontal_alignment = "left",
		size = {
			270,
			23
		},
		position = {
			84,
			85,
			1
		}
	},
	progress_bar = {
		vertical_alignment = "bottom",
		parent = "header_inner",
		horizontal_alignment = "left",
		size = {
			progress_bar_width,
			progress_bar_height
		},
		position = {
			0,
			0,
			1
		}
	},
	progression_reward_icon = {
		vertical_alignment = "bottom",
		parent = "header_inner",
		horizontal_alignment = "right",
		size = {
			reward_icon_size,
			reward_icon_size
		},
		position = {
			0,
			-6,
			1
		}
	},
	progression_reward_label = {
		vertical_alignment = "top",
		parent = "header_inner",
		horizontal_alignment = "right",
		size = {
			reward_icon_size + 30,
			23
		},
		position = {
			15,
			2,
			1
		}
	},
	show_all_commendations_button = {
		vertical_alignment = "bottom",
		horizontal_alignment = "left",
		parent = COMMENDATIONS_COLUMN,
		size = {
			column_width,
			64
		},
		position = {
			0,
			20,
			5
		}
	}
}
local columns = {
	BOONS_COLUMN,
	COMMENDATIONS_COLUMN,
	CONTRACTS_COLUMN
}
local horizontal_alignments = {
	"left",
	"center",
	"right"
}

for i, column in ipairs(columns) do
	local column_position = -((i - 2) * 175)
	local list_name = column .. "_list"
	scenegraph[column] = {
		vertical_alignment = "top",
		parent = "visible_area",
		size = {
			column_width,
			column_height
		},
		position = {
			column_position,
			300,
			1
		},
		horizontal_alignment = horizontal_alignments[i]
	}
	scenegraph[list_name] = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		parent = column,
		size = {
			column_width,
			list_height
		},
		position = {
			0,
			column_header_height,
			1
		}
	}
	scenegraph[list_name .. "_content"] = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		parent = list_name,
		size = {
			list_item_size[1],
			list_height
		},
		position = {
			list_offset_x,
			0,
			1
		}
	}
	scenegraph[list_name .. "_mask"] = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		parent = list_name,
		size = {
			column_width + mask_margin * 2,
			list_height + mask_margin
		},
		position = {
			-mask_margin,
			-mask_margin,
			2
		}
	}
	scenegraph[column .. "_scrollbar"] = {
		vertical_alignment = "top",
		horizontal_alignment = "right",
		parent = list_name,
		size = {
			scrollbar_width,
			scrollbar_height
		},
		position = scrollbar_offset
	}
end

local widget_definitions = {
	header = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = ViewStyles.header_background
		}
	}, "header"),
	player_name = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			style = ViewStyles.player_name
		}
	}, "player_name"),
	account_rank = UIWidget.create_definition({
		{
			value_id = "rank_text",
			scenegraph_id = "account_rank",
			pass_type = "text",
			style_id = "account_rank",
			value = ""
		},
		{
			value = "content/ui/materials/bars/heavy/frame_back",
			style_id = "progress_bar_background",
			pass_type = "texture"
		},
		{
			value = "content/ui/materials/bars/heavy/frame_top",
			style_id = "progress_bar_frame",
			pass_type = "texture"
		},
		{
			value = "content/ui/materials/buttons/background_selected_edge",
			style_id = "progress_bar",
			pass_type = "texture"
		}
	}, "progress_bar", nil, nil, ViewStyles.account_rank),
	progression_reward = UIWidget.create_definition({
		{
			scenegraph_id = "progression_reward_label",
			pass_type = "text",
			style_id = "label",
			value = Managers.localization:localize("loc_account_profile_next_reward")
		},
		{
			value = "content/ui/materials/icons/weapons/frames/background",
			value_id = "icon_background",
			pass_type = "texture",
			style_id = "icon_background"
		},
		{
			value = "content/ui/materials/icons/weapons/frames/base_rarity_01_left",
			value_id = "rarity",
			pass_type = "texture",
			style_id = "rarity"
		},
		{
			value = "content/ui/materials/icons/weapons/frames/base_variant_01_left",
			value_id = "variant",
			pass_type = "texture",
			style_id = "variant"
		},
		{
			value_id = "banner",
			style_id = "banner",
			pass_type = "texture",
			value = "content/ui/materials/icons/weapons/frames/banner_01",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				size = {
					138,
					138
				},
				offset = {
					0,
					0,
					6
				}
			}
		},
		{
			value = "content/ui/materials/icons/weapons/ranged/lasgun",
			value_id = "icon",
			pass_type = "texture",
			style_id = "icon"
		}
	}, "progression_reward_icon", nil, nil, ViewStyles.progression_reward),
	boons = UIWidget.create_definition({
		{
			style_id = "headline",
			pass_type = "text",
			value = Managers.localization:localize("loc_account_profile_boons")
		},
		{
			value = "content/ui/materials/dividers/skull_rendered_left_01",
			style_id = "headline_divider",
			pass_type = "texture"
		}
	}, "boons_column", nil, nil, ViewStyles.column_style),
	boons_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.default_scrollbar, "boons_column_scrollbar"),
	boons_interaction = UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		}
	}, "boons_column"),
	boons_widgets_mask = UIWidget.create_definition({
		{
			value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur_02",
			pass_type = "texture",
			style = {
				color = {
					255,
					255,
					255,
					255
				}
			}
		}
	}, "boons_column_list_mask", {
		text = ""
	}),
	commendations = UIWidget.create_definition({
		{
			style_id = "headline",
			pass_type = "text",
			value = Managers.localization:localize("loc_account_profile_commendations")
		},
		{
			value = "content/ui/materials/dividers/skull_rendered_left_01",
			style_id = "headline_divider",
			pass_type = "texture"
		}
	}, "commendations_column", nil, nil, ViewStyles.column_style),
	commendations_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.default_scrollbar, "commendations_column_scrollbar"),
	commendations_interaction = UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		}
	}, "commendations_column"),
	commendations_widgets_mask = UIWidget.create_definition({
		{
			value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur_02",
			pass_type = "texture",
			style = {
				color = {
					255,
					255,
					255,
					255
				}
			}
		}
	}, "commendations_column_list_mask"),
	all_commendations_button = UIWidget.create_definition(ButtonPassTemplates.secondary_button, "show_all_commendations_button", {
		text = Managers.localization:localize("loc_account_profile_all_commendations")
	}),
	contracts = UIWidget.create_definition({
		{
			style_id = "headline",
			pass_type = "text",
			value = Managers.localization:localize("loc_account_profile_current_contact")
		},
		{
			style_id = "num_contracts_tasks",
			value_id = "num_tasks",
			pass_type = "text"
		},
		{
			value = "content/ui/materials/dividers/skull_rendered_left_01",
			style_id = "headline_divider",
			pass_type = "texture"
		}
	}, "contracts_column", nil, nil, ViewStyles.column_style),
	contracts_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.default_scrollbar, "contracts_column_scrollbar"),
	contracts_interaction = UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		}
	}, "contracts_column"),
	contracts_widgets_mask = UIWidget.create_definition({
		{
			value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur_02",
			pass_type = "texture",
			style = {
				color = {
					255,
					255,
					255,
					255
				}
			}
		}
	}, "contracts_column_list_mask")
}
local blueprints = {
	item_blueprint_with_icon = {
		passes = {
			{
				style_id = "hotspot_style",
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				style_id = "icon",
				value_id = "icon",
				pass_type = "texture"
			},
			{
				value = "content/ui/materials/icons/achievements/frames/default",
				value_id = "icon_frame",
				pass_type = "texture",
				style_id = "icon_background"
			},
			{
				value_id = "label",
				pass_type = "text",
				style_id = "label",
				change_function = ButtonPassTemplates.list_button_label_change_function
			},
			{
				value_id = "value",
				pass_type = "text",
				style_id = "value",
				change_function = ButtonPassTemplates.list_button_label_change_function
			},
			{
				style_id = "highlight",
				pass_type = "texture",
				value = "content/ui/materials/frames/hover",
				change_function = ButtonPassTemplates.list_button_highlight_change_function,
				visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
			}
		},
		size = ViewStyles.list_item.size,
		style = ViewStyles.list_item_with_icon
	},
	item_blueprint = {
		passes = {
			{
				style_id = "hotspot_style",
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				value_id = "label",
				pass_type = "text",
				style_id = "label",
				change_function = ButtonPassTemplates.list_button_label_change_function
			},
			{
				value_id = "value",
				pass_type = "text",
				style_id = "value",
				change_function = ButtonPassTemplates.list_button_label_change_function
			},
			{
				style_id = "highlight",
				pass_type = "texture",
				value = "content/ui/materials/frames/hover",
				change_function = ButtonPassTemplates.list_button_highlight_change_function,
				visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
			}
		},
		size = ViewStyles.list_item.size,
		style = ViewStyles.list_item
	}
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph,
	blueprints = blueprints
}
