-- chunkname: @scripts/ui/hud/elements/dodge_counter/hud_element_dodge_counter_definitions.lua

local HudElementDodgeCounterSettings = require("scripts/ui/hud/elements/dodge_counter/hud_element_dodge_counter_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local bar_size = HudElementDodgeCounterSettings.bar_size
local area_size = HudElementDodgeCounterSettings.area_size
local glow_size = HudElementDodgeCounterSettings.glow_size
local center_offset = HudElementDodgeCounterSettings.center_offset
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
			-5,
			1,
		},
	},
	overlap_bar = {
		horizontal_alignment = "center",
		parent = "area",
		vertical_alignment = "top",
		size = bar_size,
		position = {
			0,
			2,
			1,
		},
	},
	dodge_bar = {
		horizontal_alignment = "center",
		parent = "area",
		vertical_alignment = "top",
		size = bar_size,
		position = {
			0,
			2,
			1,
		},
	},
}
local value_text_style = table.clone(UIFontSettings.body_small)

value_text_style.offset = {
	0,
	10,
	3,
}
value_text_style.size = {
	500,
	30,
}
value_text_style.vertical_alignment = "top"
value_text_style.horizontal_alignment = "left"
value_text_style.text_horizontal_alignment = "left"
value_text_style.text_vertical_alignment = "top"
value_text_style.text_color = UIHudSettings.color_tint_main_1

local name_text_style = table.clone(value_text_style)

name_text_style.offset = {
	0,
	18,
	3,
}
name_text_style.horizontal_alignment = "right"
name_text_style.text_horizontal_alignment = "right"
name_text_style.text_color = UIHudSettings.color_tint_main_2
name_text_style.drop_shadow = false

