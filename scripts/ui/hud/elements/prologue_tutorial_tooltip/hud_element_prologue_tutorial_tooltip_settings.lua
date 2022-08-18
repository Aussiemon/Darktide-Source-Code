local hud_element_prologue_tutorial_tooltip_settings = {
	events = {
		{
			"event_player_display_prologue_tutorial_tooltip",
			"event_player_display_prologue_tutorial_tooltip"
		},
		{
			"event_player_hide_prologue_tutorial_tooltip",
			"event_player_hide_prologue_tutorial_tooltip"
		}
	}
}

return settings("HudElementPrologueTutorialTooltipSettings", hud_element_prologue_tutorial_tooltip_settings)
