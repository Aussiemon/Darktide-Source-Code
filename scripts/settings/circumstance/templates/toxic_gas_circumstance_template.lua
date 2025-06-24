-- chunkname: @scripts/settings/circumstance/templates/toxic_gas_circumstance_template.lua

local MissionOverrides = require("scripts/settings/circumstance/mission_overrides")
local circumstance_templates = {
	toxic_gas_01 = {
		dialogue_id = "circumstance_vo_toxic_gas",
		theme_tag = "toxic_gas",
		wwise_state = "ventilation_purge_01",
		mutators = {
			"mutator_toxic_gas_volumes",
		},
		ui = {
			background = "content/ui/materials/backgrounds/mutators/mutator_toxic_gas",
			description = "loc_circumstance_toxic_gas_description",
			display_name = "loc_circumstance_toxic_gas_title",
			happening_display_name = "loc_happening_ventilation_purge",
			icon = "content/ui/materials/icons/circumstances/nurgle_manifestation_01",
			mission_board_icon = "content/ui/materials/mission_board/circumstances/nurgle_manifestation_01",
		},
		mission_overrides = MissionOverrides.more_corruption_syringes,
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
			mission_board_icon = "content/ui/materials/mission_board/circumstances/nurgle_manifestation_01",
		},
		mission_overrides = MissionOverrides.more_corruption_syringes,
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
			mission_board_icon = "content/ui/materials/mission_board/circumstances/nurgle_manifestation_01",
		},
		mission_overrides = MissionOverrides.more_corruption_syringes,
	},
	toxic_gas_cultist_grenadier = {
		dialogue_id = "circumstance_vo_toxic_gas",
		theme_tag = "toxic_gas",
		wwise_state = "ventilation_purge_01",
		mutators = {
			"mutator_toxic_gas_volumes",
			"mutator_cultist_grenadier",
		},
		ui = {
			background = "content/ui/materials/backgrounds/mutators/mutator_toxic_gas",
			description = "loc_circumstance_toxic_gas_cultist_grenadier_description",
			display_name = "loc_circumstance_toxic_gas_cultist_grenadier_title",
			happening_display_name = "loc_happening_ventilation_purge",
			icon = "content/ui/materials/icons/circumstances/nurgle_manifestation_01",
			mission_board_icon = "content/ui/materials/mission_board/circumstances/nurgle_manifestation_01",
		},
		mission_overrides = MissionOverrides.more_corruption_syringes,
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
