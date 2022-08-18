local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local title_height = 70
local edge_padding = 44
local grid_width = 640
local grid_height = 750
local grid_size = {
	grid_width - edge_padding,
	grid_height
}
local grid_spacing = {
	10,
	10
}
local mask_size = {
	grid_width + 40,
	grid_height
}
local grid_settings = {
	scrollbar_width = 7,
	grid_spacing = grid_spacing,
	grid_size = grid_size,
	mask_size = mask_size,
	title_height = title_height,
	edge_padding = edge_padding
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	canvas = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
	item_grid_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = mask_size,
		position = {
			100,
			250,
			1
		}
	},
	grid_tab_panel = {
		vertical_alignment = "top",
		parent = "item_grid_pivot",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			-50,
			1
		}
	},
	weapon_stats_pivot = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-1140,
			-450,
			3
		}
	},
	display_name = {
		vertical_alignment = "top",
		parent = "weapon_stats_pivot",
		horizontal_alignment = "left",
		size = {
			1700,
			50
		},
		position = {
			0,
			-497,
			3
		}
	},
	sub_display_name = {
		vertical_alignment = "top",
		parent = "display_name",
		horizontal_alignment = "center",
		size = {
			1700,
			50
		},
		position = {
			0,
			35,
			4
		}
	},
	display_name_divider = {
		vertical_alignment = "bottom",
		parent = "sub_display_name",
		horizontal_alignment = "left",
		size = {
			344,
			18
		},
		position = {
			0,
			15,
			-1
		}
	},
	display_name_divider_glow = {
		vertical_alignment = "bottom",
		parent = "display_name_divider",
		horizontal_alignment = "left",
		size = {
			300,
			80
		},
		position = {
			20,
			-16,
			-1
		}
	}
}
local display_name_style = table.clone(UIFontSettings.header_2)
display_name_style.text_horizontal_alignment = "left"
display_name_style.text_vertical_alignment = "center"
local sub_display_name_style = table.clone(UIFontSettings.body)
sub_display_name_style.text_horizontal_alignment = "left"
sub_display_name_style.text_vertical_alignment = "center"
local widget_definitions = {
	display_name_divider = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/skull_rendered_left_01"
		}
	}, "display_name_divider"),
	display_name_divider_glow = UIWidget.create_definition({
		{
			value = "content/ui/materials/effects/wide_upward_glow",
			style_id = "texture",
			pass_type = "texture"
		}
	}, "display_name_divider_glow"),
	display_name = UIWidget.create_definition({
		{
			value = "",
			value_id = "text",
			pass_type = "text",
			style = display_name_style
		}
	}, "display_name"),
	sub_display_name = UIWidget.create_definition({
		{
			value = "",
			value_id = "text",
			pass_type = "text",
			style = sub_display_name_style
		}
	}, "sub_display_name")
}
local anim_start_delay = 0
local animations = {
	on_enter = {
		{
			name = "init",
			end_time = 0,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				parent._alpha_multiplier = 0
			end
		},
		{
			name = "fade_in",
			start_time = anim_start_delay + 1.5,
			end_time = anim_start_delay + 2,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				parent._alpha_multiplier = anim_progress
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end
		}
	},
	grid_entry = {
		{
			name = "fade_in",
			end_time = 0.5,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				for i = 1, #widgets, 1 do
					widgets[i].alpha_multiplier = anim_progress
				end
			end
		}
	}
}

return {
	animations = animations,
	grid_settings = grid_settings,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
