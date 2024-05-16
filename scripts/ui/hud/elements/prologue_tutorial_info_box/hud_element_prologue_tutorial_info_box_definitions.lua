-- chunkname: @scripts/ui/hud/elements/prologue_tutorial_info_box/hud_element_prologue_tutorial_info_box_definitions.lua

local HudElementPrologueTutorialInfoBoxSettings = require("scripts/ui/hud/elements/prologue_tutorial_info_box/hud_element_prologue_tutorial_info_box_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")

require("scripts/foundation/utilities/color")

local get_hud_color = UIHudSettings.get_hud_color
local info_box_settings = HudElementPrologueTutorialInfoBoxSettings
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	background = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = info_box_settings.info_box_background_size,
		position = {
			50,
			100,
			5,
		},
	},
	entry_pivot_1 = {
		horizontal_alignment = "left",
		parent = "background",
		vertical_alignment = "top",
		size = info_box_settings.tracker_background_size,
		position = {
			0,
			0,
			0,
		},
	},
	entry_pivot_2 = {
		horizontal_alignment = "left",
		parent = "background",
		vertical_alignment = "top",
		size = info_box_settings.tracker_background_size,
		position = {
			0,
			0,
			0,
		},
	},
	entry_pivot_3 = {
		horizontal_alignment = "left",
		parent = "background",
		vertical_alignment = "top",
		size = info_box_settings.tracker_background_size,
		position = {
			0,
			0,
			0,
		},
	},
	entry_pivot_4 = {
		horizontal_alignment = "left",
		parent = "background",
		vertical_alignment = "top",
		size = info_box_settings.tracker_background_size,
		position = {
			0,
			0,
			0,
		},
	},
}
local entry_size = info_box_settings.tracker_entry_size
local widget_definitions = {
	info_widget = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size_addition = {
					10,
					10,
				},
				color = Color.terminal_grid_background(255, true),
				offset = {
					0,
					0,
					0,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "title_text",
			value_id = "title_text",
			style = info_box_settings.title_text_style,
		},
		{
			pass_type = "text",
			style_id = "input_description_text",
			value_id = "input_description_text",
			style = info_box_settings.input_description_text_style,
		},
		{
			pass_type = "text",
			style_id = "description_text",
			value_id = "description_text",
			style = info_box_settings.description_text_style,
		},
	}, "background"),
}
local animations = {
	popup_enter = {
		{
			end_time = 0,
			name = "reset",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				widget.alpha_multiplier = 0

				local style = widget.style
				local alpha = 0
				local scenegraph_id = widget.scenegraph_id
				local scenegraph_definition = scenegraph_definition[scenegraph_id]
				local size = scenegraph_definition.size
				local size_x = size[1]

				style.description_text.text_color[1] = alpha
				widget.offset[1] = -size_x - 25
			end,
		},
		{
			end_time = 0.8,
			name = "enter_left",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				local scenegraph_id = widget.scenegraph_id
				local scenegraph_definition = scenegraph_definition[scenegraph_id]
				local size = scenegraph_definition.size
				local size_x = size[1]
				local anim_progress = math.easeOutCubic(progress)

				widget.alpha_multiplier = anim_progress
				widget.offset[1] = -size_x - 25 + (25 + size_x) * math.easeInCubic(progress)
			end,
		},
		{
			end_time = 0.8,
			name = "text_fade_in",
			start_time = 0.3,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				local anim_progress = math.easeOutCubic(progress)
				local style = widget.style
				local alpha = anim_progress * 255

				style.description_text.text_color[1] = alpha
				style.input_description_text.text_color[1] = alpha
			end,
		},
		{
			end_time = 1.3,
			name = "delay",
			start_time = 0.8,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				return
			end,
		},
	},
	popup_exit = {
		{
			end_time = 0.5,
			name = "text_fade_out",
			start_time = 0.3,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				local anim_progress = math.easeInCubic(1 - progress)
				local style = widget.style
				local alpha = anim_progress * 255

				style.description_text.text_color[1] = alpha
				style.input_description_text.text_color[1] = alpha
			end,
		},
		{
			end_time = 0.8,
			name = "fade_out",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				local anim_progress = math.easeOutCubic(1 - progress)

				widget.alpha_multiplier = anim_progress

				local scenegraph_id = widget.scenegraph_id
				local scenegraph_definition = scenegraph_definition[scenegraph_id]
				local size = scenegraph_definition.size
				local size_x = size[1]

				widget.offset[1] = 25 + (-size_x - 25) * math.easeInCubic(progress)
			end,
		},
		{
			end_time = 1.5,
			name = "delay",
			start_time = 0.5,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				return
			end,
		},
	},
	add_entry = {
		{
			end_time = 0,
			name = "add_entry_init",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				widget.alpha_multiplier = 0

				local scenegraph_id = widget.scenegraph_id
				local scenegraph_definition = scenegraph_definition[scenegraph_id]
				local size = scenegraph_definition.size
				local size_x = size[1]

				widget.offset[1] = -size_x - 25
			end,
		},
		{
			end_time = 0.8,
			name = "add_entry",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local scenegraph_id = widget.scenegraph_id
				local scenegraph_definition = scenegraph_definition[scenegraph_id]
				local size = scenegraph_definition.size
				local size_x = size[1]

				widget.offset[1] = -size_x - 25 + (25 + size_x) * math.easeInCubic(progress)
			end,
		},
		{
			end_time = 0.4,
			name = "fade_in",
			start_time = 0.2,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				widget.alpha_multiplier = 1 * math.easeOutCubic(progress)
			end,
		},
	},
	remove_entry = {
		{
			end_time = 0.8,
			name = "remove_entry",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				for _, widget in pairs(widgets) do
					local scenegraph_id = widget.scenegraph_id
					local scenegraph_definition = scenegraph_definition[scenegraph_id]
					local size = scenegraph_definition.size
					local size_x = size[1]

					widget.offset[1] = 25 + (-size_x - 25) * math.easeInCubic(progress)
				end
			end,
		},
		{
			end_time = 0.8,
			name = "fade_out",
			start_time = 0.6,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local alpha = -1 * math.easeOutCubic(progress)

				for _, widget in pairs(widgets) do
					widget.alpha_multiplier = alpha
				end
			end,
		},
	},
	uptick_entry = {
		{
			end_time = 0.4,
			name = "blink",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local style = widget.style
				local alpha = 190 + 65 * math.sin(Managers.time:time("ui") * 20)

				style.frame.color[1] = alpha
			end,
		},
		{
			end_time = 0.8,
			name = "reset_alpha",
			start_time = 0.4,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local style = widget.style
				local alpha = math.lerp(style.frame.color[1], 255, progress)

				style.frame.color[1] = alpha
			end,
		},
	},
	complete_entry = {
		{
			end_time = 0.8,
			name = "blink",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local style = widget.style
				local alpha = 190 + 65 * math.sin(Managers.time:time("ui") * 20)

				style.frame.color[1] = alpha
			end,
		},
		{
			end_time = 1.2,
			name = "reset_alpha",
			start_time = 0.8,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local style = widget.style
				local alpha = math.lerp(style.frame.color[1], 255, progress)

				style.frame.color[1] = alpha
			end,
		},
		{
			end_time = 0.6,
			name = "fade_out_counter",
			start_time = 0.4,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local style = widget.style
				local alpha = 255 * (1 - progress)

				style.counter_text.text_color[1] = alpha
			end,
		},
		{
			end_time = 0.8,
			name = "fade_in_checkmark",
			start_time = 0.6,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				local content = widget.content

				content.counter_text = ""

				local style = widget.style

				style.counter_text.font_size = 30
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local style = widget.style
				local alpha = 255 * progress

				style.counter_text.text_color[1] = alpha
			end,
		},
	},
}

