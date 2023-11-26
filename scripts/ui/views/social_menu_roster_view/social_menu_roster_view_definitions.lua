-- chunkname: @scripts/ui/views/social_menu_roster_view/social_menu_roster_view_definitions.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ViewElementTabMenu = require("scripts/ui/view_elements/view_element_tab_menu/view_element_tab_menu")
local RosterStyles = require("scripts/ui/views/social_menu_roster_view/social_menu_roster_view_styles")
local SocialMenuSettings = require("scripts/ui/views/social_menu_view/social_menu_view_settings")
local ColorUtilities = require("scripts/utilities/ui/colors")
local grid_mask_expansion = RosterStyles.roster_grid.mask_expansion
local grid_margin = RosterStyles.grid_margin
local grid_spacing = RosterStyles.grid_spacing
local flickering_function = RosterStyles.change_functions.flickering_windows
local party_visibility_function = RosterStyles.change_functions.party_visibility
local party_inverted_visibility_function = RosterStyles.change_functions.party_inverted_visibility
local player_panel_size = RosterStyles.player_panel_size
local panel_header_height = RosterStyles.panel_header_height
local frame_offset = 14
local sort_cycle_button_size = {
	player_panel_size[1],
	30
}
local party_panel_size = {
	520,
	415
}
local party_panel_top_size = {
	party_panel_size[1],
	36
}
local party_panel_bottom_size = {
	party_panel_size[1],
	266
}
local party_grid_size = {
	player_panel_size[1],
	party_panel_size[2] - 2 * grid_margin[2]
}
local roster_panel_size = RosterStyles.roster_panel_size
local roster_panel_tab_bar_size = {
	roster_panel_size[1],
	panel_header_height
}
local roster_panel_frame_size = {
	roster_panel_size[1],
	36
}
local roster_grid_size = {
	roster_panel_size[1],
	roster_panel_size[2] - 2 * grid_margin[2]
}
local roster_grid_mask_size = {
	roster_grid_size[1] + grid_mask_expansion[1] * 2,
	roster_panel_size[2]
}
local roster_scrollbar_size = {
	ScrollbarPassTemplates.terminal_scrollbar.default_width,
	roster_grid_size[2]
}
local visible_area_size = {
	roster_panel_size[1] + 50 + party_panel_size[1],
	roster_panel_size[2]
}
local panel_content_position = {
	grid_margin[1],
	grid_margin[2],
	1
}
local panel_frame_top_position = {
	0,
	-frame_offset,
	10
}
local panel_frame_bottom_position = {
	0,
	frame_offset,
	10
}
local party_panel_position = {
	0,
	frame_offset,
	1
}
local party_panel_bottom_position = {
	0,
	party_panel_bottom_size[2] - grid_margin[2],
	10
}
local party_grid_position = {
	0,
	22,
	0
}
local roster_panel_position = {
	0,
	frame_offset,
	0
}
local roster_panel_tab_bar_position = {
	0,
	-panel_header_height,
	10
}
local roster_grid_mask_position = {
	-grid_margin[1],
	-grid_margin[2],
	1
}
local roster_scrollbar_position = {
	0,
	grid_margin[2],
	5
}
local sort_cycle_button_position = {
	0,
	50,
	0
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	visible_area = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = visible_area_size,
		position = {
			0,
			250,
			0
		}
	},
	party_panel = {
		vertical_alignment = "top",
		parent = "visible_area",
		horizontal_alignment = "left",
		size = party_panel_size,
		position = party_panel_position
	},
	party_panel_top = {
		vertical_alignment = "top",
		parent = "party_panel",
		horizontal_alignment = "left",
		size = party_panel_top_size,
		position = panel_frame_top_position
	},
	party_panel_bottom = {
		vertical_alignment = "bottom",
		parent = "party_panel",
		horizontal_alignment = "left",
		size = party_panel_bottom_size,
		position = party_panel_bottom_position
	},
	party_grid = {
		vertical_alignment = "top",
		parent = "party_panel",
		horizontal_alignment = "center",
		size = party_grid_size,
		position = party_grid_position
	},
	roster_panel = {
		vertical_alignment = "top",
		parent = "visible_area",
		horizontal_alignment = "right",
		size = roster_panel_size,
		position = roster_panel_position
	},
	roster_panel_tabs = {
		vertical_alignment = "top",
		parent = "roster_panel",
		horizontal_alignment = "left",
		size = roster_panel_tab_bar_size,
		position = roster_panel_tab_bar_position
	},
	roster_panel_top = {
		vertical_alignment = "top",
		parent = "roster_panel",
		horizontal_alignment = "left",
		size = roster_panel_frame_size,
		position = panel_frame_top_position
	},
	roster_panel_bottom = {
		vertical_alignment = "bottom",
		parent = "roster_panel",
		horizontal_alignment = "left",
		size = roster_panel_frame_size,
		position = panel_frame_bottom_position
	},
	roster_grid = {
		vertical_alignment = "top",
		parent = "roster_panel",
		horizontal_alignment = "left",
		size = roster_grid_size,
		position = panel_content_position
	},
	roster_grid_content = {
		vertical_alignment = "top",
		parent = "roster_grid",
		horizontal_alignment = "left",
		size = roster_grid_size,
		position = {
			0,
			0,
			0
		}
	},
	roster_grid_mask = {
		vertical_alignment = "top",
		parent = "roster_grid",
		horizontal_alignment = "center",
		size = roster_grid_mask_size,
		position = roster_grid_mask_position
	},
	roster_scrollbar = {
		vertical_alignment = "top",
		parent = "roster_panel",
		horizontal_alignment = "right",
		size = roster_scrollbar_size,
		position = roster_scrollbar_position
	},
	sort_cycle_button = {
		vertical_alignment = "bottom",
		parent = "roster_panel",
		horizontal_alignment = "left",
		size = sort_cycle_button_size,
		position = sort_cycle_button_position
	}
}
local widget_definitions = {
	party_panel = UIWidget.create_definition({
		{
			value_id = "header",
			pass_type = "text",
			style_id = "header",
			value = Localize("loc_social_menu_party_header")
		},
		{
			value = "content/ui/materials/dividers/horizontal_frame_big_upper",
			style_id = "frame_top",
			pass_type = "texture",
			scenegraph_id = "party_panel_top"
		},
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			style_id = "background",
			pass_type = "texture"
		},
		{
			style_id = "party_slot_1",
			scenegraph_id = "party_grid",
			pass_type = "texture",
			value = "content/ui/materials/frames/line_medium_inner_shadow",
			visibility_function = party_inverted_visibility_function
		},
		{
			style_id = "party_slot_2",
			scenegraph_id = "party_grid",
			pass_type = "texture",
			value = "content/ui/materials/frames/line_medium_inner_shadow",
			visibility_function = party_inverted_visibility_function
		},
		{
			style_id = "party_slot_3",
			scenegraph_id = "party_grid",
			pass_type = "texture",
			value = "content/ui/materials/frames/line_medium_inner_shadow",
			visibility_function = party_inverted_visibility_function
		},
		{
			style_id = "party_slot_4",
			scenegraph_id = "party_grid",
			pass_type = "texture",
			value = "content/ui/materials/frames/line_medium_inner_shadow",
			visibility_function = party_inverted_visibility_function
		},
		{
			value = "content/ui/materials/frames/party_lower",
			style_id = "frame_bottom",
			pass_type = "texture",
			scenegraph_id = "party_panel_bottom"
		},
		{
			scenegraph_id = "party_panel_bottom",
			pass_type = "texture",
			style_id = "window_1",
			value = "content/ui/materials/frames/party_lower_window_1",
			change_function = flickering_function,
			visibility_function = party_visibility_function
		},
		{
			scenegraph_id = "party_panel_bottom",
			pass_type = "texture",
			style_id = "window_2",
			value = "content/ui/materials/frames/party_lower_window_2",
			change_function = flickering_function,
			visibility_function = party_visibility_function
		},
		{
			scenegraph_id = "party_panel_bottom",
			pass_type = "texture",
			style_id = "window_3",
			value = "content/ui/materials/frames/party_lower_window_3",
			change_function = flickering_function,
			visibility_function = party_visibility_function
		},
		{
			scenegraph_id = "party_panel_bottom",
			pass_type = "texture",
			style_id = "window_4",
			value = "content/ui/materials/frames/party_lower_window_4",
			change_function = flickering_function,
			visibility_function = party_visibility_function
		}
	}, "party_panel", {
		num_party_members = 0,
		max_num_party_members = SocialMenuSettings.max_num_party_members,
		times_til_next_flicker = {
			0,
			0,
			0,
			0
		},
		flicker_data = {
			{
				fade_in = 0
			},
			{
				fade_in = 0
			},
			{
				fade_in = 0
			},
			{
				fade_in = 0
			}
		}
	}, nil, RosterStyles.party_panel),
	roster_panel = UIWidget.create_definition({
		{
			value = "content/ui/materials/dividers/horizontal_frame_big_upper",
			style_id = "frame_top",
			pass_type = "texture",
			scenegraph_id = "roster_panel_top"
		},
		{
			value = "content/ui/materials/dividers/horizontal_frame_big_lower",
			style_id = "frame_bottom",
			pass_type = "texture",
			scenegraph_id = "roster_panel_bottom"
		},
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			style_id = "background",
			pass_type = "texture"
		}
	}, "roster_panel", nil, nil, RosterStyles.roster_panel),
	roster_grid_mask = UIWidget.create_definition({
		{
			value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur",
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
	}, "roster_grid_mask"),
	roster_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.terminal_scrollbar, "roster_scrollbar"),
	roster_grid_interaction = UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		}
	}, "roster_grid_mask")
}
local tab_button_template = table.clone(ButtonPassTemplates.tab_menu_button)

tab_button_template[2].style.offset[2] = 3

local view_elements = {
	tab_bar = {
		init = "_setup_tab_bar",
		layer = 3,
		class = ViewElementTabMenu,
		context = {
			horizontal_alignment = "center",
			button_spacing = 20
		},
		init_params = {
			scenegraph_id = "roster_panel_tabs",
			tabs = {
				"loc_social_menu_roster_friends",
				"loc_social_menu_roster_players_from_previous_missions",
				"loc_social_menu_roster_players_in_hub",
				"loc_social_menu_roster_invites",
				"loc_social_menu_roster_blocked_players"
			},
			tab_button_template = tab_button_template
		}
	}
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	view_elements = view_elements
}
