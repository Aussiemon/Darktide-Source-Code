-- chunkname: @scripts/ui/view_elements/view_element_weapon_info/view_element_weapon_info_definitions.lua

local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	bottom_panel = UIWorkspaceSettings.bottom_panel,
	pivot = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			1,
		},
	},
	bar_breakdown_slate = {
		horizontal_alignment = "left",
		parent = "pivot",
		vertical_alignment = "bottom",
		size = {
			600,
			100,
		},
		position = {
			630,
			950,
			1,
		},
	},
	entry = {
		horizontal_alignment = "left",
		parent = "bar_breakdown_slate",
		vertical_alignment = "top",
	},
}
local widget_definitions = {
	grid_background = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size_addition = {
					-4,
					0,
				},
				color = {
					100,
					0,
					0,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/dropshadow_heavy",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size_addition = {
					16,
					20,
				},
				color = {
					100,
					0,
					0,
					0,
				},
			},
		},
	}, "grid_background"),
	overlay = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size_addition = {
					-4,
					0,
				},
				color = {
					128,
					0,
					0,
					0,
				},
			},
			visibility_function = function (content, style)
				return content.disabled
			end,
		},
	}, "screen"),
}
local header_style = table.clone(UIFontSettings.header_2)

header_style.font_size = 18
header_style.size = {
	600,
	100,
}
header_style.text_horizontal_alignment = "left"
header_style.text_vertical_alignment = "top"
header_style.text_color = Color.terminal_text_body(255, true)

local description_style = table.clone(UIFontSettings.body)

description_style.font_size = 18
description_style.size = {
	600,
	100,
}
description_style.text_horizontal_alignment = "left"
description_style.text_vertical_alignment = "bottom"
description_style.text_color = Color.terminal_text_body_dark(255, true)

local bar_breakdown_entry_style = table.clone(UIFontSettings.body)

bar_breakdown_entry_style.offset = {
	0,
	0,
	3,
}
bar_breakdown_entry_style.size = {
	600,
	100,
}
bar_breakdown_entry_style.font_size = 16
bar_breakdown_entry_style.text_horizontal_alignment = "left"
bar_breakdown_entry_style.text_vertical_alignment = "top"
bar_breakdown_entry_style.text_color = Color.terminal_text_body(255, true)

local bar_breakdown_widgets_definitions = {
	bar_breakdown_slate = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size_addition = {
					-4,
					0,
				},
				color = {
					100,
					0,
					0,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/dropshadow_heavy",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size_addition = {
					16,
					20,
				},
				color = {
					100,
					0,
					0,
					0,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "header",
			value = "N/A",
			value_id = "header",
			style = table.merge_recursive(table.clone(header_style), {
				horizontal_alignment = "left",
				vertical_alignment = "top",
				offset = {
					20,
					10,
					1,
				},
			}),
		},
		{
			pass_type = "text",
			style_id = "description",
			value = "",
			value_id = "description",
			style = table.merge_recursive(table.clone(description_style), {
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				size_addition = {
					-40,
					0,
				},
				offset = {
					20,
					-10,
					2,
				},
			}),
		},
	}, "bar_breakdown_slate"),
	entry = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/icons/perks/perk_level_01",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "top",
				size = {
					20,
					20,
				},
				offset = {
					20,
					10,
					0,
				},
				color = Color.terminal_icon(255, true),
			},
		},
		{
			pass_type = "text",
			value = "N/A",
			value_id = "text",
			style = table.merge_recursive(table.clone(bar_breakdown_entry_style), {
				text_horizontal_alignment = "left",
				text_vertical_alignment = "top",
				offset = {
					40,
					10,
					1,
				},
			}),
		},
	}, "entry"),
}

return {
	bar_breakdown_widgets_definitions = bar_breakdown_widgets_definitions,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
