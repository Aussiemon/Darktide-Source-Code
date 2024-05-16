-- chunkname: @scripts/settings/circumstance/templates/toxic_gas_circumstance_template.lua

local mission_overrides = {
	pickup_settings = {
		rubberband_pool = {
			wounds = {
				syringe_corruption_pocketable = {
					10,
					10,
					10,
					10,
					10,
				},
			},
		},
		mid_event = {
			wounds = {
				syringe_corruption_pocketable = {
					1,
					1,
					1,
					1,
					1,
				},
			},
		},
		end_event = {
			wounds = {
				syringe_corruption_pocketable = {
					1,
					1,
					1,
					1,
					1,
				},
			},
		},
		primary = {
			wounds = {
				syringe_corruption_pocketable = {
					10,
					10,
					10,
					10,
					10,
				},
			},
		},
		secondary = {
			wounds = {
				syringe_corruption_pocketable = {
					10,
					10,
					10,
					10,
					10,
				},
			},
		},
	},
}
local circumstance_templates = {
	toxic_gas_volumes_01 = {
		dialogue_id = "circumstance_vo_toxic_gas",
		theme_tag = "toxic_gas",
		wwise_state = "ventilation_purge_01",
		mutators = {
			"mutator_toxic_gas_volumes",
		},
		ui = {
			description = "loc_circumstance_toxic_gas_description",
			display_name = "loc_circumstance_toxic_gas_title",
			happening_display_name = "loc_happening_ventilation_purge",
			icon = "content/ui/materials/icons/circumstances/nurgle_manifestation_01",
		},
		mission_overrides = mission_overrides,
	},
	toxic_gas_01 = {
		dialogue_id = "circumstance_vo_toxic_gas",
		theme_tag = "toxic_gas",
		wwise_state = "ventilation_purge_01",
		mutators = {
			"mutator_toxic_gas_volumes",
		},
		ui = {
			description = "loc_circumstance_toxic_gas_description",
			display_name = "loc_circumstance_toxic_gas_title",
			happening_display_name = "loc_happening_ventilation_purge",
			icon = "content/ui/materials/icons/circumstances/nurgle_manifestation_01",
		},
		mission_overrides = mission_overrides,
	},
	toxic_gas_less_resistance_01 = {
		dialogue_id = "circumstance_vo_toxic_gas",
		theme_tag = "toxic_gas",
		wwise_state = "ventilation_purge_01",
		mutators = {
			"mutator_toxic_gas_volumes",
			"mutator_subtract_resistance",
		},
		ui = {
			description = "loc_circumstance_toxic_gas_less_resistance_description",
			display_name = "loc_circumstance_toxic_gas_less_resistance_title",
			happening_display_name = "loc_happening_ventilation_purge",
			icon = "content/ui/materials/icons/circumstances/nurgle_manifestation_01",
		},
		mission_overrides = mission_overrides,
	},
	toxic_gas_more_resistance_01 = {
		dialogue_id = "circumstance_vo_toxic_gas",
		theme_tag = "toxic_gas",
		wwise_state = "ventilation_purge_01",
		mutators = {
			"mutator_toxic_gas_volumes",
			"mutator_add_resistance",
		},
		ui = {
			description = "loc_circumstance_toxic_gas_more_resistance_description",
			display_name = "loc_circumstance_toxic_gas_more_resistance_title",
			happening_display_name = "loc_happening_ventilation_purge",
			icon = "content/ui/materials/icons/circumstances/nurgle_manifestation_01",
		},
		mission_overrides = mission_overrides,
	},
	toxic_gas_twins_01 = {
		dialogue_id = "circumstance_vo_toxic_gas",
		wwise_state = "ventilation_purge_01",
		mutators = {
			"mutator_toxic_gas_twins",
			"mutator_no_hordes",
			"mutator_only_none_roamer_packs",
			"mutator_low_roamer_amount",
			"mutator_no_monsters",
			"mutator_no_witches",
			"mutator_no_boss_patrols",
			"mutator_only_traitor_guard_faction",
		},
	},
}

return circumstance_templates
