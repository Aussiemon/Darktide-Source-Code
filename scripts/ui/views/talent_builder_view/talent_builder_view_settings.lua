-- chunkname: @scripts/ui/views/talent_builder_view/talent_builder_view_settings.lua

local node_definitions = require("scripts/ui/views/talent_builder_view/talent_builder_view_node_definitions")
local summary_window_size = {
	800,
	800,
}
local summary_grid_size = {
	summary_window_size[1] - 40,
	summary_window_size[2] - 100,
}
local tutorial_window_size = {
	900,
	576,
}
local tutorial_grid_size = {
	tutorial_window_size[1] - 420,
	tutorial_window_size[2] - 225,
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
			button_1 = "loc_skip",
			button_2 = "loc_next",
			header = "loc_talent_menu_tutorial_header_1",
			image = "content/ui/materials/frames/talents/tutorial/talent_tree_tutorial_bg_01",
			text = "loc_talent_menu_tutorial_body_1",
		},
		{
			button_1 = "loc_previous",
			button_2 = "loc_next",
			header = "loc_talent_menu_tutorial_header_2",
			image = "content/ui/materials/frames/talents/tutorial/talent_tree_tutorial_bg_02",
			text = "loc_talent_menu_tutorial_body_2",
		},
		{
			button_1 = "loc_previous",
			button_2 = "loc_talent_menu_tutorial_final_button_label",
			header = "loc_talent_menu_tutorial_header_4",
			image = "content/ui/materials/frames/talents/tutorial/talent_tree_tutorial_bg_03",
			text = "loc_talent_menu_tutorial_body_4",
		},
	},
	node_gradient_colors = {
		"content/ui/textures/color_ramps/class_node_colors/adamant_01",
		"content/ui/textures/color_ramps/class_node_colors/adamant_02",
		"content/ui/textures/color_ramps/class_node_colors/adamant_03",
		"content/ui/textures/color_ramps/class_node_colors/ogryn_01",
		"content/ui/textures/color_ramps/class_node_colors/ogryn_02",
		"content/ui/textures/color_ramps/class_node_colors/ogryn_03",
		"content/ui/textures/color_ramps/class_node_colors/psyker_01",
		"content/ui/textures/color_ramps/class_node_colors/psyker_02",
		"content/ui/textures/color_ramps/class_node_colors/psyker_03",
		"content/ui/textures/color_ramps/class_node_colors/veteran_01",
		"content/ui/textures/color_ramps/class_node_colors/veteran_02",
		"content/ui/textures/color_ramps/class_node_colors/veteran_03",
		"content/ui/textures/color_ramps/class_node_colors/zealot_01",
		"content/ui/textures/color_ramps/class_node_colors/zealot_02",
		"content/ui/textures/color_ramps/class_node_colors/zealot_03",
	},
	settings_by_node_type = {
		start = {
			node_definition = node_definitions.node_definition_start,
			size = {
				10,
				10,
			},
		},
		stat = {
			display_name = "loc_glossary_talent_stat",
			frame = "content/ui/textures/frames/talents/circular_small_frame",
			sort_order = 10,
			node_definition = node_definitions.node_definition_stat,
			size = {
				82,
				82,
			},
		},
		iconic = {
			display_name = "loc_class_selection_class_iconic",
			frame = "content/ui/textures/frames/talents/circular_small_frame",
			sort_order = 10,
			node_definition = node_definitions.node_definition_stat,
			size = {
				82,
				82,
			},
		},
		tactical = {
			display_name = "loc_glossary_term_tactical",
			frame = "content/ui/textures/frames/talents/square_frame",
			gradient_map = "content/ui/textures/color_ramps/talent_blitz",
			icon_mask = "content/ui/textures/frames/talents/square_frame_mask",
			mutually_exclusive_tooltip_string = "loc_talent_mechanic_exclusive_tactical",
			selected_material = "content/ui/materials/frames/talents/square_frame_selected",
			sort_order = 3,
			node_definition = node_definitions.node_definition_tactical,
			size = {
				110,
				110,
			},
		},
		tactical_modifier = {
			display_name = "loc_glossary_term_tactical",
			frame = "content/ui/textures/frames/talents/square_frame",
			gradient_map = "content/ui/textures/color_ramps/talent_blitz",
			icon_mask = "content/ui/textures/frames/talents/square_frame_mask",
			selected_material = "content/ui/materials/frames/talents/square_frame_selected",
			sort_order = 4,
			node_definition = node_definitions.node_definition_tactical_modifier,
			size = {
				75,
				75,
			},
		},
		ability = {
			display_name = "loc_glossary_term_class_ability",
			frame = "content/ui/textures/frames/talents/hex_frame",
			gradient_map = "content/ui/textures/color_ramps/talent_ability",
			icon_mask = "content/ui/textures/frames/talents/hex_frame_mask",
			mutually_exclusive_tooltip_string = "loc_talent_mechanic_exclusive_ability",
			selected_material = "content/ui/materials/frames/talents/hex_frame_selected",
			sort_order = 1,
			node_definition = node_definitions.node_definition_ability,
			size = {
				132,
				132,
			},
		},
		ability_modifier = {
			display_name = "loc_glossary_talent_ability_modifier",
			frame = "content/ui/textures/frames/talents/hex_frame",
			gradient_map = "content/ui/textures/color_ramps/talent_ability",
			icon_mask = "content/ui/textures/frames/talents/hex_frame_mask",
			selected_material = "content/ui/materials/frames/talents/hex_frame_selected",
			sort_order = 2,
			node_definition = node_definitions.node_definition_ability_modifier,
			size = {
				80,
				80,
			},
		},
		aura = {
			display_name = "loc_glossary_term_aura",
			frame = "content/ui/textures/frames/talents/circular_frame",
			gradient_map = "content/ui/textures/color_ramps/talent_aura",
			icon_mask = "content/ui/textures/frames/talents/circular_frame_mask",
			mutually_exclusive_tooltip_string = "loc_talent_mechanic_exclusive_aura",
			selected_material = "content/ui/materials/frames/talents/circular_frame_selected",
			sort_order = 5,
			node_definition = node_definitions.node_definition_aura,
			size = {
				110,
				110,
			},
		},
		aura_modifier = {
			display_name = "loc_glossary_talent_aura_modifier",
			frame = "content/ui/textures/frames/talents/circular_frame",
			gradient_map = "content/ui/textures/color_ramps/talent_aura",
			icon_mask = "content/ui/textures/frames/talents/circular_frame_mask",
			selected_material = "content/ui/materials/frames/talents/circular_frame_selected",
			sort_order = 6,
			node_definition = node_definitions.node_definition,
			size = {
				80,
				80,
			},
		},
		keystone = {
			display_name = "loc_glossary_talent_keystone",
			frame = "content/ui/textures/frames/talents/circular_frame",
			gradient_map = "content/ui/textures/color_ramps/talent_keystone",
			icon_mask = "content/ui/textures/frames/talents/circular_frame_mask",
			mutually_exclusive_tooltip_string = "loc_talent_mechanic_exclusive_keystone",
			selected_material = "content/ui/materials/frames/talents/circular_frame_selected",
			sort_order = 7,
			node_definition = node_definitions.node_definition_keystone,
			size = {
				110,
				110,
			},
		},
		keystone_modifier = {
			display_name = "loc_glossary_talent_keystone_modifier",
			frame = "content/ui/textures/frames/talents/circular_frame",
			gradient_map = "content/ui/textures/color_ramps/talent_keystone",
			icon_mask = "content/ui/textures/frames/talents/circular_frame_mask",
			selected_material = "content/ui/materials/frames/talents/circular_frame_selected",
			sort_order = 8,
			node_definition = node_definitions.node_definition,
			size = {
				80,
				80,
			},
		},
		default = {
			display_name = "loc_glossary_talent_default",
			frame = "content/ui/textures/frames/talents/circular_frame",
			gradient_map = "content/ui/textures/color_ramps/talent_default",
			icon_mask = "content/ui/textures/frames/talents/circular_frame_mask",
			selected_material = "content/ui/materials/frames/talents/circular_frame_selected",
			sort_order = 9,
			node_definition = node_definitions.node_definition,
			size = {
				80,
				80,
			},
		},
		broker_stimm = {
			display_name = "loc_stimm_lab_recipe",
			frame = "content/ui/textures/frames/talents/diamond_frame",
			gradient_map = "content/ui/textures/color_ramps/talent_default",
			icon_mask = "content/ui/textures/frames/talents/diamond_frame_mask",
			selected_material = "content/ui/materials/frames/talents/diamond_frame_selected",
			sort_order = 9,
			node_definition = node_definitions.node_definition_broker_stimm,
			size = {
				110,
				110,
			},
		},
	},
	starting_talent_nodes_offset_by_name = {
		adamant = {
			2,
			-20,
		},
		ogryn = {
			2,
			-20,
		},
		psyker = {
			33,
			-25,
		},
		veteran = {
			60,
			-20,
		},
		zealot = {
			-30,
			35,
		},
	},
	archetype_badge_texture_by_name = {
		adamant = "content/ui/textures/icons/class_badges/adamant_01_01",
		broker = "content/ui/textures/icons/class_badges/broker_01_01",
		ogryn = "content/ui/textures/icons/class_badges/ogryn_01_01",
		psyker = "content/ui/textures/icons/class_badges/psyker_01_01",
		veteran = "content/ui/textures/icons/class_badges/veteran_01_01",
		zealot = "content/ui/textures/icons/class_badges/zealot_01_01",
	},
	archetype_backgrounds_by_name = {
		adamant = "content/ui/materials/frames/talents/talent_bg_top_gradient_adamant",
		broker = "content/ui/materials/frames/talents/talent_bg_top_gradient_broker",
		ogryn = "content/ui/materials/frames/talents/talent_bg_top_gradient_ogryn",
		psyker = "content/ui/materials/frames/talents/talent_bg_top_gradient_psyker",
		veteran = "content/ui/materials/frames/talents/talent_bg_top_gradient_veteran",
		zealot = "content/ui/materials/frames/talents/talent_bg_top_gradient_zealot",
	},
	node_text_colors = {
		default = {
			255,
			120,
			120,
			120,
		},
		chosen = {
			255,
			93,
			118,
			202,
		},
		maxed_out = {
			255,
			255,
			255,
			255,
		},
	},
	glow_colors_by_class = {
		adamant = {
			line_chosen = {
				fill_color = {
					255,
					224,
					250,
					255,
				},
				blur_color = {
					255,
					99,
					167,
					176,
				},
			},
			line_available = {
				fill_color = {
					255,
					39,
					74,
					78,
				},
				blur_color = {
					127,
					42,
					55,
					59,
				},
			},
		},
		psyker = {
			line_chosen = {
				fill_color = {
					255,
					224,
					250,
					255,
				},
				blur_color = {
					255,
					99,
					167,
					176,
				},
			},
			line_available = {
				fill_color = {
					255,
					39,
					74,
					78,
				},
				blur_color = {
					127,
					42,
					55,
					59,
				},
			},
		},
		ogryn = {
			line_chosen = {
				fill_color = {
					255,
					224,
					250,
					255,
				},
				blur_color = {
					255,
					99,
					167,
					176,
				},
			},
			line_available = {
				fill_color = {
					255,
					39,
					74,
					78,
				},
				blur_color = {
					127,
					42,
					55,
					59,
				},
			},
		},
		veteran = {
			line_chosen = {
				fill_color = {
					255,
					224,
					250,
					255,
				},
				blur_color = {
					255,
					99,
					167,
					176,
				},
			},
			line_available = {
				fill_color = {
					255,
					39,
					74,
					78,
				},
				blur_color = {
					127,
					42,
					55,
					59,
				},
			},
		},
		zealot = {
			line_chosen = {
				fill_color = {
					255,
					224,
					250,
					255,
				},
				blur_color = {
					150,
					99,
					167,
					176,
				},
			},
			line_available = {
				fill_color = {
					255,
					39,
					74,
					78,
				},
				blur_color = {
					127,
					42,
					55,
					59,
				},
			},
		},
		broker = {
			line_chosen = {
				fill_color = {
					255,
					224,
					250,
					255,
				},
				blur_color = {
					150,
					99,
					167,
					176,
				},
			},
			line_available = {
				fill_color = {
					255,
					39,
					74,
					78,
				},
				blur_color = {
					127,
					42,
					55,
					59,
				},
			},
		},
	},
	gamepad_cursor_settings = {
		arrow_rotate_rate = 0.0001,
		average_speed_smoothing = 100.5,
		bounds_max_x = 1770,
		bounds_min_x = 150,
		cursor_acceleration = 12000,
		cursor_friction_coefficient = 2e-06,
		cursor_minimum_speed = 0.1,
		default_size_x = 115,
		default_size_y = 135,
		edge_margin_bottom = 140,
		edge_margin_top = 200,
		selected_stickiness_radius = 25,
		size_resize_rate = 0.0001,
		snap_delay = 0.001,
		snap_input_length_threshold = 0.5,
		snap_movement_rate = 5e-05,
		snap_selection_speed_threshold = 1,
		stickiness_radius = 45,
		stickiness_speed_threshold = 50,
		widget_drag_coefficient = 1,
	},
}

return settings("TalentBuilderViewSettings", talent_builder_view_settings)
