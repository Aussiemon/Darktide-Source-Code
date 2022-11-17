local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local TalentSettings = require("scripts/settings/buff/talent_settings")
local talent_settings = TalentSettings.ogryn_2
local shared_talent_settings = TalentSettings.ogryn_shared
local math_round = math.round
math_round = math_round or function (value)
	if value >= 0 then
		return math.floor(value + 0.5)
	else
		return math.ceil(value - 0.5)
	end
end
local archetype_talents = {
	archetype = "ogryn",
	specialization = "ogryn_2",
	talents = {
		ogryn_2_combat_ability = {
			description = "loc_ability_ogryn_charge_description",
			name = "F-Ability - Charge forward, knocking enemies back. Grants movement speed and attack speed afterwards",
			display_name = "loc_ability_ogryn_charge",
			large_icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_combat",
			hud_icon = "content/ui/materials/icons/abilities/default",
			format_values = {
				duration = talent_settings.combat_ability.active_duration,
				attack_speed = talent_settings.combat_ability.melee_attack_speed * 100,
				move_speed = (talent_settings.combat_ability.movement_speed - 1) * 100
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
		ogryn_2_charge_buff = {
			description = "loc_talent_ogryn_2_combat_description",
			name = "ogryn_bonebreaker_speed_on_lunge",
			display_name = "loc_talent_ogryn_2_combat",
			passive = {
				buff_template_name = "ogryn_bonebreaker_speed_on_lunge",
				identifier = "combat_ability"
			}
		},
		ogryn_2_grenade = {
			description = "loc_ability_ogryn_grenade_box_description",
			name = "G-Ability - Ogryn Grenade Box",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			display_name = "loc_ability_ogryn_grenade_box",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tactical",
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.ogryn_grenade_box
			}
		},
		ogryn_2_base_1 = {
			description = "loc_talent_bonebreaker_melee_stagger_desc",
			name = "Passive - Increased stagger",
			display_name = "loc_talent_bonebreaker_melee_stagger",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_base_1",
			format_values = {
				stagger = talent_settings.passive_1.impact_modifier * 100
			},
			passive = {
				buff_template_name = "ogryn_bonebreaker_passive_stagger",
				identifier = "ogryn_bonebreaker_passive_stagger"
			}
		},
		ogryn_2_base_2 = {
			description = "loc_talent_bonebreaker_revive_uninterruptible_desc",
			name = "Passive - Uninterruptible while reviving",
			display_name = "loc_talent_bonebreaker_revive_uninterruptible",
			hud_icon = "content/ui/materials/icons/abilities/default",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_base_4",
			format_values = {},
			passive = {
				buff_template_name = "ogryn_bonebreaker_passive_revive",
				identifier = "ogryn_bonebreaker_passive_revive"
			}
		},
		ogryn_2_base_3 = {
			description = "loc_talent_ogryn_2_base_3_description",
			name = "Passive - Decreased toughness damage take and damage taken",
			display_name = "loc_talent_ogryn_2_base_3",
			hud_icon = "content/ui/materials/icons/abilities/default",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_base_3",
			format_values = {
				toughness_reduction = math_round((1 - shared_talent_settings.tank.toughness_damage_taken_multiplier) * 100),
				damage_reduction = math_round((1 - shared_talent_settings.tank.damage_taken_multiplier) * 100)
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
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_aura",
			format_values = {
				damage = talent_settings.coherency.melee_damage * 100
			},
			coherency = {
				buff_template_name = "ogryn_bonebreaker_coherency_increased_melee_damage",
				identifier = "increased_melee_heavy_damage"
			}
		},
		ogryn_2_tier_1_name_1 = {
			description = "loc_talent_bonebreaker_coherency_toughness_increase_desc",
			name = "Increase the toughness you regenerate from coherency",
			display_name = "loc_talent_bonebreaker_coherency_toughness_increase",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_base_2",
			format_values = {
				toughness_multiplier = talent_settings.toughness_1.toughness_bonus * 100
			},
			passive = {
				buff_template_name = "ogryn_bonebreaker_increased_coherency_regen",
				identifier = "toughness"
			}
		},
		ogryn_2_tier_1_name_2 = {
			description = "loc_talent_bonebreaker_toughness_on_single_heavy_desc",
			name = "Replenish toughness when hitting a single enemy with a heavy attack",
			display_name = "loc_talent_bonebreaker_toughness_on_single_heavy",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_1_2",
			format_values = {
				toughness = talent_settings.toughness_2.toughness * 100
			},
			passive = {
				buff_template_name = "ogryn_bonebreaker_heavy_hits_toughness",
				identifier = "toughness"
			}
		},
		ogryn_2_tier_1_name_3 = {
			description = "loc_talent_bonebreaker_toughness_on_multiple_desc",
			name = "Heavy attacks restore toughness when hitting multiple enemies",
			display_name = "loc_talent_bonebreaker_toughness_on_multiple",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_5_3",
			format_values = {
				toughness = talent_settings.toughness_3.toughness * 100
			},
			passive = {
				buff_template_name = "ogryn_bonebreaker_multiple_enemy_heavy_hits_restore_toughness",
				identifier = "toughness"
			}
		},
		ogryn_2_tier_2_name_1 = {
			description = "loc_talent_bonebreaker_ogryn_fighter_desc",
			name = "You deal 50% more damage versus Ogryns, and take 50% less damage from them",
			display_name = "loc_talent_bonebreaker_ogryn_fighter",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_2_1",
			format_values = {
				damage = talent_settings.offensive_1.damage_vs_ogryn * 100,
				damage_reduction = talent_settings.offensive_1.ogryn_damage_taken_multiplier * 100
			},
			passive = {
				buff_template_name = "ogryn_bonebreaker_better_ogryn_fighting",
				identifier = "offensive"
			}
		},
		ogryn_2_tier_2_name_2 = {
			description = "loc_talent_bonebreaker_grenade_super_armor_explosion_desc",
			name = "Your direct grenade hits on super armored enemies creates a large explosion",
			display_name = "loc_talent_bonebreaker_grenade_super_armor_explosion",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_4_3",
			format_values = {},
			passive = {
				buff_template_name = "ogryn_bonebreaker_direct_grenade_hits_on_supers_explode",
				identifier = "offensive"
			}
		},
		ogryn_2_tier_2_name_3 = {
			description = "loc_talent_bonebreaker_bleed_on_multiple_hit_desc",
			name = "Heavy melee attacks apply bleed to enemies hit",
			display_name = "loc_talent_bonebreaker_bleed_on_multiple_hit",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_2_3_b",
			format_values = {},
			passive = {
				buff_template_name = "ogryn_bonebreaker_heavy_attacks_bleed",
				identifier = "offensive"
			}
		},
		ogryn_2_tier_3_name_1 = {
			description = "loc_talent_bonebreaker_bigger_coherency_radius_desc",
			name = "Increased coherency radius",
			display_name = "loc_talent_bonebreaker_bigger_coherency_radius",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_3_1_b",
			format_values = {
				radius = talent_settings.coop_1.coherency_aura_size_increase * 100
			},
			passive = {
				buff_template_name = "ogryn_bonebreaker_bigger_coherency_radius",
				identifier = "coop"
			}
		},
		ogryn_2_tier_3_name_2 = {
			description = "loc_talent_bonebreaker_bull_rush_movement_speed_desc",
			name = "Allies in coherency gain movement speed when you use your Charge",
			display_name = "loc_talent_bonebreaker_bull_rush_movement_speed",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_1_3",
			format_values = {
				movement_speed = (talent_settings.coop_2.movement_speed - 1) * 100,
				time = talent_settings.coop_2.duration
			},
			passive = {
				buff_template_name = "ogryn_bonebreaker_charge_grants_allied_movement_speed",
				identifier = "coop"
			}
		},
		ogryn_2_tier_3_name_3 = {
			description = "loc_talent_bonebreaker_cooldown_on_elite_kills_desc",
			name = "Cooldown on your or allied elite kills",
			display_name = "loc_talent_bonebreaker_cooldown_on_elite_kills",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_4_1",
			format_values = {
				cooldown = talent_settings.coop_3.cooldown * 100
			},
			passive = {
				buff_template_name = "ogryn_bonebreaker_cooldown_on_elite_kills_by_coherence",
				identifier = "coop"
			}
		},
		ogryn_2_tier_4_name_1 = {
			description = "loc_talent_bonebreaker_damage_reduction_per_bleed_desc",
			name = "Take reduced damage per nearby bleeding enemy",
			display_name = "loc_talent_bonebreaker_damage_reduction_per_bleed",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_3_2",
			format_values = {
				damage_reduction = (1 - talent_settings.defensive_1.max) * 100 / talent_settings.defensive_1.max_stacks,
				max_stacks = talent_settings.defensive_1.max_stacks
			},
			passive = {
				buff_template_name = "ogryn_bonebreaker_reduce_damage_taken_per_bleed",
				identifier = "defensive"
			}
		},
		ogryn_2_tier_4_name_2 = {
			description = "loc_talent_bonebreaker_tanky_with_downed_allies_desc",
			name = "Reduce damage taken for each ally knocked down or disabled",
			display_name = "loc_talent_bonebreaker_tanky_with_downed_allies",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_2_2",
			format_values = {
				damage_taken = (1 - talent_settings.defensive_2.max) / 3 * 100
			},
			coherency = {
				buff_template_name = "ogryn_bonebreaker_reduce_damage_taken_on_disabled_allies",
				identifier = "increased_melee_heavy_damage"
			}
		},
		ogryn_2_tier_4_name_3 = {
			description = "loc_talent_bonebreaker_toughness_gain_increase_on_low_health_desc",
			name = "Increased toughness replenishment by 100% when below 25% health",
			display_name = "loc_talent_bonebreaker_toughness_gain_increase_on_low_health",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_3_3",
			format_values = {
				toughness_multiplier = talent_settings.defensive_3.toughness_replenish_multiplier * 100,
				health = talent_settings.defensive_3.increased_toughness_health_threshold * 100
			},
			passive = {
				buff_template_name = "ogryn_bonebreaker_increased_toughness_at_low_health",
				identifier = "defense"
			}
		},
		ogryn_2_tier_5_name_1 = {
			description = "loc_talent_bonebreaker_revenge_damage_desc",
			name = "WORK IN PROGRESS - Increases your damage against any enemy that damages you, for a few seconds",
			display_name = "loc_talent_bonebreaker_revenge_damage",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_3_1",
			format_values = {
				damage = talent_settings.offensive_2_1.damage * 100,
				time = talent_settings.offensive_2_1.time
			},
			passive = {
				buff_template_name = "ogryn_bonebreaker_revenge_damage",
				identifier = "specialization_passive"
			}
		},
		ogryn_2_tier_5_name_2 = {
			description = "loc_talent_bonebreaker_unlimited_cleave_on_fully_charged_desc",
			name = "Fully charged heavy attacks have unlimited cleave",
			display_name = "loc_talent_bonebreaker_unlimited_cleave_on_fully_charged",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_5_2",
			passive = {
				buff_template_name = "ogryn_bonebreaker_fully_charged_attacks_infinite_cleave",
				identifier = "offensive_2"
			}
		},
		ogryn_2_tier_5_name_3 = {
			description = "loc_talent_bonebreaker_damage_per_enemy_hit_previous_desc",
			name = "Hitting multiple enemies with one attack grants damage bonus on next target hit",
			display_name = "loc_talent_bonebreaker_damage_per_enemy_hit_previous",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_1_1",
			format_values = {
				damage = talent_settings.offensive_2_3.melee_damage * 100
			},
			passive = {
				buff_template_name = "ogryn_bonebreaker_hitting_multiple_with_melee_grants_melee_damage_bonus",
				identifier = "offensive_2"
			}
		},
		ogryn_2_tier_6_name_1 = {
			description = "loc_talent_bonebreaker_bleed_on_bull_rush_desc",
			name = "Apply Bleed to enemies hit by your Bull Rush",
			display_name = "loc_talent_bonebreaker_bleed_on_bull_rush",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_6_1",
			format_values = {
				stacks = talent_settings.combat_ability_1.stacks
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.ogryn_charge_bleed
			}
		},
		ogryn_2_tier_6_name_2 = {
			description = "loc_talent_bonebreaker_bull_rush_distance_desc",
			name = "Increase the travel distance of your Charge by 100%, and you can no longer be stopped by any enemy but monsters",
			display_name = "loc_talent_bonebreaker_bull_rush_distance",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_6_2",
			format_values = {
				distance = talent_settings.combat_ability_2.increase_visualizer * 100
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.ogryn_charge_increased_distance
			}
		},
		ogryn_2_tier_6_name_3 = {
			description = "loc_talent_bonebreaker_toughness_on_bull_rush_desc",
			name = "Replenish Toughness for each enemy hit during bull rush",
			display_name = "loc_talent_bonebreaker_toughness_on_bull_rush",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_6_3",
			format_values = {
				cooldown = talent_settings.combat_ability_3.cooldown,
				toughness = talent_settings.combat_ability_3.toughness * 100
			},
			passive = {
				buff_template_name = "ogryn_bonebreaker_bull_rush_hits_replenish_toughness",
				identifier = "combat_ability"
			}
		}
	}
}

return archetype_talents
