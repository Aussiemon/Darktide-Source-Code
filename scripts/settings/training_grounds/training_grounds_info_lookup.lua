local TrainingGroundsObjectivesLookup = require("scripts/settings/training_grounds/training_grounds_objectives_lookup")
local step_info_lookup = {
	armor_types = {
		description = "loc_armor_desc",
		title = "loc_armor",
		objectives = {
			TrainingGroundsObjectivesLookup.armor_objective_2
		}
	},
	stagger = {
		description = "loc_stagger_desc",
		title = "loc_stagger",
		objectives = {
			TrainingGroundsObjectivesLookup.stagger_objective_1,
			TrainingGroundsObjectivesLookup.stargger_objective_2
		}
	},
	pushing = {
		description = "loc_pushing_desc",
		title = "loc_pushing",
		objectives = {
			TrainingGroundsObjectivesLookup.push
		}
	},
	push_follow_up = {
		description = "loc_push_follow_up_desc",
		title = "loc_push_follow_up",
		objectives = {
			TrainingGroundsObjectivesLookup.push_follow
		}
	},
	ranged_basic = {
		description = "loc_ranged_basic_gun_desc",
		title = "loc_ranged_basic_gun",
		objectives = {
			TrainingGroundsObjectivesLookup.basic_ranged_objective_1,
			TrainingGroundsObjectivesLookup.basic_ranged_objective_2
		}
	},
	ranged_warp_charge = {
		description = "loc_ranged_warp_charge_desc",
		title = "loc_ranged_warp_charge",
		objectives = {
			TrainingGroundsObjectivesLookup.ranged_warp_charge_objective_1,
			TrainingGroundsObjectivesLookup.ranged_warp_charge_objective_2,
			TrainingGroundsObjectivesLookup.ranged_warp_charge_objective_3
		}
	},
	ranged_suppression = {
		description = "loc_ranged_suppression_desc",
		title = "loc_ranged_suppression",
		objectives = {
			TrainingGroundsObjectivesLookup.suppression_objective_1
		}
	},
	incoming_suppression = {
		description = "loc_incoming_suppression_desc",
		title = "loc_incoming_suppression",
		objectives = {
			TrainingGroundsObjectivesLookup.incoming_suppression_objective_0
		}
	},
	grunt_blitz = {
		description = "loc_ability_frag_grenade_description",
		title = "loc_talents_category_tactical",
		objectives = {
			TrainingGroundsObjectivesLookup.grenade
		}
	},
	bonebreaker_blitz = {
		description = "loc_ability_ogryn_grenade_box_description",
		title = "loc_talents_category_tactical",
		objectives = {
			TrainingGroundsObjectivesLookup.bonebreaker_blitz
		}
	},
	maniac_blitz = {
		description = "loc_ability_shock_grenade_description",
		title = "loc_talents_category_tactical",
		objectives = {
			TrainingGroundsObjectivesLookup.maniac_blitz
		}
	},
	biomancer_blitz = {
		description = "loc_psyker_ability_desc",
		title = "loc_talents_category_tactical",
		objectives = {
			TrainingGroundsObjectivesLookup.biomancer_blitz
		}
	},
	ranged_grenade = {
		description = "loc_ranged_grenade_desc",
		title = "loc_talents_category_tactical",
		objectives = {
			TrainingGroundsObjectivesLookup.grenade
		}
	},
	tagging = {
		description = "loc_tagging_desc",
		title = "loc_tagging",
		objectives = {
			TrainingGroundsObjectivesLookup.tag_sniper,
			TrainingGroundsObjectivesLookup.tag_world
		}
	},
	dodge = {
		description = "loc_dodging_tutorial_desc",
		title = "loc_dodging_tutorial",
		objectives = {
			TrainingGroundsObjectivesLookup.dodge_left,
			TrainingGroundsObjectivesLookup.dodge_backward,
			TrainingGroundsObjectivesLookup.dodge_right
		}
	},
	sprint_slide = {
		description = "loc_sprint_slide_desc",
		title = "loc_sprint_slide",
		objectives = {
			TrainingGroundsObjectivesLookup.slide
		}
	},
	sprint_dodge = {
		description = "loc_sprint_slide_desc",
		title = "loc_sprint_slide",
		objectives = {
			TrainingGroundsObjectivesLookup.sprint
		}
	},
	lock_in_melee = {
		description = "loc_lock_in_melee_desc",
		title = "loc_lock_in_melee",
		objectives = {
			TrainingGroundsObjectivesLookup.lock_in_melee,
			TrainingGroundsObjectivesLookup.lock_in_melee_2
		}
	},
	toughness = {
		description = "loc_toughness_tutorial_desc",
		title = "loc_toughness_tutorial",
		objectives = {
			TrainingGroundsObjectivesLookup.toughness_melee,
			TrainingGroundsObjectivesLookup.toughness_coherency
		}
	},
	toughness_pre = {
		description = "loc_toughness_damage_tutorial_desc",
		title = "loc_toughness_damage_tutorial",
		objectives = {
			TrainingGroundsObjectivesLookup.toughness_pre_1,
			TrainingGroundsObjectivesLookup.toughness_pre_2,
			TrainingGroundsObjectivesLookup.toughness_pre_3
		}
	},
	combat_ability = {
		description = "loc_combat_ability_tutorial_desc",
		title = "loc_combat_ability_tutorial",
		objectives = {
			TrainingGroundsObjectivesLookup.combat_ability
		}
	},
	combat_ability_bone_breaker = {
		description = "loc_combat_ability_tutorial_ogryn_desc",
		title = "loc_combat_ability_tutorial",
		objectives = {
			TrainingGroundsObjectivesLookup.combat_ability_ogryn_1,
			TrainingGroundsObjectivesLookup.combat_ability_ogryn_2
		}
	},
	combat_ability_biomancer = {
		description = "loc_combat_ability_tutorial_psyker_desc",
		title = "loc_combat_ability_tutorial",
		objectives = {
			TrainingGroundsObjectivesLookup.combat_ability_psyker_3
		}
	},
	combat_ability_protectorate = {
		description = "loc_combat_ability_tutorial_psyker_3_desc",
		title = "loc_combat_ability_tutorial",
		objectives = {
			TrainingGroundsObjectivesLookup.combat_ability_psyker_3_1,
			TrainingGroundsObjectivesLookup.combat_ability_psyker_3_2
		}
	},
	combat_ability_maniac = {
		description = "loc_combat_ability_tutorial_zealot_desc",
		title = "loc_combat_ability_tutorial",
		objectives = {
			TrainingGroundsObjectivesLookup.combat_ability_zealot_1,
			TrainingGroundsObjectivesLookup.combat_ability_zealot_2
		}
	},
	weapon_special = {
		description = "loc_weapon_special_desc",
		title = "loc_weapon_special",
		objectives = {
			TrainingGroundsObjectivesLookup.weapon_special
		}
	},
	chain_attack = {
		description = "loc_chain_light_desc",
		title = "loc_chain_light",
		objectives = {
			TrainingGroundsObjectivesLookup.attack_chain,
			TrainingGroundsObjectivesLookup.attack_chain_2
		}
	},
	reviving = {
		description = "loc_reviving_tutorial_desc",
		title = "loc_reviving_tutorial",
		objectives = {
			TrainingGroundsObjectivesLookup.reviving
		}
	},
	corruption = {
		description = "loc_corruption_tutorial_desc",
		title = "loc_corruption_tutorial",
		objectives = {
			TrainingGroundsObjectivesLookup.corruption
		}
	},
	health_station = {
		description = "loc_health_station_tutorial_desc",
		title = "loc_health_station_tutorial",
		objectives = {
			TrainingGroundsObjectivesLookup.health_station_objective_1,
			TrainingGroundsObjectivesLookup.health_station_objective_2
		}
	},
	healing_self_and_others = {
		description = "loc_healing_self_and_others_desc",
		title = "loc_healing_self_and_others",
		objectives = {
			TrainingGroundsObjectivesLookup.healing_objective_1,
			TrainingGroundsObjectivesLookup.healing_objective_2,
			TrainingGroundsObjectivesLookup.healing_objective_3,
			TrainingGroundsObjectivesLookup.healing_objective_4
		}
	},
	end_of_tg = {
		description = "loc_training_grounds_training_end_desc",
		title = "loc_training_ground_view",
		objectives = {
			TrainingGroundsObjectivesLookup.end_of_tg_objective
		}
	}
}

return step_info_lookup
