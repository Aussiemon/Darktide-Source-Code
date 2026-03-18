-- chunkname: @scripts/ui/views/expedition_view/expedition_view_settings.lua

local expedition_view_settings = {
	analog_input_threshold = 0.7,
	collision_filter = "filter_ground_material_check",
	dotted_line_anim_duration = 1,
	enable_input_delay = 2.2,
	gamepad_input_cooldown = 0.35,
	hologram_dotted_line_unit_path = "content/fx/expeditions_table/hologram_dotted_line",
	hologram_terrain_unit_path = "content/fx/expeditions_table/hologram_terrain",
	loot_icon = "content/ui/materials/hud/interactions/icons/expeditions_loot",
	node_drop_delay = 2.1,
	node_drop_frequency = 0.1,
	node_height_offset = 0.25,
	node_scale = 1,
	node_selection_emissive_multiplier = 5,
	node_selection_mesh = "g_selection_box",
	node_unit_path = "content/fx/expeditions_table/hologram_node",
	switch_dot_threshold = 0.6,
	table_length = 1.65,
	table_width = 2.3,
	tooltip_height = 120,
	tooltip_width = 400,
	tooltip_x_offset = 65,
	tooltip_y_offset = 0,
	unlock_anim_duration = 1.2,
	unlockable_anim_duration = 0.5,
	loot_icon_size = {
		30,
		30,
	},
	popup_pages = {
		{
			image = "content/ui/materials/backgrounds/expedition/onboarding/expedition_menu_onboarding_04",
			template = "three_texts_right",
			text_1 = "loc_expeditions_onboarding_01_desc",
			text_2 = "loc_expeditions_onboarding_02_desc",
			text_3 = "loc_expeditions_onboarding_03_desc",
			title_1 = "loc_expeditions_onboarding_01_title",
			title_2 = "loc_expeditions_onboarding_02_title",
			title_3 = "loc_expeditions_onboarding_03_title",
		},
		{
			header = "loc_expeditions_onboarding_04_title",
			image = "content/ui/materials/backgrounds/expedition/onboarding/expedition_menu_onboarding_05",
			template = "single_text_bottom",
			text = "loc_expeditions_onboarding_04_desc",
		},
		{
			header = "loc_expeditions_onboarding_05_title",
			image = "content/ui/materials/backgrounds/expedition/onboarding/expedition_menu_onboarding_06",
			template = "single_text_bottom",
			text = "loc_expeditions_onboarding_05_desc",
		},
		{
			header = "loc_expeditions_onboarding_06_title",
			image = "content/ui/materials/backgrounds/expedition/onboarding/expedition_menu_onboarding_07",
			template = "single_text_bottom",
			text = "loc_expeditions_onboarding_06_desc",
		},
		{
			header = "loc_expeditions_onboarding_07_title",
			image = "content/ui/materials/backgrounds/expedition/onboarding/expedition_menu_onboarding_08",
			template = "single_text_bottom",
			text = "loc_expeditions_onboarding_07_desc",
		},
	},
}

expedition_view_settings.colors = {
	text_light = {
		255,
		167,
		190,
		151,
	},
	text_dark = {
		255,
		101,
		145,
		102,
	},
	terminal = {
		255,
		167,
		190,
		151,
	},
	terminal_frame = {
		255,
		101,
		145,
		102,
	},
	tab_unselected = {
		255,
		0,
		0,
		0,
	},
	tab_selected = {
		255,
		50,
		72,
		51,
	},
}
expedition_view_settings.dimensions = {
	sidebar_size = {
		483,
		960,
	},
}

return settings("ExpeditionViewSettings", expedition_view_settings)
