local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local special_rules = SpecialRulesSetting.special_rules
local archetype_talents = {
	archetype = "veteran",
	specialization = "veteran_2",
	talents = {
		veteran_2_combat = {
			large_icon = "content/ui/materials/icons/talents/veteran_2/veteran_2_combat",
			name = "F-Ability - Mark elite and special enemies, gain a lot of ranged damage",
			display_name = "loc_talents_veteran_2_combat_ability",
			description = "loc_talents_veteran_2_combat_ability_description",
			icon_position = {
				8,
				4
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.veteran_ranger_ranged_stance
			}
		},
		veteran_2_frag_grenade = {
			description = "loc_ability_frag_grenade_description",
			name = "G-Ability - Frag Grenade",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			display_name = "loc_ability_frag_grenade",
			icon = "content/ui/materials/icons/abilities/combat/default",
			icon_position = {
				9,
				5
			},
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.veteran_ranger_frag_grenade
			}
		},
		veteran_2_base_1 = {
			description = "loc_talents_veteran_ranger_passive_make_every_bullet_count_description",
			name = "Passive - Increased weakspot Damage",
			display_name = "loc_talents_veteran_ranger_passive_make_every_bullet_count",
			icon = "content/ui/materials/icons/talents/veteran_2/veteran_2_base_1",
			icon_position = {
				10,
				5
			},
			passive = {
				buff_template_name = "veteran_ranger_increase_weakspot_damage",
				identifier = "veteran_base_passive_1"
			}
		},
		veteran_2_base_2 = {
			description = "loc_talents_veteran_ranger_increased_ammo_reserve_description",
			name = "Passive - Increased ammo reserve",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			display_name = "loc_talents_veteran_ranger_increased_ammo_reserve",
			icon = "content/ui/materials/icons/talents/veteran_2/veteran_2_base_2",
			icon_position = {
				10,
				6
			},
			passive = {
				buff_template_name = "veteran_ranger_increased_ammo_reserve",
				identifier = "veteran_base_passive"
			}
		},
		veteran_2_base_3 = {
			description = "loc_talents_veteran_ranger_passive_free_ammo_chance_description",
			name = "Aura - Chance not to consume ammo on shot",
			display_name = "loc_talents_veteran_ranger_passive_free_ammo_chance",
			icon = "content/ui/materials/icons/talents/veteran_2/veteran_2_base_3",
			icon_position = {
				11,
				6
			},
			coherency = {
				buff_template_name = "veteran_ranger_free_ammo_chance",
				identifier = "no_ammo_chance"
			}
		},
		veteran_2_tier_1_name_1 = {
			description = "loc_talent_veteran_2_tier_1_name_1_description",
			name = "Deal increased damage to enemies not in combat",
			display_name = "loc_talent_veteran_2_tier_1_name_1",
			icon = "content/ui/materials/icons/talents/veteran_2/veteran_2_tier_1_name_1",
			icon_position = {
				8,
				8
			},
			passive = {
				buff_template_name = "veteran_ranger_increase_damage_to_unaggroed_enemies",
				identifier = "mixed"
			}
		},
		veteran_2_tier_1_name_2 = {
			description = "loc_talent_veteran_2_tier_1_name_2_description",
			name = "You replenish 1 grenade every 45 seconds",
			display_name = "loc_talent_veteran_2_tier_1_name_2",
			icon = "content/ui/materials/icons/talents/veteran_2/veteran_2_tier_1_name_2",
			icon_position = {
				7,
				7
			},
			passive = {
				buff_template_name = "veteran_ranger_grenade_replenishment",
				identifier = "mixed"
			}
		},
		veteran_2_tier_1_name_3 = {
			description = "loc_talent_veteran_2_tier_1_name_3_description",
			name = "Enemies are less likely to target you",
			display_name = "loc_talent_veteran_2_tier_1_name_3",
			icon = "content/ui/materials/icons/talents/veteran_2/veteran_2_tier_1_name_3",
			icon_position = {
				8,
				7
			},
			passive = {
				buff_template_name = "veteran_ranger_reduced_threat_gain",
				identifier = "mixed"
			}
		},
		veteran_2_tier_2_name_1 = {
			description = "loc_talent_veteran_2_tier_2_name_1_description",
			name = "Deal more damage to far distance enemies",
			display_name = "loc_talent_veteran_2_tier_2_name_1",
			icon = "content/ui/materials/icons/talents/veteran_2/veteran_2_tier_2_name_1",
			icon_position = {
				5,
				5
			},
			passive = {
				buff_template_name = "veteran_ranger_increase_ranged_far_damage",
				identifier = "offensive"
			}
		},
		veteran_2_tier_2_name_2 = {
			description = "loc_talent_veteran_2_tier_2_name_2_description",
			name = "Increased reload speed of non-empty magazines",
			display_name = "loc_talent_veteran_2_tier_2_name_2",
			icon = "content/ui/materials/icons/talents/veteran_2/veteran_2_tier_2_name_2",
			icon_position = {
				5,
				6
			},
			passive = {
				buff_template_name = "veteran_ranger_tactical_reload_speed",
				identifier = "offensive"
			}
		},
		veteran_2_tier_2_name_3 = {
			description = "loc_talent_veteran_2_tier_2_name_3_description",
			name = "Increased ranged damage",
			display_name = "loc_talent_veteran_2_tier_2_name_3",
			icon = "content/ui/materials/icons/talents/veteran_2/veteran_2_tier_2_name_3",
			icon_position = {
				6,
				6
			},
			passive = {
				buff_template_name = "veteran_ranger_increase_ranged_damage",
				identifier = "offensive"
			}
		},
		veteran_2_tier_3_name_1 = {
			description = "loc_talent_veteran_2_tier_3_name_1_description",
			name = "Regenerate toughness on weakspot kills",
			display_name = "loc_talent_veteran_2_tier_3_name_1",
			icon = "content/ui/materials/icons/talents/veteran_2/veteran_2_tier_3_name_1",
			icon_position = {
				2,
				4
			},
			passive = {
				buff_template_name = "veteran_ranger_ranged_weakspot_toughness_gain",
				identifier = "defensive"
			}
		},
		veteran_2_tier_3_name_2 = {
			description = "loc_talent_veteran_2_tier_3_name_2_description",
			name = "Increased mobility while aiming down sights",
			display_name = "loc_talent_veteran_2_tier_3_name_2",
			icon = "content/ui/materials/icons/talents/veteran_2/veteran_2_tier_3_name_2",
			icon_position = {
				3,
				4
			},
			passive = {
				buff_template_name = "veteran_ranger_mobility_while_aiming_down_sights",
				identifier = "defensive"
			}
		},
		veteran_2_tier_3_name_3 = {
			description = "loc_talent_veteran_2_tier_3_name_3_description",
			name = "Decrease chance of being hit by far ranged attacks",
			display_name = "loc_talent_veteran_2_tier_3_name_3",
			icon = "content/ui/materials/icons/talents/veteran_2/veteran_2_tier_3_name_3",
			icon_position = {
				4,
				4
			},
			passive = {
				buff_template_name = "veteran_ranger_improved_ranged_dodge",
				identifier = "defensive"
			}
		},
		veteran_2_tier_4_name_1 = {
			description = "loc_talent_veteran_2_tier_4_name_1_description",
			name = "Allies in coherency also gain outlines for half the duration",
			display_name = "loc_talent_veteran_2_tier_4_name_1",
			icon = "content/ui/materials/icons/talents/veteran_2/veteran_2_tier_4_name_1",
			icon_position = {
				4,
				1
			},
			special_rule = {
				identifier = "coherency_outline",
				special_rule_name = special_rules.veteran_ranger_combat_ability_outlines_for_coherency
			}
		},
		veteran_2_tier_4_name_2 = {
			description = "loc_talent_veteran_2_tier_4_name_2_description",
			name = "Increase the efficiency of your aura",
			display_name = "loc_talent_veteran_2_tier_4_name_2",
			icon = "content/ui/materials/icons/talents/veteran_2/veteran_2_tier_4_name_2",
			icon_position = {
				5,
				2
			},
			coherency = {
				buff_template_name = "veteran_ranger_free_ammo_chance_improved",
				identifier = "no_ammo_chance"
			}
		},
		veteran_2_tier_4_name_3 = {
			description = "loc_talents_veteran_ranger_toughness_regen_description",
			name = "Increase toughness regeneration",
			display_name = "loc_talent_veteran_2_tier_4_name_3",
			icon = "content/ui/materials/icons/talents/veteran_2/veteran_2_tier_4_name_3",
			icon_position = {
				5,
				3
			},
			passive = {
				buff_template_name = "veteran_ranger_toughness_regen",
				identifier = "toughness_regen"
			}
		},
		veteran_2_tier_5_name_1 = {
			description = "loc_talent_veteran_2_tier_5_name_1_description",
			name = "Increased weakspot damage",
			display_name = "loc_talent_veteran_2_tier_5_name_1",
			icon = "content/ui/materials/icons/talents/veteran_2/veteran_2_tier_5_name_1",
			icon_position = {
				11,
				1
			},
			passive = {
				buff_template_name = "veteran_ranger_increase_weakspot_damage_improved",
				identifier = "veteran_base_passive_1"
			}
		},
		veteran_2_tier_5_name_2 = {
			description = "loc_talent_veteran_2_tier_5_name_2_description",
			name = "Increased armor penetration on weakspot hits",
			display_name = "loc_talent_veteran_2_tier_5_name_2",
			icon = "content/ui/materials/icons/talents/veteran_2/veteran_2_tier_5_name_2",
			icon_position = {
				11,
				2
			},
			passive = {
				buff_template_name = "veteran_ranger_armor_penetreation_on_weakspot",
				identifier = "weakspot_armor_pen"
			}
		},
		veteran_2_tier_5_name_3 = {
			description = "loc_talent_veteran_2_tier_5_name_3_description",
			name = "Weakspot hits have a chance to restore the ammo used",
			display_name = "loc_talent_veteran_2_tier_5_name_3",
			icon = "content/ui/materials/icons/talents/veteran_2/veteran_2_tier_5_name_3",
			icon_position = {
				10,
				3
			},
			passive = {
				buff_template_name = "veteran_ranger_chance_of_ammo_on_weakspot",
				identifier = "ammo_restore_on_crit"
			}
		},
		veteran_2_tier_6_name_1 = {
			description = "loc_talent_veteran_2_tier_6_name_1_description",
			name = "Increased weakspot damage during combat ability",
			display_name = "loc_talent_veteran_2_tier_6_name_1",
			icon = "content/ui/materials/icons/talents/veteran_2/veteran_2_tier_6_name_1",
			icon_position = {
				12,
				4
			},
			special_rule = {
				identifier = "veteran_ranger_combat_ability",
				special_rule_name = special_rules.veteran_ranger_combat_ability_increased_weakspot_damage
			}
		},
		veteran_2_tier_6_name_2 = {
			description = "loc_talent_veteran_2_tier_6_name_2_description",
			name = "Your combat ability reloads your weapon automatically",
			display_name = "loc_talent_veteran_2_tier_6_name_2",
			icon = "content/ui/materials/icons/talents/veteran_2/veteran_2_tier_6_name_2",
			icon_position = {
				13,
				4
			},
			special_rule = {
				identifier = "veteran_ranger_combat_ability",
				special_rule_name = special_rules.veteran_ranger_combat_ability_reloads_weapon
			}
		},
		veteran_2_tier_6_name_3 = {
			description = "loc_talent_veteran_2_tier_6_name_3_description",
			name = "Killing a marked target refreshses the duration of combat ability",
			display_name = "loc_talent_veteran_2_tier_6_name_3",
			icon = "content/ui/materials/icons/talents/veteran_2/veteran_2_tier_6_name_3",
			icon_position = {
				14,
				4
			},
			special_rule = {
				identifier = "veteran_ranger_combat_ability",
				special_rule_name = special_rules.veteran_ranger_combat_ability_kills_refresh
			}
		}
	}
}

return archetype_talents
