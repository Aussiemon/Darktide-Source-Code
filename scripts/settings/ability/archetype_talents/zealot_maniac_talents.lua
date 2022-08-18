local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local special_rules = SpecialRulesSetting.special_rules
local archetype_talents = {
	archetype = "zealot",
	specialization = "zealot_2",
	talents = {
		zealot_2_combat = {
			large_icon = "content/ui/materials/icons/talents/zealot_2/zealot_2_combat",
			name = "F-Ability - Dash towards your input, or target it towards an enemy. Your next melee attack deals bonus damage and is a guaranteed crit. Two charges",
			display_name = "loc_talent_zealot_2_combat",
			description = "loc_talent_zealot_2_combat_description",
			icon_position = {
				8,
				4
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.zealot_maniac_targeted_dash
			}
		},
		zealot_2_fire_grenade = {
			description = "loc_talent_zealot_2_grenade_despription",
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
		zealot_2_shock_grenade = {
			description = "loc_talent_zealot_2_grenade_despription",
			name = "G-Ability - Shock Grenade",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			display_name = "loc_ability_shock_grenade",
			icon = "content/ui/materials/icons/abilities/combat/default",
			icon_position = {
				9,
				5
			},
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.zealot_maniac_shock_grenade
			}
		},
		zealot_2_base_1 = {
			description = "loc_talent_zealot_2_base_1_description",
			name = "Passive - Increased damage the lower your health",
			display_name = "loc_talent_zealot_2_base_1",
			icon = "content/ui/materials/icons/talents/zealot_2/zealot_2_base_1",
			icon_position = {
				10,
				5
			},
			passive = {
				buff_template_name = "zealot_maniac_martyrdom_base",
				identifier = "martyrdom"
			}
		},
		zealot_2_base_2 = {
			description = "loc_talent_zealot_2_base_2_description",
			name = "Passive - When taking lethal damage, become invulnerable for 5 seconds. 90 seconds cooldown",
			display_name = "loc_talent_zealot_2_base_2",
			icon = "content/ui/materials/icons/talents/zealot_2/zealot_2_base_2",
			icon_position = {
				10,
				6
			},
			passive = {
				buff_template_name = "zealot_maniac_resist_death",
				identifier = "resist_death"
			}
		},
		zealot_2_base_3 = {
			description = "loc_talent_zealot_2_base_3_description",
			name = "Aura - Reduced toughness damage taken",
			display_name = "loc_talent_zealot_2_base_3",
			icon = "content/ui/materials/icons/talents/zealot_2/zealot_2_base_3",
			icon_position = {
				11,
				6
			},
			coherency = {
				buff_template_name = "zealot_maniac_coherency_toughness_damage_resistance",
				identifier = "toughness_damage_resistance"
			}
		},
		zealot_2_base_4 = {
			description = "loc_ability_zealot_combat_ability_description",
			name = "Passive - Increased attack speed",
			hud_icon = "content/ui/materials/icons/abilities/default",
			display_name = "loc_talent_zealot_2_base_4",
			icon = "content/ui/materials/icons/talents/zealot_2/zealot_2_base_4",
			icon_position = {
				10,
				7
			},
			passive = {
				buff_template_name = "zealot_maniac_increased_melee_attack_speed",
				identifier = "zealot_base_passive"
			}
		},
		zealot_2_tier_1_name_1 = {
			description = "loc_talent_zealot_2_tier_1_name_1_description",
			name = "Increased amount of Shock Grenades",
			display_name = "loc_talent_zealot_2_tier_1_name_1",
			icon = "content/ui/materials/icons/talents/zealot_2/zealot_2_tier_1_name_1",
			icon_position = {
				8,
				8
			},
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.zealot_maniac_shock_grenade_increased_amount
			}
		},
		zealot_2_tier_1_name_2 = {
			description = "loc_talent_zealot_2_tier_1_name_2_description",
			name = "Melee critical hits sets the enemy on fire",
			display_name = "loc_talent_zealot_2_tier_1_name_2",
			icon = "content/ui/materials/icons/talents/zealot_2/zealot_2_tier_1_name_2",
			icon_position = {
				7,
				7
			},
			passive = {
				buff_template_name = "zealot_maniac_melee_crits_set_target_on_fire",
				identifier = "mixed"
			}
		},
		zealot_2_tier_1_name_3 = {
			description = "loc_talent_zealot_2_tier_3_name_2_description",
			name = "Recuperate a portion of all damage taken",
			display_name = "loc_talent_zealot_2_tier_3_name_2",
			icon = "content/ui/materials/icons/talents/zealot_2/zealot_2_tier_3_name_2",
			icon_position = {
				8,
				7
			},
			passive = {
				buff_template_name = "zealot_maniac_recuperate_a_portion_of_damage_taken",
				identifier = "mixed"
			}
		},
		zealot_2_tier_2_name_1 = {
			description = "loc_talent_zealot_2_tier_2_name_1_description",
			name = "Increased melee critical strike chance",
			display_name = "loc_talent_zealot_2_tier_2_name_1",
			icon = "content/ui/materials/icons/talents/zealot_2/zealot_2_tier_2_name_1",
			icon_position = {
				5,
				5
			},
			passive = {
				buff_template_name = "zelaot_maniac_melee_critical_strike_chance_increased",
				identifier = "offensive"
			}
		},
		zealot_2_tier_2_name_2 = {
			description = "loc_talent_zealot_2_tier_2_name_2_description",
			name = "Hitting a target increases melee damage for a short duration, stacking up to five times. Only triggers once per attack",
			display_name = "loc_talent_zealot_2_tier_2_name_2",
			icon = "content/ui/materials/icons/talents/zealot_2/zealot_2_tier_2_name_2",
			icon_position = {
				5,
				6
			},
			passive = {
				buff_template_name = "zealot_maniac_stacking_melee_damage",
				identifier = "offensive"
			}
		},
		zealot_2_tier_2_name_3 = {
			description = "loc_talent_zealot_2_tier_2_name_3_description",
			name = "Increased attack speed by 10% while below 50% health, doubled when below 20% health",
			display_name = "loc_talent_zealot_2_tier_2_name_3",
			icon = "content/ui/materials/icons/talents/zealot_2/zealot_2_tier_2_name_3",
			icon_position = {
				6,
				6
			},
			passive = {
				buff_template_name = "zealot_maniac_attack_speed_low_health",
				identifier = "offensive"
			}
		},
		zealot_2_tier_3_name_1 = {
			description = "loc_talent_zealot_2_tier_3_name_1_description",
			name = "Toughness gained from kill increased",
			display_name = "loc_talent_zealot_2_tier_3_name_1",
			icon = "content/ui/materials/icons/talents/zealot_2/zealot_2_tier_3_name_1",
			icon_position = {
				2,
				4
			},
			passive = {
				buff_template_name = "zealot_maniac_toughness_gained_from_kills_increased",
				identifier = "defensive"
			}
		},
		zealot_2_tier_3_name_2 = {
			description = "loc_talent_zealot_2_tier_1_name_3_description",
			name = "Melee kills grant toughness damage reduction for a short while, stacking up to 3 times",
			display_name = "loc_talent_zealot_2_tier_1_name_3",
			icon = "content/ui/materials/icons/talents/zealot_2/zealot_2_tier_1_name_3",
			icon_position = {
				3,
				4
			},
			passive = {
				buff_template_name = "zealot_maniac_melee_kills_grant_tougness_damage_reduction_stacking",
				identifier = "defensive"
			}
		},
		zealot_2_tier_3_name_3 = {
			description = "loc_talent_zealot_2_tier_3_name_3_description",
			name = "Taking damage grants a short burst of movementspeed. Getting attacked no longer reduces movement speed",
			display_name = "loc_talent_zealot_2_tier_3_name_3",
			icon = "content/ui/materials/icons/talents/zealot_2/zealot_2_tier_3_name_3",
			icon_position = {
				4,
				4
			},
			passive = {
				buff_template_name = "zealot_maniac_movement_enhanced",
				identifier = "defensive"
			}
		},
		zealot_2_tier_4_name_1 = {
			description = "loc_talent_zealot_2_tier_4_name_1_description",
			name = "When toughness broken by a melee attack, grant toughness to all allies in coherency",
			display_name = "loc_talent_zealot_2_tier_4_name_1",
			icon = "content/ui/materials/icons/talents/zealot_2/zealot_2_tier_4_name_1",
			icon_position = {
				4,
				1
			},
			passive = {
				buff_template_name = "zealot_maniac_toughness_broken_by_melee_restores_toughness_to_allies",
				identifier = "coherency"
			}
		},
		zealot_2_tier_4_name_2 = {
			description = "loc_talent_zealot_2_tier_4_name_2_description",
			name = "Increase the efficiency of your aura",
			display_name = "loc_talent_zealot_2_tier_4_name_2",
			icon = "content/ui/materials/icons/talents/zealot_2/zealot_2_tier_4_name_2",
			icon_position = {
				5,
				2
			},
			coherency = {
				buff_template_name = "zealot_maniac_coherency_toughness_damage_resistance_improved",
				identifier = "toughness_damage_resistance"
			}
		},
		zealot_2_tier_4_name_3 = {
			description = "loc_talent_zealot_2_tier_4_name_3_description",
			name = "Elite kills grant a damage bonus to allies in coherency",
			display_name = "loc_talent_zealot_2_tier_4_name_3",
			icon = "content/ui/materials/icons/talents/zealot_2/zealot_2_tier_4_name_3",
			icon_position = {
				5,
				3
			},
			passive = {
				buff_template_name = "zealot_maniac_elite_kills_grant_damage_to_allies",
				identifier = "coherency"
			}
		},
		zealot_2_tier_5_name_1 = {
			description = "loc_talent_zealot_2_tier_5_name_1_description",
			name = "Gain further increased damage the lower your health is",
			display_name = "loc_talent_zealot_2_tier_5_name_1",
			icon = "content/ui/materials/icons/talents/zealot_2/zealot_2_tier_5_name_1",
			icon_position = {
				11,
				1
			},
			special_rule = {
				identifier = "specialization_passive",
				special_rule_name = special_rules.martyrdom_increased_damage_output
			}
		},
		zealot_2_tier_5_name_2 = {
			description = "loc_talent_zealot_2_tier_5_name_2_description",
			name = "Gain movement speed the lower your health is",
			display_name = "loc_talent_zealot_2_tier_5_name_2",
			icon = "content/ui/materials/icons/talents/zealot_2/zealot_2_tier_5_name_2",
			icon_position = {
				11,
				2
			},
			special_rule = {
				identifier = "specialization_passive",
				special_rule_name = special_rules.martyrdom_increased_movement_speed
			}
		},
		zealot_2_tier_5_name_3 = {
			description = "loc_talent_zealot_2_tier_5_name_3_description",
			name = "Take less damage the lower your health is",
			display_name = "loc_talent_zealot_2_tier_5_name_3",
			icon = "content/ui/materials/icons/talents/zealot_2/zealot_2_tier_5_name_3",
			icon_position = {
				10,
				3
			},
			special_rule = {
				identifier = "specialization_passive",
				special_rule_name = special_rules.martyrdom_decrease_damage_taken
			}
		},
		zealot_2_tier_6_name_1 = {
			description = "loc_talent_zealot_2_tier_6_name_1_description",
			name = "Your invulnerability lasts longer. When the effect ends you restore health based on enemies killed",
			display_name = "loc_talent_zealot_2_tier_6_name_1",
			icon = "content/ui/materials/icons/talents/zealot_2/zealot_2_tier_6_name_1",
			icon_position = {
				12,
				4
			},
			passive = {
				buff_template_name = "zealot_maniac_resist_death_improved_with_leech",
				identifier = "resist_death"
			}
		},
		zealot_2_tier_6_name_2 = {
			description = "loc_talent_zealot_2_tier_6_name_2_description",
			name = "Gain attack speed after using your dash ability",
			display_name = "loc_talent_zealot_2_tier_6_name_2",
			icon = "content/ui/materials/icons/talents/zealot_2/zealot_2_tier_6_name_2",
			icon_position = {
				13,
				4
			},
			passive = {
				buff_template_name = "zealot_maniac_combat_ability_attack_speed_increase",
				identifier = "combat_ability_improve"
			}
		},
		zealot_2_tier_6_name_3 = {
			description = "loc_talent_zealot_2_tier_6_name_3_description",
			name = "Increases charges of your dash ability to 3, and reduces its cooldown",
			display_name = "loc_talent_zealot_2_tier_6_name_3",
			icon = "content/ui/materials/icons/talents/zealot_2/zealot_2_tier_6_name_3",
			icon_position = {
				14,
				4
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.zealot_maniac_targeted_dash_improved
			}
		}
	}
}

return archetype_talents
