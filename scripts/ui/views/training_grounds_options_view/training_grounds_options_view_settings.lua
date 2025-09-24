-- chunkname: @scripts/ui/views/training_grounds_options_view/training_grounds_options_view_settings.lua

local training_grounds_options_view_settings = {
	rewards_claimed_text = "loc_training_grounds_claimed_rewards",
	play_settings = {
		basic = {
			init_scenario_name = "basic_training",
			header_text = Localize("loc_training_grounds_view_basic_header_text"),
			sub_header_text = Localize("loc_training_grounds_view_basic_sub_header_text"),
			body_text = Localize("loc_training_grounds_view_basic_body_text"),
			play_button_text = Localize("loc_training_grounds_view_option_enter"),
		},
		advanced = {
			init_scenario_name = "advanced_training",
			header_text = Localize("loc_training_grounds_view_advanced_header_text"),
			sub_header_text = Localize("loc_training_grounds_view_advanced_sub_header_text"),
			body_text = Localize("loc_training_grounds_view_advanced_body_text"),
			play_button_text = Localize("loc_training_grounds_view_option_enter"),
		},
		shooting_range = {
			header_text = Localize("loc_training_grounds_view_shooting_range_text"),
			sub_header_text = Localize("loc_training_grounds_view_shooting_range_sub_header_text"),
			body_text = Localize("loc_training_grounds_view_shooting_range_body_text"),
			play_button_text = Localize("loc_training_grounds_view_option_enter"),
		},
	},
	panel_size = {
		default = {
			720,
			690,
		},
		large = {
			720,
			860,
		},
		small = {
			720,
			490,
		},
	},
	reward_size = {
		288,
		153.6,
	},
	weapon_size = {
		288,
		153.6,
	},
}

return settings("TrainingGroundsOptionsViewSettings", training_grounds_options_view_settings)
