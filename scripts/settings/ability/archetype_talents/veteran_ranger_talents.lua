local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local TalentSettings = require("scripts/settings/buff/talent_settings")
local talent_settings = TalentSettings.veteran_2
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
	archetype = "veteran",
	specialization = "veteran_2",
	talents = {
		veteran_2_combat = {
			description = "loc_talent_veteran_2_combat_ability_description",
			name = "F-Ability - Mark elite and special enemies, gain a lot of ranged damage",
			display_name = "loc_talent_veteran_2_combat_ability",
			large_icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_combat",
			format_values = {
				duration = talent_settings.combat_ability.duration,
				damage = talent_settings.combat_ability.ranged_damage * 100,
				weakspot_damage = talent_settings.combat_ability.ranged_weakspot_damage
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
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tactical",
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.veteran_ranger_frag_grenade
			}
		},
		veteran_2_base_1 = {
			description = "loc_talent_veteran_2_passive_make_every_bullet_count_description",
			name = "Passive - Increased weakspot Damage",
			display_name = "loc_talent_veteran_2_passive_make_every_bullet_count",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_base_1",
			format_values = {
				damage = talent_settings.passive_1.weakspot_damage * 100
			},
			passive = {
				buff_template_name = "veteran_ranger_increase_weakspot_damage",
				identifier = "veteran_base_passive_1"
			}
		},
		veteran_2_base_2 = {
			description = "loc_talent_veteran_2_passive_increased_ammo_reserve_description",
			name = "Passive - Increased ammo reserve",
			display_name = "loc_talent_veteran_2_passive_increased_ammo_reserve",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_base_2",
			format_values = {
				capacity = talent_settings.passive_2.ammo_reserve_capacity * 100
			},
			passive = {
				buff_template_name = "veteran_ranger_increased_ammo_reserve",
				identifier = "veteran_base_passive"
			}
		},
		veteran_2_base_3 = {
			description = "loc_talent_ranger_elite_kills_grant_ammo_coop_desc",
			name = "Aura - Elite kills by you or your allies in coherency replenishes ammo to you and said allies",
			display_name = "loc_talent_ranger_elite_kills_grant_ammo_coop",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_aura",
			format_values = {},
			coherency = {
				buff_template_name = "veteran_ranger_elites_replenish_ammo",
				identifier = "elites_replenish_ammo"
			}
		},
		veteran_2_tier_1_name_1 = {
			description = "loc_talent_ranger_toughness_on_elite_kill_desc",
			name = "Significant Toughness on elite kill, and gain low toughness over 10 seconds",
			display_name = "loc_talent_ranger_toughness_on_elite_kill",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_1_1",
			format_values = {
				toughness = talent_settings.toughness_1.instant_toughness * 100,
				toughness_over_time = talent_settings.toughness_1.toughness * 1000
			},
			passive = {
				buff_template_name = "veteran_ranger_toughness_on_elite_kill",
				identifier = "toughness_regen"
			}
		},
		veteran_2_tier_1_name_2 = {
			description = "loc_talent_ranger_toughness_and_toughness_reduction_on_weakspot_kill_desc",
			name = "Medium Toughness on ranged weakspot kill",
			display_name = "loc_talent_ranger_toughness_on_weakspot_kill",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_3_1",
			format_values = {
				toughness = talent_settings.toughness_2.toughness * 100,
				toughness_damage_taken_multiplier = math_round((1 - talent_settings.toughness_2.toughness_damage_taken_multiplier) * 100),
				stacks = talent_settings.toughness_2.max_stacks,
				duration = talent_settings.toughness_2.duration
			},
			passive = {
				buff_template_name = "veteran_ranger_ranged_weakspot_toughness_recovery",
				identifier = "toughness_regen"
			}
		},
		veteran_2_tier_1_name_3 = {
			description = "loc_talent_ranger_toughness_regen_when_not_in_range_desc",
			name = "Low toughness regeneration when not in melee with an enemy",
			display_name = "loc_talent_ranger_toughness_regen_when_not_in_range",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_3_3",
			format_values = {
				toughness = talent_settings.toughness_3.toughness * 1000,
				range = talent_settings.toughness_3.range
			},
			passive = {
				buff_template_name = "veteran_ranger_toughness_regen_out_of_melee",
				identifier = "toughness_regen"
			}
		},
		veteran_2_tier_2_name_1 = {
			description = "loc_talent_ranger_damage_on_far_range_desc",
			name = "Deal more damage to far distance enemies",
			display_name = "loc_talent_ranger_damage_on_far_range",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_2_1",
			format_values = {
				max_damage = talent_settings.offensive_1_1.damage_far * 100
			},
			passive = {
				buff_template_name = "veteran_ranger_increase_ranged_far_damage",
				identifier = "offensive"
			}
		},
		veteran_2_tier_2_name_2 = {
			description = "loc_talent_ranger_reload_speed_empty_mag_desc",
			name = "Increased reload speed of non-empty magazines",
			display_name = "loc_talent_ranger_reload_speed_empty_mag",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_2_2",
			format_values = {
				reload_speed = talent_settings.offensive_1_2.reload_speed * 100
			},
			passive = {
				buff_template_name = "veteran_ranger_tactical_reload_speed",
				identifier = "offensive"
			}
		},
		veteran_2_tier_2_name_3 = {
			description = "loc_talent_ranger_replenish_grenade_desc",
			name = "You replenish a grenade every 60 seconds",
			display_name = "loc_talent_ranger_replenish_grenade",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_1_2",
			format_values = {
				amount = talent_settings.offensive_1_3.grenade_restored,
				time = talent_settings.offensive_1_3.grenade_replenishment_cooldown
			},
			passive = {
				buff_template_name = "veteran_ranger_grenade_replenishment",
				identifier = "offensive"
			}
		},
		veteran_2_tier_3_name_1 = {
			description = "loc_talent_ranger_volley_fire_outlines_for_allies_desc",
			name = "Allies in coherency also gain outlines for half the duration",
			display_name = "loc_talent_ranger_volley_fire_outlines_for_allies",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_4_1",
			special_rule = {
				identifier = "coop",
				special_rule_name = special_rules.veteran_ranger_combat_ability_outlines_for_coherency
			}
		},
		veteran_2_tier_3_name_2 = {
			description = "loc_talent_ranger_grenade_on_elite_kills_coop_desc",
			name = "You and allies in coherency have a chance to gain a grenade whenever you or an ally in coherency kills an elite enemy.",
			display_name = "loc_talent_ranger_grenade_on_elite_kills_coop",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_4_2",
			format_values = {
				chance = talent_settings.coop_2.proc_chance * 100
			},
			coherency = {
				buff_template_name = "veteran_ranger_elites_replenish_grenades",
				identifier = "elites_replenish_grenades"
			}
		},
		veteran_2_tier_3_name_3 = {
			description = "loc_talent_ranger_toughness_and_damage_for_allies_close_to_ranged_kills_desc",
			name = "Replenishes toughness to an ally when killing an enemy with a ranged attack that is in melee range of that ally.",
			display_name = "loc_talent_ranger_toughness_for_allies_close_to_ranged_kills",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_4_3",
			format_values = {
				toughness = talent_settings.coop_3.toughness_percent * 100,
				damage = talent_settings.coop_3.damage * 100,
				duration = talent_settings.coop_3.duration
			},
			passive = {
				buff_template_name = "veteran_ranger_replenish_toughness_of_ally_close_to_victim",
				identifier = "coop"
			}
		},
		veteran_2_tier_4_name_1 = {
			description = "loc_talent_ranger_reduced_toughness_during_volley_fire_desc",
			name = "Toughness damage taken reduction during Volley Fire",
			display_name = "loc_talent_ranger_reduced_toughness_during_volley_fire",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_4_1_b",
			format_values = {
				toughness_reduction = (1 - talent_settings.defensive_1.toughness_damage_taken_multiplier) * 100
			},
			special_rule = {
				identifier = "defensive",
				special_rule_name = special_rules.veteran_ranger_combat_ability_toughness_damage_reduction
			}
		},
		veteran_2_tier_4_name_2 = {
			description = "loc_talent_ranger_stamina_on_ranged_dodge_desc",
			name = "Dodging, Sprinting or Sliding to avoid ranged attacks grants stamina.",
			display_name = "loc_talent_ranger_stamina_on_ranged_dodge",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_3_2",
			format_values = {
				stamina = talent_settings.defensive_2.stamina_percent * 100
			},
			passive = {
				buff_template_name = "veteran_ranger_stamina_on_ranged_dodges",
				identifier = "defensive"
			}
		},
		veteran_2_tier_4_name_3 = {
			description = "loc_talent_ranger_reduced_threat_while_still_desc",
			name = "Enemies are less likely to target you when standing still",
			display_name = "loc_talent_ranger_reduced_threat_while_still",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_1_3",
			format_values = {},
			passive = {
				buff_template_name = "veteran_ranger_reduced_threat_gain",
				identifier = "mixed"
			}
		},
		veteran_2_tier_5_name_1 = {
			description = "loc_talent_ranger_grenades_apply_bleed_desc",
			name = "Frag grenades apply 1 stacks of bleed to all enemies hit.",
			display_name = "loc_talent_ranger_grenades_apply_bleed",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_5_1_b",
			format_values = {
				stacks = talent_settings.offensive_2_1.stacks
			},
			passive = {
				buff_template_name = "veteran_ranger_frag_grenade_bleed",
				identifier = "offensive_2"
			}
		},
		veteran_2_tier_5_name_2 = {
			description = "loc_talent_ranger_ads_drains_stamina_boost_desc",
			name = "ADS Drains stamina. If you ADS while not having 0 stamina, you gain crit and sway reduction",
			display_name = "loc_talent_ranger_ads_drains_stamina_boost",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_5_1",
			format_values = {
				crit_chance = talent_settings.offensive_2_2.critical_strike_chance * 100,
				sway_reduction = (1 - talent_settings.offensive_2_2.sway_modifier) * 100,
				stamina = talent_settings.offensive_2_2.stamina * 100,
				stamina_per_shot = talent_settings.offensive_2_2.shot_stamina_percent * 100
			},
			passive = {
				buff_template_name = "veteran_ranger_ads_stamina_boost",
				identifier = "offensive_2"
			}
		},
		veteran_2_tier_5_name_3 = {
			description = "loc_talent_ranger_reload_speed_on_elite_kills_desc",
			name = "The speed of your next reload after killing an elite is increased.",
			display_name = "loc_talent_ranger_reload_speed_on_elite_kills",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_5_3",
			format_values = {
				reload_speed = talent_settings.offensive_2_3.reload_speed * 100
			},
			passive = {
				buff_template_name = "veteran_ranger_elite_kills_reload_speed",
				identifier = "offensive_2"
			}
		},
		veteran_2_tier_6_name_1 = {
			description = "loc_talent_ranger_volley_fire_improved_desc",
			name = "Activating Volley Fire reloads your weapon and replenishes toughness. Killing a marked enemy during Volley Fire refreshes the duration of Volley Fire",
			display_name = "loc_talent_ranger_volley_fire_improved",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_6_2",
			format_values = {
				toughness = talent_settings.combat_ability.toughness * 100
			},
			special_rule = {
				identifier = {
					"veteran_ranger_combat_ability_refresh",
					"veteran_ranger_combat_ability_reloads_weapon",
					"veteran_ranger_combat_ability_replenishes_toughness"
				},
				special_rule_name = {
					special_rules.veteran_ranger_combat_ability_kills_refresh,
					special_rules.veteran_ranger_combat_ability_reloads_weapon,
					special_rules.veteran_ranger_combat_ability_replenishes_toughness
				}
			}
		},
		veteran_2_tier_6_name_2 = {
			description = "loc_talent_ranger_volley_fire_headhunter_desc",
			name = "Now outlines all ranged enemies. Gain weakspot damage during Volley Fire. Killing a marked enemy during Volley Fire refreshes the duration of Volley Fire",
			display_name = "loc_talent_ranger_volley_fire_headhunter",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_6_1",
			format_values = {
				weakspot_damage = (talent_settings.combat_ability_2.weakspot_damage - talent_settings.combat_ability.ranged_weakspot_damage) * 100
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.veteran_ranger_ranged_stance_headhunter
			},
			special_rule = {
				identifier = {
					"veteran_ranger_combat_ability_refresh",
					"veteran_ranger_combat_ability_headhunter"
				},
				special_rule_name = {
					special_rules.veteran_ranger_combat_ability_kills_refresh,
					special_rules.veteran_ranger_combat_ability_headhunter
				}
			}
		},
		veteran_2_tier_6_name_3 = {
			description = "loc_talent_ranger_volley_fire_big_game_hunter_desc",
			name = "Now also outlines Ogryns and Monsters. Damage vs Marked Targets increased by during Volley Fire. Killing a marked enemy during Volley Fire refreshes the duration of Volley Fire",
			display_name = "loc_talent_ranger_volley_fire_big_game_hunter",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_6_3_b",
			format_values = {
				damage = talent_settings.combat_ability_3.damage_vs_ogryn_and_monsters * 100
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.veteran_ranger_ranged_stance_big_game_hunter
			},
			special_rule = {
				identifier = {
					"veteran_ranger_combat_ability_refresh",
					"veteran_ranger_combat_ability_big_game_hunter"
				},
				special_rule_name = {
					special_rules.veteran_ranger_combat_ability_kills_refresh,
					special_rules.veteran_ranger_combat_ability_big_game_hunter
				}
			}
		}
	}
}

return archetype_talents
