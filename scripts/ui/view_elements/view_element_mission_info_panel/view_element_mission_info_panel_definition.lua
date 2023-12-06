local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ViewAnimations = require("scripts/ui/view_elements/view_element_mission_info_panel/view_element_mission_info_panel_animations")
local ViewStyles = require("scripts/ui/view_elements/view_element_mission_info_panel/view_element_mission_info_panel_styles")
local panel_style = ViewStyles.panel
local panel_size = panel_style.size
local infoarea_height = panel_style.max_size[2] - ViewStyles.panel_header.size[2]
local scrollbar_width = ScrollbarPassTemplates.terminal_scrollbar.default_width
local button_template = ButtonPassTemplates.default_button
local sg_panel_wrapper = {
	vertical_alignment = "center",
	parent = "screen",
	horizontal_alignment = "right",
	size = panel_size,
	position = {
		-90,
		-18,
		1
	}
}
local sg_panel = {
	vertical_alignment = "center",
	parent = "panel_wrapper",
	horizontal_alignment = "center",
	size = {
		panel_size[1],
		96
	},
	position = {
		0,
		0,
		1
	}
}
local sg_panel_top = {
	vertical_alignment = "top",
	parent = "panel",
	horizontal_alignment = "center",
	size = panel_style.top.size,
	position = panel_style.top.offset
}
local sg_panel_bottom = {
	vertical_alignment = "bottom",
	parent = "panel",
	horizontal_alignment = "center",
	size = panel_style.bottom.size,
	position = panel_style.bottom.offset
}
local sg_panel_header = {
	vertical_alignment = "top",
	parent = "panel",
	horizontal_alignment = "left",
	size = {
		panel_size[1],
		96
	},
	position = {
		0,
		0,
		1
	}
}
local sg_header_banner = {
	vertical_alignment = "bottom",
	parent = "panel_header",
	horizontal_alignment = "left",
	size = {
		panel_size[1],
		50
	},
	position = {
		0,
		-34,
		1
	}
}
local sg_info_area = {
	vertical_alignment = "top",
	parent = "panel",
	horizontal_alignment = "left",
	size = {
		panel_size[1],
		infoarea_height
	},
	position = {
		0,
		sg_panel_header.size[2],
		1
	}
}
local sg_info_area_content = {
	vertical_alignment = "top",
	parent = "info_area",
	horizontal_alignment = "left",
	size = {
		panel_size[1],
		infoarea_height
	},
	position = {
		0,
		0,
		1
	}
}
local sg_panel_scrollbar = {
	vertical_alignment = "top",
	parent = "panel",
	horizontal_alignment = "right",
	size = {
		scrollbar_width,
		0
	},
	position = {
		0,
		75,
		5
	}
}
local sg_list_mask = {
	vertical_alignment = "top",
	parent = "info_area",
	horizontal_alignment = "left",
	size = {
		sg_info_area.size[1] + 40,
		0
	},
	position = {
		-20,
		0,
		5
	}
}
local sg_play_button = {
	vertical_alignment = "bottom",
	parent = "panel",
	horizontal_alignment = "center",
	size = button_template.size,
	position = {
		0,
		button_template.size[2] + 11,
		1
	}
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	panel_wrapper = sg_panel_wrapper,
	panel = sg_panel,
	panel_top = sg_panel_top,
	panel_bottom = sg_panel_bottom,
	panel_header = sg_panel_header,
	header_banner = sg_header_banner,
	info_area = sg_info_area,
	info_area_content = sg_info_area_content,
	list_mask = sg_list_mask,
	panel_scrollbar = sg_panel_scrollbar,
	play_button = sg_play_button
}
local change_functions = ViewAnimations.change_functions
local widget_definitions = {
	panel = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/terminal_gradient",
			style_id = "background",
			pass_type = "texture"
		},
		{
			value = "content/ui/materials/frames/inner_glow",
			style_id = "event_frame",
			pass_type = "texture",
			change_function = change_functions.event_frame
		},
		{
			value = "content/ui/materials/dividers/horizontal_frame_mission_upper",
			style_id = "frame_top",
			pass_type = "texture",
			scenegraph_id = "panel_top"
		},
		{
			scenegraph_id = "panel_top",
			pass_type = "texture",
			style_id = "frame_top_regular",
			value = "content/ui/materials/dividers/horizontal_frame_mission_upper_regular",
			change_function = change_functions.frame_lights
		},
		{
			scenegraph_id = "panel_top",
			pass_type = "texture",
			style_id = "frame_top_event",
			value = "content/ui/materials/dividers/horizontal_frame_mission_upper_event",
			change_function = change_functions.frame_lights
		},
		{
			scenegraph_id = "panel_top",
			pass_type = "texture",
			style_id = "frame_top_red",
			value = "content/ui/materials/dividers/horizontal_frame_mission_upper_flash",
			change_function = change_functions.frame_lights
		},
		{
			value = "content/ui/materials/dividers/horizontal_frame_mission_lower",
			style_id = "frame_bottom",
			pass_type = "texture",
			scenegraph_id = "panel_bottom"
		}
	}, "panel", nil, nil, panel_style),
	panel_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.terminal_scrollbar, "panel_scrollbar"),
	list_interaction = UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		}
	}, "panel"),
	list_mask = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur_02"
		}
	}, "list_mask"),
	report_background = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/info_panels/situation_report",
			style_id = "insignia",
			pass_type = "texture_uv"
		}
	}, "panel", nil, nil, ViewStyles.report_background),
	mission_header = UIWidget.create_definition({
		{
			value = "content/ui/materials/icons/zones/dust",
			value_id = "zone_image",
			pass_type = "texture_uv",
			style_id = "zone_image"
		},
		{
			value = "content/ui/materials/bars/headline_background_vertical",
			style_id = "fade",
			pass_type = "texture_uv"
		},
		{
			value = "Mission Title",
			value_id = "mission_title",
			pass_type = "text",
			style_id = "mission_title"
		},
		{
			value = "Mission Type · Mission Zone",
			value_id = "type_and_zone",
			pass_type = "text",
			style_id = "type_and_zone"
		},
		{
			value = " 40:30",
			value_id = "time_left",
			pass_type = "text",
			style_id = "time_left"
		}
	}, "panel_header", nil, nil, ViewStyles.panel_header),
	header_banner = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "background"
		},
		{
			style_id = "text",
			value_id = "text",
			pass_type = "text"
		}
	}, "header_banner", nil, nil, ViewStyles.header_banner),
	play_button = UIWidget.create_definition(button_template, "play_button", {
		original_text = Localize("loc_mission_board_view_accept_mission"),
		hotspot = {
			use_is_focused = true
		}
	})
}
local view_element_mission_info_panel_definition = {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	animations = ViewAnimations.sequence_animations
}

return settings("ViewElementMissionInfoPanelDefinition", view_element_mission_info_panel_definition)
