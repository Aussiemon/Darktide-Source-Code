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
	domain = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			680,
			390
		},
		position = {
			160,
			-235,
			2
		}
	},
	domain_options = {
		vertical_alignment = "bottom",
		parent = "domain",
		horizontal_alignment = "center",
		size = {
			680,
			100
		},
		position = {
			0,
			-365,
			2
		}
	},
	domain_info = {
		vertical_alignment = "bottom",
		parent = "domain",
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
		parent = "domain",
		horizontal_alignment = "center",
		size = ButtonPassTemplates.default_button.size,
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
		horizontal_alignment = "center",
		size = {
			ClassSelectionViewSettings.class_size[1],
			ClassSelectionViewSettings.class_size[2]
		},
		position = {
			0,
			0,
			3
		}
	},
	class_details_scrollbar = {
		vertical_alignment = "center",
		parent = "class",
		horizontal_alignment = "right",
		size = {
			10,
			ClassSelectionViewSettings.class_size[2] - 10
		},
		position = {
			-15,
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
	domain_info = UIWidget.create_definition({
		{
			value_id = "title",
			style_id = "title",
			pass_type = "text",
			value = "",
			style = ClassSelectionViewFontStyle.domain_title_style
		},
		{
			value = "content/ui/materials/dividers/skull_center_02",
			value_id = "texture",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					400,
					18
				},
				offset = {
					0,
					60,
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
		},
		{
			value_id = "description",
			style_id = "description",
			pass_type = "text",
			value = "",
			style = ClassSelectionViewFontStyle.domain_description_style
		}
	}, "domain_info"),
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
	class_details_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.terminal_scrollbar, "class_details_scrollbar"),
	class_details_mask = UIWidget.create_definition({
		{
			value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur",
			pass_type = "texture",
			style = {
				color = {
					255,
					255,
					255,
					255
				}
			}
		}
	}, "class_details_mask"),
	details_button = UIWidget.create_definition(ButtonPassTemplates.default_button, "details_button", {
		text = Utf8.upper(Localize("loc_mission_voting_view_show_details"))
	}),
	continue_button = UIWidget.create_definition(ButtonPassTemplates.default_button, "continue_button", {
		text = Utf8.upper(Localize("loc_character_creator_continue"))
	})
}
local domain_option_definition = UIWidget.create_definition({
	{
		pass_type = "hotspot",
		content_id = "hotspot"
	},
	{
		pass_type = "texture",
		value_id = "icon",
		style_id = "icon",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = {
				255,
				180,
				161,
				83
			},
			original_size = ClassSelectionViewSettings.domain_option_icon_size,
			size = ClassSelectionViewSettings.domain_option_icon_size,
			offset = {
				0,
				0,
				1
			}
		},
		change_function = function (content, style)
			local hotspot = content.hotspot
			local anim_progress = math.max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)
			style.color[1] = (1 - anim_progress) * 255
			local size = style.size
			local default_size = style.original_size
			local class_option_expanded_size_fraction = ClassSelectionViewSettings.class_option_expanded_size_fraction
			size[1] = default_size[1] + anim_progress * default_size[1] * class_option_expanded_size_fraction
			size[2] = default_size[2] + anim_progress * default_size[2] * class_option_expanded_size_fraction
		end
	},
	{
		pass_type = "texture",
		value_id = "icon_highlight",
		style_id = "icon_highlight",
		style = {
			vertical_alignment = "center",
			hdr = true,
			horizontal_alignment = "center",
			color = Color.ui_terminal(255, true),
			original_size = ClassSelectionViewSettings.domain_option_icon_size,
			size = ClassSelectionViewSettings.domain_option_icon_size,
			offset = {
				0,
				0,
				2
			}
		},
		change_function = function (content, style)
			local hotspot = content.hotspot
			local anim_progress = math.max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)
			style.color[1] = anim_progress * 255
			local size = style.size
			local default_size = style.original_size
			local class_option_expanded_size_fraction = ClassSelectionViewSettings.class_option_expanded_size_fraction
			size[1] = default_size[1] + anim_progress * default_size[1] * class_option_expanded_size_fraction
			size[2] = default_size[2] + anim_progress * default_size[2] * class_option_expanded_size_fraction
		end
	},
	{
		pass_type = "texture",
		style_id = "highlight",
		value = "content/ui/materials/frames/hover",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			scale_to_material = true,
			hdr = true,
			color = Color.ui_terminal(255, true),
			size = ClassSelectionViewSettings.domain_option_icon_size,
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
		change_function = function (content, style)
			local hotspot = content.hotspot
			local anim_progress = hotspot.anim_focus_progress
			style.color[1] = anim_progress * 255
			local size_addition = 20 + 20 * math.easeInCubic(1 - anim_progress)
			local style_size_additon = style.size_addition
			style_size_additon[1] = size_addition
			style_size_additon[2] = size_addition
			style.hdr = anim_progress == 1
		end
	}
}, "domain_options", nil, ClassSelectionViewSettings.domain_option_icon_size)
local domain_selection_definition = {
	left = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = ClassSelectionViewFontStyle.select_style
		}
	}, "domain_option"),
	right = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = ClassSelectionViewFontStyle.select_style
		}
	}, "domain_option")
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
	domain_option_definition = domain_option_definition,
	domain_selection_definition = domain_selection_definition,
	class_option_definition = class_option_definition,
	animations = animations
}
