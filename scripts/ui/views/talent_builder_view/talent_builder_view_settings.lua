-- chunkname: @scripts/ui/views/talent_builder_view/talent_builder_view_settings.lua

local node_definitions = require("scripts/ui/views/talent_builder_view/talent_builder_view_node_definitions")
local summary_window_size = {
	800,
	800
}
local summary_grid_size = {
	summary_window_size[1] - 40,
	summary_window_size[2] - 100
}
local tutorial_window_size = {
	900,
	576
}
local tutorial_grid_size = {
	tutorial_window_size[1] - 420,
	tutorial_window_size[2] - 225
}
local talent_builder_view_settings = {
	tooltip_fade_delay = 0.3,
	tooltip_fade_speed = 7,
	summary_window_size = summary_window_size,
	summary_grid_size = summary_grid_size,
	tutorial_window_size = tutorial_window_size,
	tutorial_grid_size = tutorial_grid_size,
	tutorial_popup_pages = {
		{
			text = "loc_talent_menu_tutorial_body_1",
			header = "loc_talent_menu_tutorial_header_1",
			button_2 = "loc_next",
			image = "content/ui/materials/frames/talents/tutorial/talent_tree_tutorial_bg_01",
			button_1 = "loc_skip"
		},
		{
			text = "loc_talent_menu_tutorial_body_2",
			header = "loc_talent_menu_tutorial_header_2",
			button_2 = "loc_next",
			image = "content/ui/materials/frames/talents/tutorial/talent_tree_tutorial_bg_02",
			button_1 = "loc_previous"
		},
		{
			text = "loc_talent_menu_tutorial_body_4",
			header = "loc_talent_menu_tutorial_header_4",
			button_2 = "loc_talent_menu_tutorial_final_button_label",
			image = "content/ui/materials/frames/talents/tutorial/talent_tree_tutorial_bg_03",
			button_1 = "loc_previous"
		}
	},
	node_gradient_colors = {
		"content/ui/textures/color_ramps/class_node_colors/veteran_01",
		"content/ui/textures/color_ramps/class_node_colors/veteran_02",
		"content/ui/textures/color_ramps/class_node_colors/veteran_03",
		"content/ui/textures/color_ramps/class_node_colors/zealot_01",
		"content/ui/textures/color_ramps/class_node_colors/zealot_02",
		"content/ui/textures/color_ramps/class_node_colors/zealot_03",
		"content/ui/textures/color_ramps/class_node_colors/psyker_01",
		"content/ui/textures/color_ramps/class_node_colors/psyker_02",
		"content/ui/textures/color_ramps/class_node_colors/psyker_03",
		"content/ui/textures/color_ramps/class_node_colors/ogryn_01",
		"content/ui/textures/color_ramps/class_node_colors/ogryn_02",
		"content/ui/textures/color_ramps/class_node_colors/ogryn_03"
	},
	settings_by_node_type = {
		start = {
			node_definition = node_definitions.node_definition_start,
			size = {
				10,
				10
			}
		},
		stat = {
			display_name = "loc_glossary_talent_stat",
			frame = "content/ui/textures/frames/talents/circular_small_frame",
			sort_order = 10,
			node_definition = node_definitions.node_definition_stat,
			size = {
				82,
				82
			}
		},
		iconic = {
			display_name = "loc_class_selection_class_iconic",
			frame = "content/ui/textures/frames/talents/circular_small_frame",
			sort_order = 10,
			node_definition = node_definitions.node_definition_stat,
			size = {
				82,
				82
			}
		},
		tactical = {
			mutually_exclusive_tooltip_string = "loc_talent_mechanic_exclusive_tactical",
			display_name = "loc_glossary_term_tactical",
			selected_material = "content/ui/materials/frames/talents/square_frame_selected",
			frame = "content/ui/textures/frames/talents/square_frame",
			gradient_map = "content/ui/textures/color_ramps/talent_blitz",
			icon_mask = "content/ui/textures/frames/talents/square_frame_mask",
			sort_order = 3,
			node_definition = node_definitions.node_definition_tactical,
			size = {
				110,
				110
			}
		},
		tactical_modifier = {
			frame = "content/ui/textures/frames/talents/square_frame",
			display_name = "loc_glossary_term_tactical",
			selected_material = "content/ui/materials/frames/talents/square_frame_selected",
			icon_mask = "content/ui/textures/frames/talents/square_frame_mask",
			gradient_map = "content/ui/textures/color_ramps/talent_blitz",
			sort_order = 4,
			node_definition = node_definitions.node_definition_tactical_modifier,
			size = {
				75,
				75
			}
		},
		ability = {
			mutually_exclusive_tooltip_string = "loc_talent_mechanic_exclusive_ability",
			display_name = "loc_glossary_term_class_ability",
			selected_material = "content/ui/materials/frames/talents/hex_frame_selected",
			frame = "content/ui/textures/frames/talents/hex_frame",
			gradient_map = "content/ui/textures/color_ramps/talent_ability",
			icon_mask = "content/ui/textures/frames/talents/hex_frame_mask",
			sort_order = 1,
			node_definition = node_definitions.node_definition_ability,
			size = {
				132,
				132
			}
		},
		ability_modifier = {
			frame = "content/ui/textures/frames/talents/hex_frame",
			display_name = "loc_glossary_talent_ability_modifier",
			selected_material = "content/ui/materials/frames/talents/hex_frame_selected",
			icon_mask = "content/ui/textures/frames/talents/hex_frame_mask",
			gradient_map = "content/ui/textures/color_ramps/talent_ability",
			sort_order = 2,
			node_definition = node_definitions.node_definition_ability_modifier,
			size = {
				80,
				80
			}
		},
		aura = {
			mutually_exclusive_tooltip_string = "loc_talent_mechanic_exclusive_aura",
			display_name = "loc_glossary_term_aura",
			selected_material = "content/ui/materials/frames/talents/circular_frame_selected",
			frame = "content/ui/textures/frames/talents/circular_frame",
			gradient_map = "content/ui/textures/color_ramps/talent_aura",
			icon_mask = "content/ui/textures/frames/talents/circular_frame_mask",
			sort_order = 5,
			node_definition = node_definitions.node_definition_aura,
			size = {
				110,
				110
			}
		},
		aura_modifier = {
			frame = "content/ui/textures/frames/talents/circular_frame",
			display_name = "loc_glossary_talent_aura_modifier",
			selected_material = "content/ui/materials/frames/talents/circular_frame_selected",
			icon_mask = "content/ui/textures/frames/talents/circular_frame_mask",
			gradient_map = "content/ui/textures/color_ramps/talent_aura",
			sort_order = 6,
			node_definition = node_definitions.node_definition,
			size = {
				80,
				80
			}
		},
		keystone = {
			mutually_exclusive_tooltip_string = "loc_talent_mechanic_exclusive_keystone",
			display_name = "loc_glossary_talent_keystone",
			selected_material = "content/ui/materials/frames/talents/circular_frame_selected",
			frame = "content/ui/textures/frames/talents/circular_frame",
			gradient_map = "content/ui/textures/color_ramps/talent_keystone",
			icon_mask = "content/ui/textures/frames/talents/circular_frame_mask",
			sort_order = 7,
			node_definition = node_definitions.node_definition_keystone,
			size = {
				110,
				110
			}
		},
		keystone_modifier = {
			frame = "content/ui/textures/frames/talents/circular_frame",
			display_name = "loc_glossary_talent_keystone_modifier",
			selected_material = "content/ui/materials/frames/talents/circular_frame_selected",
			icon_mask = "content/ui/textures/frames/talents/circular_frame_mask",
			gradient_map = "content/ui/textures/color_ramps/talent_keystone",
			sort_order = 8,
			node_definition = node_definitions.node_definition,
			size = {
				80,
				80
			}
		},
		default = {
			frame = "content/ui/textures/frames/talents/circular_frame",
			display_name = "loc_glossary_talent_default",
			selected_material = "content/ui/materials/frames/talents/circular_frame_selected",
			icon_mask = "content/ui/textures/frames/talents/circular_frame_mask",
			gradient_map = "content/ui/textures/color_ramps/talent_default",
			sort_order = 9,
			node_definition = node_definitions.node_definition,
			size = {
				80,
				80
			}
		}
	},
	starting_talent_nodes_offset_by_name = {
		veteran = {
			60,
			-20
		},
		psyker = {
			33,
			-25
		},
		zealot = {
			-30,
			35
		},
		ogryn = {
			2,
			-20
		}
	},
	starting_points_material_by_name = {
		psyker = "content/ui/materials/frames/talents/starting_points/starting_point_psyker",
		veteran = "content/ui/materials/frames/talents/starting_points/starting_point_veteran",
		zealot = "content/ui/materials/frames/talents/starting_points/starting_point_zealot",
		ogryn = "content/ui/materials/frames/talents/starting_points/starting_point_ogryn"
	},
	archetype_badge_texture_by_name = {
		psyker = "content/ui/textures/icons/class_badges/psyker_01_01",
		veteran = "content/ui/textures/icons/class_badges/veteran_01_01",
		zealot = "content/ui/textures/icons/class_badges/zealot_01_01",
		ogryn = "content/ui/textures/icons/class_badges/ogryn_01_01"
	},
	archetype_backgrounds_by_name = {
		psyker = "content/ui/materials/frames/talents/talent_bg_top_gradient_psyker",
		veteran = "content/ui/materials/frames/talents/talent_bg_top_gradient_veteran",
		zealot = "content/ui/materials/frames/talents/talent_bg_top_gradient_zealot",
		ogryn = "content/ui/materials/frames/talents/talent_bg_top_gradient_ogryn"
	},
	node_text_colors = {
		default = {
			255,
			120,
			120,
			120
		},
		chosen = {
			255,
			93,
			118,
			202
		},
		maxed_out = {
			255,
			255,
			255,
			255
		}
	},
	glow_colors_by_class = {
		veteran = {
			line_chosen = {
				fill_color = {
					255,
					224,
					250,
					255
				},
				blur_color = {
					255,
					99,
					167,
					176
				}
			},
			line_available = {
				fill_color = {
					255,
					39,
					74,
					78
				},
				blur_color = {
					127,
					42,
					55,
					59
				}
			}
		},
		psyker = {
			line_chosen = {
				fill_color = {
					255,
					224,
					250,
					255
				},
				blur_color = {
					255,
					99,
					167,
					176
				}
			},
			line_available = {
				fill_color = {
					255,
					39,
					74,
					78
				},
				blur_color = {
					127,
					42,
					55,
					59
				}
			}
		},
		zealot = {
			line_chosen = {
				fill_color = {
					255,
					224,
					250,
					255
				},
				blur_color = {
					150,
					99,
					167,
					176
				}
			},
			line_available = {
				fill_color = {
					255,
					39,
					74,
					78
				},
				blur_color = {
					127,
					42,
					55,
					59
				}
			}
		},
		ogryn = {
			line_chosen = {
				fill_color = {
					255,
					224,
					250,
					255
				},
				blur_color = {
					255,
					99,
					167,
					176
				}
			},
			line_available = {
				fill_color = {
					255,
					39,
					74,
					78
				},
				blur_color = {
					127,
					42,
					55,
					59
				}
			}
		}
	},
	gamepad_cursor_settings = {
		snap_selection_speed_threshold = 1,
		stickiness_speed_threshold = 50,
		widget_drag_coefficient = 1,
		cursor_acceleration = 12000,
		average_speed_smoothing = 100.5,
		cursor_friction_coefficient = 2e-06,
		edge_margin_bottom = 140,
		edge_margin_top = 200,
		snap_input_length_threshold = 0.5,
		snap_movement_rate = 5e-05,
		selected_stickiness_radius = 25,
		default_size_y = 135,
		bounds_max_x = 1770,
		size_resize_rate = 0.0001,
		stickiness_radius = 45,
		default_size_x = 115,
		arrow_rotate_rate = 0.0001,
		snap_delay = 0.001,
		bounds_min_x = 150,
		cursor_minimum_speed = 0.1
	}
}

return settings("TalentBuilderViewSettings", talent_builder_view_settings)
