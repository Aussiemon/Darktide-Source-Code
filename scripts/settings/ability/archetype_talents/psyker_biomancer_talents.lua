local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local archetype_talents = {
	archetype = "psyker",
	specialization = "psyker_2",
	talents = {
		psyker_2_combat = {
			large_icon = "content/ui/materials/icons/talents/psyker_2/psyker_2_combat",
			name = "F-Ability - Shout, knocking down enemies in front of you in a cone, and remove all accumilated warp charge",
			display_name = "loc_talent_psyker_2_combat",
			description = "loc_talent_psyker_2_combat_description",
			icon_position = {
				8,
				4
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.psyker_discharge_shout
			},
			special_rule = {
				special_rule_name = "shout_drains_warp_charge",
				identifier = "shout_drains_warp_charge"
			}
		},
		psyker_2_smite = {
			description = "loc_ability_psyker_smite_description",
			name = "G-Ability - Target enemies to charge a Smite attack, dealing a high amount of damage",
			hud_icon = "content/ui/materials/icons/abilities/default",
			display_name = "loc_ability_psyker_smite",
			icon = "content/ui/materials/icons/abilities/combat/default",
			icon_position = {
				9,
				5
			},
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.psyker_smite
			}
		},
		psyker_2_base_1 = {
			description = "loc_talent_psyker_biomancy_passive_1_description",
			name = "Passive - Smite kills stores the soul of your enemy, increasing smite damage. Lasts for 20 seconds, stacking up to 4",
			display_name = "loc_talent_psyker_2_base_1",
			icon = "content/ui/materials/icons/talents/psyker_2/psyker_2_base_1",
			icon_position = {
				10,
				6
			},
			passive = {
				buff_template_name = "psyker_biomancer_passive",
				identifier = "psyker_biomancer_passive"
			}
		},
		psyker_2_base_2 = {
			description = "loc_talent_psyker_biomancy_passive_2_description",
			name = "Passive - Reduced warp charge generated",
			display_name = "loc_talent_psyker_2_base_2",
			icon = "content/ui/materials/icons/talents/psyker_2/psyker_2_base_2",
			icon_position = {
				10,
				5
			},
			passive = {
				buff_template_name = "psyker_biomancer_base_passive",
				identifier = "psyker_biomancer_base_passive"
			}
		},
		psyker_2_base_3 = {
			description = "loc_talent_psyker_biomancy_passive_3_description",
			name = "Aura - Increased damage versus elites and specials",
			display_name = "loc_talent_psyker_2_base_3",
			icon = "content/ui/materials/icons/talents/psyker_2/psyker_2_base_3",
			icon_position = {
				11,
				6
			},
			coherency = {
				buff_template_name = "psyker_biomancer_coherency_damage_vs_elites",
				identifier = "damage_vs_elite"
			}
		},
		psyker_2_tier_1_name_1 = {
			description = "loc_talent_psyker_biomancy_tier_1_ability_1_description",
			name = "Killing an enemy with your smite ability replenishes toughness over a short time, stacking up to 3 times",
			display_name = "loc_talent_psyker_2_tier_1_name_1",
			icon = "content/ui/materials/icons/talents/psyker_2/psyker_2_tier_1_name_1",
			icon_position = {
				8,
				8
			},
			passive = {
				buff_template_name = "psyker_biomancer_smite_kills_replenish_toughness_stacking",
				identifier = "mixed"
			}
		},
		psyker_2_tier_1_name_2 = {
			description = "loc_talent_psyker_biomancy_tier_1_ability_2_description",
			name = "All kills have an 8 percent chance to generate a soul",
			display_name = "loc_talent_psyker_2_tier_1_name_2",
			icon = "content/ui/materials/icons/talents/psyker_2/psyker_2_tier_1_name_2",
			icon_position = {
				7,
				7
			},
			special_rule = {
				special_rule_name = "psyker_biomancer_all_kills_can_generate_souls",
				identifier = "psyker_biomancer_all_kills_can_generate_souls"
			}
		},
		psyker_2_tier_1_name_3 = {
			description = "loc_talent_psyker_biomancy_tier_1_ability_3_description",
			name = "Gain increased non-warp damage the higher your warp charge",
			display_name = "loc_talent_psyker_2_tier_1_name_3",
			icon = "content/ui/materials/icons/talents/psyker_2/psyker_2_tier_1_name_3",
			icon_position = {
				8,
				7
			},
			passive = {
				buff_template_name = "psyker_biomancer_warp_charge_increase_non_warp_damage",
				identifier = "mixed"
			}
		},
		psyker_2_tier_2_name_1 = {
			description = "loc_talent_psyker_biomancy_tier_2_ability_1_description",
			name = "Melee kills have a chance to reduce warp charge",
			display_name = "loc_talent_psyker_2_tier_2_name_1",
			icon = "content/ui/materials/icons/talents/psyker_2/psyker_2_tier_2_name_1",
			icon_position = {
				5,
				5
			},
			passive = {
				buff_template_name = "psyker_biomancer_melee_kills_reduce_warp_charge",
				identifier = "offensive"
			}
		},
		psyker_2_tier_2_name_2 = {
			description = "loc_talent_psyker_biomancy_tier_2_ability_2_description",
			name = "Each soul stored increases damage",
			display_name = "loc_talent_psyker_2_tier_2_name_2",
			icon = "content/ui/materials/icons/talents/psyker_2/psyker_2_tier_2_name_2",
			icon_position = {
				5,
				6
			},
			passive = {
				buff_template_name = "psyker_biomancer_damage_per_soul",
				identifier = "offensive"
			}
		},
		psyker_2_tier_2_name_3 = {
			description = "loc_talent_psyker_biomancy_tier_2_ability_3_description",
			name = "Your shout ability deals damage based on your warp charge",
			display_name = "loc_talent_psyker_2_tier_2_name_3",
			icon = "content/ui/materials/icons/talents/psyker_2/psyker_2_tier_2_name_3",
			icon_position = {
				6,
				6
			},
			passive = {
				buff_template_name = "psyker_biomancer_warp_charge_shout",
				identifier = "offensive"
			},
			special_rule = {
				special_rule_name = "psyker_biomancer_discharge_damage_per_warp_charge",
				identifier = "psyker_biomancer_discharge_damage_per_warp_charge"
			}
		},
		psyker_2_tier_3_name_1 = {
			description = "loc_talent_psyker_biomancy_tier_3_ability_1_description",
			name = "Reduces movement speed reduction when venting",
			display_name = "loc_talent_psyker_2_tier_3_name_1",
			icon = "content/ui/materials/icons/talents/psyker_2/psyker_2_tier_3_name_1",
			icon_position = {
				2,
				4
			},
			passive = {
				buff_template_name = "psyker_biomancer_venting_improvements",
				identifier = "defensive"
			}
		},
		psyker_2_tier_3_name_2 = {
			description = "loc_talent_psyker_biomancy_tier_3_ability_3_description",
			name = "Increased toughness regeneration for each soul stored",
			display_name = "loc_talent_psyker_2_tier_3_name_2",
			icon = "content/ui/materials/icons/talents/psyker_2/psyker_2_tier_3_name_2",
			icon_position = {
				3,
				4
			},
			special_rule = {
				special_rule_name = "psyker_biomancer_toughness_regen_soul",
				identifier = "psyker_biomancer_toughness_regen_soul"
			}
		},
		psyker_2_tier_3_name_3 = {
			description = "loc_talent_psyker_biomancy_tier_3_ability_2_description",
			name = "Increased passive warp charge dissipation",
			display_name = "loc_talent_psyker_2_tier_3_name_3",
			icon = "content/ui/materials/icons/talents/psyker_2/psyker_2_tier_3_name_3",
			icon_position = {
				4,
				4
			},
			passive = {
				buff_template_name = "psyker_biomancer_increase_passive_warp_charge_dissipation",
				identifier = "defensive"
			}
		},
		psyker_2_tier_4_name_1 = {
			description = "loc_talent_psyker_biomancy_tier_4_ability_1_description",
			name = "Killing an elite restores combat ability cooldown for all allies in coherency",
			display_name = "loc_talent_psyker_2_tier_4_name_1",
			icon = "content/ui/materials/icons/talents/psyker_2/psyker_2_tier_4_name_1",
			icon_position = {
				4,
				1
			},
			passive = {
				buff_template_name = "psyker_biomancer_cooldown_reduction_on_elite_kill_for_coherency",
				identifier = "coherency"
			}
		},
		psyker_2_tier_4_name_2 = {
			description = "loc_talent_psyker_biomancy_tier_4_ability_2_description",
			name = "Increased efficiency of your aura",
			display_name = "loc_talent_psyker_2_tier_4_name_2",
			icon = "content/ui/materials/icons/talents/psyker_2/psyker_2_tier_4_name_2",
			icon_position = {
				5,
				2
			},
			coherency = {
				buff_template_name = "psyker_biomancer_coherency_damage_vs_elites_improved",
				identifier = "damage_vs_elite"
			}
		},
		psyker_2_tier_4_name_3 = {
			description = "loc_talent_psyker_biomancy_tier_4_ability_3_description",
			name = "Damaging an enemy with your smite ability debuffs them, increasing damage taken from all sources",
			display_name = "loc_talent_psyker_2_tier_4_name_3",
			icon = "content/ui/materials/icons/talents/psyker_2/psyker_2_tier_4_name_3",
			icon_position = {
				5,
				3
			},
			passive = {
				buff_template_name = "psyker_biomancer_smite_makes_victim_vulnerable",
				identifier = "coop"
			}
		},
		psyker_2_tier_5_name_1 = {
			description = "loc_talent_psyker_biomancy_tier_5_ability_1_description",
			name = "Increased max number of souls stored from 4 to 5",
			display_name = "loc_talent_psyker_2_tier_5_name_1",
			icon = "content/ui/materials/icons/talents/psyker_2/psyker_2_tier_5_name_1",
			icon_position = {
				11,
				1
			},
			special_rule = {
				special_rule_name = "psyker_biomancer_increased_max_souls",
				identifier = "psyker_biomancer_increased_max_souls"
			}
		},
		psyker_2_tier_5_name_2 = {
			description = "loc_talent_psyker_biomancy_tier_5_ability_2_description",
			name = "Reduce warp charge generation and warp charge from venting, per soul stored",
			display_name = "loc_talent_psyker_2_tier_5_name_2",
			icon = "content/ui/materials/icons/talents/psyker_2/psyker_2_tier_5_name_2",
			icon_position = {
				11,
				2
			},
			passive = {
				buff_template_name = "psyker_biomancer_souls_increase_warp_charge_decrease_venting",
				identifier = "specialization_passive"
			}
		},
		psyker_2_tier_5_name_3 = {
			description = "loc_talent_psyker_biomancy_tier_5_ability_3_description",
			name = "Increase the duration souls are stored to 60 seconds",
			display_name = "loc_talent_psyker_2_tier_5_name_3",
			icon = "content/ui/materials/icons/talents/psyker_2/psyker_2_tier_5_name_3",
			icon_position = {
				10,
				3
			},
			special_rule = {
				special_rule_name = "psyker_biomancer_increased_souls_duration",
				identifier = "psyker_biomancer_increased_souls_duration"
			}
		},
		psyker_2_tier_6_name_1 = {
			description = "loc_talent_psyker_biomancy_tier_6_ability_1_description",
			name = "Souls are consumed when you use your combat ability, but restores cooldown based on number of souls",
			display_name = "loc_talent_psyker_2_tier_6_name_1",
			icon = "content/ui/materials/icons/talents/psyker_2/psyker_2_tier_6_name_1",
			icon_position = {
				12,
				4
			},
			special_rule = {
				special_rule_name = "psyker_biomancer_restore_cooldown_per_soul",
				identifier = "psyker_biomancer_restore_cooldown_per_soul"
			}
		},
		psyker_2_tier_6_name_2 = {
			description = "loc_talent_psyker_biomancy_tier_6_ability_2_description",
			name = "Souls are consumed when you use your combat ability, but apply warpfire to enemies hit based on number of souls",
			display_name = "loc_talent_psyker_2_tier_6_name_2",
			icon = "content/ui/materials/icons/talents/psyker_2/psyker_2_tier_6_name_2",
			icon_position = {
				13,
				4
			},
			special_rule = {
				special_rule_name = "psyker_biomancer_discharge_applies_warpfire",
				identifier = "combat_ability"
			}
		},
		psyker_2_tier_6_name_3 = {
			description = "loc_talent_psyker_biomancy_tier_6_ability_3_description",
			name = "For 10 seconds after using your combat abilty, your Smite ability casts faster and costs less warp charge",
			display_name = "loc_talent_psyker_2_tier_6_name_3",
			icon = "content/ui/materials/icons/talents/psyker_2/psyker_2_tier_6_name_3",
			icon_position = {
				14,
				4
			},
			special_rule = {
				special_rule_name = "psyker_biomancer_efficient_smites",
				identifier = "combat_ability"
			}
		}
	}
}

return archetype_talents
