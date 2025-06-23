-- chunkname: @scripts/ui/views/penance_overview_view/penance_overview_view_settings.lua

local window_size = {
	1400,
	500
}
local image_size = {
	window_size[1] * 0.5,
	window_size[2] + 200
}
local right_side_width = 480
local right_side_height = 508
local carousel_penance_size = {
	368,
	582
}
local penance_grid_background_size = {
	1064,
	558
}
local penance_grid_side_margin = 22
local penance_grid_size = {
	penance_grid_background_size[1] - penance_grid_side_margin * 2,
	penance_grid_background_size[2]
}
local penance_grid_spacing = {
	10,
	10
}
local num_small_penances_in_grid = 10
local total_small_penances_spacing = penance_grid_spacing[1] * (num_small_penances_in_grid - 1)
local penance_pixel_size = (penance_grid_size[1] - total_small_penances_spacing) / num_small_penances_in_grid
local penance_size = {
	penance_pixel_size,
	penance_pixel_size
}
local penance_size_large = {
	(penance_grid_size[1] - penance_grid_spacing[1]) * 0.5,
	140
}
local tooltip_grid_size = {
	480,
	578
}
local tooltip_entries_width = tooltip_grid_size[1] - 0
local background_world_params = {
	shading_environment = "content/shading_environments/ui/penance_view",
	world_layer = 1,
	total_blur_duration = 0.5,
	timer_name = "ui",
	viewport_type = "default",
	register_camera_event = "event_register_penances_view_camera",
	viewport_name = "ui_penances_world_viewport",
	viewport_layer = 1,
	level_name = "content/levels/ui/penances/world",
	world_name = "ui_penances_world"
}
local penance_overview_view_settings = {
	carousel_scroll_input_handle_threshold = 0.3,
	carousel_min_scroll_speed = 1,
	carousel_scroll_speed_increase = 0.3,
	carousel_max_scroll_speed = 15,
	carousel_scroll_speed_decrease = 0.1,
	carousel_max_entries = 10,
	carousel_initial_scroll_speed = 0.6,
	background_world_params = background_world_params,
	right_side_width = right_side_width,
	right_side_height = right_side_height,
	penance_pixel_size = penance_pixel_size,
	penance_size = penance_size,
	penance_size_large = penance_size_large,
	penance_grid_background_size = penance_grid_background_size,
	penance_grid_size = penance_grid_size,
	penance_grid_spacing = penance_grid_spacing,
	tooltip_grid_size = tooltip_grid_size,
	tooltip_entries_width = tooltip_entries_width,
	carousel_penance_size = carousel_penance_size,
	window_size = window_size,
	image_size = image_size,
	animation_event_by_archetype = {
		psyker = "human_psyker_inspect_pose",
		adamant = "human_adamant_inspect_pose",
		ogryn = "ogryn_inspect_pose",
		veteran = "human_veteran_inspect_pose",
		zealot = "human_zealot_inspect_pose"
	},
	archetype_badge_texture_by_name = {
		psyker = "content/ui/textures/icons/class_badges/psyker_01_01",
		adamant = "content/ui/textures/icons/class_badges/adamant_01_01",
		ogryn = "content/ui/textures/icons/class_badges/ogryn_01_01",
		veteran = "content/ui/textures/icons/class_badges/veteran_01_01",
		zealot = "content/ui/textures/icons/class_badges/zealot_01_01"
	},
	roman_numeral_texture_array = {
		"content/ui/textures/icons/achievements/number_overlays/01",
		"content/ui/textures/icons/achievements/number_overlays/02",
		"content/ui/textures/icons/achievements/number_overlays/03",
		"content/ui/textures/icons/achievements/number_overlays/04",
		"content/ui/textures/icons/achievements/number_overlays/05",
		"content/ui/textures/icons/achievements/number_overlays/06",
		"content/ui/textures/icons/achievements/number_overlays/07",
		"content/ui/textures/icons/achievements/number_overlays/08",
		"content/ui/textures/icons/achievements/number_overlays/09",
		"content/ui/textures/icons/achievements/number_overlays/10"
	},
	carousel_entry_settings = {
		{
			alpha = 0,
			color_intensity = 0.25,
			position = {
				-(carousel_penance_size[1] + 30 + 160),
				-40
			}
		},
		{
			alpha = 0.25,
			color_intensity = 0.5,
			position = {
				-(carousel_penance_size[1] + 30 + 120),
				-30
			}
		},
		{
			alpha = 0.5,
			color_intensity = 0.5,
			position = {
				-(carousel_penance_size[1] + 30 + 80),
				-20
			}
		},
		{
			alpha = 0.75,
			color_intensity = 0.75,
			position = {
				-(carousel_penance_size[1] + 30 + 40),
				-10
			}
		},
		{
			alpha = 1,
			color_intensity = 1,
			position = {
				-(carousel_penance_size[1] + 30),
				0
			}
		},
		{
			alpha = 1,
			color_intensity = 1,
			position = {
				0,
				0
			}
		},
		{
			alpha = 1,
			color_intensity = 1,
			position = {
				carousel_penance_size[1] + 30,
				0
			}
		},
		{
			alpha = 0.75,
			color_intensity = 0.75,
			position = {
				carousel_penance_size[1] + 30 + 40,
				-10
			}
		},
		{
			alpha = 0.5,
			color_intensity = 0.5,
			position = {
				carousel_penance_size[1] + 30 + 80,
				-20
			}
		},
		{
			alpha = 0.25,
			color_intensity = 0.5,
			position = {
				carousel_penance_size[1] + 30 + 120,
				-30
			}
		},
		{
			alpha = 0,
			color_intensity = 0.25,
			position = {
				carousel_penance_size[1] + 30 + 160,
				-40
			}
		}
	},
	category_icons = {
		adamant = "content/ui/materials/icons/achievements/categories/category_adamant",
		weapons = "content/ui/materials/icons/achievements/categories/category_weapons",
		heretics = "content/ui/materials/icons/achievements/categories/category_heretics",
		missions = "content/ui/materials/icons/achievements/categories/category_mission",
		zealot_2 = "content/ui/materials/icons/achievements/categories/category_zealot",
		tactical = "content/ui/materials/icons/achievements/categories/category_tactical",
		psyker_2 = "content/ui/materials/icons/achievements/categories/category_psyker",
		veteran_2 = "content/ui/materials/icons/achievements/categories/category_veteran",
		ogryn_2 = "content/ui/materials/icons/achievements/categories/category_ogryn",
		account = "content/ui/materials/icons/achievements/categories/category_account",
		exploration = "content/ui/materials/icons/achievements/categories/category_exploration",
		endeavours = "content/ui/materials/icons/achievements/categories/category_endeavour"
	},
	default_highlight_penances = {
		adamant = {
			"basic_training",
			"slide_dodge",
			"coherency_toughness",
			"fast_headshot_1",
			"enemies_1",
			"kill_renegades_1",
			"mission_circumstace_1",
			"amount_of_chests_opened_1"
		},
		ogryn = {
			"basic_training",
			"slide_dodge",
			"missions_ogryn_2_easy_difficulty_1",
			"coherency_toughness",
			"fast_headshot_1",
			"enemies_1",
			"rank_ogryn_2_1",
			"kill_renegades_1",
			"mission_circumstace_1",
			"ogryn_2_easy_2",
			"amount_of_chests_opened_1"
		},
		psyker = {
			"basic_training",
			"slide_dodge",
			"missions_psyker_2_easy_difficulty_1",
			"coherency_toughness",
			"fast_headshot_1",
			"enemies_1",
			"rank_psyker_2_1",
			"kill_renegades_1",
			"mission_circumstace_1",
			"psyker_2_easy_1",
			"amount_of_chests_opened_1"
		},
		veteran = {
			"basic_training",
			"slide_dodge",
			"missions_veteran_2_easy_difficulty_1",
			"coherency_toughness",
			"fast_headshot_1",
			"enemies_1",
			"rank_veteran_2_1",
			"kill_renegades_1",
			"mission_circumstace_1",
			"veteran_2_easy_1",
			"amount_of_chests_opened_1"
		},
		zealot = {
			"basic_training",
			"slide_dodge",
			"missions_zealot_2_easy_difficulty_1",
			"coherency_toughness",
			"fast_headshot_1",
			"enemies_1",
			"rank_zealot_2_1",
			"kill_renegades_1",
			"mission_circumstace_1",
			"zealot_2_easy_2",
			"amount_of_chests_opened_1"
		}
	}
}

return settings("PenanceOverviewViewSettings", penance_overview_view_settings)
