local hud_element_prologue_tutorial_sequence_transition_end_settings = {
	transition_text = "loc_sequence_transition_text",
	events = {
		{
			"show_transition_popup",
			"show_transition_popup"
		},
		{
			"hide_transition_popup",
			"hide_transition_popup"
		}
	}
}

return settings("HudElementPrologueTutorialSequenceTransitionEndSettings", hud_element_prologue_tutorial_sequence_transition_end_settings)
