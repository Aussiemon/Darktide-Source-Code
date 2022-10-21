local training_grounds_options_view_settings = {
	rewards_claimed_text = "loc_training_grounds_claimed_rewards",
	play_settings = {
		basic = {
			init_scenario_name = "basic_training",
			header_text = Localize("loc_training_grounds_view_basic_header_text"),
			sub_header_text = Localize("loc_training_grounds_view_basic_sub_header_text"),
			body_text = Localize("loc_training_grounds_view_basic_body_text"),
			play_button_text = Localize("loc_training_grounds_view_option_play")
		},
		advanced = {
			init_scenario_name = "advanced_training",
			header_text = Localize("loc_training_grounds_view_advanced_header_text"),
			sub_header_text = Localize("loc_training_grounds_view_advanced_sub_header_text"),
			body_text = Localize("loc_training_grounds_view_advanced_body_text"),
			play_button_text = Localize("loc_training_grounds_view_option_play")
		}
	}
}

return settings("TrainingGroundsOptionsViewSettings", training_grounds_options_view_settings)
