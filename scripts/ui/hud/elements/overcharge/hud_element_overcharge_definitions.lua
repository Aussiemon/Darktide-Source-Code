local HudElementOverchargeSettings = require("scripts/ui/hud/elements/overcharge/hud_element_overcharge_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	overcharge = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			20,
			119
		},
		position = {
			-220,
			0,
			1
		}
	},
	overheat = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			20,
			119
		},
		position = {
			220,
			0,
			1
		}
	},
	warning_text = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			500,
			100
		},
		position = {
			0,
			130,
			1
		}
	}
}
local overcharge_text_style = table.clone(UIFontSettings.body_small)
overcharge_text_style.offset = {
	-30,
	-4,
	3
}
overcharge_text_style.size = {
	500,
	50
}
overcharge_text_style.vertical_alignment = "top"
overcharge_text_style.horizontal_alignment = "right"
overcharge_text_style.text_horizontal_alignment = "right"
overcharge_text_style.text_vertical_alignment = "top"
overcharge_text_style.text_color = UIHudSettings.color_tint_main_2
local overheat_text_style = table.clone(overcharge_text_style)
overheat_text_style.text_horizontal_alignment = "left"
overheat_text_style.horizontal_alignment = "left"
overheat_text_style.offset = {
	30,
	-4,
	3
}
local overcharge_warning_text_style = table.clone(UIFontSettings.body)
overcharge_warning_text_style.offset = {
	-30,
	14,
	3
}
overcharge_warning_text_style.size = {
	500,
	50
}
overcharge_warning_text_style.vertical_alignment = "top"
overcharge_warning_text_style.horizontal_alignment = "right"
overcharge_warning_text_style.text_horizontal_alignment = "right"
overcharge_warning_text_style.text_vertical_alignment = "top"
overcharge_warning_text_style.text_color = UIHudSettings.color_tint_alert_2
local overheat_warning_text_style = table.clone(overcharge_warning_text_style)
overheat_warning_text_style.text_horizontal_alignment = "left"
overheat_warning_text_style.horizontal_alignment = "left"
overheat_warning_text_style.offset = {
	30,
	14,
	3
}
local warning_text_style = table.clone(UIFontSettings.body)
warning_text_style.offset = {
	0,
	0,
	3
}
warning_text_style.size = {
	500,
	50
}
warning_text_style.vertical_alignment = "bottom"
warning_text_style.horizontal_alignment = "center"
warning_text_style.text_horizontal_alignment = "center"
warning_text_style.text_vertical_alignment = "bottom"
warning_text_style.text_color = UIHudSettings.color_tint_alert_2
local widget_definitions = {
	overcharge = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = Utf8.upper(Localize("loc_hud_display_overcharge")),
			style = overcharge_text_style
		},
		{
			value_id = "warning_text",
			style_id = "warning_text",
			pass_type = "text",
			value = "999%",
			style = overcharge_warning_text_style
		},
		{
			value = "content/ui/materials/hud/overheat_warning",
			style_id = "warning",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					52,
					46
				},
				offset = {
					-40,
					42,
					0
				},
				color = UIHudSettings.color_tint_alert_2
			}
		},
		{
			value = "content/ui/materials/hud/overheat_gauge",
			style_id = "gauge",
			pass_type = "texture_uv",
			style = {
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				},
				offset = {
					0,
					0,
					0
				},
				color = UIHudSettings.color_tint_main_2
			}
		},
		{
			value = "content/ui/materials/hud/overheat_fill",
			style_id = "fill",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				},
				size = {
					20,
					106
				},
				default_size = {
					20,
					106
				},
				offset = {
					16,
					-6,
					1
				},
				color = {
					255,
					101,
					170,
					190
				}
			}
		}
	}, "overcharge"),
	overheat = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = Utf8.upper(Localize("loc_hud_display_overheat")),
			style = overheat_text_style
		},
		{
			value_id = "warning_text",
			style_id = "warning_text",
			pass_type = "text",
			value = "999%",
			style = overheat_warning_text_style
		},
		{
			value = "content/ui/materials/hud/overheat_warning",
			style_id = "warning",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					52,
					46
				},
				offset = {
					40,
					42,
					0
				},
				color = UIHudSettings.color_tint_alert_2
			}
		},
		{
			value = "content/ui/materials/hud/overheat_gauge",
			style_id = "gauge",
			pass_type = "texture",
			style = {
				offset = {
					0,
					0,
					0
				},
				color = UIHudSettings.color_tint_main_2
			}
		},
		{
			value = "content/ui/materials/hud/overheat_fill",
			style_id = "fill",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				},
				size = {
					20,
					106
				},
				default_size = {
					20,
					106
				},
				offset = {
					-16,
					-6,
					1
				},
				color = {
					255,
					186,
					118,
					51
				}
			}
		}
	}, "overheat"),
	warning_text = UIWidget.create_definition({
		{
			value_id = "warning_text",
			style_id = "warning_text",
			pass_type = "text",
			value = Utf8.upper(Localize("loc_hud_display_overheat_death_danger")),
			style = warning_text_style
		},
		{
			value = "content/ui/materials/hud/overheat_warning_extra",
			style_id = "warning",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					128,
					128
				},
				offset = {
					0,
					-40,
					1
				},
				color = UIHudSettings.color_tint_alert_2
			}
		}
	}, "warning_text")
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
