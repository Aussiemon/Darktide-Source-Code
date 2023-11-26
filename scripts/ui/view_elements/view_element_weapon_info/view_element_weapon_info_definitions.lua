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
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	bar_breakdown_slate = {
		vertical_alignment = "bottom",
		parent = "pivot",
		horizontal_alignment = "left",
		size = {
			600,
			100
		},
		position = {
			630,
			950,
			1
		}
	},
	entry = {
		vertical_alignment = "top",
		parent = "bar_breakdown_slate",
		horizontal_alignment = "left"
	}
}
local widget_definitions = {
	grid_background = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size_addition = {
					-4,
					0
				},
				color = {
					100,
					0,
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/frames/dropshadow_heavy",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				size_addition = {
					16,
					20
				},
				color = {
					100,
					0,
					0,
					0
				}
			}
		}
	}, "grid_background"),
	overlay = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size_addition = {
					-4,
					0
				},
				color = {
					128,
					0,
					0,
					0
				}
			},
			visibility_function = function (content, style)
				return content.disabled
			end
		}
	}, "screen")
}
local header_style = table.clone(UIFontSettings.header_2)

header_style.font_size = 18
header_style.size = {
	600,
	100
}
header_style.text_horizontal_alignment = "left"
header_style.text_vertical_alignment = "top"
header_style.text_color = Color.terminal_text_body(255, true)

local description_style = table.clone(UIFontSettings.body)

description_style.font_size = 18
description_style.size = {
	600,
	100
}
description_style.text_horizontal_alignment = "left"
description_style.text_vertical_alignment = "bottom"
description_style.text_color = Color.terminal_text_body_dark(255, true)

local bar_breakdown_entry_style = table.clone(UIFontSettings.body)

bar_breakdown_entry_style.offset = {
	0,
	0,
	3
}
bar_breakdown_entry_style.size = {
	600,
	100
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
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size_addition = {
					-4,
					0
				},
				color = {
					100,
					0,
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/frames/dropshadow_heavy",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				size_addition = {
					16,
					20
				},
				color = {
					100,
					0,
					0,
					0
				}
			}
		},
		{
			style_id = "header",
			value_id = "header",
			pass_type = "text",
			value = "N/A",
			style = table.merge_recursive(table.clone(header_style), {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				offset = {
					20,
					10,
					1
				}
			})
		},
		{
			style_id = "description",
			value_id = "description",
			pass_type = "text",
			value = "",
			style = table.merge_recursive(table.clone(description_style), {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				size_addition = {
					-40,
					0
				},
				offset = {
					20,
					-10,
					2
				}
			})
		}
	}, "bar_breakdown_slate"),
	entry = UIWidget.create_definition({
		{
			value = "content/ui/materials/icons/perks/perk_level_01",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				size = {
					20,
					20
				},
				offset = {
					20,
					10,
					0
				},
				color = Color.terminal_icon(255, true)
			}
		},
		{
			value = "N/A",
			value_id = "text",
			pass_type = "text",
			style = table.merge_recursive(table.clone(bar_breakdown_entry_style), {
				text_vertical_alignment = "top",
				text_horizontal_alignment = "left",
				offset = {
					40,
					10,
					1
				}
			})
		}
	}, "entry")
}

return {
	bar_breakdown_widgets_definitions = bar_breakdown_widgets_definitions,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
