local hud_element_prologue_tutorial_popup_settings = {
	events = {
		{
			"event_player_display_prologue_tutorial_message",
			"event_player_display_prologue_tutorial_message"
		},
		{
			"event_player_hide_prologue_tutorial_message",
			"event_player_hide_prologue_tutorial_message"
		}
	}
}

return settings("HudElementPrologueTutorialPopupSettings", hud_element_prologue_tutorial_popup_settings)
