-- chunkname: @scripts/ui/hud/elements/prologue_tutorial_sequence_transition_end/hud_element_prologue_tutorial_sequence_transition_end_definitions.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local background_size = {
	1920,
	1080
}
local text_box_size = {
	800,
	300
}
local scenegraph_definition = {
	screen = {
		UIWorkspaceSettings.screen
	},
	background = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = background_size,
		position = {
			0,
			0,
			0
		}
	},
	transition_text_bg = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		size = text_box_size,
		position = {
			0,
			0,
			0
		}
	},
	transition_text = {
		vertical_alignment = "center",
		parent = "transition_text_bg",
		horizontal_alignment = "center",
		size = text_box_size,
		position = {
			0,
			0,
			0
		}
	}
}
local widget_definitions = {
	background = UIWidget.create_definition({
		{
			style_id = "background",
			pass_type = "rect",
			style = {
				color = {
					255,
					25,
					25,
					25
				}
			}
		}
	}, "background"),
	text_background = UIWidget.create_definition({
		{
			style_id = "text_background",
			pass_type = "rect",
			style = {
				color = {
					255,
					19,
					97,
					43
				}
			}
		}
	}, "transition_text_bg"),
	text = UIWidget.create_definition({
		{
			value_id = "transition_text",
			pass_type = "text",
			style_id = "transition_text",
			value = "",
			style = {
				font_size = 60,
				text_vertical_alignment = "center",
				text_horizontal_alignment = "center",
				drop_shadow = false,
				font_type = "proxima_nova_bold",
				offset = {
					0,
					0,
					4
				},
				size = text_box_size,
				text_color = {
					255,
					255,
					255,
					255
				},
				default_text_color = {
					255,
					255,
					255,
					255
				}
			}
		}
	}, "transition_text")
}
local animations = {
	fade_in = {
		{
			name = "fade_in",
			end_time = 0.6,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress)
				for _, widget in pairs(widgets) do
					widget.alpha_multiplier = 0
				end
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress)
				local amin_progress = math.easeOutCubic(progress)

				for _, widget in pairs(widgets) do
					widget.alpha_multiplier = amin_progress
				end
			end
		}
	},
	fade_out = {
		{
			name = "fade_out",
			end_time = 0.6,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress)
				local amin_progress = math.easeOutCubic(progress)

				for _, widget in pairs(widgets) do
					widget.alpha_multiplier = -1 * amin_progress
				end
			end
		}
	}
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	animations = animations
}
