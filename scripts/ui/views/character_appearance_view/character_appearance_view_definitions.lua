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
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1740,
			900
		},
		position = {
			0,
			0,
			1
		}
	},
	grid_1_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			25,
			200,
			0
		}
	},
	grid_1_area = {
		vertical_alignment = "top",
		parent = "grid_1_pivot",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	grid_1_content = {
		vertical_alignment = "top",
		parent = "grid_1_area",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	grid_1_scrollbar = {
		vertical_alignment = "center",
		parent = "grid_1_area",
		horizontal_alignment = "right",
		size = {
			10,
			0
		},
		position = {
			0,
			0,
			2
		}
	},
	grid_2_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			25,
			200,
			0
		}
	},
	grid_2_area = {
		vertical_alignment = "top",
		parent = "grid_2_pivot",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	grid_2_content = {
		vertical_alignment = "top",
		parent = "grid_2_area",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	grid_2_scrollbar = {
		vertical_alignment = "center",
		parent = "grid_2_area",
		horizontal_alignment = "right",
		size = {
			10,
			0
		},
		position = {
			0,
			0,
			2
		}
	},
	grid_3_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			25,
			200,
			0
		}
	},
	grid_3_area = {
		vertical_alignment = "top",
		parent = "grid_3_pivot",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	grid_3_content = {
		vertical_alignment = "top",
		parent = "grid_3_area",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	grid_3_scrollbar = {
		vertical_alignment = "center",
		parent = "grid_3_area",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			2
		}
	},
	grid_4_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			25,
			200,
			0
		}
	},
	grid_4_area = {
		vertical_alignment = "top",
		parent = "grid_4_pivot",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	grid_4_content = {
		vertical_alignment = "top",
		parent = "grid_4_area",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	grid_4_scrollbar = {
		vertical_alignment = "center",
		parent = "grid_4_area",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			2
		}
	},
	backstory_choices_warning = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			700,
			76
		},
		position = {
			-390,
			-40,
			0
		}
	},
	continue_pivot = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			374,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	continue_button = {
		vertical_alignment = "bottom",
		parent = "continue_pivot",
		horizontal_alignment = "center",
		size = {
			374,
			76
		},
		position = {
			0,
			-40,
			3
		}
	},
	page_indicator = {
		vertical_alignment = "bottom",
		parent = "continue_pivot",
		horizontal_alignment = "center",
		size = {
			0,
			18
		},
		position = {
			0,
			0,
			0
		}
	},
	choice_detail = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			800,
			50
		},
		position = {
			0,
			0,
			0
		}
	},
	backstory_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			760,
			0
		},
		position = {
			-100,
			0,
			0
		}
	},
	backstory_background = {
		vertical_alignment = "top",
		parent = "backstory_pivot",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	error_input = {
		vertical_alignment = "bottom",
		parent = "continue_pivot",
		horizontal_alignment = "left",
		size = {
			374,
			0
		},
		position = {
			0,
			-120,
			0
		}
	}
}
local widget_definitions = {
	transition_fade = UIWidget.create_definition({
		{
			style_id = "background",
			pass_type = "rect",
			style = {
				color = Color.black(255, true),
				offset = {
					0,
					0,
					100
				}
			}
		}
	}, "screen"),
	continue_button = UIWidget.create_definition(ButtonPassTemplates.default_button, "continue_button", {
		gamepad_action = "confirm_pressed",
		original_text = Utf8.upper(Localize("loc_character_creator_continue")),
		hotspot = {
			on_pressed_sound = UISoundEvents.character_appearence_confirm
		}
	}),
	corners = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/screen/class_zealot_01_lower_left",
			value_id = "left_lower",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "bottom",
				size = {
					70,
					202
				},
				offset = {
					0,
					0,
					62
				},
				color = Color.white(255, true)
			}
		},
		{
			value = "content/ui/materials/frames/screen/class_zealot_01_lower_right",
			value_id = "right_lower",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				size = {
					70,
					202
				},
				offset = {
					0,
					0,
					62
				},
				color = Color.white(255, true)
			}
		},
		{
			value = "content/ui/materials/frames/screen/class_zealot_01_upper_right",
			value_id = "left_upper",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "top",
				size = {
					130,
					272
				},
				offset = {
					0,
					0,
					62
				},
				color = Color.white(255, true),
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				}
			}
		},
		{
			value = "content/ui/materials/frames/screen/class_zealot_01_upper_right",
			value_id = "right_upper",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				size = {
					130,
					272
				},
				offset = {
					0,
					0,
					62
				},
				color = Color.white(255, true)
			}
		}
	}, "screen"),
	loading_overlay = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				offset = {
					0,
					0,
					200
				},
				color = Color.black(200, true)
			}
		},
		{
			value = "",
			value_id = "text",
			pass_type = "text",
			style = CharacterAppearanceViewFontStyle.overlay_text_style
		}
	}, "screen"),
	choice_detail = UIWidget.create_definition({
		{
			style_id = "choice_icon",
			value_id = "choice_icon",
			pass_type = "texture",
			value = "content/ui/materials/base/ui_default_base",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				offset = {
					0,
					0,
					3
				},
				color = Color.ui_terminal(255, true),
				size = {
					16,
					16
				}
			},
			visibility_function = function (content)
				return content.use_choice_icon
			end
		},
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = CharacterAppearanceViewFontStyle.effect_description_style
		},
		{
			value_id = "not_selected_text",
			style_id = "not_selected_text",
			pass_type = "text",
			value = Localize("loc_character_create_choice_reason_not_active"),
			style = CharacterAppearanceViewFontStyle.effect_description_not_selected_style,
			visibility_function = function (content)
				return content.available == false
			end
		}
	}, "choice_detail")
}
local error_text_definitions = UIWidget.create_definition({
	{
		value_id = "text",
		style_id = "text",
		pass_type = "text",
		value = "",
		style = CharacterAppearanceViewFontStyle.error_style
	}
}, "error_input")
local legend_inputs = {
	{
		input_action = "confirm_pressed",
		display_name = "loc_settings_menu_change_name",
		alignment = "left_alignment",
		visibility_function = function (parent)
			return (IS_XBS or IS_PLAYSTATION) and parent._active_page_name == "final" and not parent._loading_overlay_visible
		end
	},
	{
		input_action = "back",
		on_pressed_callback = "_on_close_pressed",
		display_name = "loc_settings_menu_close_menu",
		alignment = "left_alignment"
	},
	{
		input_action = "character_create_randomize",
		display_name = "loc_randomize",
		alignment = "right_alignment",
		on_pressed_callback = "_randomize_character_appearance",
		visibility_function = function (parent)
			return parent._is_character_showing and parent._active_page_name == "appearance" and not parent._is_barber_appearance and not parent._loading_overlay_visible
		end
	},
	{
		input_action = "navigate_controller_right",
		display_name = "loc_rotate",
		alignment = "right_alignment",
		visibility_function = function (parent)
			return not parent._using_cursor_navigation and parent._is_character_showing and not parent._loading_overlay_visible and not parent._in_barber_chair
		end
	},
	{
		input_action = "hotkey_menu_special_2",
		display_name = "loc_zoom_in",
		alignment = "right_alignment",
		on_pressed_callback = "_zoom_camera",
		visibility_function = function (parent)
			return not parent._camera_zoomed and parent._is_character_showing and parent._active_page_name == "appearance" and not parent._disable_zoom and not parent._loading_overlay_visible
		end
	},
	{
		input_action = "hotkey_menu_special_2",
		display_name = "loc_zoom_out",
		alignment = "right_alignment",
		on_pressed_callback = "_zoom_camera",
		visibility_function = function (parent)
			return parent._camera_zoomed and parent._is_character_showing and parent._active_page_name == "appearance" and not parent._disable_zoom and not parent._loading_overlay_visible
		end
	}
}
local animations = {
	on_enter = {
		{
			name = "init",
			end_time = 0,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				for i = 1, #params.widgets do
					local widget = params.widgets[i]

					widget.alpha_multiplier = 0
				end
			end
		},
		{
			name = "fade_in",
			end_time = 1.5,
			start_time = 1,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				for i = 1, #params.widgets do
					local widget = params.widgets[i]

					widget.alpha_multiplier = anim_progress
				end
			end
		}
	},
	on_level_switch = {
		{
			name = "fade_in",
			end_time = 1.5,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				widgets.transition_fade.alpha_multiplier = 1
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				widgets.transition_fade.alpha_multiplier = 1 - anim_progress
			end
		}
	},
	on_planet_select = {
		{
			name = "move_background",
			end_time = 2.5,
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
						255
					}
					params.in_focus_color = in_focus_color
				end

				local out_of_focus_color = params.out_of_focus_color

				if not out_of_focus_color then
					out_of_focus_color = {
						255,
						55,
						55,
						55
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
			end
		},
		{
			name = "zoom_planets",
			end_time = 1.5,
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
			end
		}
	}
}

return {
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	error_text_definitions = error_text_definitions,
	animations = animations
}
