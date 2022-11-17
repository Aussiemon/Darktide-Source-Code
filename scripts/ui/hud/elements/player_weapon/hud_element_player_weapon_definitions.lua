local HudElementPlayerWeaponHandlerSettings = require("scripts/ui/hud/elements/player_weapon_handler/hud_element_player_weapon_handler_settings")
local HudElementPlayerWeaponSettings = require("scripts/ui/hud/elements/player_weapon/hud_element_player_weapon_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local size = HudElementPlayerWeaponHandlerSettings.size
local icon_size = HudElementPlayerWeaponHandlerSettings.icon_size
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	weapon = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "right",
		size = size,
		position = {
			-50,
			0,
			2
		}
	},
	background = {
		vertical_alignment = "bottom",
		parent = "weapon",
		horizontal_alignment = "right",
		size = size,
		position = {
			0,
			0,
			0
		}
	}
}
local ammo_text_style = {
	line_spacing = 0.9,
	font_size = 48,
	drop_shadow = false,
	font_type = "machine_medium",
	text_color = UIHudSettings.color_tint_main_1,
	offset = {
		-64,
		0,
		6
	},
	default_font_size = HudElementPlayerWeaponSettings.ammo_font_size_default,
	focused_font_size = HudElementPlayerWeaponSettings.ammo_font_size_focused,
	text_horizontal_alignment = "right",
	text_vertical_alignment = "top",
	vertical_alignment = "center",
	drop_shadow = false,
	clip_ammo = true
}
local ammo_spare_text_style = table.clone(ammo_text_style)
ammo_spare_text_style.offset = {
	0,
	0,
	7
}
ammo_spare_text_style.text_horizontal_alignment = "right"
ammo_spare_text_style.text_vertical_alignment = "top"
ammo_spare_text_style.vertical_alignment = "center"
ammo_spare_text_style.text_color = UIHudSettings.color_tint_main_3
ammo_spare_text_style.default_text_color = ammo_text_style.text_color
ammo_spare_text_style.default_font_size = HudElementPlayerWeaponSettings.ammo_font_size_default_small
ammo_spare_text_style.focused_font_size = HudElementPlayerWeaponSettings.ammo_font_size_focused_small
ammo_spare_text_style.clip_ammo = false
local input_text_style = table.clone(UIFontSettings.hud_body)
input_text_style.horizontal_alignment = "left"
input_text_style.vertical_alignment = "center"
input_text_style.text_horizontal_alignment = "left"
input_text_style.text_vertical_alignment = "center"
input_text_style.font_size = 20
input_text_style.offset = {
	10,
	0,
	8
}
input_text_style.drop_shadow = false
input_text_style.text_color = UIHudSettings.color_tint_main_1

local function color_copy(target, source, alpha)
	target[1] = alpha or source[1]
	target[2] = source[2]
	target[3] = source[3]
	target[4] = source[4]

	return target
end

local widget_definitions = {
	icon = UIWidget.create_definition({
		{
			value_id = "icon",
			style_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/hud/icons/weapon_icon_container",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				size = icon_size,
				default_size = icon_size,
				offset = {
					0,
					0,
					4
				},
				color = UIHudSettings.color_tint_main_2,
				default_color = Color.terminal_corner_hover(nil, true),
				highlight_color = Color.terminal_icon(nil, true),
				material_values = {}
			}
		}
	}, "background"),
	ammo_text = UIWidget.create_definition({
		{
			value_id = "ammo_amount_1",
			style_id = "ammo_amount_1",
			pass_type = "text",
			value = "<ammo_amount_1>",
			style = table.merge({
				index = 1,
				primary_counter = true
			}, ammo_text_style)
		},
		{
			value_id = "ammo_amount_2",
			style_id = "ammo_amount_2",
			pass_type = "text",
			value = "<ammo_amount_2>",
			style = table.merge({
				index = 2,
				primary_counter = true
			}, ammo_text_style)
		},
		{
			value_id = "ammo_amount_3",
			style_id = "ammo_amount_3",
			pass_type = "text",
			value = "<ammo_amount_3>",
			style = table.merge({
				index = 3,
				primary_counter = true
			}, ammo_text_style)
		},
		{
			value_id = "ammo_spare_1",
			style_id = "ammo_spare_1",
			pass_type = "text",
			value = "",
			style = table.merge({
				index = 1
			}, ammo_spare_text_style)
		},
		{
			value_id = "ammo_spare_2",
			style_id = "ammo_spare_2",
			pass_type = "text",
			value = "",
			style = table.merge({
				index = 2
			}, ammo_spare_text_style)
		},
		{
			value_id = "ammo_spare_3",
			style_id = "ammo_spare_3",
			pass_type = "text",
			value = "",
			style = table.merge({
				index = 3
			}, ammo_spare_text_style)
		}
	}, "background"),
	input_text = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "<n/a>",
			style = input_text_style,
			visibility_function = function (content, style)
				local text = content.text

				return text ~= nil
			end
		}
	}, "background"),
	overheat_infinite_symbol = UIWidget.create_definition({
		{
			value = "content/ui/materials/symbols/infinite",
			style_id = "texture",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				size = HudElementPlayerWeaponSettings.infinite_symbol_size,
				offset = {
					20,
					0,
					10
				},
				color = UIHudSettings.color_tint_main_2
			}
		}
	}, "background"),
	background = UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/backgrounds/terminal_background_weapon",
			style_id = "background",
			pass_type = "texture",
			style = {
				color = Color.terminal_background_gradient(255, true)
			}
		},
		{
			style_id = "line",
			pass_type = "rect",
			style = {
				horizontal_alignment = "right",
				color = Color.terminal_icon(nil, true),
				default_color = Color.terminal_corner(nil, true),
				highlight_color = Color.terminal_corner_hover(nil, true),
				size = {
					4
				},
				offset = {
					0,
					0,
					2
				}
			}
		}
	}, "background")
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
