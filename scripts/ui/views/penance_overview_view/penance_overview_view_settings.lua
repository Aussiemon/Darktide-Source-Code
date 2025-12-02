-- chunkname: @scripts/ui/views/penance_overview_view/penance_overview_view_settings.lua

local window_size = {
	1400,
	500,
}
local image_size = {
	window_size[1] * 0.5,
	window_size[2] + 200,
}
local carousel_penance_size = {
	368,
	582,
}
local penance_grid_background_size = {
	1064,
	558,
}
local penance_grid_side_margin = 22
local penance_grid_size = {
	penance_grid_background_size[1] - penance_grid_side_margin * 2,
	penance_grid_background_size[2],
}
local penance_grid_spacing = {
	10,
	10,
}
local num_small_penances_in_grid = 10
local total_small_penances_spacing = penance_grid_spacing[1] * (num_small_penances_in_grid - 1)
local penance_pixel_size = (penance_grid_size[1] - total_small_penances_spacing) / num_small_penances_in_grid
local penance_size = {
	penance_pixel_size,
	penance_pixel_size,
}
local penance_size_large = {
	(penance_grid_size[1] - penance_grid_spacing[1]) * 0.5,
	140,
}
local tooltip_grid_size = {
	480,
	578,
}
local tooltip_entries_width = tooltip_grid_size[1] - 0
local background_world_params = {
	level_name = "content/levels/ui/penances/world",
	register_camera_event = "event_register_penances_view_camera",
	shading_environment = "content/shading_environments/ui/penance_view",
	timer_name = "ui",
	total_blur_duration = 0.5,
	viewport_layer = 1,
	viewport_name = "ui_penances_world_viewport",
	viewport_type = "default",
	world_layer = 1,
	world_name = "ui_penances_world",
}
local penance_overview_view_settings = {
	carousel_acceleration = 0.3,
	carousel_max_entries = 10,
	carousel_scroll_deadzone = 0.2,
	carousel_scroll_decay = 0.1,
	carousel_scroll_input_handle_threshold = 0.3,
	carousel_scroll_sensitivity = 0.05,
	carousel_scroll_speed = 3.2,
	initial_carousel_factor_speed = 1.6,
	background_world_params = background_world_params,
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
		"content/ui/textures/icons/achievements/number_overlays/10",
	},
	carousel_entry_settings = {
		{
			alpha = 0,
			color_intensity = 0.25,
			position = {
				-(carousel_penance_size[1] + 30 + 65),
				-30,
			},
		},
		{
			alpha = 0.5,
			color_intensity = 0.3333333333333333,
			position = {
				-(carousel_penance_size[1] + 30 + 60),
				-20,
			},
		},
		{
			alpha = 0.8,
			color_intensity = 0.5,
			position = {
				-(carousel_penance_size[1] + 30 + 40),
				-10,
			},
		},
		{
			alpha = 1,
			color_intensity = 1,
			position = {
				-(carousel_penance_size[1] + 30),
				0,
			},
		},
		{
			alpha = 1,
			color_intensity = 1,
			position = {
				0,
				0,
			},
		},
		{
			alpha = 1,
			color_intensity = 1,
			position = {
				carousel_penance_size[1] + 30,
				0,
			},
		},
		{
			alpha = 0.8,
			color_intensity = 0.5,
			position = {
				carousel_penance_size[1] + 30 + 40,
				-10,
			},
		},
		{
			alpha = 0.5,
			color_intensity = 0.3333333333333333,
			position = {
				carousel_penance_size[1] + 30 + 60,
				-20,
			},
		},
		{
			alpha = 0,
			color_intensity = 0.25,
			position = {
				carousel_penance_size[1] + 30 + 65,
				-30,
			},
		},
	},
	category_icons = {
		account = "content/ui/materials/icons/achievements/categories/category_account",
		adamant = "content/ui/materials/icons/achievements/categories/category_adamant",
		broker = "content/ui/materials/icons/achievements/categories/category_broker",
		endeavours = "content/ui/materials/icons/achievements/categories/category_endeavour",
		exploration = "content/ui/materials/icons/achievements/categories/category_exploration",
		heretics = "content/ui/materials/icons/achievements/categories/category_heretics",
		missions = "content/ui/materials/icons/achievements/categories/category_mission",
		ogryn_2 = "content/ui/materials/icons/achievements/categories/category_ogryn",
		psyker_2 = "content/ui/materials/icons/achievements/categories/category_psyker",
		tactical = "content/ui/materials/icons/achievements/categories/category_tactical",
		veteran_2 = "content/ui/materials/icons/achievements/categories/category_veteran",
		weapons = "content/ui/materials/icons/achievements/categories/category_weapons",
		zealot_2 = "content/ui/materials/icons/achievements/categories/category_zealot",
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
			"amount_of_chests_opened_1",
		},
		broker = {
			"basic_training",
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
			"amount_of_chests_opened_1",
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
			"amount_of_chests_opened_1",
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
			"amount_of_chests_opened_1",
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
			"amount_of_chests_opened_1",
		},
	},
	blueprints_by_page = {
		carousel = {
			body = "carousel_penance_body",
			category = "carousel_penance_category",
			completed = "carousel_penance_completed",
			dynamic_spacing = "dynamic_spacing",
			header = "carousel_penance_header",
			penance_icon = "carousel_penance_icon",
			penance_icon_and_name = "carousel_penance_icon_and_name",
			penance_icon_small = "carousel_penance_icon_small",
			progress_bar = "carousel_penance_progress_bar",
			score = "carousel_penance_reward",
			score_and_reward = "carousel_penance_score_and_reward",
			stat = "carousel_penance_stat",
			tracked = "carousel_penance_tracked",
		},
		tooltip = {
			body = "tooltip_penance_body",
			category = "tooltip_penance_category",
			completed = "tooltip_penance_completed",
			dynamic_spacing = "dynamic_spacing",
			header = "tooltip_penance_header",
			penance_icon = "tooltip_penance_icon",
			penance_icon_and_name = "tooltip_penance_icon_and_name",
			penance_icon_small = "tooltip_penance_icon_small",
			progress_bar = "tooltip_penance_progress_bar",
			score = "tooltip_penance_reward",
			score_and_reward = "tooltip_penance_score_and_reward",
			stat = "tooltip_penance_stat",
			tracked = "tooltip_penance_tracked",
		},
	},
}

return settings("PenanceOverviewViewSettings", penance_overview_view_settings)
