-- chunkname: @scripts/ui/hud/elements/danger_zone_overlay/hud_element_danger_zone_overlay_definitions.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local title_text_style = table.clone(UIFontSettings.hud_body)

title_text_style.horizontal_alignment = "center"
title_text_style.vertical_alignment = "center"
title_text_style.text_horizontal_alignment = "center"
title_text_style.text_vertical_alignment = "center"
title_text_style.size = {
	650,
	50,
}
title_text_style.offset = {
	0,
	80,
	2,
}
title_text_style.text_color = Color.ui_interaction_critical(180, true)
title_text_style.font_type = "machine_medium"
title_text_style.font_size = 52
title_text_style.drop_shadow = true

local description_text_style = table.clone(UIFontSettings.header_2)

description_text_style.horizontal_alignment = "center"
description_text_style.vertical_alignment = "center"
description_text_style.text_horizontal_alignment = "center"
description_text_style.text_vertical_alignment = "center"
description_text_style.text_color = Color.ui_interaction_critical(180, true)
description_text_style.size = {
	650,
	50,
}
description_text_style.offset = {
	0,
	120,
	2,
}
description_text_style.font_type = "machine_medium"
description_text_style.font_size = 30
description_text_style.drop_shadow = true

local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	warning_sign = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			128,
			128,
		},
		position = {
			0,
			-230,
			1,
		},
	},
}
local widget_definitions = {
	warning_sign = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "title_text",
			value = "WARNING",
			value_id = "title_text",
			style = title_text_style,
		},
		{
			pass_type = "text",
			style_id = "description_text",
			value = "EVACUATE IMMEDIATELY",
			value_id = "description_text",
			style = description_text_style,
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/hud/overheat_warning_extra",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					0,
				},
				color = Color.ui_interaction_critical(180, true),
			},
		},
	}, "warning_sign"),
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
