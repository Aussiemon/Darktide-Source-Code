local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local option_size = {
	400,
	100
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
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
			3
		}
	},
	page_header = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			1300,
			194
		},
		position = {
			110,
			60,
			2
		}
	},
	detail = {
		vertical_alignment = "top",
		parent = "page_header",
		horizontal_alignment = "left",
		size = {
			483,
			344
		},
		position = {
			0,
			200,
			2
		}
	},
	detail_header = {
		vertical_alignment = "top",
		parent = "detail",
		horizontal_alignment = "right",
		size = {
			483,
			75
		},
		position = {
			0,
			0,
			0
		}
	},
	detail_location = {
		vertical_alignment = "bottom",
		parent = "detail_header",
		horizontal_alignment = "right",
		size = {
			483,
			269
		},
		position = {
			0,
			269,
			0
		}
	},
	objective = {
		vertical_alignment = "top",
		parent = "detail",
		horizontal_alignment = "center",
		size = {
			483,
			200
		},
		position = {
			0,
			354,
			0
		}
	},
	objective_header = {
		vertical_alignment = "top",
		parent = "objective",
		horizontal_alignment = "left",
		size = {
			483,
			68
		},
		position = {
			0,
			0,
			10
		}
	},
	objective_credits = {
		vertical_alignment = "bottom",
		parent = "objective",
		horizontal_alignment = "left",
		size = {
			110,
			33
		},
		position = {
			-10,
			10,
			10
		}
	},
	objective_xp = {
		vertical_alignment = "bottom",
		parent = "objective_credits",
		horizontal_alignment = "left",
		size = {
			110,
			33
		},
		position = {
			115,
			0,
			0
		}
	},
	objective_speaker = {
		vertical_alignment = "bottom",
		parent = "objective",
		horizontal_alignment = "right",
		size = {
			40,
			48
		},
		position = {
			10,
			10,
			10
		}
	},
	option_header = {
		vertical_alignment = "top",
		parent = "detail",
		horizontal_alignment = "right",
		size = {
			option_size[1],
			45
		},
		position = {
			option_size[1] + 40,
			0,
			0
		}
	},
	option_1 = {
		vertical_alignment = "top",
		parent = "detail",
		horizontal_alignment = "right",
		size = option_size,
		position = {
			option_size[1] + 40,
			44,
			0
		}
	},
	option_2 = {
		vertical_alignment = "top",
		parent = "option_1",
		horizontal_alignment = "left",
		size = option_size,
		position = {
			0,
			option_size[2] + 20,
			0
		}
	},
	option_3 = {
		vertical_alignment = "top",
		parent = "option_2",
		horizontal_alignment = "left",
		size = option_size,
		position = {
			0,
			option_size[2] + 20,
			0
		}
	},
	option_4 = {
		vertical_alignment = "bottom",
		parent = "objective",
		horizontal_alignment = "right",
		size = option_size,
		position = {
			option_size[1] + 40,
			0,
			0
		}
	},
	reward_1 = {
		vertical_alignment = "center",
		parent = "option_2",
		horizontal_alignment = "right",
		size = {
			178,
			370
		},
		position = {
			180,
			0,
			0
		}
	},
	reward_2 = {
		vertical_alignment = "center",
		parent = "option_4",
		horizontal_alignment = "right",
		size = {
			178,
			125
		},
		position = {
			180,
			0,
			0
		}
	},
	play_button = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "right",
		size = ButtonPassTemplates.default_button.size,
		position = {
			-165,
			-150,
			1
		}
	},
	info_box = {
		vertical_alignment = "center",
		parent = "play_button",
		horizontal_alignment = "center",
		size = {
			380,
			60
		},
		position = {
			0,
			0,
			0
		}
	},
	info_button = {
		vertical_alignment = "bottom",
		parent = "objective",
		horizontal_alignment = "left",
		size = {
			option_size[1],
			40
		},
		position = {
			0,
			55,
			1
		}
	},
	bonus_reward_claimer = {
		vertical_alignment = "bottom",
		parent = "option_4",
		horizontal_alignment = "left",
		size = {
			800,
			40
		},
		position = {
			0,
			50,
			4
		}
	}
}

