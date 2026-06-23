-- chunkname: @scripts/ui/view_elements/view_element_keybind_popup/view_element_keybind_popup_definitions.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local Text = require("scripts/utilities/ui/text")
local start_layer = 1
local background_height = 200
local box_width = 1000
local text_box_height = background_height - 60
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	text_box_background = {
		parent = "screen",
		scale = "fit_width",
		vertical_alignment = "center",
		size = {
			1920,
			0,
		},
		position = {
			0,
			0,
			1,
		},
	},
	text_box_pivot = {
		horizontal_alignment = "center",
		parent = "text_box_background",
		vertical_alignment = "center",
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
	text_box = {
		horizontal_alignment = "center",
		parent = "text_box_pivot",
		vertical_alignment = "center",
		size = {
			box_width,
			text_box_height,
		},
		position = {
			0,
			0,
			2,
		},
	},
}
local action_text_style = table.clone(UIFontSettings.header_2)

action_text_style.text_horizontal_alignment = "center"
action_text_style.text_vertical_alignment = "top"

local description_text_style = table.clone(UIFontSettings.body)

description_text_style.text_horizontal_alignment = "center"
description_text_style.text_vertical_alignment = "center"

local warning_text_style = table.clone(UIFontSettings.body)

warning_text_style.text_horizontal_alignment = "center"
warning_text_style.text_vertical_alignment = "bottom"
warning_text_style.text_color = {
	150,
	255,
	0,
	0,
}

local value_text_style = table.clone(UIFontSettings.header_3)

value_text_style.text_horizontal_alignment = "center"
value_text_style.text_vertical_alignment = "center"

local widget_definitions = {
	popup_background = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				offset = {
					0,
					0,
					start_layer,
				},
				color = {
					166,
					0,
					0,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/buttons/background_selected_edge",
			style = {
				vertical_alignment = "top",
				offset = {
					0,
					0,
					start_layer + 1,
				},
				size = {
					nil,
					2,
				},
				color = Color.terminal_corner(255, true),
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/buttons/background_selected_edge",
			style = {
				vertical_alignment = "bottom",
				offset = {
					0,
					0,
					start_layer + 1,
				},
				size = {
					nil,
					2,
				},
				color = Color.terminal_corner(255, true),
			},
		},
	}, "text_box_background"),
}
local blueprints = {
	header = {
		size_function = function (parent, element, ui_renderer)
			local entry_height = 0
			local desciption_height = Text.text_height(ui_renderer, element.text, action_text_style, {
				box_width,
				1000,
			}, true)

			entry_height = desciption_height or entry_height

			return {
				box_width,
				entry_height,
			}
		end,
		pass_template = {
			{
				pass_type = "text",
				style_id = "text",
				value = "",
				value_id = "text",
				style = action_text_style,
			},
		},
		init = function (parent, widget, element)
			widget.content.text = element.text
		end,
	},
	description = {
		size_function = function (parent, element, ui_renderer)
			local entry_height = 0
			local desciption_height = Text.text_height(ui_renderer, element.text, description_text_style, nil, true)

			entry_height = desciption_height or entry_height

			return {
				box_width,
				entry_height,
			}
		end,
		pass_template = {
			{
				pass_type = "text",
				style_id = "text",
				value = "",
				value_id = "text",
				style = description_text_style,
			},
		},
		init = function (parent, widget, element)
			widget.content.text = element.text
		end,
	},
	value = {
		size_function = function (parent, element, ui_renderer)
			local entry_height = 0
			local desciption_height = Text.text_height(ui_renderer, element.text, value_text_style, nil, true)

			entry_height = desciption_height or entry_height

			return {
				box_width,
				entry_height,
			}
		end,
		pass_template = {
			{
				pass_type = "text",
				style_id = "text",
				value = "",
				value_id = "text",
				style = value_text_style,
			},
		},
		init = function (parent, widget, element)
			widget.content.text = element.text
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local speed = 4
			local anim_progress = 0.5 + math.sin(Application.time_since_launch() * speed) * 0.5

			widget.alpha_multiplier = 0.4 + 0.6 * anim_progress
		end,
	},
	conflict_title = {
		size_function = function (parent, element, ui_renderer)
			local entry_height = 0
			local desciption_height = Text.text_height(ui_renderer, element.text, warning_text_style, {
				box_width,
				1000,
			}, true)

			entry_height = desciption_height or entry_height

			return {
				box_width,
				entry_height,
			}
		end,
		pass_template = {
			{
				pass_type = "text",
				style_id = "text",
				value = "",
				value_id = "text",
				style = warning_text_style,
			},
		},
		init = function (parent, widget, element)
			widget.content.text = element.text
		end,
	},
	dynamic_spacing = {
		size_function = function (parent, element)
			return element.size
		end,
	},
}

return {
	background_widget_definition = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				offset = {
					0,
					0,
					start_layer - 1,
				},
				color = Color.terminal_corner(30, true),
			},
		},
	}, "screen"),
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	grid_blueprints = blueprints,
}
