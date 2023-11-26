-- chunkname: @scripts/ui/hud/elements/combat_feed/hud_element_combat_feed_definitions.lua

local ConstantElementNotificationFeedSettings = require("scripts/ui/constant_elements/elements/notification_feed/constant_element_notification_feed_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local header_size = ConstantElementNotificationFeedSettings.header_size
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	background = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			header_size[1],
			250
		},
		position = {
			0,
			50,
			990
		}
	}
}

local function create_notification_message_default(scenegraph_id)
	local description_font_settings = UIFontSettings.hud_body
	local description_font_color = UIHudSettings.color_tint_main_2
	local side_offset = 10
	local icon_size = {
		40,
		40
	}

	return UIWidget.create_definition({
		{
			style_id = "text",
			pass_type = "text",
			value_id = "text",
			value = "<n/a>",
			style = {
				text_vertical_alignment = "center",
				text_horizontal_alignment = "left",
				vertical_alignment = "top",
				offset = {
					icon_size[1] + side_offset,
					0,
					2
				},
				font_type = description_font_settings.font_type,
				font_size = description_font_settings.font_size,
				text_color = description_font_color,
				default_text_color = description_font_color,
				size = {
					header_size[1] - (icon_size[1] + side_offset * 2),
					header_size[2]
				}
			}
		}
	}, scenegraph_id)
end

local widget_definitions = {}

return {
	notification_message_default = create_notification_message_default("background"),
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