local function create_option_widget(scenegraph_id)
	return UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot",
			content = {
				on_hover_sound = UISoundEvents.story_mission_option_mouse_hover
			}
		},
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				scale_to_material = true,
				vertical_alignment = "center",
				horizontal_alignment = "center",
				default_color = Color.terminal_frame(nil, true),
				hover_color = Color.terminal_frame_hover(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true),
				offset = {
					0,
					0,
					6
				}
			},
			change_function = ButtonPassTemplates.terminal_button_change_function
		},
		{
			pass_type = "texture",
			style_id = "corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			style = {
				scale_to_material = true,
				vertical_alignment = "center",
				horizontal_alignment = "center",
				default_color = Color.terminal_corner(nil, true),
				hover_color = Color.terminal_corner_hover(nil, true),
				selected_color = Color.terminal_corner_selected(nil, true),
				offset = {
					0,
					0,
					7
				}
			},
			change_function = ButtonPassTemplates.terminal_button_change_function
		},
		{
			style_id = "background_gradient",
			pass_type = "texture",
			value = "content/ui/materials/masks/gradient_horizontal_sides_02",
			value_id = "background_gradient",
			style = {
				scale_to_material = true,
				max_alpha = 255,
				min_alpha = 150,
				color = Color.terminal_background_gradient(nil, true),
				default_color = Color.terminal_background_gradient(nil, true),
				hover_color = Color.terminal_background_gradient(nil, true),
				selected_color = Color.terminal_background_selected(nil, true),
				size_addition = {
					0,
					-30
				},
				offset = {
					0,
					0,
					2
				}
			},
			change_function = ButtonPassTemplates.terminal_list_button_frame_hover_change_function,
			visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
		},
		{
			pass_type = "texture",
			style_id = "outer_shadow",
			value = "content/ui/materials/frames/dropshadow_medium",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				default_color = Color.black(200, true),
				hover_color = Color.black(200, true),
				selected_color = Color.terminal_corner_selected(nil, true),
				color = Color.black(200, true),
				size_addition = {
					20,
					20
				},
				offset = {
					0,
					0,
					3
				}
			},
			change_function = ButtonPassTemplates.terminal_button_change_function
		},
		{
			value = "content/ui/materials/frames/dropshadow_medium",
			style_id = "outer_shadow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				scale_to_material = true,
				color = Color.black(200, true),
				size_addition = {
					20,
					20
				},
				offset = {
					0,
					0,
					3
				}
			}
		},
		{
			pass_type = "texture",
			style_id = "header_frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				scale_to_material = true,
				horizontal_alignment = "center",
				vertical_alignment = "top",
				default_color = Color.terminal_frame(nil, true),
				hover_color = Color.terminal_frame_hover(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true),
				offset = {
					0,
					0,
					6
				},
				size_addition = {
					0,
					-30
				}
			},
			change_function = ButtonPassTemplates.terminal_button_change_function
		},
		{
			style_id = "background_top",
			value_id = "content/ui/materials/backgrounds/default_square",
			pass_type = "rect",
			style = {
				color = Color.terminal_grid_background_gradient(nil, true),
				offset = {
					0,
					0,
					1
				},
				size_addition = {
					0,
					-30
				}
			}
		},
		{
			style_id = "background",
			value_id = "content/ui/materials/backgrounds/default_square",
			pass_type = "rect",
			style = {
				color = Color.black(150, true)
			}
		},
		{
			style_id = "reward_icon_1",
			value_id = "reward_icon_1",
			pass_type = "texture",
			value = "content/ui/materials/icons/currencies/credits_small",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				offset = {
					-22,
					-6,
					4
				},
				default_offset = {
					-22,
					-6,
					4
				},
				size = {
					28,
					20
				}
			}
		},
		{
			style_id = "reward_icon_2",
			value_id = "reward_icon_2",
			pass_type = "texture",
			value = "content/ui/materials/icons/currencies/experience_small",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				offset = {
					-22,
					-6,
					4
				},
				default_offset = {
					-22,
					-6,
					4
				},
				size = {
					28,
					20
				}
			}
		},
		{
			value_id = "reward_text_1",
			style_id = "reward_text_1",
			pass_type = "text",
			value = "0",
			style = {
				font_size = 20,
				line_spacing = 1.2,
				horizontal_alignment = "right",
				text_vertical_alignment = "center",
				text_horizontal_alignment = "right",
				vertical_alignment = "bottom",
				font_type = "proxima_nova_bold",
				text_color = Color.terminal_text_body(nil, true),
				offset = {
					-52,
					-1,
					4
				},
				default_offset = {
					-52,
					-1,
					4
				},
				size = {
					nil,
					30
				},
				size_addition = {
					-100,
					0
				}
			}
		},
		{
			value_id = "reward_text_2",
			style_id = "reward_text_2",
			pass_type = "text",
			value = "0",
			style = {
				font_size = 20,
				line_spacing = 1.2,
				horizontal_alignment = "right",
				text_vertical_alignment = "center",
				text_horizontal_alignment = "right",
				vertical_alignment = "bottom",
				font_type = "proxima_nova_bold",
				text_color = Color.terminal_text_body(nil, true),
				offset = {
					-52,
					-1,
					4
				},
				default_offset = {
					-52,
					-1,
					4
				},
				size = {
					nil,
					30
				},
				size_addition = {
					-100,
					0
				}
			}
		},
		{
			value_id = "title_text",
			style_id = "title_text",
			pass_type = "text",
			value = "title_text",
			style = {
				font_size = 24,
				text_vertical_alignment = "center",
				horizontal_alignment = "left",
				text_horizontal_alignment = "left",
				vertical_alignment = "center",
				line_spacing = 1.2,
				font_type = "proxima_nova_bold",
				text_color = Color.terminal_text_header(nil, true),
				offset = {
					30,
					-12,
					4
				},
				size_addition = {
					-100,
					0
				}
			}
		},
		{
			value_id = "reward_header",
			style_id = "reward_header",
			pass_type = "text",
			value = Localize("loc_story_mission_play_menu_difficulty_option_reward_title"),
			style = {
				font_size = 18,
				text_vertical_alignment = "center",
				horizontal_alignment = "left",
				text_horizontal_alignment = "left",
				vertical_alignment = "bottom",
				line_spacing = 1.2,
				font_type = "proxima_nova_bold",
				text_color = Color.terminal_text_body_sub_header(nil, true),
				offset = {
					30,
					-2,
					5
				},
				size = {
					nil,
					30
				},
				size_addition = {
					-100,
					0
				}
			}
		},
		{
			style_id = "difficulty_box_5",
			pass_type = "rect",
			style = {
				horizontal_alignment = "right",
				offset = {
					-30,
					20,
					2
				},
				size = {
					10,
					30
				},
				color = Color.terminal_text_body_dark(nil, true)
			}
		},
		{
			style_id = "difficulty_box_4",
			pass_type = "rect",
			style = {
				horizontal_alignment = "right",
				offset = {
					-48,
					20,
					2
				},
				size = {
					10,
					30
				},
				color = Color.terminal_text_body_dark(nil, true)
			}
		},
		{
			style_id = "difficulty_box_3",
			pass_type = "rect",
			style = {
				horizontal_alignment = "right",
				offset = {
					-66,
					20,
					2
				},
				size = {
					10,
					30
				},
				color = Color.terminal_text_body_dark(nil, true)
			}
		},
		{
			style_id = "difficulty_box_2",
			pass_type = "rect",
			style = {
				horizontal_alignment = "right",
				offset = {
					-84,
					20,
					2
				},
				size = {
					10,
					30
				},
				color = Color.terminal_text_body_dark(nil, true)
			}
		},
		{
			style_id = "difficulty_box_1",
			pass_type = "rect",
			style = {
				horizontal_alignment = "right",
				offset = {
					-102,
					20,
					2
				},
				size = {
					10,
					30
				},
				color = Color.terminal_text_body_dark(nil, true)
			}
		},
		{
			value = "content/ui/materials/icons/generic/danger",
			style_id = "difficulty_icon",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				color = Color.terminal_icon(nil, true),
				offset = {
					-118,
					15,
					2
				},
				size = {
					40,
					40
				}
			}
		}
	}, scenegraph_id)
