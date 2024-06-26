-- chunkname: @scripts/ui/views/character_appearance_view/character_appearance_view_definitions.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local CharacterAppearanceViewFontStyle = require("scripts/ui/views/character_appearance_view/character_appearance_view_font_style")
local CharacterAppearanceViewSettings = require("scripts/ui/views/character_appearance_view/character_appearance_view_settings")
local ColorUtilities = require("scripts/utilities/ui/colors")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	canvas = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			1740,
			900,
		},
		position = {
			0,
			0,
			1,
		},
	},
	backstory_choices_title = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			1740,
			480,
		},
		position = {
			0,
			0,
			0,
		},
	},
	backstory_choices_grid = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = {
			1740,
			480,
		},
		position = {
			0,
			0,
			0,
		},
	},
	backstory_choices_pivot = {
		horizontal_alignment = "left",
		parent = "backstory_choices_grid",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			0,
		},
	},
	backstory_selection_pivot = {
		horizontal_alignment = "left",
		parent = "list_background",
		vertical_alignment = "bottom",
		size = {
			440,
			0,
		},
		position = {
			490,
			0,
			0,
		},
	},
	backstory_selection_pivot_background = {
		horizontal_alignment = "left",
		parent = "backstory_selection_pivot",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			0,
		},
	},
	list_pivot = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			200,
			2,
		},
	},
	list_background = {
		horizontal_alignment = "left",
		parent = "list_pivot",
		vertical_alignment = "top",
		size = {
			530,
			780,
		},
		position = {
			0,
			0,
			1,
		},
	},
	list_header = {
		horizontal_alignment = "center",
		parent = "list_background",
		vertical_alignment = "top",
		size = {
			480,
			40,
		},
		position = {
			0,
			-50,
			53,
		},
	},
	list_description = {
		horizontal_alignment = "center",
		parent = "list_background",
		vertical_alignment = "top",
		size = {
			420,
			200,
		},
		position = {
			0,
			0,
			5,
		},
	},
	grid_1_area = {
		horizontal_alignment = "left",
		parent = "list_background",
		vertical_alignment = "top",
		size = CharacterAppearanceViewSettings.area_grid_size,
		position = {
			25,
			0,
			0,
		},
	},
	grid_1_background = {
		horizontal_alignment = "left",
		parent = "grid_1_area",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			-40,
			-40,
			0,
		},
	},
	grid_1_mask = {
		horizontal_alignment = "center",
		parent = "grid_1_area",
		vertical_alignment = "center",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			2,
		},
	},
	grid_1_content_pivot = {
		horizontal_alignment = "left",
		parent = "grid_1_area",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			2,
		},
	},
	grid_1_interaction = {
		horizontal_alignment = "left",
		parent = "grid_1_area",
		vertical_alignment = "top",
		size = {
			10,
			0,
		},
		position = {
			0,
			0,
			2,
		},
	},
	grid_1_scrollbar = {
		horizontal_alignment = "right",
		parent = "grid_1_area",
		vertical_alignment = "top",
		size = {
			10,
			0,
		},
		position = {
			0,
			0,
			2,
		},
	},
	appearance_background = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			20,
			10,
		},
	},
	grid_2_area = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			20,
			10,
		},
	},
	grid_2_background = {
		horizontal_alignment = "left",
		parent = "grid_2_area",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			-40,
			-40,
			0,
		},
	},
	grid_2_content_pivot = {
		horizontal_alignment = "left",
		parent = "grid_2_area",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			2,
		},
	},
	grid_2_mask = {
		horizontal_alignment = "center",
		parent = "grid_2_area",
		vertical_alignment = "center",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			2,
		},
	},
	grid_2_interaction = {
		horizontal_alignment = "left",
		parent = "grid_2_area",
		vertical_alignment = "top",
		size = {
			10,
			0,
		},
		position = {
			0,
			0,
			2,
		},
	},
	grid_2_scrollbar = {
		horizontal_alignment = "right",
		parent = "grid_2_area",
		vertical_alignment = "top",
		size = {
			10,
			0,
		},
		position = {
			30,
			0,
			2,
		},
	},
	grid_3_area = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			20,
			10,
		},
	},
	grid_3_background = {
		horizontal_alignment = "left",
		parent = "grid_3_area",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			-40,
			-40,
			0,
		},
	},
	grid_3_content_pivot = {
		horizontal_alignment = "left",
		parent = "grid_3_area",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			2,
		},
	},
	grid_3_mask = {
		horizontal_alignment = "center",
		parent = "grid_3_area",
		vertical_alignment = "center",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			2,
		},
	},
	grid_3_interaction = {
		horizontal_alignment = "left",
		parent = "grid_3_area",
		vertical_alignment = "top",
		size = {
			10,
			0,
		},
		position = {
			0,
			0,
			2,
		},
	},
	grid_3_scrollbar = {
		horizontal_alignment = "right",
		parent = "grid_3_area",
		vertical_alignment = "top",
		size = {
			10,
			0,
		},
		position = {
			30,
			0,
			2,
		},
	},
	backstory_choices_warning = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			700,
			76,
		},
		position = {
			-390,
			-40,
			0,
		},
	},
	continue_pivot = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			374,
			0,
		},
		position = {
			0,
			0,
			0,
		},
	},
	continue_button = {
		horizontal_alignment = "center",
		parent = "continue_pivot",
		vertical_alignment = "bottom",
		size = {
			374,
			76,
		},
		position = {
			0,
			-40,
			3,
		},
	},
	page_indicator = {
		horizontal_alignment = "center",
		parent = "continue_pivot",
		vertical_alignment = "bottom",
		size = {
			0,
			18,
		},
		position = {
			0,
			0,
			0,
		},
	},
	choice_detail = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			800,
			50,
		},
		position = {
			0,
			0,
			0,
		},
	},
	backstory_pivot = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			760,
			0,
		},
		position = {
			-100,
			0,
			0,
		},
	},
	backstory_background = {
		horizontal_alignment = "left",
		parent = "backstory_pivot",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			0,
		},
	},
	name_input = {
		horizontal_alignment = "left",
		parent = "backstory_pivot",
		vertical_alignment = "top",
		size = {
			760,
			0,
		},
		position = {
			0,
			0,
			0,
		},
	},
	error_input = {
		horizontal_alignment = "left",
		parent = "continue_pivot",
		vertical_alignment = "bottom",
		size = {
			760,
			0,
		},
		position = {
			0,
			-120,
			0,
		},
	},
}
local widget_definitions = {
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
	background = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "background",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				color = Color.black(255, true),
			},
		},
		{
			pass_type = "texture_uv",
			style_id = "texture",
			value_id = "texture",
			style = {
				offset = {
					0,
					0,
					1,
				},
				uvs = {
					{
						0,
						0,
					},
					{
						1,
						1,
					},
				},
			},
		},
	}, "screen"),
	list_background = UIWidget.create_definition({
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
					35,
					30,
				},
				offset = {
					0,
					-15,
					1,
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
				color = Color.black(80, true),
				size = {
					480,
					480,
				},
				offset = {
					0,
					0,
					0,
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
					480,
					36,
				},
				offset = {
					0,
					-18,
					2,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "top_frame_extra",
			value_id = "top_frame_extra",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				size = {
					480,
					36,
				},
				offset = {
					0,
					-18,
					2,
				},
			},
			visiblity_function = function (content, style)
				return not not content.top_frame_extra
			end,
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/horizontal_frame_big_lower",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = {
					480,
					36,
				},
				offset = {
					0,
					18,
					2,
				},
			},
		},
	}, "list_background"),
	list_header = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text_title",
			value = "",
			value_id = "text_title",
			style = CharacterAppearanceViewFontStyle.header_text_style,
		},
		{
			pass_type = "texture",
			style_id = "divider",
			value = "content/ui/materials/dividers/skull_rendered_center_01",
			value_id = "divider",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = {
					140,
					18,
				},
				offset = {
					0,
					9,
					2,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "icon",
			value_id = "icon",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				size = {
					0,
					0,
				},
				offset = {
					0,
					0,
					2,
				},
			},
			visibility_function = function (content, style)
				return content.icon
			end,
		},
	}, "list_header"),
	list_description = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = CharacterAppearanceViewFontStyle.list_description_style,
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/horizontal_frame_big_middle",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = {
					480,
					44,
				},
				offset = {
					0,
					22,
					1,
				},
			},
		},
	}, "list_description"),
	continue_button = UIWidget.create_definition(ButtonPassTemplates.default_button, "continue_button", {
		gamepad_action = "confirm_pressed",
		original_text = Utf8.upper(Localize("loc_character_creator_continue")),
		hotspot = {
			on_pressed_sound = UISoundEvents.character_appearence_confirm,
		},
	}),
	page_indicator_frame = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/dividers/skull_rendered_left_02",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				size = {
					78,
					18,
				},
				offset = {
					-78,
					0,
					1,
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
			value = "content/ui/materials/dividers/skull_rendered_left_02",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				size = {
					78,
					18,
				},
				offset = {
					78,
					0,
					1,
				},
			},
		},
	}, "page_indicator", {
		visible = false,
	}),
	corners = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/frames/screen/class_zealot_01_lower_left",
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
				color = Color.white(255, true),
			},
		},
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/frames/screen/class_zealot_01_lower_right",
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
				color = Color.white(255, true),
			},
		},
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/frames/screen/class_zealot_01_upper_right",
			value_id = "left_upper",
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
				color = Color.white(255, true),
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
			value = "content/ui/materials/frames/screen/class_zealot_01_upper_right",
			value_id = "right_upper",
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
				color = Color.white(255, true),
			},
		},
	}, "screen"),
	loading_overlay = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				offset = {
					0,
					0,
					200,
				},
				color = Color.black(200, true),
			},
		},
		{
			pass_type = "text",
			value = "",
			value_id = "text",
			style = CharacterAppearanceViewFontStyle.overlay_text_style,
		},
	}, "screen"),
	backstory_background = UIWidget.create_definition({
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
					2,
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
					2,
				},
			},
		},
	}, "backstory_background"),
	backstory_title = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			value = Localize("loc_character_create_title_name"),
			style = CharacterAppearanceViewFontStyle.header_final_title_style,
		},
		{
			pass_type = "rect",
			style_id = "baseline",
			style = {
				vertical_alignment = "bottom",
				color = Color.terminal_corner(255, true),
				size = {
					nil,
					2,
				},
				offset = {
					0,
					15,
					1,
				},
			},
		},
	}, "backstory_pivot"),
	backstory_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = CharacterAppearanceViewFontStyle.description_style,
		},
	}, "backstory_pivot"),
	choice_detail = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "choice_icon",
			value = "content/ui/materials/base/ui_default_base",
			value_id = "choice_icon",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					3,
				},
				color = Color.ui_terminal(255, true),
				size = {
					16,
					16,
				},
			},
			visibility_function = function (content)
				return content.use_choice_icon
			end,
		},
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = CharacterAppearanceViewFontStyle.effect_description_style,
		},
		{
			pass_type = "text",
			style_id = "not_selected_text",
			value_id = "not_selected_text",
			value = Localize("loc_character_create_choice_reason_not_active"),
			style = CharacterAppearanceViewFontStyle.effect_description_not_selected_style,
			visibility_function = function (content)
				return content.available == false
			end,
		},
	}, "choice_detail"),
	appearance_background = UIWidget.create_definition({
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
					2,
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
					2,
				},
			},
		},
	}, "appearance_background"),
}
local choice_descriptions = {
	option_title = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = CharacterAppearanceViewFontStyle.option_title_style,
		},
	}, "backstory_selection_pivot"),
	option_description = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = CharacterAppearanceViewFontStyle.description_style,
		},
	}, "backstory_selection_pivot"),
	option_effect_title = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = CharacterAppearanceViewFontStyle.effect_title_style,
		},
		{
			pass_type = "rect",
			style_id = "divider",
			value = "",
			value_id = "divider",
			style = {
				vertical_alignment = "top",
				color = Color.ui_grey_light(255, true),
				size = {
					nil,
					2,
				},
				offset = {
					0,
					30,
					0,
				},
			},
		},
	}, "backstory_selection_pivot"),
	option_effect_description = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = CharacterAppearanceViewFontStyle.effect_description_style,
		},
	}, "backstory_selection_pivot"),
}
local randomize_button_definition = UIWidget.create_definition({
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		content = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.default_click,
		},
	},
	{
		pass_type = "texture",
		style_id = "icon",
		value = "content/ui/materials/base/ui_default_base",
		value_id = "icon",
		style = {
			vertical_alignment = "center",
			hover_color = Color.terminal_frame_selected(255, true),
			default_color = Color.terminal_text_body(255, true),
			color = Color.terminal_text_body(255, true),
			size = {
				30,
				30,
			},
			material_values = {
				texture_map = "content/ui/textures/icons/generic/randomize",
			},
			offset = {
				20,
				0,
				2,
			},
		},
		change_function = function (content, style, _, dt)
			local default_color = style.default_color
			local hover_color = style.hover_color
			local color = style.color
			local hotspot = content.hotspot
			local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

			ColorUtilities.color_lerp(default_color, hover_color, progress, color)

			style.hdr = progress == 1
		end,
		visibility_function = function (content)
			return content.show_icon
		end,
	},
	{
		pass_type = "texture",
		style_id = "background_gradient",
		value = "content/ui/materials/masks/gradient_horizontal_sides_dynamic_02",
		style = {
			horizontal_alignment = "center",
			offset = {
				0,
				0,
				3,
			},
			size_addition = {
				-10,
				0,
			},
			default_color = Color.terminal_frame(nil, true),
			hover_color = Color.terminal_frame_selected(nil, true),
			color = Color.terminal_text_body(255, true),
		},
		change_function = function (content, style, _, dt)
			local default_color = style.default_color
			local hover_color = style.hover_color
			local color = style.color
			local hotspot = content.hotspot
			local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

			ColorUtilities.color_lerp(default_color, hover_color, progress, color)

			style.hdr = progress == 1
		end,
		visibility_function = function (content, style)
			return content.hotspot.is_focused or content.hotspot.is_hover
		end,
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			horizontal_alignment = "center",
			scale_to_material = true,
			vertical_alignment = "center",
			size_addition = {
				-10,
				0,
			},
			default_color = Color.terminal_frame(nil, true),
			hover_color = Color.terminal_frame_selected(nil, true),
			color = Color.terminal_text_body(255, true),
			offset = {
				0,
				0,
				4,
			},
		},
		change_function = function (content, style, _, dt)
			local default_color = style.default_color
			local hover_color = style.hover_color
			local color = style.color
			local hotspot = content.hotspot
			local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

			ColorUtilities.color_lerp(default_color, hover_color, progress, color)

			style.hdr = progress == 1
		end,
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			horizontal_alignment = "center",
			scale_to_material = true,
			vertical_alignment = "center",
			size_addition = {
				-10,
				0,
			},
			default_color = Color.terminal_corner(nil, true),
			hover_color = Color.terminal_corner_selected(nil, true),
			color = Color.terminal_text_body(255, true),
			offset = {
				0,
				0,
				5,
			},
		},
		change_function = function (content, style, _, dt)
			local default_color = style.default_color
			local hover_color = style.hover_color
			local color = style.color
			local hotspot = content.hotspot
			local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

			ColorUtilities.color_lerp(default_color, hover_color, progress, color)

			style.hdr = progress == 1
		end,
	},
	{
		pass_type = "text",
		style_id = "text",
		value = "",
		value_id = "text",
		style = CharacterAppearanceViewFontStyle.randomize_button_text_style,
		change_function = function (content, style, _, dt)
			local default_color = style.default_color
			local hover_color = style.hover_color
			local color = style.text_color
			local hotspot = content.hotspot
			local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

			ColorUtilities.color_lerp(default_color, hover_color, progress, color)

			style.hdr = progress == 1
		end,
	},
}, "name_input", nil, {
	360,
	60,
})
local error_text_definitions = UIWidget.create_definition({
	{
		pass_type = "text",
		style_id = "text",
		value = "",
		value_id = "text",
		style = CharacterAppearanceViewFontStyle.error_style,
	},
}, "error_input")
local legend_inputs = {
	{
		alignment = "left_alignment",
		display_name = "loc_settings_menu_change_name",
		input_action = "confirm_pressed",
		visibility_function = function (parent)
			return (IS_XBS or IS_PLAYSTATION) and parent._active_page_name == "final" and not parent._loading_overlay_visible
		end,
	},
	{
		alignment = "left_alignment",
		display_name = "loc_settings_menu_close_menu",
		input_action = "back",
		on_pressed_callback = "_on_close_pressed",
	},
	{
		alignment = "right_alignment",
		display_name = "loc_randomize",
		input_action = "character_create_randomize",
		on_pressed_callback = "_randomize_character_appearance",
		visibility_function = function (parent)
			return parent._is_character_showing and parent._active_page_name == "appearance" and not parent._is_barber_appearance and not parent._loading_overlay_visible
		end,
	},
	{
		alignment = "right_alignment",
		display_name = "loc_rotate",
		input_action = "navigate_controller_right",
		visibility_function = function (parent)
			return not parent._using_cursor_navigation and parent._is_character_showing and not parent._loading_overlay_visible and not parent._in_barber_chair
		end,
	},
	{
		alignment = "right_alignment",
		display_name = "loc_zoom_in",
		input_action = "hotkey_menu_special_2",
		on_pressed_callback = "_zoom_camera",
		visibility_function = function (parent)
			return not parent._camera_zoomed and parent._is_character_showing and parent._active_page_name == "appearance" and not parent._disable_zoom and not parent._loading_overlay_visible
		end,
	},
	{
		alignment = "right_alignment",
		display_name = "loc_zoom_out",
		input_action = "hotkey_menu_special_2",
		on_pressed_callback = "_zoom_camera",
		visibility_function = function (parent)
			return parent._camera_zoomed and parent._is_character_showing and parent._active_page_name == "appearance" and not parent._disable_zoom and not parent._loading_overlay_visible
		end,
	},
}
local animations = {
	on_enter = {
		{
			end_time = 0,
			name = "init",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				for i = 1, #params.widgets do
					local widget = params.widgets[i]

					widget.alpha_multiplier = 0
				end
			end,
		},
		{
			end_time = 1.5,
			name = "fade_in",
			start_time = 1,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				for i = 1, #params.widgets do
					local widget = params.widgets[i]

					widget.alpha_multiplier = anim_progress
				end
			end,
		},
	},
	on_level_switch = {
		{
			end_time = 1.5,
			name = "fade_in",
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
	on_planet_select = {
		{
			end_time = 2.5,
			name = "move_background",
			start_time = 0.2,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local target_planet_id = params.target_planet.id
				local planets_widget = widgets.home_planets
				local planets_widget_style = planets_widget.style
				local in_focus_color = params.in_focus_color

				if not in_focus_color then
					in_focus_color = {
						255,
						255,
						255,
						255,
					}
					params.in_focus_color = in_focus_color
				end

				local out_of_focus_color = params.out_of_focus_color

				if not out_of_focus_color then
					out_of_focus_color = {
						255,
						55,
						55,
						55,
					}
					params.out_of_focus_color = out_of_focus_color
				end

				for planet_id, style in pairs(planets_widget_style) do
					local is_target_planet = planet_id == target_planet_id
					local planet_params = params[planet_id]

					if not planet_params then
						planet_params = {}
						params[planet_id] = planet_params
					end

					planet_params.start_x = style.size_addition[1]
					planet_params.start_y = style.size_addition[2]
					planet_params.end_x = is_target_planet and 0 or math.floor(style.size[1] * -0.8)
					planet_params.end_y = is_target_planet and 0 or math.floor(style.size[2] * -0.8)
					planet_params.start_color = table.clone(style.color)
					planet_params.end_color = is_target_planet and in_focus_color or out_of_focus_color
				end

				parent:_stop_sound(UISoundEvents.character_create_planet_select)
				parent:_play_sound(UISoundEvents.character_create_planet_select)
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local math_lerp = math.lerp
				local anim_progress = math.easeCubic(progress)
				local background_widget = widgets.background_planet
				local progess_background_offset = background_widget.offset
				local start_background_position = params.start_background_position
				local end_background_position = params.end_background_position

				progess_background_offset[1] = math_lerp(start_background_position[1], end_background_position[1], anim_progress)
				progess_background_offset[2] = math_lerp(start_background_position[2], end_background_position[2], anim_progress)

				local start_position = params.start_planet_position
				local end_position = params.end_planet_position
				local widget_offset_x = math_lerp(start_position[1], end_position[1], anim_progress)
				local widget_offset_y = math_lerp(start_position[2], end_position[2], anim_progress)
				local planets_widget = widgets.home_planets
				local planets_widget_offset = planets_widget.offset

				planets_widget_offset[1] = -widget_offset_x
				planets_widget_offset[2] = -widget_offset_y

				local target_planet_id = params.target_planet.id
				local target_planet_style = planets_widget.style[target_planet_id]
				local planet_params = params[target_planet_id]
				local planet_size_addition = target_planet_style.size_addition

				planet_size_addition[1] = math_lerp(planet_params.start_x, planet_params.end_x, anim_progress)
				planet_size_addition[2] = math_lerp(planet_params.start_y, planet_params.end_y, anim_progress)

				ColorUtilities.color_lerp(planet_params.start_color, planet_params.end_color, anim_progress, target_planet_style.color)
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				if parent._reset_background then
					parent._reset_background = nil

					local page = parent._pages[parent._active_page_number]

					widgets.background.offset[1] = 0
					widgets.background.offset[2] = 0
				end

				local current_planet = params.target_planet
				local current_planet_id = current_planet.id
				local planets_widget = widgets.home_planets
				local planets_widget_style = planets_widget.style
				local in_focus_color = params.in_focus_color
				local out_of_focus_color = params.out_of_focus_color

				for planet_id, style in pairs(planets_widget_style) do
					local is_target_planet = planet_id == current_planet_id

					ColorUtilities.color_copy(is_target_planet and in_focus_color or out_of_focus_color, style.color)
				end

				planets_widget.content.current_planet = current_planet
			end,
		},
		{
			end_time = 1.5,
			name = "zoom_planets",
			start_time = 0.2,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local math_lerp = math.lerp
				local anim_progress = math.easeCubic(progress)
				local target_planet_id = params.target_planet.id
				local planets_widget = widgets.home_planets
				local planets_widget_style = planets_widget.style

				for planet_id, style in pairs(planets_widget_style) do
					local planet_params = params[planet_id]
					local planet_size_addition = style.size_addition

					if planet_id ~= target_planet_id then
						planet_size_addition[1] = math_lerp(planet_params.start_x, planet_params.end_x, anim_progress)
						planet_size_addition[2] = math_lerp(planet_params.start_y, planet_params.end_y, anim_progress)

						ColorUtilities.color_lerp(planet_params.start_color, planet_params.end_color, anim_progress, style.color)
					end
				end
			end,
		},
	},
}

return {
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	choice_descriptions_definitions = choice_descriptions,
	randomize_button_definition = randomize_button_definition,
	error_text_definitions = error_text_definitions,
	animations = animations,
}
