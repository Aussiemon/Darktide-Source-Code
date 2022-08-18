local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local end_player_view_settings = {
	duration = 20,
	carousel_initial_states = {
		{
			retract_duration = 0.25,
			name = "slide_cards_to_the_left",
			duration = 0.5,
			update_func_name = "carousel_state_slide_cards_to_the_left",
			sound_event = UISoundEvents.end_screen_summary_card_slide_left,
			sound_event_on_retract = UISoundEvents.end_screen_summary_card_retract
		},
		{
			name = "expand_current_card",
			update_func_name = "carousel_state_expand_current_card",
			duration = 0.3,
			sound_event = UISoundEvents.end_screen_summary_card_expand
		},
		{
			update_func_name = "carousel_state_show_card_content",
			name = "show_card_content"
		}
	},
	animation_times = {
		text_row_fade_in_time = 0.1
	}
}

return settings("EndPlayerViewSettings", end_player_view_settings)
