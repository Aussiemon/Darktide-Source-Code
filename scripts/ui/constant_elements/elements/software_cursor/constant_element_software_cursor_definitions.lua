﻿-- chunkname: @scripts/ui/constant_elements/elements/software_cursor/constant_element_software_cursor_definitions.lua

local InputDevice = require("scripts/managers/input/input_device")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local cursor_settings = {
	click_texture = "content/ui/materials/cursors/cursor_click",
	idle_texture = "content/ui/materials/cursors/cursor_idle",
	size = {
		40,
		40,
	},
	cursor_offset = {
		-8,
		31,
	},
}
local w, h = Gui.resolution()
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	software_cursor = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "bottom",
		size = cursor_settings.size,
		position = {
			0,
			0,
			997,
		},
	},
}
local widget_definitions = {
	software_cursor = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "cursor_idle",
			value = cursor_settings.idle_texture,
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = cursor_settings.size,
				offset = {
					cursor_settings.cursor_offset[1],
					cursor_settings.cursor_offset[2],
					0,
				},
				color = {
					255,
					255,
					255,
					255,
				},
			},
			visibility_function = function (content, style)
				return not InputDevice.gamepad_active and not content.left_held and Managers.input:software_cursor_active()
			end,
		},
		{
			pass_type = "texture",
			style_id = "cursor_click",
			value = cursor_settings.click_texture,
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = cursor_settings.size,
				offset = {
					cursor_settings.cursor_offset[1],
					cursor_settings.cursor_offset[2],
					0,
				},
				color = {
					255,
					255,
					255,
					255,
				},
			},
			visibility_function = function (content, style)
				return not InputDevice.gamepad_active and content.left_held and Managers.input:software_cursor_active()
			end,
		},
	}, "software_cursor", nil, nil, nil),
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
