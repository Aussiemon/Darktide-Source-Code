-- chunkname: @scripts/ui/views/end_player_view/end_player_view_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local end_player_view_settings = {
	carousel_initial_states = {
		{
			animation_id = nil,
			duration = 0.5,
			name = "slide_cards_to_the_left",
			retract_duration = 0.25,
			update_func_name = "carousel_state_slide_cards_to_the_left",
			sound_event = UISoundEvents.end_screen_summary_card_slide_left,
			sound_event_on_retract = UISoundEvents.end_screen_summary_card_retract,
		},
		{
			duration = 0.3,
			name = "expand_current_card",
			sound_event = nil,
			update_func_name = "carousel_state_expand_current_card",
		},
		{
			animation_id = nil,
			name = "show_fade_in_content",
			update_func_name = "carousel_state_fade_in_card_content",
		},
		{
			duration = 3,
			name = "show_card_content",
			update_func_name = "carousel_state_show_card_content",
		},
	},
	animation_times = {
		card_compress_content_time = 0.25,
		card_fade_out_time = 0.1,
		currency_gain_visibility_time = 10,
		text_row_fade_in_time = 0.1,
		timed_widget_fade_time = 0.25,
		xp_gain_visibility_time = 2,
	},
	item_rarity_sounds = {
		UISoundEvents.end_screen_summary_reward_in_rarity_1,
		UISoundEvents.end_screen_summary_reward_in_rarity_2,
		UISoundEvents.end_screen_summary_reward_in_rarity_3,
		UISoundEvents.end_screen_summary_reward_in_rarity_4,
		UISoundEvents.end_screen_summary_reward_in_rarity_5,
		UISoundEvents.end_screen_summary_reward_in_rarity_6,
	},
	currency_sounds = {
		experience = {
			start = UISoundEvents.end_screen_summary_experience_start,
			stop = UISoundEvents.end_screen_summary_experience_stop,
			progress = UISoundEvents.end_screen_summary_experience_progress,
			zero = UISoundEvents.end_screen_summary_experience_zero,
		},
		credits = {
			start = UISoundEvents.end_screen_summary_credits_start,
			stop = UISoundEvents.end_screen_summary_credits_stop,
			progress = UISoundEvents.end_screen_summary_credits_progress,
			zero = UISoundEvents.end_screen_summary_credits_zero,
		},
		plasteel = {
			start = UISoundEvents.end_screen_summary_plasteel_start,
			stop = UISoundEvents.end_screen_summary_plasteel_stop,
			progress = UISoundEvents.end_screen_summary_plasteel_progress,
			zero = UISoundEvents.end_screen_summary_plasteel_zero,
		},
		diamantine = {
			start = UISoundEvents.end_screen_summary_diamantine_start,
			stop = UISoundEvents.end_screen_summary_diamantine_stop,
			progress = UISoundEvents.end_screen_summary_diamantine_progress,
			zero = UISoundEvents.end_screen_summary_diamantine_zero,
		},
	},
}

local function _calculate_fixed_card_time(card_states)
	local time = 0

	for i = 1, #card_states do
		local card_state = card_states[i]

		time = time + (card_state.duration or 0)
	end

	return time
end

end_player_view_settings.animation_times.fixed_card_time = _calculate_fixed_card_time(end_player_view_settings.carousel_initial_states)

return settings("EndPlayerViewSettings", end_player_view_settings)
