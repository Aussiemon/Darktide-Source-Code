local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local special_rules = SpecialRulesSetting.special_rules
local archetype_talents = {
	archetype = "ogryn",
	specialization = "ogryn_2",
	talents = {
		ogryn_2_charge = {
			description = "loc_ability_ogryn_combat_ability_description",
			name = "F-Ability - Charge forward, knocking enemies back. Grants movement speed and attack speed afterwards",
			hud_icon = "content/ui/materials/icons/abilities/default",
			display_name = "loc_ability_ogryn_charge",
			icon_position = {
				8,
				4
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.ogryn_charge
			},
			passive = {
				buff_template_name = "ogryn_base_lunge_toughness_and_damage_resistance",
				identifier = "ogryn_base_combat_ability_pasive"
			}
		},
		ogryn_2_combat = {
			large_icon = "content/ui/materials/icons/talents/ogryn_2/ogryn_2_combat",
			name = "ogryn_bonebreaker_speed_on_lunge",
			display_name = "loc_talent_ogryn_2_combat",
			description = "loc_talent_ogryn_2_combat_description",
			icon_position = {
				8,
				4
			},
			passive = {
				buff_template_name = "ogryn_bonebreaker_speed_on_lunge",
				identifier = "combat_ability"
			}
		},
		ogryn_2_grenade = {
			description = "loc_ability_ogryn_grenade_description",
			name = "G-Ability - Ogryn Frag Grenade",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			display_name = "loc_ability_ogryn_grenade",
			icon = "content/ui/materials/icons/abilities/combat/default",
			icon_position = {
				8,
				6
			},
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.ogryn_grenade
			}
		},
		ogryn_2_base_1 = {
			description = "loc_talent_ogryn_2_base_1_description",
			name = "Passive - Increased heavy melee damage, gain more toughness on kills",
			display_name = "loc_talent_ogryn_2_base_1",
			icon = "content/ui/materials/icons/talents/ogryn_2/ogryn_2_base_1",
			icon_position = {
				7,
				7
			},
			passive = {
				buff_template_name = "ogryn_bonebreaker_passive",
				identifier = "ogryn_bonebreaker_passive"
			}
		},
		ogryn_2_base_2 = {
			description = "loc_talent_ogryn_2_base_2_description",
			name = "Passive - Increased revive and assist speed",
			hud_icon = "content/ui/materials/icons/abilities/default",
			display_name = "loc_talent_ogryn_2_base_2",
			icon = "content/ui/materials/icons/talents/ogryn_2/ogryn_2_base_2",
			icon_position = {
				8,
				7
			},
			passive = {
				buff_template_name = "ogryn_base_passive_revive",
				identifier = "ogryn_base_passive_revive"
			}
		},
		ogryn_2_base_3 = {
			description = "loc_talent_ogryn_2_base_3_description",
			name = "Passive - Decreased toughness damage take and damage taken",
			hud_icon = "content/ui/materials/icons/abilities/default",
			display_name = "loc_talent_ogryn_2_base_3",
			icon = "content/ui/materials/icons/talents/ogryn_2/ogryn_2_base_3",
			icon_position = {
				7,
				6
			},
			passive = {
				buff_template_name = "ogryn_base_passive_tank",
				identifier = "ogryn_base_passive_tank"
			}
		},
		ogryn_2_base_4 = {
			description = "loc_talent_ogryn_2_base_4_description",
			name = "Aura - Increased melee damage",
			display_name = "loc_talent_ogryn_2_base_4",
			icon = "content/ui/materials/icons/talents/ogryn_2/ogryn_2_base_4",
			icon_position = {
				10,
				6
			},
			coherency = {
				buff_template_name = "ogryn_bonebreaker_coherency_increased_melee_damage",
				identifier = "increased_melee_heavy_damage"
			}
		},
		ogryn_2_tier_1_name_1 = {
			description = "loc_talent_ogryn_2_tier_1_name_1_description",
			name = "Hitting multiple enemies with one attack grants damage bonus on next target hit",
			display_name = "loc_talent_ogryn_2_tier_1_name_1",
			icon = "content/ui/materials/icons/talents/ogryn_2/ogryn_2_tier_1_name_1",
			icon_position = {
				3,
				3
			},
			passive = {
				buff_template_name = "ogryn_bonebreaker_hitting_multiple_with_melee_grants_melee_damage_bonus",
				identifier = "mixed"
			}
		},
		ogryn_2_tier_1_name_2 = {
			description = "loc_talent_ogryn_2_tier_1_name_2_description",
			name = "Increased toughness replenishment when low on health",
			display_name = "loc_talent_ogryn_2_tier_1_name_2",
			icon = "content/ui/materials/icons/talents/ogryn_2/ogryn_2_tier_1_name_2",
			icon_position = {
				5,
				7
			},
			passive = {
				buff_template_name = "ogryn_bonebreaker_increased_toughness_at_low_health",
				identifier = "mixed"
			}
		},
		ogryn_2_tier_1_name_3 = {
			description = "loc_talent_ogryn_2_tier_1_name_3_description",
			name = "Allies in coherency gain movement speed when you use your Charge",
			display_name = "loc_talent_ogryn_2_tier_1_name_3",
			icon = "content/ui/materials/icons/talents/ogryn_2/ogryn_2_tier_1_name_3",
			icon_position = {
				6,
				8
			},
			passive = {
				buff_template_name = "ogryn_bonebreaker_charge_grants_allied_movement_speed",
				identifier = "mixed"
			}
		},
		ogryn_2_tier_2_name_1 = {
			description = "loc_talent_ogryn_2_tier_2_name_1_description",
			name = "You deal a lot more damage versus Ogryns, and take less damage from them",
			display_name = "loc_talent_ogryn_2_tier_2_name_1",
			icon = "content/ui/materials/icons/talents/ogryn_2/ogryn_2_tier_2_name_1",
			icon_position = {
				5,
				6
			},
			passive = {
				buff_template_name = "ogryn_bonebreaker_better_ogryn_fighting",
				identifier = "offensive"
			}
		},
		ogryn_2_tier_2_name_2 = {
			description = "loc_talent_ogryn_2_tier_2_name_2_description",
			name = "Increased damage versus armored and super armored enemies",
			display_name = "loc_talent_ogryn_2_tier_2_name_2",
			icon = "content/ui/materials/icons/talents/ogryn_2/ogryn_2_tier_2_name_2",
			icon_position = {
				3,
				4
			},
			passive = {
				buff_template_name = "ogryn_bonebreaker_armored_damage",
				identifier = "offensive"
			}
		},
		ogryn_2_tier_2_name_3 = {
			description = "loc_talent_ogryn_2_tier_2_name_3_description",
			name = "Killing an elite grants cooldown reduction of your ability",
			display_name = "loc_talent_ogryn_2_tier_2_name_3",
			icon = "content/ui/materials/icons/talents/ogryn_2/ogryn_2_tier_2_name_3",
			icon_position = {
				3,
				5
			},
			passive = {
				buff_template_name = "ogryn_bonebreaker_elite_kills_grant_cooldown_reduction",
				identifier = "offensive"
			}
		},
		ogryn_2_tier_3_name_1 = {
			description = "loc_talent_ogryn_2_tier_3_name_1_description",
			name = "Taking damage increase your stamina regeneration for a short duration",
			display_name = "loc_talent_ogryn_2_tier_3_name_1",
			icon = "content/ui/materials/icons/talents/ogryn_2/ogryn_2_tier_3_name_1",
			icon_position = {
				4,
				1
			},
			passive = {
				buff_template_name = "ogryn_bonebreaker_block_regen_on_damage_taken",
				identifier = "defensive"
			}
		},
		ogryn_2_tier_3_name_2 = {
			description = "loc_talent_ogryn_2_tier_3_name_2_description",
			name = "Sprinting costs less stamina",
			display_name = "loc_talent_ogryn_2_tier_3_name_2",
			icon = "content/ui/materials/icons/talents/ogryn_2/ogryn_2_tier_3_name_2",
			icon_position = {
				5,
				1
			},
			passive = {
				buff_template_name = "ogryn_bonebreaker_reduce_sprint_staminica_cost",
				identifier = "defensive"
			}
		},
		ogryn_2_tier_3_name_3 = {
			description = "loc_talent_ogryn_2_tier_3_name_3_description",
			name = "Hitting an enemy with a heavy attack reduces damage taken for a short duration",
			display_name = "loc_talent_ogryn_2_tier_3_name_3",
			icon = "content/ui/materials/icons/talents/ogryn_2/ogryn_2_tier_3_name_3",
			icon_position = {
				5,
				2
			},
			passive = {
				buff_template_name = "ogryn_bonebreaker_heavy_hits_damage_reduction",
				identifier = "defensive"
			}
		},
		ogryn_2_tier_4_name_1 = {
			description = "loc_talent_ogryn_2_tier_4_name_1_description",
			name = "Increased coherency radius",
			display_name = "loc_talent_ogryn_2_tier_4_name_1",
			icon = "content/ui/materials/icons/talents/ogryn_2/ogryn_2_tier_4_name_1",
			icon_position = {
				10,
				1
			},
			passive = {
				buff_template_name = "coherency_aura_size_increase",
				identifier = "coherency"
			}
		},
		ogryn_2_tier_4_name_2 = {
			description = "loc_talent_ogryn_2_tier_4_name_2_description",
			name = "Allies in coherency gain a moderate amount of toughness when you kill enemies with melee attacks",
			display_name = "loc_talent_ogryn_2_tier_4_name_2",
			icon = "content/ui/materials/icons/talents/ogryn_2/ogryn_2_tier_4_name_2",
			icon_position = {
				11,
				1
			},
			passive = {
				buff_template_name = "ogryn_bonebreaker_melee_kills_restore_ally_toughness",
				identifier = "coherency"
			}
		},
		ogryn_2_tier_4_name_3 = {
			description = "loc_talent_ogryn_2_tier_4_name_3_description",
			name = "Increased efficiency of your aura",
			display_name = "loc_talent_ogryn_2_tier_4_name_3",
			icon = "content/ui/materials/icons/talents/ogryn_2/ogryn_2_tier_4_name_3",
			icon_position = {
				11,
				2
			},
			coherency = {
				buff_template_name = "ogryn_bonebreaker_coherency_increased_melee_damage_improved",
				identifier = "increased_melee_heavy_damage"
			}
		},
		ogryn_2_tier_5_name_1 = {
			description = "loc_talent_ogryn_2_tier_5_name_1_description",
			name = "Fully charged heavy attacks gain double effect of your passive",
			display_name = "loc_talent_ogryn_2_tier_5_name_1",
			icon = "content/ui/materials/icons/talents/ogryn_2/ogryn_2_tier_5_name_1",
			icon_position = {
				12,
				3
			},
			passive = {
				buff_template_name = "ogryn_bonebreaker_fully_charged_damage",
				identifier = "specialization_passive"
			}
		},
		ogryn_2_tier_5_name_2 = {
			description = "loc_talent_ogryn_2_tier_5_name_2_description",
			name = "Fully charged heavy attacks have unlimited cleave",
			display_name = "loc_talent_ogryn_2_tier_5_name_2",
			icon = "content/ui/materials/icons/talents/ogryn_2/ogryn_2_tier_5_name_2",
			icon_position = {
				13,
				4
			},
			passive = {
				buff_template_name = "ogryn_bonebreaker_fully_charged_attacks_infinite_cleave",
				identifier = "specialization_passive"
			}
		},
		ogryn_2_tier_5_name_3 = {
			description = "loc_talent_ogryn_2_tier_5_name_3_description",
			name = "Heavy attacks restore toughness",
			display_name = "loc_talent_ogryn_2_tier_5_name_3",
			icon = "content/ui/materials/icons/talents/ogryn_2/ogryn_2_tier_5_name_3",
			icon_position = {
				12,
				5
			},
			passive = {
				buff_template_name = "ogryn_bonebreaker_heavy_hits_toughness",
				identifier = "specialization_passive"
			}
		},
		ogryn_2_tier_6_name_1 = {
			description = "loc_talent_ogryn_2_tier_6_name_1_description",
			name = "Deal damage to enemies hit during your charge, and increase the stagger",
			display_name = "loc_talent_ogryn_2_tier_6_name_1",
			icon = "content/ui/materials/icons/talents/ogryn_2/ogryn_2_tier_6_name_1",
			icon_position = {
				11,
				6
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.ogryn_charge_damage
			}
		},
		ogryn_2_tier_6_name_2 = {
			description = "loc_talent_ogryn_2_tier_6_name_2_description",
			name = "Increase the travel distance of your Charge",
			display_name = "loc_talent_ogryn_2_tier_6_name_2",
			icon = "content/ui/materials/icons/talents/ogryn_2/ogryn_2_tier_6_name_2",
			icon_position = {
				10,
				7
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.ogryn_charge_increased_distance
			}
		},
		ogryn_2_tier_6_name_3 = {
			description = "loc_talent_ogryn_2_tier_6_name_3_description",
			name = "Reduced cooldown of your Charge",
			display_name = "loc_talent_ogryn_2_tier_6_name_3",
			icon = "content/ui/materials/icons/talents/ogryn_2/ogryn_2_tier_6_name_3",
			icon_position = {
				10,
				8
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.ogryn_charge_cooldown_reduction
			}
		}
	}
}

return archetype_talents
