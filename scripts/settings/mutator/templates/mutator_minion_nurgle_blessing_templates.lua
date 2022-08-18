local mutator_templates = {
	mutator_minion_nurgle_blessing = {
		class = "scripts/managers/mutator/mutators/mutator_minion_nurgle_blessing",
		description = {
			"loc_mutator_minion_nurgle_blessing_description_1",
			"loc_mutator_minion_nurgle_blessing_description_2",
			"loc_mutator_minion_nurgle_blessing_description_3"
		},
		buff_templates = {
			"mutator_minion_nurgle_blessing_tougher",
			"mutator_minion_nurgle_blessing_heal_over_time"
		}
	}
}

return mutator_templates
