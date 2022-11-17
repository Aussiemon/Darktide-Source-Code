local HudElementBlockingSettings = require("scripts/ui/hud/elements/blocking/hud_element_blocking_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local bar_size = HudElementBlockingSettings.bar_size
local area_size = HudElementBlockingSettings.area_size
local glow_size = HudElementBlockingSettings.glow_size
local center_offset = HudElementBlockingSettings.center_offset
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	area = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = area_size,
		position = {
			0,
			center_offset,
			0
		}
	},
	gauge = {
		vertical_alignment = "top",
		parent = "area",
		horizontal_alignment = "center",
		size = {
			212,
			10
		},
		position = {
			0,
			6,
			1
		}
	},
	shield = {
		vertical_alignment = "top",
		parent = "area",
		horizontal_alignment = "center",
		size = bar_size,
		position = {
			0,
			0,
			1
		}
	}
}
local value_text_style = table.clone(UIFontSettings.body_small)
value_text_style.offset = {
	0,
	10,
	3
}
value_text_style.size = {
	500,
	30
}
value_text_style.vertical_alignment = "top"
value_text_style.horizontal_alignment = "left"
value_text_style.text_horizontal_alignment = "left"
value_text_style.text_vertical_alignment = "top"
value_text_style.text_color = UIHudSettings.color_tint_main_1
local name_text_style = table.clone(value_text_style)
name_text_style.offset = {
	0,
	10,
	3
}
name_text_style.horizontal_alignment = "right"
name_text_style.text_horizontal_alignment = "right"
name_text_style.text_color = UIHudSettings.color_tint_main_2
name_text_style.drop_shadow = false
local widget_definitions = {
	gauge = UIWidget.create_definition({
		{
			value_id = "value_text",
			style_id = "value_text",
			pass_type = "text",
			value = Utf8.upper(Localize("loc_hud_display_overheat_death_danger")),
			style = value_text_style
		},
		{
			value_id = "name_text",
			style_id = "name_text",
			pass_type = "text",
			value = Utf8.upper(Localize("loc_hud_display_name_stamina")),
			style = name_text_style
		},
		{
			value = "content/ui/materials/hud/stamina_gauge",
			style_id = "warning",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					1
				},
				color = UIHudSettings.color_tint_main_2
			}
		}
	}, "gauge")
}
local shield = UIWidget.create_definition({
	{
		value = "content/ui/materials/hud/stamina_full",
		style_id = "full",
		pass_type = "rect",
		style = {
			offset = {
				0,
				0,
				3
			},
			color = UIHudSettings.color_tint_main_1
		}
	}
}, "shield")

return {
	shield_definition = shield,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
