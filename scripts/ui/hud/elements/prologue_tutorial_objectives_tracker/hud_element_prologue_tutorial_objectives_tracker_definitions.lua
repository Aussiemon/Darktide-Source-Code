local HudElementPrologueTutorialObjectivesTrackerSettings = require("scripts/ui/hud/elements/prologue_tutorial_objectives_tracker/hud_element_prologue_tutorial_objectives_tracker_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local objective_tracker_settings = HudElementPrologueTutorialObjectivesTrackerSettings
local background_size = objective_tracker_settings.background_size
local entry_size = objective_tracker_settings.entry_size
local scenegraph_definition = {
	screen = {
		UIWorkspaceSettings.screen
	},
	background = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = background_size,
		position = {
			0,
			0,
			0
		}
	},
	entry_pivot = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "center",
		size = background_size,
		position = {
			-25,
			25,
			0
		}
	}
}
local entry_text_style = {
	font_size = 20,
	text_vertical_alignment = "center",
	text_horizontal_alignment = "center",
	drop_shadow = false,
	font_type = "proxima_nova_bold",
	offset = {
		0,
		0,
		0
	},
	size = entry_size,
	text_color = objective_tracker_settings.entry_colors.entry_text,
	default_text_color = objective_tracker_settings.entry_colors.entry_text
}
local counter_text_style = {
	font_size = 20,
	text_vertical_alignment = "center",
	text_horizontal_alignment = "right",
	drop_shadow = false,
	font_type = "proxima_nova_bold",
	offset = {
		0,
		0,
		0
	},
	size = {
		75,
		75
	},
	text_color = objective_tracker_settings.entry_colors.entry_text,
	default_text_color = objective_tracker_settings.entry_colors.entry_text
}

local function create_entry_widget(scenegraph_id, offset)
	return UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/backgrounds/fade_horizontal",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "top",
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
				color = UIHudSettings.color_tint_main_3,
				size = entry_size,
				offset = offset
			}
		},
		{
			value_id = "icon",
			style_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/icons/objectives/main",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				size = objective_tracker_settings.icon_size,
				offset = offset,
				color = UIHudSettings.color_tint_main_1
			}
		},
		{
			vertical_alignment = "top",
			pass_type = "text",
			style_id = "entry_text",
			value = "",
			value_id = "entry_text",
			horizontal_alignment = "center",
			style = {
				font_type = "proxima_nova_bold",
				font_size = 20,
				text_vertical_alignment = "center",
				text_horizontal_alignment = "right",
				drop_shadow = false,
				initial_x_offset = 100,
				offset = {
					100,
					offset[2],
					4
				},
				size = {
					entry_size[1] - 100,
					entry_size[2]
				},
				text_color = objective_tracker_settings.entry_colors.entry_text,
				default_text_color = objective_tracker_settings.entry_colors.entry_text
			}
		},
		{
			vertical_alignment = "top",
			pass_type = "text",
			style_id = "counter_text",
			value = "",
			value_id = "counter_text",
			horizontal_alignment = "left",
			style = {
				font_type = "proxima_nova_bold",
				font_size = 20,
				text_vertical_alignment = "center",
				text_horizontal_alignment = "left",
				drop_shadow = false,
				initial_x_offset = 60,
				offset = {
					80,
					offset[2],
					4
				},
				size = {
					50,
					50
				},
				text_color = objective_tracker_settings.entry_colors.entry_text,
				default_text_color = objective_tracker_settings.entry_colors.entry_text
			}
		}
	}, scenegraph_id)
end

local widget_definitions = {}
local animations = {
	add_entry = {
		{
			name = "add_entry_init",
			end_time = 0,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				widget.alpha_multiplier = 0
			end
		},
		{
			name = "add_entry",
			end_time = 0.6,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local scenegraph_id = widget.scenegraph_id
				local scenegraph_definition = scenegraph_definition[scenegraph_id]
				local size = scenegraph_definition.size
				local size_x = size[1]
				local styles = widget.style

				for _, style in pairs(styles) do
					local initial_offset = style.initial_x_offset or 0
					local desired_x = size_x - initial_offset
					style.offset[1] = size_x - desired_x * math.easeInCubic(progress)
				end
			end
		},
		{
			name = "fade_in",
			end_time = 0.4,
			start_time = 0.2,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				widget.alpha_multiplier = 1 * math.easeOutCubic(progress)
			end
		}
	}
}
animations.remove_entry = {
	{
		name = "remove_entry",
		end_time = 0.8,
		start_time = 0,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
			for _, widget in pairs(widgets) do
				local scenegraph_id = widget.scenegraph_id
				local scenegraph_definition = scenegraph_definition[scenegraph_id]
				local size = scenegraph_definition.size
				local size_x = size[1]
				local styles = widget.style

				for _, style in pairs(styles) do
					local offset_x = style.offset[1]
					style.offset[1] = offset_x - size_x * -1 * math.easeInCubic(progress)
				end
			end
		end
	},
	{
		name = "fade_out",
		end_time = 0.8,
		start_time = 0.6,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
			local alpha = -1 * math.easeOutCubic(progress)

			for _, widget in pairs(widgets) do
				widget.alpha_multiplier = alpha
			end
		end
	}
}

return {
	animations = animations,
	create_entry_widget = create_entry_widget,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
