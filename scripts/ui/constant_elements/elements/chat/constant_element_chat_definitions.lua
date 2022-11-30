local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ChatSettings = require("scripts/ui/constant_elements/elements/chat/constant_element_chat_settings")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local TextInputPassTemplates = require("scripts/ui/pass_templates/text_input_pass_templates")
local window_margins = ChatSettings.window_margins
local scrollbar_margins = ChatSettings.scrollbar_margins
local scrollbar_width = ChatSettings.scrollbar_width
local placeholder_fade_time = ChatSettings.placeholder_fade_time
local chat_horizontal_alignment = ChatSettings.horizontal_alignment
local chat_vertical_alignment = ChatSettings.vertical_alignment
local background_color = {
	0,
	0,
	0,
	0
}

ColorUtilities.color_copy(ChatSettings.background_color, background_color, true)

local chat_window_size = ChatSettings.chat_window_size
local chat_message_area_size = {
	chat_window_size[1] - (window_margins[1] + window_margins[3] + scrollbar_width + scrollbar_margins[1] + scrollbar_margins[3]),
	chat_window_size[2] - (window_margins[2] + window_margins[4])
}
local chat_scrollbar_size = {
	scrollbar_width,
	chat_window_size[2] - (scrollbar_margins[2] + scrollbar_margins[4])
}
local input_field_size = {
	chat_window_size[1],
	ChatSettings.input_field_height
}
local chat_window_position = ChatSettings.chat_window_offset
local chat_scrollbar_position = {
	-scrollbar_margins[3],
	scrollbar_margins[2],
	3
}
local chat_message_area_position = {
	window_margins[1],
	window_margins[2],
	4
}
local input_field_position = {
	0,
	input_field_size[2] + 5,
	chat_window_position[3]
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	chat_window = {
		parent = "screen",
		size = chat_window_size,
		position = chat_window_position,
		horizontal_alignment = chat_horizontal_alignment,
		vertical_alignment = chat_vertical_alignment
	},
	chat_message_area = {
		vertical_alignment = "top",
		parent = "chat_window",
		horizontal_alignment = "left",
		size = chat_message_area_size,
		position = chat_message_area_position
	},
	chat_scrollbar = {
		vertical_alignment = "top",
		parent = "chat_window",
		horizontal_alignment = "right",
		size = chat_scrollbar_size,
		position = chat_scrollbar_position
	},
	input_field = {
		vertical_alignment = "bottom",
		parent = "chat_window",
		horizontal_alignment = "left",
		size = input_field_size,
		position = input_field_position
	}
}
local widget_definitions = {
	chat_window = UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot",
			style = {
				offset = {
					0,
					0,
					2
				}
			}
		},
		{
			style_id = "background",
			pass_type = "rect",
			style = {
				color = background_color
			}
		}
	}, "chat_window"),
	input_field = UIWidget.create_definition(TextInputPassTemplates.chat_input_field, "input_field", {
		close_on_backspace = false
	}),
	chat_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.simple_scrollbar, "chat_scrollbar"),
	chat_window_mask = UIWidget.create_definition({
		{
			value = "content/ui/materials/masks/color_mask",
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
	}, "chat_message_area")
}
local message_widget_blueprints = {
	chat_message = UIWidget.create_definition({
		{
			style_id = "message",
			value_id = "message",
			pass_type = "text",
			style = UIFontSettings.chat_message
		}
	}, "chat_message_area"),
	notification = UIWidget.create_definition({
		{
			style_id = "message",
			value_id = "message",
			pass_type = "text",
			style = UIFontSettings.chat_notification
		}
	}, "chat_message_area")
}
local animations = {
	fade_chat_window = {
		{
			name = "fade_chat_window",
			start_time = 0,
			end_time = ChatSettings.fade_time,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				params.target_alpha = params.target_alpha
				params.target_background_alpha = params.target_background_alpha
				params.source_alpha = parent._alpha
				params.source_background_alpha = widgets.chat_window.style.background.color[1]
				parent._active_state = params.target_state

				for widget_name, widget in pairs(widgets) do
					if widget_name ~= "input_field" and widget_name ~= "input_placeholder" then
						widget.content.visible = true
					end
				end
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local eased_progress = math.easeCubic(progress)
				local alpha_multiplier = math.lerp(params.source_alpha, params.target_alpha, eased_progress)

				for widget_name, widget in pairs(widgets) do
					if widget_name == "chat_window" then
						widget.style.background.color[1] = math.lerp(params.source_background_alpha, params.target_background_alpha, eased_progress)
					elseif widget_name == "chat_scrollbar" then
						widget.alpha_multiplier = math.lerp(params.source_background_alpha, params.target_background_alpha, eased_progress) / 255
					elseif widget_name ~= "input_field" and widget_name ~= "input_placeholder" then
						widget.alpha_multiplier = alpha_multiplier
					end
				end

				local message_widgets = params.message_widgets

				for i = 1, #message_widgets do
					local widget = message_widgets[i]
					widget.alpha_multiplier = alpha_multiplier
				end

				parent._alpha = alpha_multiplier
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				for widget_name, widget in pairs(widgets) do
					if widget_name ~= "input_field" and widget_name ~= "input_placeholder" then
						widget.content.visible = params.target_alpha > 0
					end
				end

				parent._alpha = params.target_alpha
			end
		}
	},
	fade_input_field = {
		{
			name = "fade_input_field",
			start_time = 0,
			end_time = ChatSettings.fade_time,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local input_field_widget = widgets.input_field
				local input_field_content = input_field_widget.content
				local active = input_field_content.is_writing
				input_field_content.visible = true
				params.input_field_source = input_field_widget.alpha_multiplier or 0
				params.input_field_target = active and 1 or 0
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local eased_progress = math.easeCubic(progress)
				local input_field_widget = widgets.input_field
				input_field_widget.alpha_multiplier = math.lerp(params.input_field_source, params.input_field_target, eased_progress)
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local input_field = widgets.input_field
				local input_field_content = input_field.content
				input_field_content.visible = params.input_field_target > 0
			end
		}
	}
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	animations = animations,
	message_widget_blueprints = message_widget_blueprints
}
