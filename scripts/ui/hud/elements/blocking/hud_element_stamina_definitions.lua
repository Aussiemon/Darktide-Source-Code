-- chunkname: @scripts/ui/hud/elements/blocking/hud_element_stamina_definitions.lua

local HudElementStaminaSettings = require("scripts/ui/hud/elements/blocking/hud_element_stamina_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local bar_size = HudElementStaminaSettings.bar_size
local spacing = HudElementStaminaSettings.spacing
local area_size = HudElementStaminaSettings.area_size
local glow_size = HudElementStaminaSettings.glow_size
local center_offset = HudElementStaminaSettings.center_offset
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	area = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = area_size,
		position = {
			0,
			center_offset,
			0,
		},
	},
	gauge = {
		horizontal_alignment = "center",
		parent = "area",
		vertical_alignment = "top",
		size = {
			212,
			10,
		},
		position = {
			0,
			6,
			1,
		},
	},
	stamina_bar = {
		horizontal_alignment = "center",
		parent = "area",
		vertical_alignment = "top",
		size = bar_size,
		position = {
			0,
			1,
			1,
		},
	},
}
local STAMINA_BAR_BACKGROUND_COLOR = HudElementStaminaSettings.STAMINA_BAR_BACKGROUND_COLOR
local STAMINA_NODGES_COLOR = HudElementStaminaSettings.STAMINA_NODGES_COLOR
local STAMINA_BAR_COLOR = HudElementStaminaSettings.STAMINA_BAR_COLOR
local value_text_style = table.clone(UIFontSettings.body_small)

value_text_style.offset = {
	-54,
	-12,
	3,
}
value_text_style.size = {
	50,
	30,
}
value_text_style.vertical_alignment = "top"
value_text_style.horizontal_alignment = "left"
value_text_style.text_horizontal_alignment = "right"
value_text_style.text_vertical_alignment = "top"
value_text_style.text_color = UIHudSettings.color_tint_main_1

local widget_definitions = {
	gauge = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "value_text",
			value_id = "value_text",
			value = Utf8.upper(Localize("loc_hud_display_overheat_death_danger")),
			style = value_text_style,
		},
		{
			pass_type = "texture",
			style_id = "warning",
			value = "content/ui/materials/hud/stamina_gauge",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					1,
				},
				color = UIHudSettings.color_tint_main_2,
			},
		},
	}, "gauge"),
	stamina_bar = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "bar_background",
			value = "content/ui/materials/hud/stamina_full",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				offset = {
					0,
					0,
					4,
				},
				size_addition = {
					0,
					0,
				},
				color = STAMINA_BAR_COLOR.background,
			},
		},
		{
			pass_type = "rect",
			style_id = "bar_spent",
			value = "content/ui/materials/hud/stamina_spent",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				offset = {
					0,
					0,
					5,
				},
				size_addition = {
					0,
					0,
				},
				color = STAMINA_BAR_COLOR.spent,
			},
		},
		{
			pass_type = "rect",
			style_id = "bar_fill",
			value = "content/ui/materials/hud/stamina_full",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				offset = {
					0,
					0,
					6,
				},
				size_addition = {
					0,
					0,
				},
				color = STAMINA_BAR_COLOR.fill,
			},
		},
	}, "stamina_bar"),
	stamina_depleted_bar = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "bar_overlap",
			value = "content/ui/materials/hud/stamina_full",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				offset = {
					0,
					0,
					8,
				},
				size_addition = {
					0,
					0,
				},
				color = STAMINA_BAR_BACKGROUND_COLOR,
			},
		},
	}, "stamina_bar"),
}
local stamina_nodges = UIWidget.create_definition({
	{
		pass_type = "rect",
		style_id = "nodges",
		value = "content/ui/materials/hud/stamina_full",
		style = {
			horizontal_alignment = "left",
			vertical_alignment = "top",
			size = {
				spacing,
				6,
			},
			offset = {
				0,
				0,
				7,
			},
			size_addition = {
				0,
				0,
			},
			color = STAMINA_NODGES_COLOR.filled,
		},
	},
}, "stamina_bar")
local animations = {
	on_stamina_depleted = {
		{
			end_time = 0.3,
			name = "bar_overlap_flash",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local stamina_depleted_bar_widget = widgets.stamina_depleted_bar
				local widget_style = stamina_depleted_bar_widget.style
				local anim_progress = math.easeOutCubic(progress)
				local bar_size_addition = widget_style.bar_overlap.size_addition

				bar_size_addition[2] = anim_progress * 15

				local color_anim_progress = math.easeOutCubic(progress)
				local fill_widget_color = widget_style.bar_overlap.color

				fill_widget_color[1] = 255 * (1 - color_anim_progress)
			end,
		},
	},
}

return {
	animations = animations,
	stamina_nodges_definition = stamina_nodges,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
