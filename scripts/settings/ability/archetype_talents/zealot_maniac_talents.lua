local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local TalentSettings = require("scripts/settings/buff/talent_settings")
local talent_settings = TalentSettings.zealot_2
local special_rules = SpecialRulesSetting.special_rules
local math_round = math.round
math_round = math_round or function (value)
	if value >= 0 then
		return math.floor(value + 0.5)
	else
		return math.ceil(value - 0.5)
	end
end
local archetype_talents = {
	archetype = "zealot",
	specialization = "zealot_2",
	talents = {
		zealot_2_combat = {
			description = "loc_talent_zealot_2_combat_description",
			name = "F-Ability - Dash towards your input, or target it towards an enemy. Your next melee attack deals bonus damage and is a guaranteed crit. Two charges",
			display_name = "loc_talent_zealot_2_combat",
			large_icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_combat",
			format_values = {
				damage = talent_settings.combat_ability.melee_damage * 100,
				toughness = talent_settings.combat_ability.toughness * 100
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.zealot_maniac_targeted_dash
			}
		},
		zealot_2_shock_grenade = {
			description = "loc_ability_shock_grenade_description",
			name = "G-Ability - Shock Grenade",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			display_name = "loc_ability_shock_grenade",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tactical",
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.zealot_maniac_shock_grenade
			}
		},
		zealot_2_base_1 = {
			description = "loc_talent_maniac_martyrdom_desc",
			name = "Passive - Gain one stack per 15% health missing, up to 3 stacks. Each stack increase damage dealt by 5%",
			display_name = "loc_talent_maniac_martyrdom",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_base_3",
			format_values = {
				damage = talent_settings.passive_1.damage_per_step * 100,
				health = talent_settings.passive_1.health_step * 100,
				amount = talent_settings.passive_1.max_stacks
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
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_base_2",
			format_values = {
				cooldown_duration = talent_settings.passive_2.cooldown_duration,
				active_duration = talent_settings.passive_2.active_duration
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
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_aura",
			format_values = {
				damage_reduction = math_round((1 - talent_settings.coherency.toughness_damage_taken_multiplier) * 100)
			},
			coherency = {
				buff_template_name = "zealot_maniac_coherency_toughness_damage_resistance",
				identifier = "toughness_damage_resistance"
			}
		},
		zealot_2_base_4 = {
			description = "loc_talent_zealot_2_base_4_description",
			name = "Passive - Increased attack speed",
			display_name = "loc_talent_zealot_2_base_4",
			hud_icon = "content/ui/materials/icons/abilities/default",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_base_4",
			format_values = {
				attack_speed = talent_settings.passive_3.melee_attack_speed * 100
			},
			passive = {
				buff_template_name = "zealot_maniac_increased_melee_attack_speed",
				identifier = "zealot_base_passive"
			}
		},
		zealot_2_tier_1_name_1 = {
			description = "loc_talent_maniac_toughness_on_melee_kill_desc",
			name = "Increase toughness gained from melee kills by 50%",
			display_name = "loc_talent_maniac_toughness_on_melee_kill",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_3_2",
			format_values = {
				toughness = talent_settings.toughness_1.toughness_melee_replenish * 100
			},
			passive = {
				buff_template_name = "zealot_maniac_toughness_recovery_from_kills_increased",
				identifier = "toughness"
			}
		},
		zealot_2_tier_1_name_2 = {
			description = "loc_talent_maniac_toughness_melee_effectiveness_desc",
			name = "Critical strikes reduce toughness damage taken by 50% for 3 seconds",
			display_name = "loc_talent_maniac_toughness_melee_effectiveness",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_5_3",
			format_values = {
				toughness_damage_reduction = math_round((1 - talent_settings.toughness_2.toughness_damage_taken_multiplier) * 100),
				time = talent_settings.toughness_2.duration
			},
			passive = {
				buff_template_name = "zealot_maniac_critical_strike_toughness_defense",
				identifier = "toughness"
			}
		},
		zealot_2_tier_1_name_3 = {
			description = "loc_talent_maniac_toughness_regen_in_melee_desc",
			name = "Regenerate toughness while in melee",
			display_name = "loc_talent_maniac_toughness_regen_in_melee",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_4_1",
			format_values = {
				toughness = talent_settings.toughness_3.toughness * 200,
				range = talent_settings.toughness_3.range,
				num_enemies = talent_settings.toughness_3.num_enemies
			},
			passive = {
				buff_template_name = "zealot_maniac_toughness_regen_in_melee",
				identifier = "toughness"
			}
		},
		zealot_2_tier_2_name_1 = {
			description = "loc_talent_maniac_bleed_melee_crit_chance_desc",
			name = "Crits apply bleed. Hitting a bleeding target increases crit for X seconds",
			display_name = "loc_talent_maniac_bleed_melee_crit_chance",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_2_1",
			format_values = {
				crit_chance = talent_settings.offensive_1.melee_critical_strike_chance * 100,
				duration = talent_settings.offensive_1.duration
			},
			passive = {
				buff_template_name = "zealot_maniac_bleeding_crits",
				identifier = "offensive"
			}
		},
		zealot_2_tier_2_name_2 = {
			description = "loc_talent_maniac_multi_hits_increase_impact_desc",
			name = "Attacks that hit more than 3 enemies adds a stacking buff that grants X% more impact. Y max stacks. At max stacks gain uninterruptible. Lasts Z seconds",
			display_name = "loc_talent_maniac_multi_hits_increase_impact",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_2_2_b",
			format_values = {
				min_hits = talent_settings.offensive_2.min_hits,
				time = talent_settings.offensive_2.duration,
				impact_modifier = talent_settings.offensive_2.impact_modifier * 100,
				max_stacks = talent_settings.offensive_2.max_stacks
			},
			passive = {
				buff_template_name = "zealot_maniac_multi_hits_increase_impact",
				identifier = "offensive"
			}
		},
		zealot_2_tier_2_name_3 = {
			description = "loc_talent_maniac_attack_speed_low_health_desc",
			name = "Increased attack speed by 10% while below 50% health, doubled when below 20% health",
			display_name = "loc_talent_maniac_attack_speed_low_health",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_2_3",
			format_values = {
				attack_speed = talent_settings.offensive_3.attack_speed * 100,
				health = talent_settings.offensive_3.first_health_threshold * 100,
				health_2 = talent_settings.offensive_3.second_health_threshold * 100
			},
			passive = {
				buff_template_name = "zealot_maniac_attack_speed_low_health",
				identifier = "offensive"
			}
		},
		zealot_2_tier_3_name_1 = {
			description = "loc_talent_maniac_power_for_allies_on_martyrdom_desc",
			name = "Whenever you gain a martyrdom stack, grant allies in coherency a power bonus for X seconds",
			display_name = "loc_talent_maniac_power_for_allies_on_martyrdom",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_1_2",
			format_values = {
				power_level_modifier = talent_settings.coop_1.power_level_modifier * 100,
				time = talent_settings.coop_1.duration
			},
			special_rule = {
				identifier = "coop",
				special_rule_name = special_rules.zealot_maniac_martyrdom_grants_ally_power_bonus
			}
		},
		zealot_2_tier_3_name_2 = {
			description = "loc_talent_maniac_aura_efficiency_desc",
			name = "Increase the efficiency of your aura to 15%",
			display_name = "loc_talent_maniac_aura_efficiency",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_4_2",
			format_values = {
				damage_reduction = math_round((1 - talent_settings.coop_2.toughness_damage_taken_multiplier) * 100)
			},
			coherency = {
				buff_template_name = "zealot_maniac_coherency_toughness_damage_resistance_improved",
				identifier = "toughness_damage_resistance"
			}
		},
		zealot_2_tier_3_name_3 = {
			description = "loc_talent_maniac_ability_grants_toughness_to_allies_desc",
			name = "When you use your Combat Ability, allies in coherency gain 20% toughness",
			display_name = "loc_talent_maniac_ability_grants_toughness_to_allies",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_4_3",
			format_values = {
				toughness = talent_settings.coop_3.toughness * 100
			},
			passive = {
				buff_template_name = "zealot_maniac_dash_grants_toughness",
				identifier = "coop"
			}
		},
		zealot_2_tier_4_name_1 = {
			description = "loc_talent_maniac_heal_during_resist_death_desc",
			name = "When Resist Death ends you gain health based on the damage you dealt during Resist Death. Melee damage dealt heals for twice the amount.",
			display_name = "loc_talent_maniac_heal_during_resist_death",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_6_1",
			format_values = {
				multiplier = talent_settings.defensive_1.leech * 100
			},
			passive = {
				buff_template_name = "zealot_maniac_resist_death_improved_with_leech",
				identifier = "resist_death"
			}
		},
		zealot_2_tier_4_name_2 = {
			description = "loc_talent_maniac_movement_speed_on_damaged_desc",
			name = "Taking damage grants a short burst of movement speed",
			display_name = "loc_talent_maniac_movement_speed_on_damaged",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_3_3",
			format_values = {
				movement_speed = math_round((talent_settings.defensive_2.movement_speed - 1) * 100),
				time = talent_settings.defensive_2.active_duration
			},
			passive = {
				buff_template_name = "zealot_maniac_movement_enhanced",
				identifier = "defensive"
			}
		},
		zealot_2_tier_4_name_3 = {
			description = "loc_talent_maniac_heal_damage_taken_desc",
			name = "Recuperate a portion of all damage taken",
			display_name = "loc_talent_maniac_heal_damage_taken",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_4_3_b",
			format_values = {
				damage_reduction = talent_settings.defensive_3.recuperate_percentage * 100,
				time = talent_settings.defensive_3.duration
			},
			passive = {
				buff_template_name = "zealot_maniac_recuperate_a_portion_of_damage_taken",
				identifier = "defensive"
			}
		},
		zealot_2_tier_5_name_1 = {
			description = "loc_talent_maniac_ranged_damage_increased_to_close_desc",
			name = "Increased ranged damage to close enemies",
			display_name = "loc_talent_maniac_ranged_damage_increased_to_close",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_5_1_b",
			format_values = {
				damage = talent_settings.offensive_2_1.damage * 100
			},
			passive = {
				buff_template_name = "zealot_maniac_close_ranged_damage",
				identifier = "offensive_2"
			}
		},
		zealot_2_tier_5_name_2 = {
			description = "loc_talent_maniac_increased_damage_stacks_on_hit_desc",
			name = "Hitting a target increases melee damage for a short duration, stacking up to five times",
			display_name = "loc_talent_maniac_increased_damage_stacks_on_hit",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_5_1",
			format_values = {
				damage = talent_settings.offensive_2_2.melee_damage * 100,
				time = talent_settings.offensive_2_2.duration,
				amount = talent_settings.offensive_2_2.max_stacks
			},
			passive = {
				buff_template_name = "zealot_maniac_stacking_melee_damage",
				identifier = "offensive_2"
			}
		},
		zealot_2_tier_5_name_3 = {
			description = "loc_talent_maniac_increased_martyrdom_stacks_desc",
			name = "Increased Martyrdom max stacks to 6",
			display_name = "loc_talent_maniac_increased_martyrdom_stacks",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_2_2",
			format_values = {
				max_stack = talent_settings.offensive_2_3.max_stacks
			},
			special_rule = {
				identifier = "offensive_2",
				special_rule_name = special_rules.martyrdom_increased_stacks
			}
		},
		zealot_2_tier_6_name_1 = {
			description = "loc_talent_maniac_cooldown_on_melee_crits_desc",
			name = "Melee critical strike hits reduce the cooldown of chastise the wicked",
			display_name = "loc_talent_maniac_cooldown_on_melee_crits",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_5_2",
			format_values = {
				time = talent_settings.combat_ability_1.time
			},
			passive = {
				buff_template_name = "zealot_maniac_combat_ability_crits_reduce_cooldown",
				identifier = "combat_ability"
			}
		},
		zealot_2_tier_6_name_2 = {
			description = "loc_talent_maniac_attack_speed_after_dash_desc_old",
			name = "Gain attack speed after using your dash ability",
			display_name = "loc_talent_maniac_attack_speed_after_dash",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_6_2",
			format_values = {
				attack_speed = talent_settings.combat_ability_2.attack_speed * 100,
				time = talent_settings.combat_ability_2.active_duration
			},
			passive = {
				buff_template_name = "zealot_maniac_combat_ability_attack_speed_increase",
				identifier = "combat_ability"
			}
		},
		zealot_2_tier_6_name_3 = {
			description = "loc_talent_maniac_dash_has_more_charges_desc",
			name = "Increases charges of your dash ability to 2",
			display_name = "loc_talent_maniac_dash_has_more_charges",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_6_3",
			format_values = {
				max_charges = talent_settings.combat_ability_3.max_charges
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.zealot_maniac_targeted_dash_improved
			}
		}
	}
}

return archetype_talents
