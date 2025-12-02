-- chunkname: @scripts/ui/views/class_selection_view/class_selection_view_definitions.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ClassSelectionViewFontStyle = require("scripts/ui/views/class_selection_view/class_selection_view_font_style")
local ClassSelectionViewSettings = require("scripts/ui/views/class_selection_view/class_selection_view_settings")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local UIWidget = require("scripts/managers/ui/ui_widget")
local scenegraph_definition = {
	screen = {
		scale = "fit",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			0,
		},
	},
	canvas = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			0,
		},
	},
	main_title = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			640,
			80,
		},
		position = {
			0,
			55,
			2,
		},
	},
	archetype = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			760,
			390,
		},
		position = {
			160,
			-235,
			2,
		},
	},
	archetype_info = {
		horizontal_alignment = "center",
		parent = "archetype",
		vertical_alignment = "bottom",
		size = {
			600,
			300,
		},
		position = {
			0,
			0,
			3,
		},
	},
	archetype_options = {
		horizontal_alignment = "left",
		parent = "archetype_info",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			10,
		},
	},
	class_option = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			920,
			680,
		},
		position = {
			220,
			-165,
			2,
		},
	},
	class = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = ClassSelectionViewSettings.class_size,
		position = {
			-200,
			-235,
			1,
		},
	},
	class_title = {
		horizontal_alignment = "center",
		parent = "class",
		vertical_alignment = "top",
		size = {
			ClassSelectionViewSettings.class_size[1],
			50,
		},
		position = {
			0,
			15,
			3,
		},
	},
	class_description = {
		horizontal_alignment = "center",
		parent = "class",
		vertical_alignment = "top",
		size = {
			ClassSelectionViewSettings.class_size[1],
			540,
		},
		position = {
			0,
			100,
			3,
		},
	},
	details_button = {
		horizontal_alignment = "center",
		parent = "archetype",
		vertical_alignment = "bottom",
		size = ButtonPassTemplates.terminal_button.size,
		position = {
			0,
			125,
			2,
		},
	},
	continue_button = {
		horizontal_alignment = "center",
		parent = "class",
		vertical_alignment = "bottom",
		size = ButtonPassTemplates.default_button.size,
		position = {
			0,
			125,
			2,
		},
	},
	class_details = {
		horizontal_alignment = "center",
		parent = "class",
		vertical_alignment = "top",
		size = {
			ClassSelectionViewSettings.class_size[1],
			ClassSelectionViewSettings.class_size[2],
		},
		position = {
			0,
			0,
			2,
		},
	},
	class_details_mask = {
		horizontal_alignment = "left",
		parent = "class_details",
		vertical_alignment = "center",
		size = {
			ClassSelectionViewSettings.class_size[1] - 50,
			ClassSelectionViewSettings.class_size[2],
		},
		position = {
			20,
			-12,
			3,
		},
	},
	class_details_scrollbar = {
		horizontal_alignment = "right",
		parent = "class",
		vertical_alignment = "center",
		size = {
			7,
			ClassSelectionViewSettings.class_size[2] - 30,
		},
		position = {
			-2,
			0,
			50,
		},
	},
	class_details_content_pivot = {
		horizontal_alignment = "left",
		parent = "class_details",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			3,
		},
	},
}
local widget_definitions = {
	corners = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/frames/screen/class_psyker_01_lower_left",
			value_id = "left_lower",
			style = {
				vertical_alignment = "bottom",
				size = {
					70,
					202,
				},
				offset = {
					0,
					0,
					62,
				},
				color = {
					255,
					255,
					255,
					255,
				},
			},
		},
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/frames/screen/class_psyker_01_lower_right",
			value_id = "right_lower",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "bottom",
				size = {
					70,
					202,
				},
				offset = {
					0,
					0,
					62,
				},
				color = {
					255,
					255,
					255,
					255,
				},
			},
		},
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/frames/screen/class_psyker_01_upper_right",
			value_id = "right_upper",
			style = {
				vertical_alignment = "top",
				size = {
					130,
					272,
				},
				offset = {
					0,
					0,
					62,
				},
				color = {
					255,
					255,
					255,
					255,
				},
				uvs = {
					{
						1,
						0,
					},
					{
						0,
						1,
					},
				},
			},
		},
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/frames/screen/class_psyker_01_upper_right",
			value_id = "left_upper",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "top",
				size = {
					130,
					272,
				},
				offset = {
					0,
					0,
					62,
				},
				color = {
					255,
					255,
					255,
					255,
				},
			},
		},
	}, "screen"),
	transition_fade = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "background",
			style = {
				color = Color.black(255, true),
				offset = {
					0,
					0,
					1,
				},
			},
		},
	}, "screen"),
	main_title = UIWidget.create_definition({
		{
			pass_type = "text",
			value = "",
			value_id = "text",
			style = ClassSelectionViewFontStyle.main_title_style,
		},
	}, "main_title"),
	archetype_info = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "title",
			value = "",
			value_id = "title",
			style = ClassSelectionViewFontStyle.archetype_title_style,
		},
		{
			pass_type = "texture",
			style_id = "divider",
			value = "content/ui/materials/dividers/skull_center_02",
			value_id = "divider",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				size = {
					400,
					18,
				},
				offset = {
					0,
					100,
					1,
				},
				color = Color.terminal_frame(255, true),
			},
		},
		{
			pass_type = "texture",
			style_id = "class_background_details",
			value = "content/ui/materials/backgrounds/terminal_basic",
			value_id = "background",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "top",
				color = Color.terminal_grid_background(nil, true),
				size_addition = {
					15,
					30,
				},
				offset = {
					0,
					-15,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/horizontal_frame_big_lower",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = {
					nil,
					36,
				},
				offset = {
					0,
					18,
					1,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "description",
			value = "",
			value_id = "description",
			style = ClassSelectionViewFontStyle.archetype_description_style,
		},
	}, "archetype_info"),
	class_background = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/backgrounds/terminal_basic",
			value_id = "background",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "top",
				color = Color.terminal_grid_background(nil, true),
				size_addition = {
					15,
					30,
				},
				offset = {
					0,
					-15,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "class_background",
			value = "",
			value_id = "class_background",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.black(76.5, true),
				size = {
					480,
					480,
				},
				offset = {
					0,
					0,
					1,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "top_frame",
			value = "content/ui/materials/dividers/horizontal_frame_big_upper",
			value_id = "top_frame",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				size = {
					nil,
					36,
				},
				offset = {
					0,
					-18,
					1,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/horizontal_frame_big_lower",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = {
					nil,
					36,
				},
				offset = {
					0,
					18,
					1,
				},
			},
		},
	}, "class"),
	class_details_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.terminal_scrollbar, "class_details_scrollbar", {
		axis = 2,
	}),
	details_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "details_button", {
		gamepad_action = "secondary_action_pressed",
		original_text = Utf8.upper(Localize("loc_mission_voting_view_show_details")),
	}),
	continue_button = UIWidget.create_definition(ButtonPassTemplates.default_button, "continue_button", {
		gamepad_action = "confirm_pressed",
		original_text = Utf8.upper(Localize("loc_character_creator_continue")),
	}),
}
local archetype_option_frame_definition = UIWidget.create_definition({
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/base/ui_default_base",
		value_id = "frame",
		style = {
			hdr = true,
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			offset = {
				0,
				0,
				2,
			},
			material_values = {
				texture_map = ClassSelectionViewSettings.archetype_frames_textures.mid_1.texture,
			},
		},
	},
}, "archetype_options", nil, ClassSelectionViewSettings.archetype_frames_textures.mid_1.size)
local archetype_option_definition = UIWidget.create_definition({
	{
		content_id = "hotspot",
		pass_type = "hotspot",
	},
	{
		pass_type = "texture",
		style_id = "icon",
		value = "content/ui/materials/frames/class_selection_top_container",
		value_id = "icon",
		style = {
			hdr = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			offset = {
				0,
				0,
				4,
			},
			material_values = {},
		},
		change_function = function (content, style)
			local hotspot = content.hotspot
			local anim_progress = hotspot.anim_select_progress

			style.material_values.selected_not_selected = 1 - anim_progress
		end,
	},
	{
		pass_type = "texture",
		style_id = "highlight",
		value = "content/ui/materials/frames/class_selection_top_highlight",
		style = {
			hdr = true,
			horizontal_alignment = "left",
			scale_to_material = true,
			vertical_alignment = "top",
			default_color = Color.terminal_text_body(255, true),
			selected_color = Color.terminal_corner_selected(255, true),
			hover_color = Color.terminal_corner_hover(255, true),
			offset = {
				-15,
				-15,
				4,
			},
			size_addition = {
				30,
				30,
			},
		},
		change_function = function (content, style)
			local color = content.hotspot.is_selected and style.selected_color or (content.hotspot.is_hover or content.hotspot.is_focused) and style.hover_color or style.default_color

			style.color = {
				color[1],
				color[2],
				color[3],
				color[4],
			}
			style.color[1] = math.max(content.hotspot.anim_focus_progress, content.hotspot.anim_select_progress, content.hotspot.anim_hover_progress) * 255
		end,
		visibility_function = function (content, style)
			return content.hotspot.is_focused or content.hotspot.is_hover
		end,
	},
}, "archetype_options", nil, ClassSelectionViewSettings.archetype_option_icon_size)
local archetype_selection_definition = {
	left = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = ClassSelectionViewFontStyle.select_style,
		},
	}, "archetype_option"),
	right = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = ClassSelectionViewFontStyle.select_style,
		},
	}, "archetype_option"),
}
local legend_inputs = {
	{
		alignment = "left_alignment",
		display_name = "loc_class_selection_button_back",
		input_action = "back",
		on_pressed_callback = "_on_back_pressed",
		visibility_function = function (parent)
			return not parent._force_character_creation
		end,
	},
	{
		alignment = "left_alignment",
		display_name = "loc_quit_game_display_name",
		input_action = "back",
		on_pressed_callback = "_on_quit_pressed",
		visibility_function = function (parent)
			return parent._force_character_creation and PLATFORM == "win32"
		end,
	},
	{
		alignment = "left_alignment",
		display_name = "loc_options_view_display_name",
		input_action = "hotkey_item_sort",
		on_pressed_callback = "_cb_on_open_options_pressed",
		visibility_function = function (parent)
			return parent._force_character_creation
		end,
	},
}
local animations = {
	fade_in = {
		{
			end_time = 2.2,
			name = "fade",
			start_time = 0.2,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				widgets.transition_fade.alpha_multiplier = 1
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				widgets.transition_fade.alpha_multiplier = 1 - anim_progress
			end,
		},
	},
	class_selection = {
		{
			end_time = 2,
			name = "class_selection",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				for i = 1, #parent._class_options_widgets do
					local widget = parent._class_options_widgets[i]

					widget.style.icon.material_values.progression = 0
				end
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				params.selected_class_widget.style.icon.material_values.progression = anim_progress
			end,
		},
	},
}

return {
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	archetype_option_frame_definition = archetype_option_frame_definition,
	archetype_option_definition = archetype_option_definition,
	archetype_selection_definition = archetype_selection_definition,
	animations = animations,
}
