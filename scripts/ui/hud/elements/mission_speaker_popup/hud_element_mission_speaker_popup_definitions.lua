-- chunkname: @scripts/ui/hud/elements/mission_speaker_popup/hud_element_mission_speaker_popup_definitions.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local HudElementMissionSpeakerPopupSettings = require("scripts/ui/hud/elements/mission_speaker_popup/hud_element_mission_speaker_popup_settings")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local portrait_size = HudElementMissionSpeakerPopupSettings.portrait_size
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	background = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = portrait_size,
		position = {
			-50,
			300,
			1,
		},
	},
}
local name_text_style = table.clone(UIFontSettings.hud_body)

name_text_style.horizontal_alignment = "right"
name_text_style.vertical_alignment = "top"
name_text_style.text_horizontal_alignment = "right"
name_text_style.text_vertical_alignment = "bottom"
name_text_style.size = {
	650,
	40,
}
name_text_style.offset = {
	-(portrait_size[1] + 20),
	15,
	2,
}
name_text_style.drop_shadow = true
name_text_style.font_size = 24

local title_text_style = table.clone(name_text_style)

title_text_style.offset = {
	-(portrait_size[1] + 20),
	-10,
	2,
}
title_text_style.text_color = UIHudSettings.color_tint_main_2

local widget_definitions = {
	popup = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "portrait",
			value = "content/ui/materials/base/ui_radio_portrait_base",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				offset = {
					-1,
					0,
					0,
				},
				color = {
					255,
					255,
					255,
					255,
				},
				material_values = {
					distortion = 1,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/hud/backgrounds/weapon_frame",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				color = UIHudSettings.color_tint_main_3,
				offset = {
					0,
					0,
					2,
				},
				size_addition = {
					8,
					5,
				},
			},
		},
	}, "background"),
	name_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "name_text",
			value = "<name_text>",
			value_id = "name_text",
			style = name_text_style,
		},
	}, "background"),
	title_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "title_text",
			value_id = "title_text",
			value = Localize("loc_mission_speaker_title_text"),
			style = title_text_style,
		},
	}, "background"),
	radio = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "soundwave",
			value = "content/ui/materials/icons/hud/radio",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "top",
				size = {
					64,
					32,
				},
				offset = {
					-250,
					55,
					0,
				},
				color = UIHudSettings.color_tint_main_2,
			},
		},
	}, "background"),
}
local num_bars = HudElementMissionSpeakerPopupSettings.bar_amount

for i = 1, num_bars do
	local name = "bar_" .. i

	widget_definitions[name] = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = HudElementMissionSpeakerPopupSettings.bar_size,
				color = UIHudSettings.color_tint_main_4,
				offset = {
					0,
					0,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "bar",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = HudElementMissionSpeakerPopupSettings.bar_size,
				color = UIHudSettings.color_tint_main_2,
				offset = {
					0,
					0,
					1,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/line_light",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = HudElementMissionSpeakerPopupSettings.bar_size,
				color = UIHudSettings.color_tint_main_3,
				size_addition = {
					4,
					4,
				},
				offset = {
					0,
					2,
					2,
				},
			},
		},
	}, "background")
end

local animations = {
	popup_enter = {
		{
			end_time = 0,
			name = "hide everything",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets)
				for key, widget in pairs(widgets) do
					widget.alpha_multiplier = 0
				end

				widgets.popup.style.portrait.material_values.distortion = 1
			end,
		},
		{
			end_time = 0.5,
			name = "icon_fade_in",
			start_time = 0.1,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress)
				local anim_progress = math.easeOutCubic(progress)
				local popup_widget = widgets.popup

				popup_widget.alpha_multiplier = anim_progress
				popup_widget.offset[1] = 50 - 50 * anim_progress
			end,
		},
		{
			end_time = 2,
			name = "icon_distortion",
			start_time = 0.3,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress)
				local anim_progress = math.ease_out_exp(math.bounce(progress))
				local popup_widget = widgets.popup

				popup_widget.style.portrait.material_values.distortion = anim_progress
			end,
		},
		{
			end_time = 1,
			name = "text_fade_in",
			start_time = 0.6,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress)
				local anim_progress = math.easeCubic(progress)
				local popup_widget = widgets.popup

				for key, widget in pairs(widgets) do
					if key ~= "popup" then
						widget.alpha_multiplier = anim_progress
					end
				end
			end,
		},
	},
	popup_exit = {
		{
			end_time = 0.3,
			name = "text_fade_out",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress)
				local anim_progress = 1 - math.easeOutCubic(progress)

				for key, widget in pairs(widgets) do
					if key ~= "popup" then
						widget.alpha_multiplier = anim_progress
					end
				end
			end,
		},
		{
			end_time = 0.8,
			name = "icon_distortion",
			start_time = 0.3,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress)
				local anim_progress = 1 - math.easeOutCubic(progress)
				local popup_widget = widgets.popup

				popup_widget.style.portrait.material_values.distortion = anim_progress
			end,
		},
		{
			end_time = 1,
			name = "icon_fade_out",
			start_time = 0.5,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress)
				local anim_progress = 1 - math.easeOutCubic(progress)
				local popup_widget = widgets.popup

				popup_widget.alpha_multiplier = anim_progress
				popup_widget.offset[1] = 50 - 50 * anim_progress
			end,
		},
	},
}

return {
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