end

local function create_reward_widget(scenegraph_id)
	return UIWidget.create_definition({
		{
			style_id = "vertical_divider",
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = Color.terminal_corner_hover(255, true),
				offset = {
					10,
					0,
					4
				},
				size = {
					2
				}
			}
		},
		{
			style_id = "top_divider",
			pass_type = "rect",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = Color.terminal_corner_hover(255, true),
				offset = {
					0,
					0,
					4
				},
				size = {
					10,
					2
				}
			}
		},
		{
			style_id = "bottom_divider",
			pass_type = "rect",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				color = Color.terminal_corner_hover(255, true),
				offset = {
					0,
					0,
					4
				},
				size = {
					10,
					2
				}
			}
		},
		{
			style_id = "center_divider",
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = Color.terminal_corner_hover(255, true),
				offset = {
					12,
					0,
					4
				},
				size = {
					nil,
					2
				},
				size_addition = {
					-156,
					0
				}
			}
		},
		{
			value = "content/ui/materials/frames/line_light",
			style_id = "reward_box_frame",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				color = Color.terminal_corner_hover(nil, true),
				offset = {
					0,
					0,
					5
				},
				size = {
					144,
					144
				}
			}
		},
		{
			value_id = "reward_icon_ui",
			style_id = "reward_icon_ui",
			pass_type = "texture",
			value = "content/ui/materials/icons/items/containers/item_container_square",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "right",
				offset = {
					-8,
					0,
					5
				},
				size = {
					128,
					128
				},
				material_values = {}
			},
			visibility_function = function (content, style)
				local parent_style = style.parent

				return parent_style.reward_icon_ui.material_values.texture_icon
			end
		},
		{
			value_id = "reward_icon",
			style_id = "reward_icon",
			pass_type = "texture",
			value = "content/ui/materials/icons/items/containers/item_container_landscape",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "right",
				offset = {
					-8,
					0,
					5
				},
				size = {
					128,
					128
				},
				material_values = {}
			},
			visibility_function = function (content, style)
				local parent_style = style.parent

				return parent_style.reward_icon.material_values.use_render_target
			end
		},
		{
			style_id = "reward_box_overlay",
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				color = Color.black(130, true),
				offset = {
					-8,
					0,
					7
				},
				size = {
					128,
					128
				}
			},
			visibility_function = function (content, style)
				return content.claimed
			end
		},
		{
			style_id = "reward_box_complete",
			pass_type = "text",
			value = "",
			style = {
				font_size = 72,
				horizontal_alignment = "right",
				text_vertical_alignment = "center",
				text_horizontal_alignment = "center",
				vertical_alignment = "center",
				line_spacing = 1.2,
				font_type = "proxima_nova_bold",
				text_color = Color.terminal_text_body(nil, true),
				offset = {
					-8,
					0,
					9
				},
				size = {
					128,
					128
				}
			},
			visibility_function = function (content, style)
				return content.claimed
			end
		},
		{
			value = "content/ui/materials/icons/generic/loot",
			style_id = "loot_icon",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				color = Color.terminal_corner_hover(nil, true),
				offset = {
					-3,
					45,
					6
				},
				size = {
					42,
					42
				}
			}
		},
		{
			style_id = "reward_box_background",
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				color = Color.black(200, true),
				offset = {
					-8,
					0,
					0
				},
				size = {
					128,
					128
				}
			}
		},
		{
			value = "content/ui/materials/gradients/gradient_vertical",
			style_id = "background_gradient",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				default_color = {
					100,
					33,
					35,
					37
				},
				color = {
					100,
					33,
					35,
					37
				},
				offset = {
					-8,
					0,
					2
				},
				size = {
					128,
					128
				}
			}
		},
		{
			pass_type = "texture",
			style_id = "button_gradient",
			value = "content/ui/materials/gradients/gradient_diagonal_down_right",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				color = Color.terminal_background_gradient(nil, true),
				default_color = Color.terminal_background_gradient(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true),
				offset = {
					-8,
					0,
					1
				},
				size = {
					128,
					128
				}
			},
			change_function = function (content, style)
				return
			end
		},
		{
			value = "content/ui/materials/frames/frame_tile_2px",
			style_id = "reward_box",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				color = Color.terminal_frame(nil, true),
				offset = {
					-8,
					0,
					9
				},
				size = {
					128,
					128
				}
			}
		}
	}, scenegraph_id)
