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
	backstory_choices_title = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			1740,
			480
		},
		position = {
			0,
			0,
			0
		}
	},
	backstory_choices_grid = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			1740,
			480
		},
		position = {
			0,
			0,
			0
		}
	},
	backstory_choices_pivot = {
		vertical_alignment = "top",
		parent = "backstory_choices_grid",
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
	backstory_selection_pivot = {
		vertical_alignment = "bottom",
		parent = "list_background",
		horizontal_alignment = "left",
		size = {
			440,
			0
		},
		position = {
			490,
			0,
			0
		}
	},
	backstory_selection_pivot_background = {
		vertical_alignment = "top",
		parent = "backstory_selection_pivot",
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
	list_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			200,
			2
		}
	},
	list_background = {
		vertical_alignment = "top",
		parent = "list_pivot",
		horizontal_alignment = "left",
		size = {
			530,
			780
		},
		position = {
			0,
			0,
			1
		}
	},
	list_header = {
		vertical_alignment = "top",
		parent = "list_background",
		horizontal_alignment = "center",
		size = {
			480,
			40
		},
		position = {
			0,
			-50,
			53
		}
	},
	list_description = {
		vertical_alignment = "top",
		parent = "list_background",
		horizontal_alignment = "center",
		size = {
			420,
			200
		},
		position = {
			0,
			0,
			5
		}
	},
	grid_1_area = {
		vertical_alignment = "top",
		parent = "list_background",
		horizontal_alignment = "left",
		size = CharacterAppearanceViewSettings.area_grid_size,
		position = {
			25,
			0,
			0
		}
	},
	grid_1_background = {
		vertical_alignment = "top",
		parent = "grid_1_area",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			-40,
			-40,
			0
		}
	},
	grid_1_mask = {
		vertical_alignment = "center",
		parent = "grid_1_area",
		horizontal_alignment = "center",
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
	grid_1_content_pivot = {
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
			2
		}
	},
	grid_1_interaction = {
		vertical_alignment = "top",
		parent = "grid_1_area",
		horizontal_alignment = "left",
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
	grid_1_scrollbar = {
		vertical_alignment = "top",
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
	appearance_background = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			20,
			10
		}
	},
	grid_2_area = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			20,
			10
		}
	},
	grid_2_background = {
		vertical_alignment = "top",
		parent = "grid_2_area",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			-40,
			-40,
			0
		}
	},
	grid_2_content_pivot = {
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
			2
		}
	},
	grid_2_mask = {
		vertical_alignment = "center",
		parent = "grid_2_area",
		horizontal_alignment = "center",
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
	grid_2_interaction = {
		vertical_alignment = "top",
		parent = "grid_2_area",
		horizontal_alignment = "left",
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
	grid_2_scrollbar = {
		vertical_alignment = "top",
		parent = "grid_2_area",
		horizontal_alignment = "right",
		size = {
			10,
			0
		},
		position = {
			30,
			0,
			2
		}
	},
	grid_3_area = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			20,
			10
		}
	},
	grid_3_background = {
		vertical_alignment = "top",
		parent = "grid_3_area",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			-40,
			-40,
			0
		}
	},
	grid_3_content_pivot = {
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
			2
		}
	},
	grid_3_mask = {
		vertical_alignment = "center",
		parent = "grid_3_area",
		horizontal_alignment = "center",
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
	grid_3_interaction = {
		vertical_alignment = "top",
		parent = "grid_3_area",
		horizontal_alignment = "left",
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
	grid_3_scrollbar = {
		vertical_alignment = "top",
		parent = "grid_3_area",
		horizontal_alignment = "right",
		size = {
			10,
			0
		},
		position = {
			30,
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
	name_input = {
		vertical_alignment = "top",
		parent = "backstory_pivot",
		horizontal_alignment = "left",
		size = {
			760,
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
			760,
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
	background = UIWidget.create_definition({
		{
			style_id = "background",
			pass_type = "rect",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				color = Color.black(255, true)
			}
		},
		{
			style_id = "texture",
			value_id = "texture",
			pass_type = "texture_uv",
			style = {
				offset = {
					0,
					0,
					1
				},
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				}
			}
		}
	}, "screen"),
	list_background = UIWidget.create_definition({
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
					35,
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
					480,
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
			value_id = "top_frame_extra",
			pass_type = "texture",
			style_id = "top_frame_extra",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					480,
					36
				},
				offset = {
					0,
					-18,
					1
				}
			},
			visiblity_function = function (content, style)
				return not not content.top_frame_extra
			end
		},
		{
			value = "content/ui/materials/dividers/horizontal_frame_big_lower",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				size = {
					480,
					36
				},
				offset = {
					0,
					18,
					1
				}
			}
		}
	}, "list_background"),
	list_header = UIWidget.create_definition({
		{
			value_id = "text_title",
			style_id = "text_title",
			pass_type = "text",
			value = "",
			style = CharacterAppearanceViewFontStyle.header_text_style
		},
		{
			value_id = "divider",
			style_id = "divider",
			pass_type = "texture",
			value = "content/ui/materials/dividers/skull_rendered_center_01",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				size = {
					140,
					18
				},
				offset = {
					0,
					9,
					1
				}
			}
		},
		{
			value_id = "icon",
			pass_type = "texture",
			style_id = "icon",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					0,
					0
				},
				offset = {
					0,
					0,
					1
				}
			},
			visibility_function = function (content, style)
				return content.icon
			end
		}
	}, "list_header"),
	list_description = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = CharacterAppearanceViewFontStyle.list_description_style
		},
		{
			value = "content/ui/materials/dividers/horizontal_frame_big_middle",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				size = {
					480,
					44
				},
				offset = {
					0,
					22,
					1
				}
			}
		}
	}, "list_description"),
	continue_button = UIWidget.create_definition(ButtonPassTemplates.default_button, "continue_button", {
		text = Localize("loc_character_creator_continue"),
		hotspot = {
			on_pressed_sound = UISoundEvents.character_appearence_confirm
		}
	}),
	page_indicator_frame = UIWidget.create_definition({
		{
			value = "content/ui/materials/dividers/skull_rendered_left_02",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				size = {
					78,
					18
				},
				offset = {
					-78,
					0,
					1
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
			value = "content/ui/materials/dividers/skull_rendered_left_02",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				size = {
					78,
					18
				},
				offset = {
					78,
					0,
					1
				}
			}
		}
	}, "page_indicator", {
		visible = false
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
	backstory_background = UIWidget.create_definition({
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
	}, "backstory_background"),
	backstory_title = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = Localize("loc_character_create_title_name"),
			style = CharacterAppearanceViewFontStyle.header_final_title_style
		},
		{
			style_id = "baseline",
			pass_type = "rect",
			style = {
				vertical_alignment = "bottom",
				color = Color.terminal_corner(255, true),
				size = {
					nil,
					2
				},
				offset = {
					0,
					15,
					1
				}
			}
		}
	}, "backstory_pivot"),
	backstory_text = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = CharacterAppearanceViewFontStyle.description_style
		}
	}, "backstory_pivot"),
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
	}, "choice_detail"),
	appearance_background = UIWidget.create_definition({
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
	}, "appearance_background")
}
local choice_descriptions = {
	option_title = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = CharacterAppearanceViewFontStyle.option_title_style
		}
	}, "backstory_selection_pivot"),
	option_description = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = CharacterAppearanceViewFontStyle.description_style
		}
	}, "backstory_selection_pivot"),
	option_effect_title = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = CharacterAppearanceViewFontStyle.effect_title_style
		},
		{
			value_id = "divider",
			style_id = "divider",
			pass_type = "rect",
			value = "",
			style = {
				vertical_alignment = "top",
				color = Color.ui_grey_light(255, true),
				size = {
					nil,
					2
				},
				offset = {
					0,
					30,
					0
				}
			}
		}
	}, "backstory_selection_pivot"),
	option_effect_description = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = CharacterAppearanceViewFontStyle.effect_description_style
		}
	}, "backstory_selection_pivot")
}
local randomize_button_definition = UIWidget.create_definition({
	{
		pass_type = "hotspot",
		content_id = "hotspot"
	},
	{
		style_id = "icon",
		pass_type = "texture",
		value = "content/ui/materials/base/ui_default_base",
		value_id = "icon",
		style = {
			vertical_alignment = "center",
			hover_color = Color.terminal_frame_selected(255, true),
			default_color = Color.terminal_text_body(255, true),
			color = Color.terminal_text_body(255, true),
			size = {
				30,
				30
			},
			material_values = {
				texture_map = "content/ui/textures/icons/generic/randomize"
			},
			offset = {
				20,
				0,
				2
			}
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
		end
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
				3
			},
			size_addition = {
				-10,
				0
			},
			default_color = Color.terminal_frame(nil, true),
			hover_color = Color.terminal_frame_selected(nil, true),
			color = Color.terminal_text_body(255, true)
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
		end
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "center",
			size_addition = {
				-10,
				0
			},
			default_color = Color.terminal_frame(nil, true),
			hover_color = Color.terminal_frame_selected(nil, true),
			color = Color.terminal_text_body(255, true),
			offset = {
				0,
				0,
				4
			}
		},
		change_function = function (content, style, _, dt)
			local default_color = style.default_color
			local hover_color = style.hover_color
			local color = style.color
			local hotspot = content.hotspot
			local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

			ColorUtilities.color_lerp(default_color, hover_color, progress, color)

			style.hdr = progress == 1
		end
	},
	{
		pass_type = "texture",
		style_id = "corner",
		value = "content/ui/materials/frames/frame_corner_2px",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "center",
			size_addition = {
				-10,
				0
			},
			default_color = Color.terminal_corner(nil, true),
			hover_color = Color.terminal_corner_selected(nil, true),
			color = Color.terminal_text_body(255, true),
			offset = {
				0,
				0,
				5
			}
		},
		change_function = function (content, style, _, dt)
			local default_color = style.default_color
			local hover_color = style.hover_color
			local color = style.color
			local hotspot = content.hotspot
			local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

			ColorUtilities.color_lerp(default_color, hover_color, progress, color)

			style.hdr = progress == 1
		end
	},
	{
		style_id = "text",
		pass_type = "text",
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
		end
	}
}, "name_input", nil, {
	360,
	60
})
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
			return IS_XBS and parent._active_page_name == "final" and not parent._loading_overlay_visible
		end
	},
	{
		input_action = "back",
		on_pressed_callback = "_on_close_pressed",
		display_name = "loc_settings_menu_close_menu",
		alignment = "left_alignment"
	},
	{
		input_action = "hotkey_menu_special_2",
		display_name = "loc_randomize",
		alignment = "right_alignment",
		on_pressed_callback = "_randomize_character_appearance",
		visibility_function = function (parent)
			return parent._is_character_showing and parent._active_page_name == "appearance" and not parent._is_barber and not parent._loading_overlay_visible
		end
	},
	{
		input_action = "navigate_controller_right",
		display_name = "loc_rotate",
		alignment = "right_alignment",
		visibility_function = function (parent)
			return not parent._using_cursor_navigation and parent._is_character_showing and not parent._loading_overlay_visible
		end
	},
	{
		input_action = "navigate_primary_right_pressed",
		display_name = "loc_zoom_in",
		alignment = "right_alignment",
		on_pressed_callback = "_zoom_camera",
		visibility_function = function (parent)
			return not parent._camera_zoomed and parent._is_character_showing and parent._active_page_name ~= "final" and not parent._disable_zoom and not parent._loading_overlay_visible
		end
	},
	{
		input_action = "navigate_primary_right_pressed",
		display_name = "loc_zoom_out",
		alignment = "right_alignment",
		on_pressed_callback = "_zoom_camera",
		visibility_function = function (parent)
			return parent._camera_zoomed and parent._is_character_showing and parent._active_page_name ~= "final" and not parent._disable_zoom and not parent._loading_overlay_visible
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
	}
}
animations.on_planet_select = {
	{
		name = "move_background",
		end_time = 2,
		start_time = 0,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
			local anim_progress = math.easeCubic(progress)
			local progress_uv = widgets.background.style.texture.uvs

			for i = 1, #params.start_uv do
				local start_uv = params.start_uv[i]
				local end_uv = params.end_uv[i]
				progress_uv[i][1] = math.lerp(start_uv[1], end_uv[1], anim_progress)
				progress_uv[i][2] = math.lerp(start_uv[2], end_uv[2], anim_progress)
			end
		end,
		on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
			if parent._reset_background then
				parent._reset_background = nil
				local page = parent._pages[parent._active_page_number]
				widgets.background.style.texture.uvs = page.background_uv or {
					{
						0,
						0
					},
					{
						1,
						1
					}
				}
			end
		end
	},
	{
		name = "move_start_planet",
		end_time = 0.5,
		start_time = 0,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
			local anim_progress = math.easeInCubic(progress)
			local start_position = params.start_planet_widget.content.planet_data.position
			local end_position = params.end_planet_widget.content.planet_data.position
			local screen_width = RESOLUTION_LOOKUP.width * RESOLUTION_LOOKUP.inverse_scale
			local screen_height = RESOLUTION_LOOKUP.height * RESOLUTION_LOOKUP.inverse_scale
			local image_size = params.start_planet_widget.content.planet_data.image.size
			local screen_max_size = math.max(screen_width, screen_height)
			local image_max_size = math.max(image_size[1], image_size[2])
			local angle = math.angle(end_position[1], end_position[2], start_position[1], start_position[2])
			local total_distance = screen_max_size + image_max_size
			local start_offset = CharacterAppearanceViewSettings.planet_offset
			local end_offset_x, end_offset_y = math.polar_to_cartesian(total_distance, angle)
			local current_offset_x = math.lerp(start_offset[1], end_offset_x + CharacterAppearanceViewSettings.planet_offset[1], anim_progress)
			local current_offset_y = math.lerp(start_offset[2], end_offset_y, anim_progress)
			local end_offset = params.start_planet_widget.style.planet.offset
			end_offset[1] = current_offset_x
			end_offset[2] = current_offset_y
		end
	},
	{
		name = "move_end_planet",
		end_time = 2,
		start_time = 1,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
			params.end_planet_widget.content.visible = true
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
			local anim_progress = math.easeOutCubic(progress)
			local start_position = params.start_planet_widget.content.planet_data.position
			local end_position = params.end_planet_widget.content.planet_data.position
			local screen_width = RESOLUTION_LOOKUP.width * RESOLUTION_LOOKUP.inverse_scale
			local screen_height = RESOLUTION_LOOKUP.height * RESOLUTION_LOOKUP.inverse_scale
			local image_size = params.end_planet_widget.content.planet_data.image.size
			local screen_max_size = math.max(screen_width, screen_height)
			local image_max_size = math.max(image_size[1], image_size[2])
			local angle = math.angle(start_position[1], start_position[2], end_position[1], end_position[2])
			local total_distance = screen_max_size + image_max_size
			local start_offset_x, start_offset_y = nil
			start_offset_x, start_offset_y = math.polar_to_cartesian(total_distance, angle)
			local end_offset = CharacterAppearanceViewSettings.planet_offset
			local current_offset_x = math.lerp(start_offset_x, end_offset[1], anim_progress)
			local current_offset_y = math.lerp(start_offset_y, end_offset[2], anim_progress)
			local end_planet_offset = params.end_planet_widget.style.planet.offset
			end_planet_offset[1] = current_offset_x
			end_planet_offset[2] = current_offset_y
		end
	}
}

return {
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	choice_descriptions_definitions = choice_descriptions,
	randomize_button_definition = randomize_button_definition,
	error_text_definitions = error_text_definitions,
	animations = animations
}
