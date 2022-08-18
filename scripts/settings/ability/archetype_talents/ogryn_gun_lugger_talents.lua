local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local special_rules = SpecialRulesSetting.special_rules
local archetype_talents = {
	archetype = "ogryn",
	specialization = "ogryn_1",
	talents = {
		ogryn_1_combat = {
			large_icon = "content/ui/materials/icons/talents/ogryn_1/ogryn_1_combat",
			name = "F-Ability - Enter a stance that reloads ranged weapons, take less damage while firing and grants increased chance not to consume ammo",
			display_name = "loc_ability_ogryn_gun_lugger_specialization_default",
			description = "loc_ability_ogryn_gun_lugger_specialization_default_description",
			icon_position = {
				8,
				4
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.ogryn_ranged_stance
			},
			passive = {
				identifier = "ogryn_base_combat_ability_pasive"
			}
		},
		ogryn_1_grenade = {
			description = "loc_ability_ogryn_grenade_description",
			name = "G-Ability - Ogryn Frag Grenade",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			display_name = "loc_ability_ogryn_grenade",
			icon = "content/ui/materials/icons/abilities/combat/default",
			icon_position = {
				7,
				6
			},
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.ogryn_grenade
			}
		},
		ogryn_1_base_1 = {
			description = "loc_talent_ogryn_1_base_1_description",
			name = "Passive - Chance not to consume ammo",
			display_name = "loc_talent_ogryn_1_base_1",
			icon = "content/ui/materials/icons/talents/ogryn_1/ogryn_1_base_1",
			icon_position = {
				9,
				6
			},
			passive = {
				buff_template_name = "ogryn_gun_lugger_no_ammo_consumption_passive",
				identifier = "ogryn_gun_lugger_no_ammo_consumption_passive"
			}
		},
		ogryn_1_base_2 = {
			description = "loc_talent_ogryn_1_base_2_description",
			name = "Passive - Increased ammo reserve",
			display_name = "loc_talent_ogryn_1_base_2",
			icon = "content/ui/materials/icons/talents/ogryn_1/ogryn_1_base_2",
			icon_position = {
				9,
				6
			},
			passive = {
				buff_template_name = "ogryn_gun_lugger_ammo_passive",
				identifier = "ogryn_gun_lugger_ammo_passive"
			}
		},
		ogryn_1_base_3 = {
			description = "loc_talent_ogryn_1_base_3_description",
			name = "Passive - Decreased toughness damage take and damage taken",
			hud_icon = "content/ui/materials/icons/abilities/default",
			display_name = "loc_talent_ogryn_1_base_3",
			icon = "content/ui/materials/icons/talents/ogryn_1/ogryn_1_base_3",
			icon_position = {
				8,
				6
			},
			passive = {
				buff_template_name = "ogryn_base_passive_tank",
				identifier = "ogryn_base_passive_tank"
			}
		},
		ogryn_1_base_4 = {
			description = "loc_talent_ogryn_1_base_4_description",
			name = "Aura - Increased damage versus suppressed enemies",
			display_name = "loc_talent_ogryn_1_base_4",
			icon = "content/ui/materials/icons/talents/ogryn_1/ogryn_1_base_4",
			icon_position = {
				11,
				6
			},
			coherency = {
				buff_template_name = "ogryn_gun_lugger_vs_suppression_aura",
				identifier = "gun_lugger_suppression_aura"
			}
		},
		ogryn_1_tier_1_name_1 = {
			description = "loc_talent_ogryn_1_tier_1_name_1_description",
			name = "Increased damage versus horde enemies",
			display_name = "loc_talent_ogryn_1_tier_1_name_1",
			icon = "content/ui/materials/icons/talents/ogryn_1/ogryn_1_tier_1_name_1",
			icon_position = {
				9,
				1
			},
			passive = {
				buff_template_name = "ogryn_gun_lugger_increased_damage_vs_hordes",
				identifier = "gun_lugger_mixed"
			}
		},
		ogryn_1_tier_1_name_2 = {
			description = "loc_talent_ogryn_1_tier_1_name_2_description",
			name = "Ranged kills restore toughness",
			display_name = "loc_talent_ogryn_1_tier_1_name_2",
			icon = "content/ui/materials/icons/talents/ogryn_1/ogryn_1_tier_1_name_2",
			icon_position = {
				10,
				1
			},
			passive = {
				buff_template_name = "ogryn_gun_lugger_toughness_on_ranged_kill",
				identifier = "gun_lugger_mixed"
			}
		},
		ogryn_1_tier_1_name_3 = {
			description = "loc_talent_ogryn_1_tier_1_name_3_description",
			name = "50% increased clip size",
			display_name = "loc_talent_ogryn_1_tier_1_name_3",
			icon = "content/ui/materials/icons/talents/ogryn_1/ogryn_1_tier_1_name_3",
			icon_position = {
				10,
				2
			},
			passive = {
				buff_template_name = "ogryn_gun_lugger_clip_size",
				identifier = "gun_lugger_mixed"
			}
		},
		ogryn_1_tier_2_name_1 = {
			description = "loc_talent_ogryn_1_tier_2_name_1_description",
			name = "Crit chance on kills",
			display_name = "loc_talent_ogryn_1_tier_2_name_1",
			icon = "content/ui/materials/icons/talents/ogryn_1/ogryn_1_tier_1_name_1",
			icon_position = {
				9,
				1
			},
			passive = {
				buff_template_name = "ogryn_gun_lugger_crit_on_kills",
				identifier = "gun_lugger_offensive"
			}
		},
		ogryn_1_tier_2_name_2 = {
			description = "loc_talent_ogryn_1_tier_2_name_2_description",
			name = "Shooting the last round of a clip increases reload speed by 25% for 5 seconds.",
			display_name = "loc_talent_ogryn_1_tier_2_name_2",
			icon = "content/ui/materials/icons/talents/ogryn_1/ogryn_1_tier_2_name_2",
			icon_position = {
				5,
				1
			},
			passive = {
				buff_template_name = "ogryn_gun_lugger_reload_speed_on_final_shot",
				identifier = "gun_lugger_offensive"
			}
		},
		ogryn_1_tier_2_name_3 = {
			description = "loc_talent_ogryn_1_tier_2_name_3_description",
			name = "Increased suppression",
			display_name = "loc_talent_ogryn_1_tier_2_name_3",
			icon = "content/ui/materials/icons/talents/ogryn_1/ogryn_1_tier_2_name_3",
			icon_position = {
				5,
				2
			},
			passive = {
				buff_template_name = "ogryn_gun_lugger_increased_suppression",
				identifier = "gun_lugger_offensive"
			}
		},
		ogryn_1_tier_3_name_1 = {
			description = "loc_talent_ogryn_1_tier_3_name_1_description",
			name = "Suppressing enemies cause them to target you",
			display_name = "loc_talent_ogryn_1_tier_3_name_1",
			icon = "content/ui/materials/icons/talents/ogryn_1/ogryn_1_tier_3_name_1",
			icon_position = {
				13,
				2
			},
			passive = {
				buff_template_name = "ogryn_gun_lugger_suppressing_taunts_ranged_enemies",
				identifier = "ogryn_gun_lugger_defensive"
			}
		},
		ogryn_1_tier_3_name_2 = {
			description = "loc_talent_ogryn_1_tier_3_name_2_description",
			name = "20% Movement speed on ranged kills",
			display_name = "loc_talent_ogryn_1_tier_3_name_2",
			icon = "content/ui/materials/icons/talents/ogryn_1/ogryn_1_tier_3_name_2",
			icon_position = {
				13,
				3
			},
			passive = {
				buff_template_name = "ogryn_gun_lugger_movement_speed_on_ranged_kill",
				identifier = "ogryn_gun_lugger_defensive"
			}
		},
		ogryn_1_tier_3_name_3 = {
			description = "loc_talent_ogryn_1_tier_3_name_3_description",
			name = "Regenerate toughness while bracing",
			display_name = "loc_talent_ogryn_1_tier_3_name_3",
			icon = "content/ui/materials/icons/talents/ogryn_1/ogryn_1_tier_3_name_3",
			icon_position = {
				13,
				4
			},
			passive = {
				buff_template_name = "ogryn_gun_lugger_regen_toughness_on_braced",
				identifier = "ogryn_gun_lugger_defensive"
			}
		},
		ogryn_1_tier_4_name_1 = {
			description = "loc_talent_ogryn_1_tier_4_name_1_description",
			name = "Allies inside coherency also take 15% less ranged damage",
			display_name = "loc_talent_ogryn_1_tier_4_name_1",
			icon = "content/ui/materials/icons/talents/ogryn_1/ogryn_1_tier_4_name_1",
			icon_position = {
				3,
				2
			},
			coherency = {
				buff_template_name = "ogryn_gun_reduced_ranged_damage_aura",
				identifier = "gun_lugger_reduced_ranged_damage_aura"
			}
		},
		ogryn_1_tier_4_name_2 = {
			description = "loc_talent_ogryn_1_tier_4_name_2_description",
			name = "Increased efficiency of your aura",
			display_name = "loc_talent_ogryn_1_tier_4_name_2",
			icon = "content/ui/materials/icons/talents/ogryn_1/ogryn_1_tier_4_name_2",
			icon_position = {
				2,
				3
			},
			coherency = {
				buff_template_name = "ogryn_gun_lugger_vs_suppression_aura_improved",
				identifier = "gun_lugger_suppression_aura"
			}
		},
		ogryn_1_tier_4_name_3 = {
			description = "loc_talent_ogryn_1_tier_4_name_3_description",
			name = "Activating your ability grants all in coherency increased revive speed",
			display_name = "loc_talent_ogryn_1_tier_4_name_3",
			icon = "content/ui/materials/icons/talents/ogryn_1/ogryn_1_tier_4_name_3",
			icon_position = {
				3,
				4
			},
			special_rule = {
				identifier = "coherency",
				special_rule_name = special_rules.ogryn_gun_lugger_revive_speed_coherency
			}
		},
		ogryn_1_tier_5_name_1 = {
			description = "loc_talent_ogryn_1_tier_5_name_1_description",
			name = "Triggering your ammo consumption passive reduces the cooldown of your ability",
			display_name = "loc_talent_ogryn_1_tier_5_name_1",
			icon = "content/ui/materials/icons/talents/ogryn_1/ogryn_1_tier_5_name_1",
			icon_position = {
				5,
				4
			},
			special_rule = {
				identifier = "passive_ability_improvement",
				special_rule_name = special_rules.ogryn_gun_lugger_passive_proc_combat_ability_cooldown_reduction
			}
		},
		ogryn_1_tier_5_name_2 = {
			description = "loc_talent_ogryn_1_tier_5_name_2_description",
			name = "Increased the chance not to consume ammo",
			display_name = "loc_talent_ogryn_1_tier_5_name_2",
			icon = "content/ui/materials/icons/talents/ogryn_1/ogryn_1_tier_5_name_2",
			icon_position = {
				4,
				5
			},
			passive = {
				buff_template_name = "ogryn_gun_lugger_passive_improved",
				identifier = "ogryn_gun_lugger_passive"
			}
		},
		ogryn_1_tier_5_name_3 = {
			description = "loc_talent_ogryn_1_tier_5_name_3_description",
			name = "Your shots that dont consume ammo now crit",
			display_name = "loc_talent_ogryn_1_tier_5_name_3",
			icon = "content/ui/materials/icons/talents/ogryn_1/ogryn_1_tier_5_name_3",
			icon_position = {
				5,
				5
			},
			special_rule = {
				identifier = "passive_ability_improvement",
				special_rule_name = special_rules.ogryn_gun_lugger_passive_crit
			}
		},
		ogryn_1_tier_6_name_1 = {
			description = "loc_talent_ogryn_1_tier_6_name_1_description",
			name = "CONTACT reduces Ranged Damage taken by 95% for 5 seconds",
			display_name = "loc_talent_ogryn_1_tier_6_name_1",
			icon = "content/ui/materials/icons/talents/ogryn_1/ogryn_1_tier_6_name_1",
			icon_position = {
				11,
				4
			},
			special_rule = {
				identifier = "combat_ability_improvement",
				special_rule_name = special_rules.ogryn_gun_lugger_combat_reduced_ranged_damage
			}
		},
		ogryn_1_tier_6_name_2 = {
			description = "loc_talent_ogryn_1_tier_6_name_2_description",
			name = "Grants an additional charge of your ability",
			display_name = "loc_talent_ogryn_1_tier_6_name_2",
			icon = "content/ui/materials/icons/talents/ogryn_1/ogryn_1_tier_6_name_2",
			icon_position = {
				10,
				5
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.ogryn_ranged_stance_double_charge
			}
		},
		ogryn_1_tier_6_name_3 = {
			description = "loc_talent_ogryn_1_tier_6_name_3_description",
			name = "CONTACT removes the movement penalty of Weponry and increases Ranged Damage vs Close enemies",
			display_name = "loc_talent_ogryn_1_tier_6_name_3",
			icon = "content/ui/materials/icons/talents/ogryn_1/ogryn_1_tier_6_name_3",
			icon_position = {
				11,
				5
			},
			special_rule = {
				identifier = "combat_ability_improvement",
				special_rule_name = special_rules.ogryn_gun_lugger_combat_no_movement_penalty
			}
		}
	}
}

return archetype_talents