end

local widget_definitions = {
	info_box = UIWidget.create_definition({
		{
			style_id = "background",
			pass_type = "rect",
			style = {
				color = {
					75,
					0,
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/frames/frame_tile_2px",
			style_id = "frame",
			pass_type = "texture",
			style = {
				scale_to_material = true,
				color = {
					0,
					0,
					0,
					0
				},
				color_info = Color.golden_rod(nil, true),
				color_warning = Color.ui_interaction_critical(255, true),
				offset = {
					0,
					0,
					1
				}
			}
		},
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = {
				font_type = "proxima_nova_bold",
				font_size = 18,
				text_vertical_alignment = "center",
				text_horizontal_alignment = "center",
				text_color = Color.ui_interaction_critical(255, true),
				offset = {
					0,
					0,
					2
				},
				size_addition = {
					-10,
					0
				}
			}
		}
	}, "info_box"),
	play_button = UIWidget.create_definition(ButtonPassTemplates.default_button, "play_button", {
		gamepad_action = "confirm_pressed",
		original_text = Utf8.upper(Localize("loc_story_mission_play_menu_button_start_mission")),
		hotspot = {}
	}),
	play_button_legend = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = {
				font_type = "proxima_nova_bold",
				font_size = 18,
				text_vertical_alignment = "center",
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_color = Color.terminal_text_body(nil, true),
				offset = {
					0,
					50,
					2
				}
			}
		}
	}, "play_button"),
	info_button = UIWidget.create_definition(ButtonPassTemplates.input_legend_button, "info_button", {
		text = "",
		visible = true
	}),
	option_header = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			style_id = "text",
			style = {
				font_type = "proxima_nova_bold",
				text_vertical_alignment = "top",
				drop_shadow = true,
				font_size = 26,
				text_horizontal_alignment = "left",
				offset = {
					0,
					0,
					1
				},
				size_addition = {
					0,
					0
				},
				text_color = Color.terminal_text_header(nil, true)
			},
			value = Localize("loc_story_mission_play_menu_difficulty_options_header")
		}
	}, "option_header"),
	option_1 = create_option_widget("option_1"),
	option_2 = create_option_widget("option_2"),
	option_3 = create_option_widget("option_3"),
	option_4 = create_option_widget("option_4"),
	reward_1 = create_reward_widget("reward_1"),
	reward_2 = create_reward_widget("reward_2"),
	bonus_reward_claimer = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			style_id = "text",
			style = {
				font_type = "proxima_nova_bold",
				font_size = 18,
				drop_shadow = true,
				text_vertical_alignment = "center",
				text_horizontal_alignment = "left",
				text_color = Color.terminal_corner_hover(nil, true),
				offset = {
					35,
					0,
					1
				}
			},
			value = Localize("loc_story_mission_play_menu_bonus_reward_disclaimer_description")
		},
		{
			value = "content/ui/materials/icons/generic/loot",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = Color.terminal_corner_hover(nil, true),
				offset = {
					0,
					0,
					0
				},
				size = {
					32,
					32
				}
			}
		}
	}, "bonus_reward_claimer"),
	page_header = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			style_id = "text",
			style = {
				font_type = "machine_medium",
				font_size = 55,
				material = "content/ui/materials/font_gradients/slug_font_gradient_header",
				drop_shadow = true,
				text_vertical_alignment = "center",
				text_horizontal_alignment = "left",
				text_color = Color.white(nil, true),
				offset = {
					0,
					0,
					1
				}
			},
			value = Localize("loc_story_mission_play_menu_title")
		}
	}, "page_header"),
	detail = UIWidget.create_definition({
		{
			style_id = "background",
			pass_type = "rect",
			scenegraph_id = "detail_header",
			style = {
				color = {
					200,
					0,
					0,
					0
				}
			}
		},
		{
			value_id = "header_title",
			pass_type = "text",
			style_id = "header_title",
			value = "",
			style = {
				font_type = "proxima_nova_bold",
				scenegraph_id = "detail_header",
				font_size = 28,
				drop_shadow = true,
				text_vertical_alignment = "center",
				text_color = Color.terminal_text_header(nil, true),
				offset = {
					20,
					-10,
					2
				}
			}
		},
		{
			value_id = "header_subtitle",
			pass_type = "text",
			style_id = "header_subtitle",
			value = "",
			style = {
				font_type = "proxima_nova_bold",
				scenegraph_id = "detail_header",
				font_size = 18,
				drop_shadow = true,
				text_vertical_alignment = "center",
				text_color = Color.terminal_text_body(nil, true),
				offset = {
					20,
					16,
					3
				}
			}
		},
		{
			style_id = "header_frame",
			pass_type = "texture",
			scenegraph_id = "detail_header",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				horizontal_alignment = "center",
				color = Color.terminal_frame(nil, true),
				offset = {
					0,
					0,
					5
				}
			}
		},
		{
			value = "content/ui/materials/frames/dropshadow_medium",
			style_id = "outer_shadow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				scale_to_material = true,
				color = Color.black(200, true),
				size_addition = {
					20,
					20
				},
				offset = {
					0,
					0,
					3
				}
			}
		},
		{
			value = "content/ui/materials/frames/frame_tile_2px",
			style_id = "frame",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Color.terminal_frame(nil, true),
				offset = {
					0,
					0,
					5
				}
			}
		},
		{
			value_id = "location_image",
			style_id = "location_image",
			pass_type = "texture",
			value = "content/ui/materials/mission_board/texture_with_grid_effect",
			scenegraph_id = "detail_location",
			style = {
				material_values = {
					texture_map = "content/ui/textures/missions/quickplay"
				}
			}
		}
	}, "detail"),
	objective = UIWidget.create_definition({
		{
			value = "content/ui/materials/gradients/gradient_horizontal",
			style_id = "header_gradient",
			pass_type = "texture",
			style = {
				scenegraph_id = "objective_header",
				color = {
					128,
					169,
					211,
					158
				}
			}
		},
		{
			value_id = "header_title",
			pass_type = "text",
			style_id = "header_title",
			value = "",
			style = {
				font_type = "proxima_nova_bold",
				scenegraph_id = "objective_header",
				font_size = 16,
				drop_shadow = true,
				text_color = Color.terminal_text_body_sub_header(nil, true),
				offset = {
					70,
					13,
					3
				},
				size_addition = {
					-90,
					0
				}
			}
		},
		{
			value_id = "header_subtitle",
			pass_type = "text",
			style_id = "header_subtitle",
			value = "",
			style = {
				font_type = "proxima_nova_bold",
				scenegraph_id = "objective_header",
				drop_shadow = true,
				font_size = 20,
				offset = {
					70,
					33,
					4
				},
				size_addition = {
					-90,
					0
				},
				text_color = Color.terminal_text_header(nil, true)
			}
		},
		{
			value_id = "header_icon",
			style_id = "header_icon",
			pass_type = "texture",
			value = "content/ui/materials/icons/mission_types/mission_type_01",
			scenegraph_id = "objective_header",
			style = {
				color = Color.terminal_text_header(nil, true),
				offset = {
					20,
					16,
					2
				},
				size = {
					36,
					36
				}
			}
		},
		{
			style_id = "location_lock",
			scenegraph_id = "detail_location",
			pass_type = "text",
			value = "",
			style = {
				font_type = "proxima_nova_bold",
				font_size = 100,
				drop_shadow = false,
				text_vertical_alignment = "center",
				text_horizontal_alignment = "center",
				text_color = Color.black(220, true),
				offset = {
					0,
					0,
					1
				}
			},
			visibility_function = function (content)
				return content.is_locked
			end
		},
		{
			style_id = "header_frame",
			pass_type = "texture",
			scenegraph_id = "objective_header",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				horizontal_alignment = "center",
				color = Color.terminal_frame(nil, true),
				offset = {
					0,
					0,
					5
				}
			}
		},
		{
			value = "content/ui/materials/frames/dropshadow_medium",
			style_id = "outer_shadow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				scale_to_material = true,
				color = Color.black(200, true),
				size_addition = {
					20,
					20
				},
				offset = {
					0,
					0,
					3
				}
			}
		},
		{
			value = "content/ui/materials/frames/frame_tile_2px",
			style_id = "frame",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Color.terminal_frame(nil, true),
				offset = {
					0,
					0,
					5
				}
			}
		},
		{
			style_id = "background",
			pass_type = "rect",
			scenegraph_id = "objective",
			style = {
				color = {
					200,
					0,
					0,
					0
				}
			}
		},
		{
			value_id = "body_text",
			style_id = "body_text",
			pass_type = "text",
			value = "body_text",
			style = {
				line_spacing = 1.2,
				font_size = 18,
				font_type = "proxima_nova_bold",
				text_color = Color.terminal_text_body(nil, true),
				offset = {
					20,
					80,
					1
				},
				size_addition = {
					-40,
					0
				}
			}
		}
	}, "objective")
}
local animations = {}
animations.on_enter = {
	{
		name = "fade_in",
		end_time = 0.6,
		start_time = 0,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
			for _, widget in pairs(widgets) do
				widget.alpha_multiplier = 0
			end
		end
	},
	{
		name = "move",
		end_time = 0.8,
		start_time = 0.35,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
			return
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
			local anim_progress = math.easeOutCubic(progress)

			for _, widget in pairs(widgets) do
				widget.alpha_multiplier = anim_progress
			end

			local x_anim_distance_max = 50
			local x_anim_distance = x_anim_distance_max - x_anim_distance_max * anim_progress
			local extra_amount = math.clamp(15 - 15 * anim_progress * 1.2, 0, 15)

			parent:_set_scenegraph_position("page_header", scenegraph_definition.page_header.position[1] - x_anim_distance)
			parent:_set_scenegraph_position("play_button", scenegraph_definition.play_button.position[1] + x_anim_distance)
			parent:_set_scenegraph_position("option_1", scenegraph_definition.option_1.position[1] - x_anim_distance)
			parent:_set_scenegraph_position("option_4", scenegraph_definition.option_4.position[1] - x_anim_distance)
		end
	}
}
animations.on_enter_fast = {
	{
		name = "fade_in",
		end_time = 0.45,
		start_time = 0,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
			return
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
			local anim_progress = math.easeOutCubic(progress)

			for _, widget in pairs(widgets) do
				widget.alpha_multiplier = anim_progress
			end
		end
	}
}

return {
	animations = animations,
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions
}
