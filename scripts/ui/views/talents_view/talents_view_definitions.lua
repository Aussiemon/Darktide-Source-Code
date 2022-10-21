local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ViewStyles = require("scripts/ui/views/talents_view/talents_view_styles")
local top_panel_size = UIWorkspaceSettings.top_panel.size
local bottom_panel_size = UIWorkspaceSettings.bottom_panel.size
local visible_area_width = UIWorkspaceSettings.screen.size[1]
local visible_area_height = UIWorkspaceSettings.screen.size[2] - (top_panel_size[2] + bottom_panel_size[2])
local archetype_header_height = 50
local grid_width = 1210
local details_panel_width = 462
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
	archetype_header = {
		vertical_alignment = "top",
		parent = "visible_area",
		horizontal_alignment = "left",
		size = {
			grid_width,
			archetype_header_height
		},
		position = {
			100,
			80,
			5
		}
	},
	details_panel = {
		vertical_alignment = "center",
		parent = "visible_area",
		horizontal_alignment = "right",
		size = {
			details_panel_width,
			615
		},
		position = {
			-94,
			0,
			5
		}
	},
	details_panel_headline = {
		vertical_alignment = "top",
		parent = "details_panel",
		horizontal_alignment = "left",
		size = {
			details_panel_width,
			22
		},
		position = {
			0,
			0,
			1
		}
	},
	details_panel_body = {
		vertical_alignment = "top",
		parent = "details_panel",
		horizontal_alignment = "left",
		size = {
			details_panel_width,
			110
		},
		position = {
			2,
			31,
			1
		}
	},
	equip_button = {
		vertical_alignment = "bottom",
		parent = "details_panel",
		horizontal_alignment = "right",
		size = {
			200,
			60
		},
		position = {
			-16,
			-20,
			1
		}
	},
	grid_area = {
		vertical_alignment = "top",
		parent = "visible_area",
		horizontal_alignment = "left",
		size = {
			grid_width,
			550
		},
		position = {
			100,
			200,
			5
		}
	}
}
local widget_definitions = {
	archetype_header = UIWidget.create_definition({
		{
			style_id = "text",
			value_id = "text",
			pass_type = "text"
		}
	}, "archetype_header", nil, nil, ViewStyles.archetype_header),
	highlight_ring = UIWidget.create_definition({
		{
			style_id = "frame",
			pass_type = "texture",
			value = "content/ui/materials/icons/talents/menu/frame_highlight",
			value_id = "frame",
			style = ViewStyles.highlight_ring,
			change_function = function (content, style, animation, dt)
				local focus_progress = content.anim_focus_progress
				local color = style.color
				color[1] = 255 * focus_progress
			end
		}
	}, "screen", {
		anim_focus_progress = 0
	}, ViewStyles.talent_icon.size),
	details_panel = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			value_id = "background",
			pass_type = "texture",
			style_id = "background"
		},
		{
			value = "content/ui/materials/frames/talent_info_upper",
			value_id = "frame_upper",
			pass_type = "texture",
			style_id = "frame_upper"
		},
		{
			value = "content/ui/materials/frames/talent_info_lower",
			value_id = "frame_lower",
			pass_type = "texture",
			style_id = "frame_lower"
		}
	}, "details_panel", nil, nil, ViewStyles.details_panel),
	details = UIWidget.create_definition({
		{
			style_id = "talent_name",
			value_id = "talent_name",
			pass_type = "text"
		},
		{
			value = "content/ui/materials/icons/talents/talent_icon_container",
			value_id = "talent_icon",
			pass_type = "texture",
			style_id = "talent_icon"
		},
		{
			value = "content/ui/materials/base/ui_default_base",
			value_id = "large_icon",
			pass_type = "texture",
			style_id = "large_icon"
		},
		{
			style_id = "talent_description",
			value_id = "talent_description",
			pass_type = "text"
		}
	}, "details_panel", {
		fade_time = ViewStyles.details.fade_time
	}, nil, ViewStyles.details),
	equip_button = UIWidget.create_definition({
		{
			style_id = "hotspot",
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			value_id = "text",
			pass_type = "text",
			style_id = "text",
			change_function = ButtonPassTemplates.list_button_label_change_function
		}
	}, "equip_button", {
		fade_time = ViewStyles.details.fade_time
	}, nil, ViewStyles.equip_button)
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph
}