local function create_entry_widget(scenegraph_id)
	local counter_text_style = info_box_settings.counter_text_style

	counter_text_style.offset = {
		30,
		0,
		6,
	}
	counter_text_style.text_color = info_box_settings.tracker_entry_colors.entry_text
	counter_text_style.default_text_color = info_box_settings.tracker_entry_colors.entry_text

	local entry_text_style = info_box_settings.entry_text_style

	entry_text_style.offset = {
		80,
		0,
		6,
	}
	entry_text_style.text_color = info_box_settings.tracker_entry_colors.entry_text
	entry_text_style.default_text_color = info_box_settings.tracker_entry_colors.entry_text

	return UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				scale_to_material = true,
				vertical_alignment = "top",
				size = entry_size,
				size_addition = {
					20,
					15,
				},
				color = Color.terminal_grid_background(255, true),
				offset = {
					-5,
					-10,
					0,
				},
			},
		},
		{
			horizontal_alignment = "center",
			pass_type = "text",
			style_id = "entry_text",
			value = "",
			value_id = "entry_text",
			vertical_alignment = "top",
			style = entry_text_style,
		},
		{
			horizontal_alignment = "left",
			pass_type = "text",
			style_id = "counter_text",
			value = "",
			value_id = "counter_text",
			vertical_alignment = "top",
			style = counter_text_style,
		},
	}, scenegraph_id)
end

return {
	animations = animations,
	create_entry_widget = create_entry_widget,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
