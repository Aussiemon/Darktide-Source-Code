local UIWidget = require("scripts/managers/ui/ui_widget")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ClassSelectionViewSettings = require("scripts/ui/views/class_selection_view/class_selection_view_settings")
local ClassSelectionViewFontStyle = require("scripts/ui/views/class_selection_view/class_selection_view_font_style")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local scenegraph_definition = {
	screen = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
	canvas = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
	main_title = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			640,
			80
		},
		position = {
			0,
			55,
			2
		}
	},
	archetype = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			760,
			390
		},
		position = {
			160,
			-235,
			2
		}
	},
	archetype_options = {
		vertical_alignment = "bottom",
		parent = "archetype",
		horizontal_alignment = "center",
		size = {
			0,
			265
		},
		position = {
			3,
			-337,
			10
		}
	},
	archetype_info = {
		vertical_alignment = "bottom",
		parent = "archetype",
		horizontal_alignment = "center",
		size = {
			600,
			300
		},
		position = {
			0,
			0,
			2
		}
	},
	class_option = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			920,
			680
		},
		position = {
			220,
			-165,
			2
		}
	},
	class = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "right",
		size = ClassSelectionViewSettings.class_size,
		position = {
			-200,
			-235,
			1
		}
	},
	class_title = {
		vertical_alignment = "top",
		parent = "class",
		horizontal_alignment = "center",
		size = {
			ClassSelectionViewSettings.class_size[1],
			50
		},
		position = {
			0,
			15,
			3
		}
	},
	class_description = {
		vertical_alignment = "top",
		parent = "class",
		horizontal_alignment = "center",
		size = {
			ClassSelectionViewSettings.class_size[1],
			540
		},
		position = {
			0,
			100,
			3
		}
	},
	details_button = {
		vertical_alignment = "bottom",
		parent = "archetype",
		horizontal_alignment = "center",
		size = ButtonPassTemplates.terminal_button.size,
		position = {
			0,
			125,
			2
		}
	},
	continue_button = {
		vertical_alignment = "bottom",
		parent = "class",
		horizontal_alignment = "center",
		size = ButtonPassTemplates.default_button.size,
		position = {
			0,
			125,
			2
		}
	},
	class_details = {
		vertical_alignment = "top",
		parent = "class",
		horizontal_alignment = "center",
		size = {
			ClassSelectionViewSettings.class_size[1],
			ClassSelectionViewSettings.class_size[2]
		},
		position = {
			0,
			0,
			2
		}
	},
	class_details_mask = {
		vertical_alignment = "center",
		parent = "class_details",
		horizontal_alignment = "left",
		size = {
			ClassSelectionViewSettings.class_size[1] - 50,
			ClassSelectionViewSettings.class_size[2]
		},
		position = {
			20,
			-12,
			3
		}
	},
	class_details_scrollbar = {
		vertical_alignment = "center",
		parent = "class",
		horizontal_alignment = "right",
		size = {
			7,
			ClassSelectionViewSettings.class_size[2] - 30
		},
		position = {
			-2,
			0,
			50
		}
	},
	class_details_content_pivot = {
		vertical_alignment = "top",
		parent = "class_details",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			3
		}
	}
}
local widget_definitions = {
	corners = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/screen/class_psyker_01_lower_left",
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
				color = {
					255,
					255,
					255,
					255
				}
			}
		},
		{
			value = "content/ui/materials/frames/screen/class_psyker_01_lower_right",
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
				color = {
					255,
					255,
					255,
					255
				}
			}
		},
		{
			value = "content/ui/materials/frames/screen/class_psyker_01_upper_right",
			value_id = "right_upper",
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
				color = {
					255,
					255,
					255,
					255
				},
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
			value = "content/ui/materials/frames/screen/class_psyker_01_upper_right",
			value_id = "left_upper",
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
				color = {
					255,
					255,
					255,
					255
				}
			}
		}
	}, "screen"),
	transition_fade = UIWidget.create_definition({
		{
			style_id = "background",
			pass_type = "rect",
			style = {
				color = Color.black(255, true),
				offset = {
					0,
					0,
					1
				}
			}
		}
	}, "screen"),
	main_title = UIWidget.create_definition({
		{
			value = "",
			value_id = "text",
			pass_type = "text",
			style = ClassSelectionViewFontStyle.main_title_style
		}
	}, "main_title"),
	archetype_info = UIWidget.create_definition({
		{
			value_id = "title",
			style_id = "title",
			pass_type = "text",
			value = "",
			style = ClassSelectionViewFontStyle.archetype_title_style
		},
		{
			value_id = "divider",
			style_id = "divider",
			pass_type = "texture",
			value = "content/ui/materials/dividers/skull_center_02",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					400,
					18
				},
				offset = {
					0,
					100,
					1
				},
				color = Color.terminal_frame(255, true)
			}
		},
		{
			value_id = "background",
			style_id = "class_background_details",
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				vertical_alignment = "top",
				scale_to_material = true,
				horizontal_alignment = "center",
				color = Color.terminal_grid_background(nil, true),
				size_addition = {
					15,
					30
				},
				offset = {
					0,
					-15,
					0
				}
			}
		},
		{
			value = "content/ui/materials/dividers/horizontal_frame_big_lower",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				size = {
					nil,
					36
				},
				offset = {
					0,
					18,
					1
				}
			}
		},
		{
			value_id = "description",
			style_id = "description",
			pass_type = "text",
			value = "",
			style = ClassSelectionViewFontStyle.archetype_description_style
		},
		{
			value = "content/ui/materials/effects/class_selection_top_candles",
			value_id = "top_candles",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					760,
					390
				},
				offset = {
					0,
					-350,
					3
				}
			}
		},
		{
			value = "content/ui/materials/frames/class_selection_top",
			value_id = "top",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					760,
					390
				},
				offset = {
					0,
					-350,
					2
				}
			}
		}
	}, "archetype_info"),
	class_background = UIWidget.create_definition({
		{
			value_id = "background",
			style_id = "background",
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				vertical_alignment = "top",
				scale_to_material = true,
				horizontal_alignment = "center",
				color = Color.terminal_grid_background(nil, true),
				size_addition = {
					15,
					30
				},
				offset = {
					0,
					-15,
					0
				}
			}
		},
		{
			value_id = "class_background",
			style_id = "class_background",
			pass_type = "texture",
			value = "",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Color.black(76.5, true),
				size = {
					480,
					480
				},
				offset = {
					0,
					0,
					1
				}
			}
		},
		{
			value_id = "top_frame",
			style_id = "top_frame",
			pass_type = "texture",
			value = "content/ui/materials/dividers/horizontal_frame_big_upper",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					nil,
					36
				},
				offset = {
					0,
					-18,
					1
				}
			}
		},
		{
			value = "content/ui/materials/dividers/horizontal_frame_big_lower",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				size = {
					nil,
					36
				},
				offset = {
					0,
					18,
					1
				}
			}
		}
	}, "class"),
	class_details_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.terminal_scrollbar, "class_details_scrollbar", {
		axis = 2
	}),
	details_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "details_button", {
		gamepad_action = "secondary_action_pressed",
		original_text = Utf8.upper(Localize("loc_mission_voting_view_show_details"))
	}),
	continue_button = UIWidget.create_definition(ButtonPassTemplates.default_button, "continue_button", {
		gamepad_action = "confirm_pressed",
		text = Utf8.upper(Localize("loc_character_creator_continue"))
	})
}
local archetype_option_definition = UIWidget.create_definition({
	{
		pass_type = "hotspot",
		content_id = "hotspot"
	},
	{
		pass_type = "texture",
		value_id = "icon_highlight",
		style_id = "icon_highlight",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			hdr = true,
			original_size = ClassSelectionViewSettings.archetype_option_icon_size,
			size = ClassSelectionViewSettings.archetype_option_icon_size,
			offset = {
				0,
				0,
				2
			}
		},
		change_function = function (content, style)
			local hotspot = content.hotspot
			local anim_progress = hotspot.anim_select_progress
			style.color[1] = anim_progress * 255
		end,
		visibility_function = function (content, style)
			return content.hotspot.is_selected
		end
	},
	{
		pass_type = "texture",
		style_id = "highlight",
		value = "content/ui/materials/frames/class_selection_top_highlight",
		style = {
			horizontal_alignment = "center",
			hdr = true,
			scale_to_material = true,
			vertical_alignment = "center",
			default_color = Color.terminal_text_body(255, true),
			selected_color = Color.terminal_corner_selected(255, true),
			hover_color = Color.terminal_corner_hover(255, true),
			offset = {
				0,
				-3,
				4
			},
			size_addition = {
				30,
				30
			}
		},
		change_function = function (content, style)
			local color = content.hotspot.is_selected and style.selected_color or (content.hotspot.is_hover or content.hotspot.is_focused) and style.hover_color or style.default_color
			style.color = {
				color[1],
				color[2],
				color[3],
				color[4]
			}
			style.color[1] = math.max(content.hotspot.anim_focus_progress, content.hotspot.anim_select_progress, content.hotspot.anim_hover_progress) * 255
		end,
		visibility_function = function (content, style)
			return content.hotspot.is_focused or content.hotspot.is_hover
		end
	}
}, "archetype_options", nil, ClassSelectionViewSettings.archetype_option_icon_size)
local archetype_selection_definition = {
	left = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = ClassSelectionViewFontStyle.select_style
		}
	}, "archetype_option"),
	right = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = ClassSelectionViewFontStyle.select_style
		}
	}, "archetype_option")
}
local class_option_definition = UIWidget.create_definition({
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		content = {
			on_hover_sound = UISoundEvents.default_mouse_hover
		}
	},
	{
		style_id = "icon",
		value_id = "icon",
		pass_type = "texture",
		value = "content/ui/materials/base/ui_illustration_dissolve_base",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size = ClassSelectionViewSettings.class_option_icon_size,
			offset = {
				0,
				0,
				1
			},
			material_values = {
				progression = 0,
				main_texture = ""
			}
		}
	},
	{
		pass_type = "texture",
		style_id = "highlight",
		value = "content/ui/materials/frames/dropshadow_heavy",
		style = {
			vertical_alignment = "center",
			hdr = true,
			horizontal_alignment = "center",
			color = Color.ui_terminal(255, true),
			offset = {
				0,
				0,
				2
			},
			size_addition = {
				20,
				20
			}
		},
		change_function = function (content, style, _, dt)
			local hotspot = content.hotspot
			local progress = math.max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)
			style.color[1] = 255 * math.easeOutCubic(progress)
			local size_addition = 20 + 20 * math.easeInCubic(1 - progress)
			local style_size_additon = style.size_addition
			style_size_additon[1] = size_addition
			style_size_additon[2] = size_addition
			style.hdr = progress == 1
		end
	},
	{
		style_id = "title",
		pass_type = "text",
		value = "",
		value_id = "title",
		style = ClassSelectionViewFontStyle.class_option_title,
		change_function = function (content, style)
			local hotspot = content.hotspot
			style.text_color = hotspot.is_focused and style.default_color or style.disabled_color
		end
	}
}, "class_option", nil, ClassSelectionViewSettings.class_option_icon_size)
local legend_inputs = {
	{
		input_action = "back",
		display_name = "loc_class_selection_button_back",
		alignment = "left_alignment",
		on_pressed_callback = "_on_back_pressed",
		visibility_function = function (parent)
			return not parent._force_character_creation
		end
	},
	{
		input_action = "back",
		display_name = "loc_quit_game_display_name",
		alignment = "left_alignment",
		on_pressed_callback = "_on_quit_pressed",
		visibility_function = function (parent)
			return parent._force_character_creation and PLATFORM == "win32"
		end
	},
	{
		display_name = "loc_options_view_display_name",
		input_action = "hotkey_item_sort",
		alignment = "left_alignment",
		on_pressed_callback = "_cb_on_open_options_pressed",
		visibility_function = function (parent)
			return parent._force_character_creation
		end
	}
}
local animations = {
	fade_in = {
		{
			name = "fade",
			end_time = 2.2,
			start_time = 0.2,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				widgets.transition_fade.alpha_multiplier = 1
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				widgets.transition_fade.alpha_multiplier = 1 - anim_progress
			end
		}
	},
	class_selection = {
		{
			name = "class_selection",
			end_time = 2,
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
			end
		}
	}
}

return {
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	archetype_option_definition = archetype_option_definition,
	archetype_selection_definition = archetype_selection_definition,
	class_option_definition = class_option_definition,
	animations = animations
}
