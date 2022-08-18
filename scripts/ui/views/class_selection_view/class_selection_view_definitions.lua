local UIWidget = require("scripts/managers/ui/ui_widget")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ClassSelectionViewSettings = require("scripts/ui/views/class_selection_view/class_selection_view_settings")
local ClassSelectionViewFontStyle = require("scripts/ui/views/class_selection_view/class_selection_view_font_style")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
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
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			680,
			390
		},
		position = {
			160,
			430,
			2
		}
	},
	domain_options = {
		vertical_alignment = "top",
		parent = "domain",
		horizontal_alignment = "center",
		size = {
			680,
			100
		},
		position = {
			0,
			-120,
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
			-40,
			2
		}
	},
	choose_button = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			374,
			76
		},
		position = {
			0,
			-95,
			2
		}
	}
}
local widget_definitions = {
	zealot_corners = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/screen/class_zealot_01_lower_left",
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
			value = "content/ui/materials/frames/screen/class_zealot_01_lower_right",
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
			value = "content/ui/materials/frames/screen/class_zealot_01_upper_right",
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
			value = "content/ui/materials/frames/screen/class_zealot_01_upper_right",
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
	ogryn_corners = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/screen/class_ogryn_01_lower_left",
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
			value = "content/ui/materials/frames/screen/class_ogryn_01_lower_right",
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
			value = "content/ui/materials/frames/screen/class_ogryn_01_upper_right",
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
			value = "content/ui/materials/frames/screen/class_ogryn_01_upper_right",
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
	veteran_corners = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/screen/class_veteran_01_lower_left",
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
			value = "content/ui/materials/frames/screen/class_veteran_01_lower_right",
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
			value = "content/ui/materials/frames/screen/class_veteran_01_upper_right",
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
			value = "content/ui/materials/frames/screen/class_veteran_01_upper_right",
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
	psyker_corners = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/screen/class_psyker_01_lower_left",
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
		},
		{
			value = "content/ui/materials/dividers/skull_rendered_center_02",
			value_id = "texture",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				size = {
					306,
					48
				}
			}
		}
	}, "main_title"),
	domain_info = UIWidget.create_definition({
		{
			value = "",
			value_id = "title",
			pass_type = "text",
			style = ClassSelectionViewFontStyle.domain_title_style
		},
		{
			value = "content/ui/materials/dividers/skull_rendered_center_01",
			value_id = "texture",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					140,
					18
				},
				offset = {
					0,
					50,
					1
				}
			}
		},
		{
			value = "",
			value_id = "description",
			pass_type = "text",
			style = ClassSelectionViewFontStyle.domain_description_style
		}
	}, "domain_info"),
	choose_button = UIWidget.create_definition(ButtonPassTemplates.default_button, "choose_button", {
		text = string.upper(Localize("loc_character_backstory_selection"))
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
	}
}

return {
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	domain_option_definition = domain_option_definition,
	domain_selection_definition = domain_selection_definition,
	animations = animations
}