local DODGE_STATE_COLORS_OVERLAP_BAR = HudElementDodgeCounterSettings.DODGE_STATE_COLORS_OVERLAP_BAR
local DODGE_BAR_STATE_COLORS_BAR_FILL = HudElementDodgeCounterSettings.DODGE_BAR_STATE_COLORS_BAR_FILL
local DODGE_BAR_STATE_COLORS_BAR_BACKGROUND = HudElementDodgeCounterSettings.DODGE_BAR_STATE_COLORS_BAR_BACKGROUND
local widget_definitions = {
	gauge = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "warning",
			value = "content/ui/materials/hud/dodge_gauge",
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
	wide_bar = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "bar_overlap",
			value = "content/ui/materials/hud/stamina_full",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				offset = {
					0,
					0,
					5,
				},
				size_addition = {
					0,
					0,
				},
				color = DODGE_STATE_COLORS_OVERLAP_BAR.hidden,
			},
		},
	}, "overlap_bar"),
}
local dodge_bar_definition = UIWidget.create_definition({
	{
		pass_type = "rect",
		style_id = "bar_fill",
		value = "content/ui/materials/hud/stamina_full",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "top",
			size = bar_size,
			offset = {
				0,
				0,
				3,
			},
			size_addition = {
				0,
				0,
			},
			color = DODGE_BAR_STATE_COLORS_BAR_FILL.available,
		},
	},
	{
		pass_type = "rect",
		style_id = "bar_background",
		value = "content/ui/materials/hud/stamina_full",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "top",
			size = bar_size,
			offset = {
				0,
				0,
				2,
			},
			size_addition = {
				0,
				0,
			},
			color = DODGE_BAR_STATE_COLORS_BAR_BACKGROUND.default,
		},
	},
}, "dodge_bar")
local animations = {
	on_bar_spent = {
		{
			end_time = 0.3,
			name = "on_bar_spent",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				local widget = params.dodge_bar_widget
				local widget_style = widget.style
				local bar_size_addition = widget_style.bar_fill.size_addition

				bar_size_addition[2] = anim_progress * 16

				local fill_widget_color = widget_style.bar_fill.color
				local color_anim_progress = math.easeOutCubic(progress)

				fill_widget_color[1] = 255 * (1 - anim_progress)
				fill_widget_color[2] = math.lerp(DODGE_BAR_STATE_COLORS_BAR_FILL.available[2], DODGE_BAR_STATE_COLORS_BAR_FILL.available_on_cooldown[2], color_anim_progress)
				fill_widget_color[3] = math.lerp(DODGE_BAR_STATE_COLORS_BAR_FILL.available[3], DODGE_BAR_STATE_COLORS_BAR_FILL.available_on_cooldown[3], color_anim_progress)
				fill_widget_color[4] = math.lerp(DODGE_BAR_STATE_COLORS_BAR_FILL.available[4], DODGE_BAR_STATE_COLORS_BAR_FILL.available_on_cooldown[4], color_anim_progress)
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local dodge_bar = params.dodge_bar

				dodge_bar.animation_id = nil
			end,
		},
	},
	on_bar_enter_cooldown = {
		{
			end_time = 0.3,
			name = "on_bar_enter_cooldown",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local dodge_bar_widget = params.dodge_bar_widget
				local widget_style = dodge_bar_widget.style
				local bar_size_addition = widget_style.bar_fill.size_addition

				bar_size_addition[2] = 0

				local fill_widget_color = widget_style.bar_fill.color

				fill_widget_color[1] = 255
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local dodge_bar_widget = params.dodge_bar_widget
				local widget_style = dodge_bar_widget.style
				local color_anim_progress = math.easeOutCubic(progress)
				local fill_widget_color = widget_style.bar_fill.color

				fill_widget_color[2] = math.lerp(DODGE_BAR_STATE_COLORS_BAR_FILL.available[2], DODGE_BAR_STATE_COLORS_BAR_FILL.available_on_cooldown[2], color_anim_progress)
				fill_widget_color[3] = math.lerp(DODGE_BAR_STATE_COLORS_BAR_FILL.available[3], DODGE_BAR_STATE_COLORS_BAR_FILL.available_on_cooldown[3], color_anim_progress)
				fill_widget_color[4] = math.lerp(DODGE_BAR_STATE_COLORS_BAR_FILL.available[4], DODGE_BAR_STATE_COLORS_BAR_FILL.available_on_cooldown[4], color_anim_progress)
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local dodge_bar = params.dodge_bar

				dodge_bar.animation_id = nil
			end,
		},
	},
	on_bar_exit_cooldown = {
		{
			end_time = 0.2,
			name = "on_bar_exit_cooldown",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local dodge_bar_widget = params.dodge_bar_widget
				local widget_style = dodge_bar_widget.style
				local bar_size_addition = widget_style.bar_fill.size_addition

				bar_size_addition[2] = 0

				local fill_widget_color = widget_style.bar_fill.color

				fill_widget_color[1] = 255
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local dodge_bar_widget = params.dodge_bar_widget
				local widget_style = dodge_bar_widget.style
				local color_anim_progress = math.easeOutCubic(1 - progress)
				local fill_widget_color = widget_style.bar_fill.color

				fill_widget_color[2] = math.lerp(DODGE_BAR_STATE_COLORS_BAR_FILL.available[2], DODGE_BAR_STATE_COLORS_BAR_FILL.available_on_cooldown[2], color_anim_progress)
				fill_widget_color[3] = math.lerp(DODGE_BAR_STATE_COLORS_BAR_FILL.available[3], DODGE_BAR_STATE_COLORS_BAR_FILL.available_on_cooldown[3], color_anim_progress)
				fill_widget_color[4] = math.lerp(DODGE_BAR_STATE_COLORS_BAR_FILL.available[4], DODGE_BAR_STATE_COLORS_BAR_FILL.available_on_cooldown[4], color_anim_progress)
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local dodge_bar = params.dodge_bar

				dodge_bar.animation_id = nil
			end,
		},
	},
	on_bar_restored = {
		{
			end_time = 0.2,
			name = "on_bar_restored",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local dodge_bar_widget = params.dodge_bar_widget
				local widget_style = dodge_bar_widget.style
				local anim_progress = math.easeOutCubic(progress)
				local bar_size_addition = widget_style.bar_fill.size_addition

				bar_size_addition[2] = (1 - anim_progress) * 25

				local color_anim_progress = math.easeOutCubic(progress)
				local fill_widget_color = widget_style.bar_fill.color

				fill_widget_color[1] = 255 * color_anim_progress
				fill_widget_color[2] = DODGE_BAR_STATE_COLORS_BAR_FILL.available[2]
				fill_widget_color[3] = DODGE_BAR_STATE_COLORS_BAR_FILL.available[3]
				fill_widget_color[4] = DODGE_BAR_STATE_COLORS_BAR_FILL.available[4]
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local dodge_bar = params.dodge_bar

				dodge_bar.animation_id = nil
			end,
		},
	},
	on_inefficient_dodge = {
		{
			end_time = 0.3,
			name = "on_inefficient_dodge",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local wide_bar_widget = widgets.wide_bar
				local widget_style = wide_bar_widget.style
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
	dodge_bar_definition = dodge_bar_definition,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
