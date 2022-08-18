local HordeCompositions = require("scripts/managers/pacing/horde_pacing/horde_compositions")
local mutator_templates = {
	mutator_chaos_hounds = {
		class = "scripts/managers/mutator/mutators/mutator_extra_trickle_hordes",
		description = {
			"loc_mutator_minion_nurgle_blessing_description_1",
			"loc_mutator_minion_nurgle_blessing_description_2",
			"loc_mutator_minion_nurgle_blessing_description_3"
		},
		trickle_horde_templates = {
			{
				num_trickle_hordes_active_for_cooldown = 20,
				optional_main_path_offset = 40,
				horde_compositions = {
					trickle_horde = {
						traitor_guards = {
							none = {
								HordeCompositions.mutator_chaos_hounds
							},
							low = {
								HordeCompositions.mutator_chaos_hounds
							},
							high = {
								HordeCompositions.mutator_chaos_hounds
							},
							poxwalkers = {
								HordeCompositions.mutator_chaos_hounds
							}
						},
						cultists = {
							none = {
								HordeCompositions.mutator_chaos_hounds
							},
							low = {
								HordeCompositions.mutator_chaos_hounds
							},
							high = {
								HordeCompositions.mutator_chaos_hounds
							},
							poxwalkers = {
								HordeCompositions.mutator_chaos_hounds
							}
						}
					}
				},
				trickle_horde_travel_distance_range = {
					30,
					45
				},
				trickle_horde_cooldown = {
					40,
					45
				}
			}
		}
	},
	mutator_snipers = {
		class = "scripts/managers/mutator/mutators/mutator_extra_trickle_hordes",
		description = {
			"loc_mutator_minion_nurgle_blessing_description_1",
			"loc_mutator_minion_nurgle_blessing_description_2",
			"loc_mutator_minion_nurgle_blessing_description_3"
		},
		trickle_horde_templates = {
			{
				num_trickle_hordes_active_for_cooldown = 20,
				optional_main_path_offset = 40,
				horde_compositions = {
					trickle_horde = {
						traitor_guards = {
							none = {
								HordeCompositions.mutator_snipers
							},
							low = {
								HordeCompositions.mutator_snipers
							},
							high = {
								HordeCompositions.mutator_snipers
							},
							poxwalkers = {
								HordeCompositions.mutator_snipers
							}
						},
						cultists = {
							none = {
								HordeCompositions.mutator_snipers
							},
							low = {
								HordeCompositions.mutator_snipers
							},
							high = {
								HordeCompositions.mutator_snipers
							},
							poxwalkers = {
								HordeCompositions.mutator_snipers
							}
						}
					}
				},
				trickle_horde_travel_distance_range = {
					30,
					45
				},
				trickle_horde_cooldown = {
					40,
					45
				}
			}
		}
	}
}

return mutator_templates
