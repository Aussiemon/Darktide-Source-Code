local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local special_rules = SpecialRulesSetting.special_rules
local archetype_talents = {
	archetype = "veteran",
	specialization = "veteran_3",
	talents = {
		veteran_3_grenade = {
			description = "loc_ability_frag_grenade_description",
			name = "G-Ability - Krak Grenade",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			display_name = "loc_ability_frag_grenade",
			icon = "content/ui/materials/icons/abilities/combat/default",
			icon_position = {
				7,
				6
			},
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.veteran_squad_leader_krak_grenade
			}
		},
		veteran_3_combat = {
			large_icon = "content/ui/materials/icons/talents/veteran_3/veteran_3_combat",
			name = "F-Ability - Shout that staggers nearby enemies and suppresses enemies in a cone, and restores toughness",
			display_name = "loc_ability_veteran_squad_leader_specialization_default",
			description = "loc_ability_veteran_squad_leader_specialization_default_description",
			icon_position = {
				8,
				4
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.veteran_squad_leader_shout
			},
			special_rule = {
				identifier = "shout_toughness",
				special_rule_name = special_rules.shout_restores_toughness
			}
		},
		veteran_3_base_1 = {
			description = "loc_ability_veteran_squad_leader_passive_1_description",
			name = "Passive - Reduce cooldown of F-Ability when killing an elite",
			display_name = "loc_ability_veteran_squad_leader_passive_1",
			icon = "content/ui/materials/icons/talents/veteran_3/veteran_3_base_1",
			icon_position = {
				7,
				7
			},
			passive = {
				buff_template_name = "veteran_squad_leader_elite_kills_passive",
				identifier = "veteran_squad_leader_elite_kills_passive"
			}
		},
		veteran_3_base_2 = {
			description = "loc_ability_veteran_squad_leader_passive_2_description",
			name = "Passive - Tagged enemies take increased damage",
			display_name = "loc_ability_veteran_squad_leader_passive_2",
			icon = "content/ui/materials/icons/talents/veteran_3/veteran_3_base_2",
			icon_position = {
				8,
				7
			},
			passive = {
				buff_template_name = "veteran_squad_leader_tag_passive",
				identifier = "veteran_squad_leader_tag_passive"
			}
		},
		veteran_3_base_3 = {
			description = "loc_ability_veteran_squad_leader_passive_3_description",
			name = "Passive - Supression Immunity",
			display_name = "loc_ability_veteran_squad_leader_passive_3",
			icon = "content/ui/materials/icons/talents/veteran_3/veteran_3_base_3",
			icon_position = {
				8,
				6
			},
			passive = {
				buff_template_name = "veteran_squad_leader_suppression_immunity",
				identifier = "veteran_squad_leader_suppression_immunity"
			}
		},
		veteran_3_base_4 = {
			description = "loc_ability_veteran_squad_leader_passive_4_description",
			name = "Aura - Increased damage",
			display_name = "loc_ability_veteran_squad_leader_passive_4",
			icon = "content/ui/materials/icons/talents/veteran_3/veteran_3_base_4",
			icon_position = {
				8,
				8
			},
			coherency = {
				buff_template_name = "veteran_squad_leader_coherency_increased_damage",
				identifier = "coherency_increased_damage"
			}
		},
		veteran_3_tier_1_name_1 = {
			description = "loc_talent_veteran_3_tier_1_name_1_description",
			name = "Medical crates lasts longer, ammo pickups provide more ammo. For all allies",
			display_name = "loc_talent_veteran_3_tier_1_name_1",
			icon = "content/ui/materials/icons/talents/veteran_3/veteran_3_tier_1_name_1",
			icon_position = {
				9,
				1
			},
			passive = {
				buff_template_name = "veteran_squad_leader_better_pickups",
				identifier = "mixed"
			}
		},
		veteran_3_tier_1_name_2 = {
			description = "loc_talent_veteran_3_1_name_2_description",
			name = "Increased damage by Krak Grenades",
			display_name = "loc_talent_veteran_3_tier_1_name_2",
			icon = "content/ui/materials/icons/talents/veteran_3/veteran_3_tier_1_name_2",
			icon_position = {
				10,
				1
			},
			passive = {
				buff_template_name = "veteran_squad_leader_better_grenades",
				identifier = "mixed"
			}
		},
		veteran_3_tier_1_name_3 = {
			description = "loc_talent_veteran_3_tier_1_name_3_description",
			name = "Guaranteed critical hit every 30 seconds",
			display_name = "loc_talent_veteran_3_tier_1_name_3",
			icon = "content/ui/materials/icons/talents/veteran_3/veteran_3_tier_1_name_3",
			icon_position = {
				10,
				2
			},
			passive = {
				buff_template_name = "veteran_squad_leader_periodic_guaranteed_critical_strikes",
				identifier = "mixed"
			}
		},
		veteran_3_tier_2_name_1 = {
			description = "loc_talent_veteran_3_tier_2_name_1_description",
			name = "Increased damage versus armored and super armored enemies",
			display_name = "loc_talent_veteran_3_tier_2_name_1",
			icon = "content/ui/materials/icons/talents/veteran_3/veteran_3_tier_2_name_1",
			icon_position = {
				9,
				1
			},
			passive = {
				buff_template_name = "veteran_squad_leader_increased_damage_vs_armored",
				identifier = "veteran_squad_leader_offensive_passive"
			}
		},
		veteran_3_tier_2_name_2 = {
			description = "loc_talent_veteran_3_tier_2_name_2_description",
			name = "Gain additional Krak Grenades",
			display_name = "loc_talent_veteran_3_tier_2_name_2",
			icon = "content/ui/materials/icons/talents/veteran_3/veteran_3_tier_2_name_2",
			icon_position = {
				10,
				1
			},
			player_ability = {
				ability_type = "grenade_ability",
				name = PlayerAbilities.veteran_squad_leader_krak_grenade_more_charges
			}
		},
		veteran_3_tier_2_name_3 = {
			description = "loc_talent_veteran_3_tier_2_name_3_description",
			name = "Allied kills have a chance to increase your damage and suppression for a short duration",
			display_name = "loc_talent_veteran_3_tier_2_name_3",
			icon = "content/ui/materials/icons/talents/veteran_3/veteran_3_tier_2_name_3",
			icon_position = {
				10,
				2
			},
			passive = {
				buff_template_name = "veteran_squad_leader_allies_kills_change_to_trigger_increased_damage",
				identifier = "veteran_squad_leader_offensive_passive"
			}
		},
		veteran_3_tier_3_name_1 = {
			description = "loc_talent_veteran_3_tier_3_name_1_description",
			name = "Gain movement speed when an ally is knocked down or incapacitated",
			display_name = "loc_talent_veteran_3_tier_3_name_1",
			icon = "content/ui/materials/icons/talents/veteran_3/veteran_3_tier_3_name_1",
			icon_position = {
				4,
				1
			},
			passive = {
				buff_template_name = "veteran_squad_leader_movespeed_when_knocked_allies",
				identifier = "veteran_squad_leader_movespeed_when_knocked_allies"
			}
		},
		veteran_3_tier_3_name_2 = {
			description = "loc_talent_veteran_3_tier_3_name_2_description",
			name = "Take less damage while reloading or venting",
			display_name = "loc_talent_veteran_3_tier_3_name_2",
			icon = "content/ui/materials/icons/talents/veteran_3/veteran_3_tier_3_name_2",
			icon_position = {
				5,
				1
			},
			passive = {
				buff_template_name = "veteran_squad_leader_damage_reduction_while_reloading_or_venting",
				identifier = "veteran_squad_leader_damage_reduction_while_reloading_or_venting"
			}
		},
		veteran_3_tier_3_name_3 = {
			description = "loc_talent_veteran_3_tier_3_name_3_description",
			name = "Increased toughness and stamina",
			display_name = "loc_talent_veteran_3_tier_3_name_3",
			icon = "content/ui/materials/icons/talents/veteran_3/veteran_3_tier_3_name_3",
			icon_position = {
				5,
				2
			},
			passive = {
				buff_template_name = "veteran_squad_leader_increased_toughness_and_stamina",
				identifier = "veteran_squad_leader_increased_toughness_and_stamina"
			}
		},
		veteran_3_tier_4_name_1 = {
			description = "loc_talent_veteran_3_tier_4_name_1_description",
			name = "Increase the efficiency of your aura for allies in coherency when using your shout",
			display_name = "loc_talent_veteran_3_tier_4_name_1",
			icon = "content/ui/materials/icons/talents/veteran_3/veteran_3_tier_4_name_1",
			icon_position = {
				13,
				2
			},
			passive = {
				buff_template_name = "veteran_squad_leader_combat_ability_boost_passive",
				identifier = "coherency_boost"
			}
		},
		veteran_3_tier_4_name_2 = {
			description = "loc_talent_veteran_3_tier_4_name_2_description",
			name = "Increased efficiency of your aura from 5->8% damage",
			display_name = "loc_talent_veteran_3_tier_4_name_2",
			icon = "content/ui/materials/icons/talents/veteran_3/veteran_3_tier_4_name_2",
			icon_position = {
				13,
				3
			},
			coherency = {
				buff_template_name = "veteran_squad_leader_coherency_increased_damage_improved",
				identifier = "coherency_increased_damage"
			}
		},
		veteran_3_tier_4_name_3 = {
			description = "loc_talent_veteran_3_tier_4_name_3_description",
			name = "All allies regenerate more toughness while in your coherency",
			display_name = "loc_talent_veteran_3_tier_4_name_3",
			icon = "content/ui/materials/icons/talents/veteran_3/veteran_3_tier_4_name_3",
			icon_position = {
				13,
				4
			},
			coherency = {
				buff_template_name = "veteran_squad_leader_coherency_toughness_regen_rate",
				identifier = "coherency_toughness_regen_rate"
			}
		},
		veteran_3_tier_5_name_1 = {
			description = "loc_talent_veteran_3_tier_5_name_1_description",
			name = "More cooldown restored when killing elite enemies",
			display_name = "loc_talent_veteran_3_tier_5_name_1",
			icon = "content/ui/materials/icons/talents/veteran_3/veteran_3_tier_5_name_1",
			icon_position = {
				3,
				2
			},
			special_rule = {
				identifier = "specialization_passive",
				special_rule_name = special_rules.veteran_squad_leader_increased_cooldown_restore_on_elite_kills
			}
		},
		veteran_3_tier_5_name_2 = {
			description = "loc_talent_veteran_3_tier_5_name_2_description",
			name = "Tagging enemies instantly suppresses them. Has an internal cooldown",
			display_name = "loc_talent_veteran_3_tier_5_name_2",
			icon = "content/ui/materials/icons/talents/veteran_3/veteran_3_tier_5_name_2",
			icon_position = {
				2,
				3
			},
			special_rule = {
				identifier = "specialization_passive",
				special_rule_name = special_rules.veteran_squad_leader_tag_suppression
			}
		},
		veteran_3_tier_5_name_3 = {
			description = "loc_talent_veteran_3_tier_5_name_3_description",
			name = "Elite kills by allies in coherency also reduces cooldown, but less efficient",
			display_name = "loc_talent_veteran_3_tier_5_name_3",
			icon = "content/ui/materials/icons/talents/veteran_3/veteran_3_tier_5_name_3",
			icon_position = {
				3,
				4
			},
			passive = {
				buff_template_name = "veteran_squad_leader_allies_elite_kills_passive",
				identifier = "coherency_boost"
			}
		},
		veteran_3_tier_6_name_1 = {
			description = "loc_talent_veteran_3_tier_6_name_1_description",
			name = "Your shout increases the Ranged capabilities of allies in coherency for 10 sec (reload speed, spread, sway, recoil, charge up time)",
			display_name = "loc_talent_veteran_3_tier_6_name_1",
			icon = "content/ui/materials/icons/talents/veteran_3/veteran_3_tier_6_name_1",
			icon_position = {
				5,
				4
			},
			passive = {
				buff_template_name = "veteran_squad_leader_combat_ability_boost_ranged",
				identifier = "veteran_squad_leader_combat_ability_boost_ranged"
			}
		},
		veteran_3_tier_6_name_2 = {
			description = "loc_talent_veteran_3_tier_6_name_2_description",
			name = "Your shout increases the Melee capabilities of allies in coherency for 10 sec (dmg, attack speed, stagger, movement speed, block cost)",
			display_name = "loc_talent_veteran_3_tier_6_name_2",
			icon = "content/ui/materials/icons/talents/veteran_3/veteran_3_tier_6_name_2",
			icon_position = {
				4,
				5
			},
			passive = {
				buff_template_name = "veteran_squad_leader_combat_ability_boost_melee",
				identifier = "veteran_squad_leader_combat_ability_boost_melee"
			}
		},
		veteran_3_tier_6_name_3 = {
			description = "loc_talent_veteran_3_tier_6_name_3_description",
			name = "Your shout now revives knocked down allies in coherency",
			display_name = "loc_talent_veteran_3_tier_6_name_3",
			icon = "content/ui/materials/icons/talents/veteran_3/veteran_3_tier_6_name_3",
			icon_position = {
				5,
				5
			},
			special_rule = {
				identifier = "squad_leader_shout_special_rule",
				special_rule_name = special_rules.shout_revives_allies
			}
		}
	}
}

return archetype_talents
