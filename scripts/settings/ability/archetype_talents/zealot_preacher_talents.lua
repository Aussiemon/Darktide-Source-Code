local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local special_rules = SpecialRulesSetting.special_rules
local archetype_talents = {
	archetype = "zealot",
	specialization = "zealot_3",
	talents = {
		zealot_3_combat = {
			large_icon = "content/ui/materials/icons/talents/zealot_3/zealot_3_combat",
			name = "F-Ability - Boost defenses for 5 seconds, afterwards deal damage to nearby enemies. Hold to target allies",
			display_name = "loc_ability_zealot_banisher_specialization_default",
			description = "loc_ability_zealot_banisher_specialization_default",
			icon_position = {
				8,
				4
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.zealot_preacher_relic
			}
		},
		zealot_3_fire_grenade = {
			description = "loc_talent_zealot_3_grenade_despription",
			name = "G-Ability - Flame Grenade",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			display_name = "loc_ability_fire_grenade",
			icon = "content/ui/materials/icons/abilities/combat/default",
			icon_position = {
				9,
				5
			},
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.fire_grenade
			}
		},
		zealot_3_base_1 = {
			description = "loc_ability_zealot_banisher_passive_1_description",
			name = "Dying enemies increase fury, on 25 stacks enter Fanatic Rage and gain crit chance",
			display_name = "loc_ability_zealot_banisher_passive_1",
			icon = "content/ui/materials/icons/talents/zealot_3/zealot_3_base_1",
			icon_position = {
				8,
				8
			},
			passive = {
				buff_template_name = "zealot_preacher_fanatic_rage",
				identifier = "fanatic_rage"
			}
		},
		zealot_3_base_2 = {
			description = "loc_ability_zealot_banisher_passive_2_description",
			name = "More damage against disgustingly resilient",
			display_name = "loc_ability_zealot_banisher_passive_2",
			icon = "content/ui/materials/icons/talents/zealot_3/zealot_3_base_2",
			icon_position = {
				7,
				7
			},
			passive = {
				buff_template_name = "zealot_preacher_damage_vs_disgusting",
				identifier = "passive_damage"
			}
		},
		zealot_3_base_3 = {
			description = "loc_ability_zealot_banisher_passive_3_description",
			name = "Reduced corruption damage taken",
			display_name = "loc_ability_zealot_banisher_passive_3",
			icon = "content/ui/materials/icons/talents/zealot_3/zealot_3_base_3",
			icon_position = {
				8,
				7
			},
			passive = {
				buff_template_name = "zealot_preacher_reduce_corruption_damage",
				identifier = "passive_defense"
			}
		},
		zealot_3_base_4 = {
			description = "loc_ability_zealot_banisher_passive_4_description",
			name = "Heal corruption of allies",
			display_name = "loc_ability_zealot_banisher_passive_4",
			icon = "content/ui/materials/icons/talents/zealot_3/zealot_3_base_4",
			icon_position = {
				8,
				6
			},
			coherency = {
				buff_template_name = "zealot_preacher_coherency_corruption_healing",
				identifier = "corruption_healing"
			}
		},
		zealot_3_tier_1_name_1 = {
			description = "loc_ability_zealot_banisher_tier_1_ability_1_description",
			name = "Mixed - impact power increase",
			display_name = "loc_ability_zealot_banisher_tier_1_ability_1",
			icon = "content/ui/materials/icons/talents/zealot_3/zealot_3_tier_1_name_1",
			icon_position = {
				11,
				1
			},
			passive = {
				buff_template_name = "zealot_preacher_impact_power",
				identifier = "mixed"
			}
		},
		zealot_3_tier_1_name_2 = {
			description = "loc_ability_zealot_banisher_tier_1_ability_2_description",
			name = "Increased toughness",
			display_name = "loc_ability_zealot_banisher_tier_1_ability_2",
			icon = "content/ui/materials/icons/talents/zealot_3/zealot_3_tier_1_name_2",
			icon_position = {
				11,
				2
			},
			passive = {
				buff_template_name = "zealot_preacher_increased_toughness",
				identifier = "mixed"
			}
		},
		zealot_3_tier_1_name_3 = {
			description = "loc_ability_zealot_banisher_tier_1_ability_3_description",
			name = "More health segments",
			display_name = "loc_ability_zealot_banisher_tier_1_ability_3",
			icon = "content/ui/materials/icons/talents/zealot_3/zealot_3_tier_1_name_3",
			icon_position = {
				10,
				3
			},
			passive = {
				buff_template_name = "zealot_preacher_more_segments",
				identifier = "mixed"
			}
		},
		zealot_3_tier_2_name_1 = {
			description = "loc_ability_zealot_banisher_tier_2_ability_1_description",
			name = "Melee hit increase next melee_attack",
			display_name = "loc_ability_zealot_banisher_tier_2_ability_1",
			icon = "content/ui/materials/icons/talents/zealot_3/zealot_3_tier_2_name_1",
			icon_position = {
				4,
				1
			},
			passive = {
				buff_template_name = "zealot_preacher_melee_increase_next_melee_proc",
				identifier = "offensive"
			}
		},
		zealot_3_tier_2_name_2 = {
			description = "loc_ability_zealot_banisher_tier_2_ability_2_description",
			name = "zealot_preacher_tier_2_name_2",
			display_name = "loc_ability_zealot_banisher_tier_2_ability_2",
			icon = "content/ui/materials/icons/talents/zealot_3/zealot_3_tier_2_name_2",
			icon_position = {
				5,
				2
			}
		},
		zealot_3_tier_2_name_3 = {
			description = "loc_ability_zealot_banisher_tier_2_ability_3_description",
			name = "zealot_preacher_tier_2_name_3",
			display_name = "loc_ability_zealot_banisher_tier_2_ability_3",
			icon = "content/ui/materials/icons/talents/zealot_3/zealot_3_tier_2_name_3",
			icon_position = {
				5,
				3
			}
		},
		zealot_3_tier_3_name_1 = {
			description = "loc_ability_zealot_banisher_tier_3_ability_1_description",
			name = "zealot_preacher_tier_3_name_1",
			display_name = "loc_ability_zealot_banisher_tier_3_ability_1",
			icon = "content/ui/materials/icons/talents/zealot_3/zealot_3_tier_3_name_1",
			icon_position = {
				12,
				4
			}
		},
		zealot_3_tier_3_name_2 = {
			description = "loc_ability_zealot_banisher_tier_3_ability_2_description",
			name = "zealot_preacher_tier_3_name_2",
			display_name = "loc_ability_zealot_banisher_tier_3_ability_2",
			icon = "content/ui/materials/icons/talents/zealot_3/zealot_3_tier_3_name_2",
			icon_position = {
				13,
				4
			}
		},
		zealot_3_tier_3_name_3 = {
			description = "loc_ability_zealot_banisher_tier_3_ability_3_description",
			name = "Toughness damage reduction per wound",
			display_name = "loc_ability_zealot_banisher_tier_3_ability_3",
			icon = "content/ui/materials/icons/talents/zealot_3/zealot_3_tier_3_name_3",
			icon_position = {
				14,
				4
			},
			passive = {
				buff_template_name = "zealot_preacher_toughness_damage_reduction_per_wound",
				identifier = "defensive"
			}
		},
		zealot_3_tier_4_name_1 = {
			description = "loc_ability_zealot_banisher_tier_2_ability_1_description",
			name = "shield of faith grants coherency bonus",
			display_name = "loc_ability_zealot_banisher_tier_2_ability_1",
			icon = "content/ui/materials/icons/talents/zealot_3/zealot_3_tier_4_name_1",
			icon_position = {
				2,
				4
			},
			special_rule = {
				identifier = "coherency_aura",
				special_rule_name = special_rules.buff_coherency_units
			}
		},
		zealot_3_tier_4_name_2 = {
			description = "loc_ability_zealot_banisher_tier_2_ability_2_description",
			name = "zealot_preacher_tier_4_name_2",
			display_name = "loc_ability_zealot_banisher_tier_2_ability_2",
			icon = "content/ui/materials/icons/talents/zealot_3/zealot_3_tier_4_name_2",
			icon_position = {
				3,
				4
			}
		},
		zealot_3_tier_4_name_3 = {
			description = "loc_ability_zealot_banisher_tier_2_ability_3_description",
			name = "zealot_preacher_tier_4_name_3",
			display_name = "loc_ability_zealot_banisher_tier_2_ability_3",
			icon = "content/ui/materials/icons/talents/zealot_3/zealot_3_tier_4_name_3",
			icon_position = {
				4,
				4
			}
		},
		zealot_3_tier_5_name_1 = {
			description = "loc_ability_zealot_banisher_tier_3_ability_1_description",
			name = "Killing enemies during Fanatic Rage reduce the remaining cooldown of your Shield of Faith by 0.5 seconds.",
			display_name = "loc_ability_zealot_banisher_tier_3_ability_1",
			icon = "content/ui/materials/icons/talents/zealot_3/zealot_3_tier_5_name_1",
			icon_position = {
				5,
				5
			},
			special_rule = {
				identifier = "specialization_passive",
				special_rule_name = special_rules.zealot_preacher_fanatic_kills_restore_cooldown
			}
		},
		zealot_3_tier_5_name_2 = {
			description = "loc_ability_zealot_banisher_tier_3_ability_2_description",
			name = "Fanatic Rage crit chance increased to 25%",
			display_name = "loc_ability_zealot_banisher_tier_3_ability_2",
			icon = "content/ui/materials/icons/talents/zealot_3/zealot_3_tier_5_name_2",
			icon_position = {
				5,
				6
			},
			special_rule = {
				identifier = "specialization_passive",
				special_rule_name = special_rules.zealot_preacher_increased_crit_chance
			}
		},
		zealot_3_tier_5_name_3 = {
			description = "loc_ability_zealot_banisher_tier_3_ability_3_description",
			name = "Your critical hits grant a stack of fury",
			display_name = "loc_ability_zealot_banisher_tier_3_ability_3",
			icon = "content/ui/materials/icons/talents/zealot_3/zealot_3_tier_5_name_3",
			icon_position = {
				6,
				6
			},
			special_rule = {
				identifier = "specialization_passive",
				special_rule_name = special_rules.zealot_preacher_crits_grants_stack
			}
		},
		zealot_3_tier_6_name_1 = {
			description = "loc_ability_zealot_banisher_tier_3_ability_1_description",
			name = "Shield of Faith has two charges",
			display_name = "loc_ability_zealot_banisher_tier_3_ability_1",
			icon = "content/ui/materials/icons/talents/zealot_3/zealot_3_tier_6_name_1",
			icon_position = {
				10,
				5
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.zealot_preacher_relic_more_charges
			}
		},
		zealot_3_tier_6_name_2 = {
			description = "loc_ability_zealot_banisher_tier_3_ability_2_description",
			name = "Shield of Faith always casts only yourself in addition to your target",
			display_name = "loc_ability_zealot_banisher_tier_3_ability_2",
			icon = "content/ui/materials/icons/talents/zealot_3/zealot_3_tier_6_name_2",
			icon_position = {
				10,
				6
			},
			special_rule = {
				identifier = "combat_ability_talent",
				special_rule_name = special_rules.buff_always_self_cast
			}
		},
		zealot_3_tier_6_name_3 = {
			description = "loc_ability_zealot_banisher_tier_3_ability_3_description",
			name = "Shield of Faith revives knocked down allies, and lasts 8 seconds",
			display_name = "loc_ability_zealot_banisher_tier_3_ability_3",
			icon = "content/ui/materials/icons/talents/zealot_3/zealot_3_tier_6_name_3",
			icon_position = {
				11,
				6
			},
			special_rule = {
				identifier = {
					"revive",
					"duration"
				},
				special_rule_name = {
					special_rules.buff_revives_allies,
					special_rules.buff_target_buff_name_override
				}
			}
		}
	}
}

return archetype_talents
