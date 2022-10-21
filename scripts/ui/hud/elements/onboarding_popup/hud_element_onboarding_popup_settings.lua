local hud_element_onboarding_popup_settings = {
	events = {
		{
			"event_player_display_onboarding_message",
			"event_player_display_onboarding_message"
		},
		{
			"event_player_hide_onboarding_message",
			"event_player_hide_onboarding_message"
		}
	}
}

return settings("HudElementOnboardingPopupSettings", hud_element_onboarding_popup_settings)
