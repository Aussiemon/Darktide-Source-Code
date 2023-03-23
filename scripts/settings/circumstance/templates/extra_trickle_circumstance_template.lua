local circumstance_templates = {
	snipers_01 = {
		wwise_state = "hunting_grounds_01",
		wwise_event_stop = "wwise/events/world/stop_hunting_grounds_occasionals",
		wwise_event_init = "wwise/events/world/play_hunting_grounds_occasionals",
		theme_tag = "default",
		mutators = {
			"mutator_snipers"
		},
		ui = {
			description = "loc_circumstance_hunting_grounds_description",
			icon = "content/ui/materials/icons/circumstances/hunting_grounds_01",
			display_name = "loc_circumstance_hunting_grounds_title",
			happening_display_name = "loc_happening_hunting_grounds"
		}
	},
	poxwalker_bombers_01 = {
		wwise_state = "hunting_grounds_01",
		wwise_event_stop = "wwise/events/world/stop_hunting_grounds_occasionals",
		wwise_event_init = "wwise/events/world/play_hunting_grounds_occasionals",
		theme_tag = "default",
		mutators = {
			"mutator_poxwalker_bombers"
		},
		ui = {
			description = "loc_circumstance_hunting_grounds_description",
			icon = "content/ui/materials/icons/circumstances/hunting_grounds_01",
			display_name = "loc_circumstance_hunting_grounds_title",
			happening_display_name = "loc_happening_hunting_grounds"
		},
		mission_overrides = {
			hazard_prop_settings = {
				explosion = 1,
				fire = 1,
				none = 0
			}
		}
	},
	mutants_01 = {
		wwise_state = "hunting_grounds_01",
		wwise_event_stop = "wwise/events/world/stop_hunting_grounds_occasionals",
		wwise_event_init = "wwise/events/world/play_hunting_grounds_occasionals",
		theme_tag = "default",
		mutators = {
			"mutator_mutants"
		},
		ui = {
			description = "loc_circumstance_hunting_grounds_description",
			icon = "content/ui/materials/icons/circumstances/hunting_grounds_01",
			display_name = "loc_circumstance_hunting_grounds_title",
			happening_display_name = "loc_happening_hunting_grounds"
		}
	}
}

return circumstance_templates
