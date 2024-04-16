local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")

local function create_definitions(settings)
	local grid_size = settings.grid_size
	local edge_padding = settings.edge_padding or 0
	local hide_dividers = settings.hide_dividers
	local background_size = {
		grid_size[1] + edge_padding,
		grid_size[2]
	}
	local scenegraph_definition = {
		screen = UIWorkspaceSettings.screen,
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
		}
	}
	local widget_definitions = {
		grid_background = UIWidget.create_definition({
			{
				pass_type = "rect",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					color = {
						100,
						0,
						0,
						0
					},
					offset = {
						0,
						0,
						-1
					},
					size_addition = {
						-8,
						0
					}
				}
			},
			{
				value = "content/ui/materials/backgrounds/terminal_basic",
				pass_type = "texture",
				style = {
					vertical_alignment = "center",
					scale_to_material = true,
					horizontal_alignment = "center",
					size_addition = {
						18,
						16
					},
					color = Color.terminal_grid_background(255, true)
				}
			}
		}, "grid_background")
	}

	if not hide_dividers then
		local divider_top_widget_name = "grid_divider_top"
		widget_definitions[divider_top_widget_name] = UIWidget.create_definition({
			{
				value_id = "texture",
				style_id = "texture",
				pass_type = "texture",
				value = "content/ui/materials/frames/item_info_upper",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "top"
				}
			}
		}, divider_top_widget_name)
		local divider_bottom_widget_name = "grid_divider_bottom"
		widget_definitions[divider_bottom_widget_name] = UIWidget.create_definition({
			{
				value_id = "texture",
				style_id = "texture",
				pass_type = "texture",
				value = "content/ui/materials/frames/item_info_lower",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center"
				}
			}
		}, divider_bottom_widget_name)
	end

	return {
		widget_definitions = widget_definitions,
		scenegraph_definition = scenegraph_definition
	}
end

return create_definitions
