-- chunkname: @scripts/ui/views/item_grid_view_base/item_grid_view_base_definitions.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local title_height = 70
local edge_padding = 44
local grid_width = 640
local grid_height = 860
local grid_size = {
	grid_width - edge_padding,
	grid_height,
}
local grid_spacing = {
	10,
	10,
}
local mask_size = {
	grid_width + 40,
	grid_height,
}
local grid_settings = {
	scrollbar_horizontal_offset = -7,
	scrollbar_width = 7,
	use_is_focused_for_navigation = false,
	use_select_on_focused = true,
	use_terminal_background = true,
	using_custom_gamepad_navigation = false,
	widget_icon_load_margin = 0,
	grid_spacing = grid_spacing,
	grid_size = grid_size,
	mask_size = mask_size,
	title_height = title_height,
	edge_padding = edge_padding,
}
local weapon_stats_grid_settings

do
	local padding = 12
	local width, height = 530, 920

	weapon_stats_grid_settings = {
		ignore_blur = true,
		scrollbar_width = 7,
		title_height = 70,
		use_parent_world = false,
		using_custom_gamepad_navigation = false,
		grid_spacing = {
			0,
			0,
		},
		grid_size = {
			width - padding,
			height,
		},
		mask_size = {
			width + 40,
			height,
		},
		edge_padding = padding,
	}
end

local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	canvas = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			0,
		},
	},
	item_grid_pivot = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			grid_width,
			grid_height,
		},
		position = {
			100,
			40,
			1,
		},
	},
	grid_tab_panel = {
		horizontal_alignment = "center",
		parent = "item_grid_pivot",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			-50,
			1,
		},
	},
	weapon_stats_pivot = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			-1140,
			80,
			3,
		},
	},
	weapon_compare_stats_pivot = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			-1140 + (grid_size[1] - 50),
			80,
			3,
		},
	},
	weapon_viewport = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			3,
		},
	},
	weapon_pivot = {
		horizontal_alignment = "center",
		parent = "weapon_viewport",
		vertical_alignment = "center",
		size = {
			0,
			0,
		},
		position = {
			300,
			0,
			1,
		},
	},
	display_name = {
		horizontal_alignment = "left",
		parent = "weapon_stats_pivot",
		vertical_alignment = "top",
		size = {
			1700,
			50,
		},
		position = {
			0,
			-497,
			3,
		},
	},
	sub_display_name = {
		horizontal_alignment = "center",
		parent = "display_name",
		vertical_alignment = "top",
		size = {
			1700,
			50,
		},
		position = {
			0,
			35,
			4,
		},
	},
	display_name_divider = {
		horizontal_alignment = "left",
		parent = "sub_display_name",
		vertical_alignment = "bottom",
		size = {
			344,
			18,
		},
		position = {
			0,
			15,
			-1,
		},
	},
	display_name_divider_glow = {
		horizontal_alignment = "left",
		parent = "display_name_divider",
		vertical_alignment = "bottom",
		size = {
			300,
			80,
		},
		position = {
			20,
			-16,
			-1,
		},
	},
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
			value = "content/ui/materials/dividers/skull_rendered_left_01",
			visibility_function = function (content)
				return content.texture ~= nil
			end,
		},
	}, "display_name_divider"),
	display_name_divider_glow = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "texture",
			value = "content/ui/materials/effects/wide_upward_glow",
			visibility_function = function (content)
				return content.texture ~= nil
			end,
		},
	}, "display_name_divider_glow"),
	display_name = UIWidget.create_definition({
		{
			pass_type = "text",
			value = "",
			value_id = "text",
			style = display_name_style,
		},
	}, "display_name"),
	sub_display_name = UIWidget.create_definition({
		{
			pass_type = "text",
			value = "",
			value_id = "text",
			style = sub_display_name_style,
		},
	}, "sub_display_name"),
}
local tab_menu_settings = {
	button_spacing = 20,
	fixed_button_size = true,
	horizontal_alignment = "center",
	layer = 10,
	button_size = {
		200,
		500,
	},
}
local anim_start_delay = 0
local animations = {
	on_enter = {
		{
			end_time = 0,
			name = "init",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				parent._alpha_multiplier = 0
			end,
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
			end,
		},
	},
	grid_entry = {
		{
			end_time = 0.5,
			name = "fade_in",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				for i = 1, #widgets do
					widgets[i].alpha_multiplier = anim_progress
				end
			end,
		},
	},
}

return {
	animations = animations,
	grid_settings = grid_settings,
	tab_menu_settings = tab_menu_settings,
	weapon_stats_grid_settings = weapon_stats_grid_settings,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
