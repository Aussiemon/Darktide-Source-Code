local circumstance_templates = {
	assault_01 = {
		wwise_state = "assault_01",
		theme_tag = "default",
		mission_overrides = {
			hazard_prop_settings = {
				explosion = 1,
				fire = 1,
				none = 0
			},
			health_station = {
				charges_to_distribute = 0
			}
		},
		mutators = {
			"mutator_more_hordes",
			"mutator_more_monsters"
		},
		ui = {
			description = "loc_circumstance_assault_description",
			icon = "content/ui/materials/icons/circumstances/assault_01",
			display_name = "loc_circumstance_assault_title",
			favourable_to_players = true
		}
	}
}

return circumstance_templates
