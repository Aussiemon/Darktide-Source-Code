local ConstantElementNotificationFeedSettings = require("scripts/ui/constant_elements/elements/notification_feed/constant_element_notification_feed_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local header_size = ConstantElementNotificationFeedSettings.header_size
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	background = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			header_size[1],
			400
		},
		position = {
			0,
			450,
			990
		}
	}
}

local function create_notification_message_default(scenegraph_id)
	local description_font_setting_name = "body"
	local description_font_settings = UIFontSettings[description_font_setting_name]
	local description_font_color = {
		255,
		255,
		255,
		255
	}
	local side_offset = 10
	local header_size = ConstantElementNotificationFeedSettings.header_size
	local bar_offset = {
		side_offset,
		header_size[2],
		0
	}
	local bar_size = {
		header_size[1] - bar_offset[1] * 2,
		0
	}
	local icon_size = {
		40,
		40
	}

	return UIWidget.create_definition({
		{
			style_id = "text",
			pass_type = "text",
			value_id = "text",
			value = "<description_text description_text description_text description_text>",
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

local function create_notification_message_alert(scenegraph_id)
	local description_font_setting_name = "body"
	local description_font_settings = UIFontSettings[description_font_setting_name]
	local description_font_color = {
		255,
		255,
		255,
		255
	}
	local side_offset = 10
	local header_size = ConstantElementNotificationFeedSettings.header_size
	local bar_offset = {
		side_offset,
		header_size[2],
		0
	}
	local bar_size = {
		header_size[1] - bar_offset[1] * 2,
		0
	}
	local icon_size = {
		40,
		40
	}

	return UIWidget.create_definition({
		{
			style_id = "background",
			pass_type = "rect",
			style = {
				vertical_alignment = "top",
				size = header_size,
				color = {
					180,
					0,
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/icons/system/attention",
			value_id = "icon",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				size = icon_size,
				offset = {
					0,
					0,
					1
				},
				color = {
					255,
					255,
					255,
					255
				}
			}
		},
		{
			style_id = "text",
			pass_type = "text",
			value_id = "text",
			value = "<description_text description_text description_text description_text>",
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

local function create_notification_message_item_granted(scenegraph_id)
	local description_font_setting_name = "body"
	local description_font_settings = UIFontSettings[description_font_setting_name]
	local description_font_color = {
		255,
		102,
		102,
		102
	}
	local side_offset = 10
	local icon_size = {
		50,
		50
	}

	return UIWidget.create_definition({
		{
			style_id = "background",
			pass_type = "rect",
			style = {
				vertical_alignment = "top",
				size = header_size,
				offset = {
					0,
					0,
					0
				},
				color = {
					180,
					0,
					0,
					0
				}
			}
		},
		{
			value_id = "icon",
			style_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/icons/item_types/poses",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				size = icon_size,
				offset = {
					0,
					0,
					1
				},
				color = {
					255,
					255,
					255,
					255
				}
			}
		},
		{
			style_id = "text",
			pass_type = "text",
			value_id = "text",
			value = "<description_text description_text description_text description_text>",
			style = {
				text_vertical_alignment = "center",
				horizontal_alignment = "right",
				text_horizontal_alignment = "right",
				vertical_alignment = "top",
				offset = {
					-(icon_size[1] + side_offset),
					0,
					2
				},
				font_type = description_font_settings.font_type,
				font_size = description_font_settings.font_size,
				text_color = description_font_color,
				default_text_color = description_font_color,
				size = {
					header_size[1] * 2,
					header_size[2]
				}
			}
		}
	}, scenegraph_id)
end

local widget_definitions = {}

return {
	notification_message_default = create_notification_message_default("background"),
	notification_message_alert = create_notification_message_alert("background"),
	notification_message_item_granted = create_notification_message_item_granted("background"),
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
