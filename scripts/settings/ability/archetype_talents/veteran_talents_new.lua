local ArmorSettings = require("scripts/settings/damage/armor_settings")
local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings_new")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local WeaponTemplates = require("scripts/settings/equipment/weapon_templates/weapon_templates")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local talent_settings_2 = TalentSettings.veteran_2
local talent_settings_3 = TalentSettings.veteran_3
local special_rules = SpecialRulesSetting.special_rules
local stat_buffs = BuffSettings.stat_buffs
local plasmagun_p1_m1 = WeaponTemplates.plasmagun_p1_m1
local improved_medical_crate = BuffSettings.keyword_settings[BuffSettings.keywords.improved_medical_crate]
local smoke_grenade = ProjectileTemplates.smoke_grenade
local armor_types = ArmorSettings.types
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
		veteran_frag_grenade = {
			description = "loc_ability_frag_grenade_description",
			name = "BASE: Frag Grenade",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			display_name = "loc_ability_frag_grenade",
			icon = "content/ui/textures/icons/talents/veteran/veteran_blitz_frag_grenade",
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.veteran_frag_grenade
			}
		},
		veteran_krak_grenade = {
			description = "loc_talent_ability_krak_grenade_desc",
			name = "Swap to Krak Grenade",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			display_name = "loc_talent_ability_krak_grenade",
			icon = "content/ui/textures/icons/talents/veteran_3/veteran_3_tactical",
			format_values = {
				talent_name = {
					value = "loc_talent_ability_krak_grenade",
					format_type = "loc_string"
				}
			},
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.veteran_krak_grenade
			},
			dev_info = {
				{
					damage_profile_name = "close_krak_grenade",
					info_func = "damage_profile"
				}
			}
		},
		veteran_smoke_grenade = {
			description = "loc_ability_smoke_grenade_description",
			name = "Swap to Smoke Grenade",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			display_name = "loc_ability_smoke_grenade",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_1_tactical",
			format_values = {
				talent_name = {
					value = "loc_ability_smoke_grenade",
					format_type = "loc_string"
				},
				duration = {
					format_type = "number",
					value = smoke_grenade.damage.fuse.spawn_unit.unit_template_parameters.duration
				}
			},
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.veteran_smoke_grenade
			}
		},
		veteran_extra_grenade = {
			description = "loc_talent_veteran_extra_grenade_description",
			name = "X amount of extra grenades",
			display_name = "loc_talent_veteran_extra_grenade",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_base_4",
			format_values = {
				ammo = {
					format_type = "value",
					find_value = {
						buff_template_name = "veteran_extra_grenade",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.extra_max_amount_of_grenades
						}
					}
				}
			},
			passive = {
				buff_template_name = "veteran_extra_grenade",
				identifier = "veteran_extra_grenade"
			}
		},
		veteran_improved_grenades = {
			description = "loc_talent_veteran_improved_grenades_desc",
			name = "Selected grenade are improved",
			display_name = "loc_talent_veteran_improved_grenades",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_base_4",
			format_values = {
				krak_grenade = {
					value = "loc_ability_krak_grenade",
					format_type = "loc_string"
				},
				frag_grenade = {
					value = "loc_ability_frag_grenade",
					format_type = "loc_string"
				},
				smoke_grenade = {
					value = "loc_ability_smoke_grenade",
					format_type = "loc_string"
				},
				frag_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_improved_grenades",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.frag_damage
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				},
				frag_radius = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_improved_grenades",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.explosion_radius_modifier_frag
						}
					},
					value_manipulation = function (value)
						return (value - 1) * 100
					end
				},
				krak = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_improved_grenades",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.krak_damage
						}
					}
				},
				smoke = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_improved_grenades",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.smoke_fog_duration_modifier
						}
					}
				}
			},
			passive = {
				buff_template_name = "veteran_improved_grenades",
				identifier = "veteran_improved_grenades"
			}
		},
		veteran_combat_ability_stance = {
			description = "loc_ability_veteran_base_ability_desc",
			name = "Recharge toughness",
			display_name = "loc_talent_veteran_2_combat_ability",
			large_icon = "content/ui/textures/icons/talents/veteran/veteran_ability_volley_fire_stance",
			icon = "content/ui/textures/icons/talents/veteran/veteran_ability_volley_fire_stance",
			format_values = {
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings_2.combat_ability.ranged_damage
				},
				weakspot_damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings_2.combat_ability.ranged_weakspot_damage
				},
				duration = {
					format_type = "number",
					value = talent_settings_2.combat_ability.duration
				},
				cooldown = {
					format_type = "number",
					value = PlayerAbilities.veteran_combat_ability_stance.cooldown
				}
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.veteran_combat_ability_stance
			},
			special_rule = {
				identifier = "veteran_combat_ability_stance",
				special_rule_name = special_rules.veteran_combat_ability_stance
			},
			passive = {
				buff_template_name = "veteran_combat_ability_increased_ranged_and_weakspot_damage_base",
				identifier = "veteran_combat_ability_increased_ranged_and_weakspot_damage_base"
			}
		},
		veteran_ads_drain_stamina = {
			description = "loc_talent_veteran_ads_drains_stamina_boost_desc",
			name = "ADS drain Stamina, grants Crit and Sway Boost",
			display_name = "loc_talent_ranger_ads_drains_stamina_boost",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_5_1",
			format_values = {
				crit_chance = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings_2.offensive_2_2.critical_strike_chance
				},
				sway_reduction = {
					prefix = "+",
					format_type = "percentage",
					value = 1 - talent_settings_2.offensive_2_2.sway_modifier
				},
				stamina = {
					format_type = "percentage",
					value = talent_settings_2.offensive_2_2.stamina
				},
				stamina_per_shot = {
					format_type = "percentage",
					value = talent_settings_2.offensive_2_2.shot_stamina_percent
				}
			},
			passive = {
				buff_template_name = "veteran_ads_stamina_boost",
				identifier = "veteran_ads_stamina_boost"
			}
		},
		veteran_combat_ability_reloads_secondary_weapon = {
			description = "loc_talent_veteran_combat_ability_wields_and_reloads_secondary_weapon_description",
			name = "Ability reloads ranged weapon",
			display_name = "loc_talent_veteran_combat_ability_wields_and_reloads_secondary_weapon",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_base_4",
			format_values = {},
			special_rule = {
				identifier = "veteran_combat_ability_reloads_secondary_weapon",
				special_rule_name = special_rules.veteran_combat_ability_reloads_secondary_weapon
			}
		},
		veteran_combat_ability_elite_and_special_outlines = {
			description = "loc_talent_veteran_combat_ability_elite_and_special_outlines_description",
			name = "Ability outlines elites + specials",
			display_name = "loc_talent_veteran_combat_ability_elite_and_special_outlines",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_base_4",
			format_values = {
				talent_name = {
					value = "loc_talent_veteran_combat_ability_elite_and_special_outlines",
					format_type = "loc_string"
				},
				duration = {
					format_type = "number",
					value = talent_settings_2.combat_ability.duration
				},
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings_2.combat_ability.ranged_damage
				},
				weakspot_damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings_2.combat_ability.ranged_weakspot_damage
				},
				cooldown = {
					format_type = "number",
					value = PlayerAbilities.veteran_combat_ability_stance.cooldown
				},
				old_talent_name = {
					value = "loc_talent_veteran_2_combat_ability",
					format_type = "loc_string"
				}
			},
			special_rule = {
				identifier = {
					"veteran_combat_ability_stance",
					"veteran_combat_ability_outlines",
					"veteran_combat_ability_elite_and_special_outlines"
				},
				special_rule_name = {
					special_rules.veteran_combat_ability_stance,
					special_rules.veteran_combat_ability_outlines,
					special_rules.veteran_combat_ability_elite_and_special_outlines
				}
			},
			passive = {
				buff_template_name = "veteran_combat_ability_increased_ranged_and_weakspot_damage_outlines",
				identifier = "veteran_combat_ability_increased_ranged_and_weakspot_damage_outlines"
			}
		},
		veteran_combat_ability_ranged_roamer_outlines = {
			description = "loc_talent_veteran_combat_ability_ranged_enemies_outlines_description",
			name = "Ranged targets gets outline + ranged weakspot damge bonus",
			display_name = "loc_talent_veteran_combat_ability_ranged_enemies_outlines",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_base_4",
			format_values = {
				talent_name = {
					value = "loc_talent_veteran_combat_ability_elite_and_special_outlines",
					format_type = "loc_string"
				}
			},
			special_rule = {
				identifier = {
					"veteran_combat_ability_outlines",
					"veteran_combat_ability_ranged_roamer_outlines"
				},
				special_rule_name = {
					special_rules.veteran_combat_ability_outlines,
					special_rules.veteran_combat_ability_ranged_roamer_outlines
				}
			}
		},
		veteran_combat_ability_coherency_outlines = {
			description = "loc_talent_veteran_combat_ability_coherency_outlines_description",
			name = "Ability applies outline allies in coherency",
			display_name = "loc_talent_veteran_combat_ability_coherency_outlines",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_base_4",
			format_values = {
				talent_name = {
					value = "loc_talent_veteran_combat_ability_elite_and_special_outlines",
					format_type = "loc_string"
				},
				duration = {
					format_type = "number",
					value = talent_settings_2.combat_ability.outline_duration
				}
			},
			special_rule = {
				identifier = {
					"veteran_combat_ability_outlines",
					"veteran_combat_ability_coherency_outlines"
				},
				special_rule_name = {
					special_rules.veteran_combat_ability_outlines,
					special_rules.veteran_combat_ability_coherency_outlines
				}
			}
		},
		veteran_combat_ability_melee_and_ranged_damage_to_coherency = {
			description = "loc_talent_veteran_combat_ability_melee_and_ranged_damage_to_coherency_description",
			name = "Ability grants allies Melee and Ranged damage",
			display_name = "loc_talent_veteran_combat_ability_melee_and_ranged_damage_to_coherency",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_base_4",
			format_values = {
				talent_name = {
					value = "loc_ability_veteran_base_ability",
					format_type = "loc_string"
				},
				melee_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_combat_ability_increased_melee_and_ranged_damage",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_damage
						}
					}
				},
				ranged_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_combat_ability_increased_melee_and_ranged_damage",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ranged_damage
						}
					}
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "veteran_combat_ability_increased_melee_and_ranged_damage",
						find_value_type = "buff_template",
						path = {
							"duration"
						}
					}
				}
			},
			passive = {
				buff_template_name = "veteran_combat_ability_melee_and_ranged_damage_to_coherency",
				identifier = "veteran_combat_ability_melee_and_ranged_damage_to_coherency"
			}
		},
		veteran_combat_ability_increase_and_restore_toughness_to_coherency = {
			description = "loc_talent_veteran_combat_ability_increase_and_restore_toughness_to_coherency_description",
			name = "Increases Max Toughness + Restores",
			display_name = "loc_talent_veteran_combat_ability_increase_and_restore_toughness_to_coherency",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_base_4",
			format_values = {
				talent_name = {
					value = "loc_talent_veteran_combat_ability_stagger_nearby_enemies",
					format_type = "loc_string"
				},
				toughness = {
					prefix = "+",
					format_type = "number",
					find_value = {
						buff_template_name = "veteran_combat_ability_increase_toughness_to_coherency",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_bonus_flat
						}
					}
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "veteran_combat_ability_increase_toughness_to_coherency",
						find_value_type = "buff_template",
						path = {
							"duration"
						}
					}
				}
			},
			special_rule = {
				identifier = "veteran_combat_ability_increase_and_restore_toughness_to_coherency",
				special_rule_name = special_rules.veteran_combat_ability_increase_and_restore_toughness_to_coherency
			}
		},
		veteran_combat_ability_outlined_kills_extends_duration = {
			description = "loc_talent_veteran_combat_ability_outlined_kills_extends_duration_description",
			name = "Refresh on Outline Kill, cd starts on buff end",
			display_name = "loc_talent_veteran_combat_ability_outlined_kills_extends_duration",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_base_4",
			format_values = {
				talent_name = {
					value = "loc_talent_veteran_combat_ability_elite_and_special_outlines",
					format_type = "loc_string"
				},
				duration = {
					format_type = "number",
					value = talent_settings_2.combat_ability.duration
				}
			},
			special_rule = {
				identifier = "veteran_combat_ability_outlined_kills_extends_duration",
				special_rule_name = special_rules.veteran_combat_ability_outlined_kills_extends_duration
			}
		},
		veteran_combat_ability_stagger_nearby_enemies = {
			description = "loc_talent_veteran_combat_ability_stagger_nearby_enemies_description",
			name = "Ability Stagger Nearby Enemies On active",
			display_name = "loc_talent_veteran_combat_ability_stagger_nearby_enemies",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_base_4",
			format_values = {
				talent_name = {
					value = "loc_talent_veteran_combat_ability_stagger_nearby_enemies",
					format_type = "loc_string"
				},
				range = {
					format_type = "number",
					value = talent_settings_3.combat_ability.radius
				},
				cooldown = {
					format_type = "number",
					value = PlayerAbilities.veteran_combat_ability_shout.cooldown
				}
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.veteran_combat_ability_shout
			},
			special_rule = {
				identifier = "veteran_combat_ability_stagger_nearby_enemies",
				special_rule_name = special_rules.veteran_combat_ability_stagger_nearby_enemies
			}
		},
		veteran_combat_ability_revive_nearby_allies = {
			description = "loc_talent_veteran_combat_ability_revives_description",
			name = "Your shout now revives knocked down allies in coherency",
			display_name = "loc_talent_veteran_combat_ability_revives",
			icon = "content/ui/textures/icons/talents/veteran_3/veteran_3_tier_6_3",
			format_values = {
				talent_name = {
					value = "loc_talent_veteran_combat_ability_stagger_nearby_enemies",
					format_type = "loc_string"
				},
				ability_cooldown = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_combat_ability_revive_nearby_allies",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.combat_ability_cooldown_modifier
						}
					}
				},
				range = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_combat_ability_revive_nearby_allies",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.shout_radius_modifier
						}
					},
					value_manipulation = function (value)
						return math_round(math.abs(value) * 100)
					end
				}
			},
			special_rule = {
				identifier = "squad_leader_shout_special_rule",
				special_rule_name = special_rules.shout_revives_allies
			},
			passive = {
				buff_template_name = "veteran_combat_ability_revive_nearby_allies",
				identifier = "veteran_combat_ability_revive_nearby_allies"
			}
		},
		veteran_combat_ability_extra_charge = {
			description = "loc_talent_veteran_combat_ability_extra_charge_description",
			name = "Extra ability charge",
			display_name = "loc_talent_veteran_combat_ability_extra_charge",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_base_4",
			format_values = {
				talent_name = {
					value = "loc_ability_veteran_base_ability",
					format_type = "loc_string"
				},
				charges = {
					prefix = "+",
					format_type = "number",
					find_value = {
						buff_template_name = "veteran_combat_ability_extra_charge",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ability_extra_charges
						}
					}
				},
				ability_cooldown = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_combat_ability_extra_charge",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.combat_ability_cooldown_modifier
						}
					}
				}
			},
			passive = {
				buff_template_name = "veteran_combat_ability_extra_charge",
				identifier = "veteran_combat_ability_extra_charge"
			}
		},
		veteran_aura_gain_ammo_on_elite_kill = {
			description = "loc_talent_veteran_elite_kills_grant_ammo_coop_desc",
			name = "Elite Kills Restore Ammo Aura - Elite kills by you or your allies in coherency replenishes ammo to you and said allies",
			display_name = "loc_talent_veteran_elite_kills_grant_ammo_coop",
			icon = "content/ui/textures/icons/talents/veteran/veteran_aura_scavengers_base",
			format_values = {
				ammo = {
					format_type = "percentage",
					value = talent_settings_2.coherency.ammo_replenishment_percent
				}
			},
			coherency = {
				identifier = "veteran_aura",
				priority = 1,
				buff_template_name = "veteran_aura_gain_ammo_on_elite_kill"
			}
		},
		veteran_aura_gain_ammo_on_elite_kill_improved = {
			description = "loc_talent_veteran_elite_kills_grant_ammo_coop_improved_desc",
			name = "Elite Kills Restore Ammo Aura - Elite kills by you or your allies in coherency replenishes ammo to you and said allies",
			display_name = "loc_talent_veteran_elite_kills_grant_ammo_coop_improved",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_aura",
			format_values = {
				talent_name = {
					value = "loc_talent_veteran_elite_kills_grant_ammo_coop",
					format_type = "loc_string"
				},
				ammo_1 = {
					format_type = "percentage",
					value = talent_settings_2.coherency.ammo_replenishment_percent
				},
				ammo_2 = {
					format_type = "percentage",
					value = talent_settings_2.coherency.ammo_replenishment_percent_improved
				}
			},
			coherency = {
				identifier = "veteran_aura",
				priority = 2,
				buff_template_name = "veteran_aura_gain_ammo_on_elite_kill_improved"
			}
		},
		veteran_increased_damage_coherency = {
			description = "loc_talent_veteran_damage_coherency_desc",
			name = "Aura: Increased Damage",
			display_name = "loc_talent_veteran_damage_coherency",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_4_2",
			format_values = {
				damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_damage_coherency",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.damage
						}
					}
				}
			},
			coherency = {
				identifier = "veteran_aura",
				priority = 2,
				buff_template_name = "veteran_damage_coherency"
			}
		},
		veteran_movement_speed_coherency = {
			description = "loc_talent_veteran_movement_speed_coherency_desc",
			name = "AURA: Increased Movement Speed",
			display_name = "loc_talent_veteran_movement_speed_coherency",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_4_2",
			format_values = {
				movement_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_movement_speed_coherency",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.movement_speed
						}
					}
				}
			},
			coherency = {
				identifier = "veteran_aura",
				priority = 2,
				buff_template_name = "veteran_movement_speed_coherency"
			}
		},
		veteran_elite_kills_reduce_cooldown = {
			description = "loc_talent_veteran_elite_kills_reduce_cooldown_desc",
			name = "Elite kills reduce Combat Ability CD - Reduce cooldown of F-Ability by 6 seconds when killing an elite",
			display_name = "loc_talent_veteran_elite_kills_reduce_cooldown",
			icon = "content/ui/textures/icons/talents/veteran_3/veteran_3_base_1",
			format_values = {
				talent_name = {
					value = "loc_ability_veteran_base_ability",
					format_type = "loc_string"
				},
				duration = {
					format_type = "number",
					value = talent_settings_3.passive_1.cooldown_reduction
				}
			},
			passive = {
				buff_template_name = "veteran_combat_ability_cooldown_reduction_on_elite_kills",
				identifier = "veteran_combat_ability_cooldown_reduction_on_elite_kills"
			}
		},
		veteran_ally_kills_increase_damage = {
			description = "loc_talent_veteran_ally_kills_increase_damage_description",
			name = "Ally Kills can increase your damage and suppression - Allied kills have a chance to increase your damage, melee impact, and suppression by 20% for 8 seconds",
			display_name = "loc_talent_veteran_ally_kills_increase_damage",
			icon = "content/ui/textures/icons/talents/veteran_3/veteran_3_tier_2_3",
			format_values = {
				proc_chance = {
					format_type = "percentage",
					value = talent_settings_3.offensive_3.on_minion_death_proc_chance
				},
				damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_allies_kills_damage_buff",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.damage
						}
					}
				},
				melee_impact = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_allies_kills_damage_buff",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_impact_modifier
						}
					}
				},
				suppression = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_allies_kills_damage_buff",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.suppression_dealt
						}
					}
				},
				duration = {
					format_type = "number",
					value = talent_settings_3.offensive_3.active_duration
				}
			},
			passive = {
				buff_template_name = "veteran_allies_kills_chance_to_trigger_increased_damage",
				identifier = "veteran_squad_leader_offensive_passive"
			}
		},
		veteran_increased_damage_based_on_range = {
			description = "loc_talent_veteran_increased_damage_based_on_range_desc",
			name = "Deal increased damage based on ranged to target - Deal more damage to far distance enemies",
			display_name = "loc_talent_veteran_increased_damage_based_on_range",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_2_1",
			format_values = {
				max_damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings_2.offensive_1_1.damage_far
				}
			},
			passive = {
				buff_template_name = "veteran_increase_ranged_far_damage",
				identifier = "veteran_increase_ranged_far_damage"
			}
		},
		veteran_increase_suppression = {
			description = "loc_talent_veteran_increase_suppression_desc",
			name = "Suppression increase",
			display_name = "loc_talent_veteran_increase_suppression",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_2_1",
			format_values = {
				suppression = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_increase_suppression",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.suppression_dealt
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "veteran_increase_suppression",
				identifier = "veteran_increase_suppression"
			}
		},
		veteran_increase_damage_vs_elites = {
			description = "loc_talent_veteran_increase_damage_vs_elites_desc",
			name = "Elite Damage increase",
			display_name = "loc_talent_veteran_increase_damage_vs_elites",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_2_1",
			format_values = {
				damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_increase_elite_damage",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.damage_vs_elites
						}
					}
				}
			},
			passive = {
				buff_template_name = "veteran_increase_elite_damage",
				identifier = "veteran_increase_elite_damage"
			}
		},
		veteran_increase_crit_chance = {
			description = "loc_talent_veteran_damage_increase_crit_chance_desc",
			name = "Increased crit chance",
			display_name = "loc_talent_veteran_damage_increase_crit_chance",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_2_1",
			format_values = {
				crit_chance = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_increase_crit_chance",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.critical_strike_chance
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "veteran_increase_crit_chance",
				identifier = "veteran_increase_crit_chance"
			}
		},
		veteran_increase_damage_after_sprinting = {
			description = "loc_talent_veteran_damage_damage_after_sprinting_desc",
			name = "Sprinting increases damage by X% for Y seconds",
			display_name = "loc_talent_veteran_damage_damage_after_sprinting",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_2_1",
			format_values = {
				base_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_damage_after_sprinting_buff",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.damage
						}
					}
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "veteran_damage_after_sprinting_buff",
						find_value_type = "buff_template",
						path = {
							"duration"
						}
					}
				},
				stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "veteran_damage_after_sprinting_buff",
						find_value_type = "buff_template",
						path = {
							"max_stacks"
						}
					}
				}
			},
			passive = {
				buff_template_name = "veteran_damage_after_sprinting",
				identifier = "veteran_damage_after_sprinting"
			}
		},
		veteran_reload_speed_on_elite_kill = {
			description = "loc_talent_veteran_reload_speed_on_elite_kill_desc",
			name = "Faster reload after Elite Kills -The speed of your next reload after killing an elite is increased.",
			display_name = "loc_talent_veteran_reload_speed_on_elite_kill",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_5_3",
			format_values = {
				reload_speed = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings_2.offensive_2_3.reload_speed
				}
			},
			passive = {
				buff_template_name = "veteran_reload_speed_on_elite_kill",
				identifier = "veteran_reload_speed_on_elite_kill"
			}
		},
		veteran_increased_weakspot_damage = {
			description = "loc_talent_veteran_increased_weakspot_damage_desc",
			name = "Increased Weakspot Damage",
			display_name = "loc_talent_veteran_increased_weakspot_damage",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_base_1",
			format_values = {
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings_2.passive_1.weakspot_damage
				}
			},
			passive = {
				buff_template_name = "veteran_increased_weakspot_damage",
				identifier = "veteran_base_passive_1"
			}
		},
		veteran_grenade_apply_bleed = {
			description = "loc_talent_veteran_grenade_apply_bleed_desc",
			name = "Grenade applies Bleed to targets hit - Frag grenades apply 1 stacks of bleed to all enemies hit.",
			display_name = "loc_talent_veteran_grenade_apply_bleed",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_5_1_b",
			format_values = {
				talent_name = {
					value = "loc_ability_frag_grenade",
					format_type = "loc_string"
				},
				stacks = {
					format_type = "number",
					value = talent_settings_2.offensive_2_1.stacks
				}
			},
			passive = {
				buff_template_name = "veteran_frag_grenade_bleed",
				identifier = "veteran_frag_grenade_bleed"
			},
			dev_info = {
				{
					value = "Bleed: damage is at max stacks",
					info_func = "text"
				},
				{
					info_func = "buff_template",
					buff_template_name = "bleed",
					values_to_show = {
						{
							format_type = "number",
							path = {
								"duration"
							}
						},
						{
							format_type = "number",
							path = {
								"interval"
							}
						},
						{
							format_type = "number",
							path = {
								"max_stacks"
							}
						}
					}
				},
				{
					damage_profile_name = "bleeding",
					info_func = "damage_profile"
				}
			}
		},
		veteran_big_game_hunter = {
			description = "loc_talent_veteran_big_game_hunter_description",
			name = "Deal increased damage to ogryns and monsters",
			display_name = "loc_talent_veteran_big_game_hunter",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_1_3",
			format_values = {
				damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_big_game_hunter",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.damage_vs_ogryn_and_monsters
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "veteran_big_game_hunter",
				identifier = "veteran_big_game_hunter"
			}
		},
		veteran_crits_apply_rending = {
			description = "loc_talent_veteran_crits_rend_description",
			name = "Crits apply rending",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			display_name = "loc_talent_veteran_crits_rend",
			icon = "content/ui/textures/icons/talents/veteran_3/veteran_3_tier_2_2",
			format_values = {
				rending_multiplier = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "rending_debuff",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.rending_multiplier
						}
					}
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "rending_debuff",
						find_value_type = "buff_template",
						path = {
							"duration"
						}
					}
				},
				max_stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "rending_debuff",
						find_value_type = "buff_template",
						path = {
							"max_stacks"
						}
					}
				}
			},
			passive = {
				buff_template_name = "veteran_crits_apply_rending",
				identifier = "veteran_crits_apply_rending"
			}
		},
		veteran_continous_hits_apply_rending = {
			description = "loc_talent_veteran_continous_hits_apply_rending_description",
			name = "Continuous hits applies rending - Consecutive hits apply rending. Stacking up to X times",
			display_name = "loc_talent_veteran_continous_hits_apply_rending",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			icon = "content/ui/textures/icons/talents/veteran_3/veteran_3_tier_2_2",
			format_values = {
				rending_multiplier = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "rending_debuff",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.rending_multiplier
						}
					}
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "rending_debuff",
						find_value_type = "buff_template",
						path = {
							"duration"
						}
					}
				},
				max_stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "rending_debuff",
						find_value_type = "buff_template",
						path = {
							"max_stacks"
						}
					}
				}
			},
			passive = {
				buff_template_name = "veteran_consecutive_hits_apply_rending",
				identifier = "veteran_consecutive_hits_apply_rending"
			}
		},
		veteran_dodging_grants_crit = {
			description = "loc_talent_veteran_dodging_grants_crit_description",
			name = "Dodging an attack grants crit chance",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			display_name = "loc_talent_veteran_dodging_grants_crit",
			icon = "content/ui/textures/icons/talents/veteran_3/veteran_3_tier_2_2",
			format_values = {
				crit_chance = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_dodging_crit_buff",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.critical_strike_chance
						}
					}
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "veteran_dodging_crit_buff",
						find_value_type = "buff_template",
						path = {
							"duration"
						}
					}
				},
				stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "veteran_dodging_crit_buff",
						find_value_type = "buff_template",
						path = {
							"max_stacks"
						}
					}
				}
			},
			passive = {
				buff_template_name = "veteran_dodging_grants_crit",
				identifier = "veteran_dodging_grants_crit"
			}
		},
		veteran_coherency_aura_size_increase = {
			description = "loc_talent_veteran_increased_aura_radius_description",
			name = "Enemies are less likely to target you when standing still",
			display_name = "loc_talent_veteran_increased_aura_radius",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_1_3",
			format_values = {
				radius = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_coherency_aura_size_increase",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.coherency_radius_modifier
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "veteran_coherency_aura_size_increase",
				identifier = "veteran_coherency_aura_size_increase"
			}
		},
		veteran_reduced_threat_when_still = {
			description = "loc_talent_veteran_reduced_threat_when_still_desc",
			name = "Enemies are less likely to target you when standing still",
			display_name = "loc_talent_veteran_reduced_threat_when_still",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_1_3",
			format_values = {
				threat_multiplier = {
					format_type = "percentage",
					value = 1 - talent_settings_2.defensive_3.threat_weight_multiplier
				}
			},
			passive = {
				buff_template_name = "veteran_reduced_threat_gain",
				identifier = "mixed"
			}
		},
		veteran_reduced_threat_after_combat_ability = {
			description = "loc_talent_veteran_reduced_threat_after_stealth_desc",
			name = "After using combat ability all threat is greatly reduced",
			display_name = "loc_talent_veteran_reduced_threat_after_combat_ability",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_1_3",
			format_values = {
				threat_multiplier = {
					prefix = "-",
					format_type = "percentage",
					value = 1 - talent_settings_2.defensive_3.threat_weight_multiplier
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "veteran_reduced_threat_generation",
						find_value_type = "buff_template",
						path = {
							"duration"
						}
					}
				},
				talent_name = {
					value = "loc_talent_veteran_invisibility_on_combat_ability",
					format_type = "loc_string"
				}
			},
			passive = {
				buff_template_name = "veteran_buffs_after_combat_ability",
				identifier = "veteran_buffs_after_combat_ability"
			},
			special_rule = {
				identifier = "veteran_reduced_threat_after_combat_ability",
				special_rule_name = special_rules.veteran_reduced_threat_after_combat_ability
			}
		},
		veteran_increased_close_damage_after_combat_ability = {
			description = "loc_talent_veteran_ability_assault_desc",
			name = "After using combat ability close damage is increased",
			display_name = "loc_talent_veteran_ability_assault",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_1_3",
			format_values = {
				power = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_increased_close_damage_after_combat_ability",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.damage_near
						}
					}
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "veteran_increased_close_damage_after_combat_ability",
						find_value_type = "buff_template",
						path = {
							"duration"
						}
					}
				},
				talent_name = {
					value = "loc_talent_veteran_invisibility_on_combat_ability",
					format_type = "loc_string"
				}
			},
			passive = {
				buff_template_name = "veteran_buffs_after_combat_ability",
				identifier = "veteran_buffs_after_combat_ability"
			},
			special_rule = {
				identifier = "veteran_increased_close_damage_after_combat_ability",
				special_rule_name = special_rules.veteran_increased_close_damage_after_combat_ability
			}
		},
		veteran_increased_weakspot_power_after_combat_ability = {
			description = "loc_talent_veteran_ability_marksman_desc",
			name = "After using combat ability close damage is increased",
			display_name = "loc_talent_veteran_ability_marksman",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_1_3",
			format_values = {
				power = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_increased_weakspot_power_after_combat_ability",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.weakspot_power_level_modifier
						},
						value_manipulation = function (value)
							return value - 1
						end
					}
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "veteran_increased_weakspot_power_after_combat_ability",
						find_value_type = "buff_template",
						path = {
							"duration"
						}
					}
				},
				talent_name = {
					value = "loc_talent_veteran_invisibility_on_combat_ability",
					format_type = "loc_string"
				}
			},
			passive = {
				buff_template_name = "veteran_buffs_after_combat_ability",
				identifier = "veteran_buffs_after_combat_ability"
			},
			special_rule = {
				identifier = "veteran_increased_weakspot_power_after_combat_ability",
				special_rule_name = special_rules.veteran_increased_weakspot_power_after_combat_ability
			}
		},
		veteran_supression_immunity = {
			description = "loc_talent_veteran_supression_immunity_desc",
			name = "Suppression Immunity",
			display_name = "loc_talent_veteran_supression_immunity",
			icon = "content/ui/textures/icons/talents/veteran_3/veteran_3_base_2",
			passive = {
				buff_template_name = "veteran_suppression_immunity",
				identifier = "veteran_suppression_immunity"
			}
		},
		veteran_reduced_toughness_damage_in_coherency = {
			description = "loc_talent_veteran_toughness_damage_reduction_per_ally_description",
			name = "Reduce toughness damage taken by X% for each ally in coherency",
			display_name = "loc_talent_veteran_toughness_damage_reduction_per_ally",
			icon = "content/ui/textures/icons/talents/veteran_3/veteran_3_tier_1_1",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings_3.toughness_1.max,
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end
				}
			},
			passive = {
				buff_template_name = "veteran_toughness_damage_reduction_per_ally_in_coherency",
				identifier = "veteran_toughness_damage_reduction_per_ally_in_coherency"
			}
		},
		veteran_all_kills_replenish_toughness = {
			description = "loc_talent_veteran_all_kills_replenish_toughness_description",
			name = "All kills replenish an additional X% of your total toughness",
			display_name = "loc_talent_veteran_all_kills_replenish_toughness",
			icon = "content/ui/textures/icons/talents/veteran_3/veteran_3_tier_1_3",
			format_values = {
				toughness = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_all_kills_replenish_bonus_toughness",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"toughness_percentage"
						}
					}
				}
			},
			passive = {
				buff_template_name = "veteran_all_kills_replenish_bonus_toughness",
				identifier = "veteran_all_kills_replenish_bonus_toughness"
			}
		},
		veteran_elite_kills_replenish_toughness = {
			description = "loc_talent_veteran_toughness_on_elite_kill_desc",
			name = "Elite Kills Replenish Toughness Instantly and Over time- Significant Toughness on elite kill, and gain low toughness over 10 seconds",
			display_name = "loc_talent_veteran_toughness_on_elite_kill",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_1_1",
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings_2.toughness_1.instant_toughness
				},
				toughness_over_time = {
					format_type = "percentage",
					value = talent_settings_2.toughness_1.toughness * talent_settings_2.toughness_1.duration
				},
				duration = {
					format_type = "number",
					value = talent_settings_2.toughness_1.duration
				}
			},
			passive = {
				buff_template_name = "veteran_toughness_on_elite_kill",
				identifier = "veteran_toughness_on_elite_kill"
			}
		},
		veteran_increased_explosion_radius = {
			description = "loc_talent_veteran_increased_explosion_radius_desc",
			name = "Increase explosion AoE",
			display_name = "loc_talent_veteran_increased_explosion_radius",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tactical",
			format_values = {
				explosion_radius = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_increased_explosion_radius",
						find_value_type = "buff_template",
						path = {
							"proc_stat_buffs",
							stat_buffs.spread_modifier
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "veteran_increased_explosion_radius",
				identifier = "explosion_radius"
			}
		},
		veteran_ranged_power_out_of_melee = {
			description = "loc_talent_veteran_ranged_power_out_of_melee_desc",
			name = "No enemies within X radius grants Y ranged power - X% Ranged power bonus when out of melee combat",
			display_name = "loc_talent_veteran_ranged_power_out_of_melee",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tactical",
			format_values = {
				ranged_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_ranged_power_out_of_melee",
						find_value_type = "buff_template",
						path = {
							"conditional_stat_buffs",
							stat_buffs.ranged_damage
						}
					}
				},
				radius = {
					format_type = "number",
					value = DamageSettings.in_melee_range
				}
			},
			passive = {
				buff_template_name = "veteran_ranged_power_out_of_melee",
				identifier = "veteran_ranged_power_out_of_melee"
			}
		},
		veteran_extra_grenade_throw_chance = {
			description = "loc_talent_veteran_extra_grenade_throw_chance_desc",
			name = "X% Chance that grenade split when throw",
			display_name = "loc_talent_veteran_extra_grenade_throw_chance",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tactical",
			format_values = {
				chance = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_extra_grenade_throw_chance",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.extra_grenade_throw_chance
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "veteran_extra_grenade_throw_chance",
				identifier = "extra_grenade_throw_chance"
			}
		},
		veteran_bonus_crit_chance_on_ammo = {
			description = "loc_talent_veteran_bonus_crit_chance_on_ammo_desc",
			name = "First 10% of Ammo bonus crit chance",
			display_name = "loc_talent_veteran_bonus_crit_chance_on_ammo",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tactical",
			format_values = {
				crit_chance = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_bonus_crit_chance_on_ammo",
						find_value_type = "buff_template",
						path = {
							"conditional_stat_buffs",
							stat_buffs.ranged_critical_strike_chance
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				},
				ammo = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_bonus_crit_chance_on_ammo",
						find_value_type = "buff_template",
						path = {
							"ammunition_percentage"
						}
					},
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end
				}
			},
			passive = {
				buff_template_name = "veteran_bonus_crit_chance_on_ammo",
				identifier = "veteran_bonus_crit_chance_on_ammo"
			}
		},
		veteran_no_ammo_consumption_on_lasweapon_crit = {
			description = "loc_talent_veteran_no_ammo_consumption_on_lasweapon_crit_desc",
			name = "Las weapons: Crits cost no ammo",
			display_name = "loc_talent_veteran_no_ammo_consumption_on_lasweapon_crit",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tactical",
			passive = {
				buff_template_name = "veteran_no_ammo_consumption_on_lasweapon_crit",
				identifier = "veteran_no_ammo_consumption_on_lasweapon_crit"
			}
		},
		veteran_cover_peaking = {
			description = "loc_talent_veteran_cover_peaking_desc",
			name = "Cover peeking",
			display_name = "loc_talent_veteran_cover_peaking",
			icon = "content/ui/textures/icons/talents/veteran_3/veteran_3_tier_6_3",
			special_rule = {
				identifier = "veteran_cover_peeking",
				special_rule_name = special_rules.veteran_cover_peeking
			}
		},
		veteran_movement_speed_on_toughness_broken = {
			description = "loc_talent_veteran_movement_speed_on_toughness_broken_desc",
			name = "Movement speed on toughness broken",
			display_name = "loc_talent_veteran_movement_speed_on_toughness_broken",
			icon = "content/ui/textures/icons/talents/veteran_3/veteran_3_tier_6_3",
			format_values = {
				movement_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_movement_speed_on_toughness_broken",
						find_value_type = "buff_template",
						path = {
							"proc_stat_buffs",
							stat_buffs.movement_speed
						}
					}
				},
				duration = {
					format_type = "value",
					find_value = {
						buff_template_name = "veteran_movement_speed_on_toughness_broken",
						find_value_type = "buff_template",
						path = {
							"active_duration"
						}
					}
				}
			},
			passive = {
				buff_template_name = "veteran_movement_speed_on_toughness_broken",
				identifier = "veteran_movement_speed_on_toughness_broken"
			}
		},
		veteran_movement_bonuses_on_toughness_broken = {
			description = "loc_talent_veteran_movement_bonus_on_toughness_broken_desc",
			name = "Movement bonuses on toughness broken",
			display_name = "loc_talent_veteran_movement_speed_on_toughness_broken",
			icon = "content/ui/textures/icons/talents/veteran_3/veteran_3_tier_6_3",
			format_values = {
				duration = {
					format_type = "value",
					find_value = {
						buff_template_name = "veteran_movement_bonuses_on_toughness_broken",
						find_value_type = "buff_template",
						path = {
							"active_duration"
						}
					}
				},
				cooldown = {
					format_type = "value",
					find_value = {
						buff_template_name = "veteran_movement_bonuses_on_toughness_broken",
						find_value_type = "buff_template",
						path = {
							"cooldown_duration"
						}
					}
				},
				stamina_percent = {
					value = 0.5,
					prefix = "+",
					format_type = "percentage"
				}
			},
			passive = {
				buff_template_name = "veteran_movement_bonuses_on_toughness_broken",
				identifier = "veteran_movement_bonuses_on_toughness_broken"
			}
		},
		veteran_movement_speed_towards_downed = {
			description = "loc_talent_veteran_movement_speed_towards_downed_description",
			name = "MS Towards Knocked Allies + Grant revived allies Damage Reduction - 20% movement speed and stun immunity when moving towards a disabled ally. Allies you revive take less damage for 5 seconds",
			display_name = "loc_talent_veteran_movement_speed_towards_downed",
			icon = "content/ui/textures/icons/talents/veteran_3/veteran_3_tier_4_1",
			format_values = {
				movement_speed = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings_3.defensive_1.movement_speed
				},
				damage_reduction = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings_3.defensive_1.damage_taken_multiplier,
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end
				},
				duration = {
					format_type = "value",
					value = talent_settings_3.defensive_1.duration
				},
				revive_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_increased_move_speed_when_moving_towards_disabled_allies",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.revive_speed_modifier
						}
					}
				}
			},
			passive = {
				buff_template_name = "veteran_increased_move_speed_when_moving_towards_disabled_allies",
				identifier = "veteran_increased_move_speed_when_moving_towards_disabled_allies"
			}
		},
		veteran_dodging_grants_stamina = {
			description = "loc_talent_veteran_stamina_on_ranged_dodge_desc",
			name = "Dodging Shots grants stamina - Dodging, Sprinting or Sliding to avoid ranged attacks grants stamina.",
			display_name = "loc_talent_ranger_stamina_on_ranged_dodge",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_3_2",
			format_values = {
				stamina = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings_2.defensive_2.stamina_percent
				}
			},
			passive = {
				buff_template_name = "veteran_stamina_on_ranged_dodges",
				identifier = "veteran_stamina_on_ranged_dodges"
			}
		},
		veteran_hits_cause_bleed = {
			description = "loc_talent_veteran_hits_cause_bleed_desc",
			name = "Attacks cause bleed",
			display_name = "loc_talent_veteran_hits_cause_bleed",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tactical",
			format_values = {
				stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "veteran_hits_cause_bleed",
						find_value_type = "buff_template",
						path = {
							"num_stacks_on_hit"
						}
					}
				}
			},
			passive = {
				buff_template_name = "veteran_hits_cause_bleed",
				identifier = "hits_cause_bleed"
			},
			dev_info = {
				{
					value = "Bleed: damage is at max stacks",
					info_func = "text"
				},
				{
					info_func = "buff_template",
					buff_template_name = "bleed",
					values_to_show = {
						{
							format_type = "number",
							path = {
								"duration"
							}
						},
						{
							format_type = "number",
							path = {
								"interval"
							}
						},
						{
							format_type = "number",
							path = {
								"max_stacks"
							}
						}
					}
				},
				{
					damage_profile_name = "bleeding",
					info_func = "damage_profile"
				}
			}
		},
		veteran_kill_grants_damage_to_other_slot = {
			description = "loc_talent_veteran_kill_grants_damage_to_other_slot_desc",
			name = "Kills increase opposite weapon slot dmg for X seconds.",
			display_name = "loc_talent_veteran_kill_grants_damage_to_other_slot",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tactical",
			format_values = {
				damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_melee_kills_grant_range_damage",
						find_value_type = "buff_template",
						path = {
							"proc_stat_buffs",
							stat_buffs.ranged_damage
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				},
				duration = {
					format_type = "value",
					find_value = {
						buff_template_name = "veteran_melee_kills_grant_range_damage",
						find_value_type = "buff_template",
						path = {
							"active_duration"
						}
					}
				}
			},
			passive = {
				identifier = {
					"melee_kills_grant_range_damage",
					"ranged_kills_grant_melee_damage"
				},
				buff_template_name = {
					"veteran_melee_kills_grant_range_damage",
					"veteran_ranged_kills_grant_melee_damage"
				}
			}
		},
		veteran_reduce_sprinting_cost = {
			description = "loc_talent_veteran_reduce_sprinting_cost_desc",
			name = "Reduce sprinting stamina cost by X%",
			display_name = "loc_talent_veteran_reduce_sprinting_cost",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tactical",
			format_values = {
				sprinting = {
					prefix = "-",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_reduce_sprinting_cost",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.sprinting_cost_multiplier
						}
					},
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end
				}
			},
			passive = {
				buff_template_name = "veteran_reduce_sprinting_cost",
				identifier = "reduce_sprinting_cost"
			}
		},
		veteran_increased_melee_crit_chance_and_melee_finesse = {
			description = "loc_talent_veteran_increased_melee_crit_chance_and_melee_finesse_desc",
			name = "Increased melee crit chance and melee finesse modifier",
			display_name = "loc_talent_veteran_increased_melee_crit_chance_and_melee_finesse",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tactical",
			format_values = {
				crit_chance = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_increased_melee_crit_chance_and_melee_finesse",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_critical_strike_chance
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				},
				finesse = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_increased_melee_crit_chance_and_melee_finesse",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_finesse_modifier_bonus
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "veteran_increased_melee_crit_chance_and_melee_finesse",
				identifier = "melee_crit_chance_and_melee_finesse"
			}
		},
		veteran_better_deployables = {
			description = "loc_talent_veteran_better_deployables_description",
			name = "Better Pickups - Ammo Crates also replenish Grenades. Healing Crates also heal corrupted health, up until the next segment",
			display_name = "loc_talent_veteran_better_deployables",
			icon = "content/ui/textures/icons/talents/veteran_3/veteran_3_tier_3_2",
			format_values = {
				damage_heal = {
					prefix = "+",
					format_type = "percentage",
					value = improved_medical_crate.heal_multiplier - 1
				},
				toughness = {
					format_type = "percentage",
					value = improved_medical_crate.toughness_percentage_per_second
				}
			},
			coherency = {
				buff_template_name = "veteran_better_deployables",
				identifier = "veteran_better_deployables"
			}
		},
		veteran_replenish_grenades = {
			description = "loc_talent_veteran_replenish_grenade_desc",
			name = "Replenish Grenade Continuously - You replenish a grenade every 60 seconds",
			display_name = "loc_talent_ranger_replenish_grenade",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_1_2",
			format_values = {
				amount = {
					format_type = "value",
					value = talent_settings_2.offensive_1_3.grenade_restored
				},
				time = {
					format_type = "value",
					value = talent_settings_2.offensive_1_3.grenade_replenishment_cooldown
				}
			},
			passive = {
				buff_template_name = "veteran_grenade_replenishment",
				identifier = "veteran_grenade_replenishment"
			}
		},
		veteran_invisibility_on_combat_ability = {
			description = "loc_talent_veteran_invisibility_on_combat_ability_desc",
			name = "Ability grants brief stealth + movement speed",
			display_name = "loc_talent_veteran_invisibility_on_combat_ability",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_1_2",
			format_values = {
				talent_name = {
					value = "loc_talent_veteran_invisibility_on_combat_ability",
					format_type = "loc_string"
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "veteran_invisibility",
						find_value_type = "buff_template",
						path = {
							"duration"
						}
					}
				},
				cooldown = {
					format_type = "number",
					value = PlayerAbilities.veteran_combat_ability_stealth.cooldown
				},
				movement_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_invisibility",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.movement_speed
						}
					}
				}
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.veteran_combat_ability_stealth
			},
			passive = {
				buff_template_name = "veteran_invisibility_on_combat_ability",
				identifier = "veteran_invisibility_on_combat_ability"
			},
			special_rule = {
				identifier = "veteran_combat_ability_stealth",
				special_rule_name = special_rules.veteran_combat_ability_stealth
			}
		},
		veteran_damage_bonus_leaving_invisibility = {
			description = "loc_talent_veteran_damage_bonus_leaving_invisibility_desc",
			name = "X% Damage bonus for Y s when leaving stealth",
			display_name = "loc_talent_veteran_damage_bonus_leaving_invisibility",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_1_2",
			format_values = {
				talent_name = {
					value = "loc_talent_veteran_invisibility_on_combat_ability",
					format_type = "loc_string"
				},
				damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_damage_bonus_leaving_invisibility",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.damage
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				},
				duration = {
					format_type = "value",
					find_value = {
						buff_template_name = "veteran_damage_bonus_leaving_invisibility",
						find_value_type = "buff_template",
						path = {
							"duration"
						}
					}
				}
			},
			special_rule = {
				identifier = "damage_bonyus_leaving_invisibility",
				special_rule_name = special_rules.veteran_damage_bonus_leaving_invisibility
			}
		},
		veteran_toughness_bonus_leaving_invisibility = {
			description = "loc_talent_veteran_toughness_bonus_leaving_invisibility_desc",
			name = "X% toughness bonus for Y s when leaving stealth",
			display_name = "loc_talent_veteran_toughness_bonus_leaving_invisibility",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_1_2",
			format_values = {
				talent_name = {
					value = "loc_talent_veteran_invisibility_on_combat_ability",
					format_type = "loc_string"
				},
				tdr = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_toughness_bonus_leaving_invisibility",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_multiplier
						}
					},
					value_manipulation = function (value)
						return math.abs(1 - value) * 100
					end
				},
				duration = {
					format_type = "value",
					find_value = {
						buff_template_name = "veteran_toughness_bonus_leaving_invisibility",
						find_value_type = "buff_template",
						path = {
							"duration"
						}
					}
				}
			},
			special_rule = {
				identifier = "toughness_bonyus_leaving_invisibility",
				special_rule_name = special_rules.veteran_toughness_bonus_leaving_invisibility
			}
		},
		veteran_aura_elite_kills_restore_grenade = {
			description = "loc_talent_veteran_grenade_on_elite_kills_coop_desc",
			name = "Elites kills can replenish Grenades - You and allies in coherency have a chance to gain a grenade whenever you or an ally in coherency kills an elite enemy.",
			display_name = "loc_talent_ranger_grenade_on_elite_kills_coop",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_4_2",
			format_values = {
				chance = {
					format_type = "percentage",
					value = talent_settings_2.coop_2.proc_chance
				}
			},
			passive = {
				buff_template_name = "veteran_aura_gain_grenade_on_elite_kill",
				identifier = "veteran_aura_gain_grenade_on_elite_kill"
			}
		},
		veteran_block_break_gives_tdr = {
			description = "loc_talent_veteran_block_break_gives_tdr_description",
			name = "When block broken, gain TDR. When toughness broken, reduce Block Cost - When block broken, gain toughness damage reduction for 5 seconds. When toughness broken gain block cost reduction for 5 seconds",
			display_name = "loc_talent_veteran_block_break_gives_tdr",
			icon = "content/ui/textures/icons/talents/veteran_3/veteran_3_tier_4_3",
			format_values = {
				toughness_damage_reduction = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings_3.defensive_3.toughness_damage_taken_multiplier,
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end
				},
				toughness_duration = {
					format_type = "value",
					value = talent_settings_3.defensive_3.toughness_duration
				},
				block_cost_multiplier = {
					prefix = "+",
					format_type = "percentage",
					value = 1 - talent_settings_3.defensive_3.block_cost_multiplier
				},
				stamina_duration = {
					format_type = "value",
					value = talent_settings_3.defensive_3.stamina_duration
				}
			},
			passive = {
				buff_template_name = "veteran_improved_toughness_stamina",
				identifier = "veteran_improved_toughness_stamina"
			}
		},
		veteran_tdr_on_high_toughness = {
			description = "loc_talent_veteran_tdr_on_high_toughness_desc",
			name = "While above 75% toughness, reduce toughness damage taken by 25%",
			display_name = "loc_talent_veteran_block_break_gives_tdr",
			icon = "content/ui/textures/icons/talents/veteran_3/veteran_3_tier_4_3",
			format_values = {
				toughness_percent = {
					value = 0.75,
					format_type = "percentage"
				},
				toughness_damage_reduction = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_tdr_on_high_toughness",
						find_value_type = "buff_template",
						path = {
							"conditional_stat_buffs",
							stat_buffs.toughness_damage_taken_multiplier
						}
					}
				}
			},
			passive = {
				buff_template_name = "veteran_tdr_on_high_toughness",
				identifier = "veteran_tdr_on_high_toughness"
			}
		},
		veteran_replenish_toughness_and_boost_allies = {
			description = "loc_talent_veteran_replenish_toughness_and_boost_allies_desc",
			name = "Replenish Toughness and boost ally near your ranged kills - Replenishes toughness to an ally and grant damage bonus to them, when killing an enemy with a ranged attack that is in melee range of that ally.",
			display_name = "loc_talent_veteran_replenish_toughness_and_boost_allies",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_4_3",
			format_values = {
				radius = {
					format_type = "number",
					value = talent_settings_2.coop_3.range
				},
				toughness = {
					format_type = "percentage",
					value = talent_settings_2.coop_3.toughness_percent
				},
				base_damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings_2.coop_3.damage
				},
				duration = {
					format_type = "number",
					value = talent_settings_2.coop_3.duration
				}
			},
			passive = {
				buff_template_name = "veteran_replenish_toughness_of_ally_close_to_victim",
				identifier = "veteran_replenish_toughness_of_ally_close_to_victim"
			}
		},
		veteran_replenish_toughness_on_weakspot_kill = {
			description = "loc_talent_veteran_toughness_on_weakspot_kill_desc",
			name = "Medium Toughness on ranged weakspot kill. Increases thoughness damage reduction by 10% for 6 seconds, 3 stacks",
			display_name = "loc_talent_veteran_toughness_on_weakspot_kill",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_3_1",
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings_2.toughness_2.toughness
				},
				toughness_damage_reduction = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings_2.toughness_2.toughness_damage_taken_modifier
				},
				duration = {
					format_type = "number",
					value = talent_settings_2.toughness_2.duration
				},
				stacks = {
					format_type = "number",
					value = talent_settings_2.toughness_2.max_stacks
				}
			},
			passive = {
				buff_template_name = "veteran_ranged_weakspot_toughness_recovery",
				identifier = "veteran_ranged_weakspot_toughness_recovery"
			}
		},
		veteran_allies_in_coherency_share_toughness_gain = {
			description = "loc_talent_veteran_allies_share_toughness_description",
			name = "Allies in coherency replenish X% of toughness that you gain",
			display_name = "loc_talent_veteran_allies_share_toughness",
			icon = "content/ui/textures/icons/talents/veteran_3/veteran_3_tier_3_3",
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings_3.coop_3.percent
				}
			},
			passive = {
				buff_template_name = "veteran_share_toughness_gained",
				identifier = "veteran_share_toughness_gained"
			}
		},
		veteran_faster_reload_on_non_empty_clips = {
			description = "loc_talent_veteran_reload_speed_non_empty_mag_desc",
			name = "Faster reload of non-empty magazines - Increased reload speed of non-empty magazines",
			display_name = "loc_talent_ranger_reload_speed_empty_mag",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_2_2",
			format_values = {
				reload_speed = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings_2.offensive_1_2.reload_speed
				}
			},
			passive = {
				buff_template_name = "veteran_reload_speed_on_non_empty_clip",
				identifier = "veteran_reload_speed_on_non_empty_clip"
			}
		},
		veteran_replenish_toughness_outside_melee = {
			description = "loc_talent_veteran_replenish_toughness_outside_melee_desc",
			name = "Replenish Toughness when not in melee - Low toughness regeneration when not in melee with an enemy",
			display_name = "loc_talent_veteran_replenish_toughness_outside_melee",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_3_3",
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings_2.toughness_3.toughness * 1 / talent_settings_2.toughness_3.time
				},
				range = {
					format_type = "number",
					value = talent_settings_2.toughness_3.range
				}
			},
			passive = {
				buff_template_name = "veteran_toughness_regen_out_of_melee",
				identifier = "veteran_toughness_regen_out_of_melee"
			}
		},
		veteran_plasma_proficiency = {
			description = "loc_talent_veteran_plasma_proficency_desc",
			name = "Take less damage when venting plasma weapons",
			display_name = "loc_talent_veteran_plasma_proficency",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_1_2",
			format_values = {
				vent_damage_1 = {
					format_type = "number",
					find_value = {
						damage_profile_name = "plasma_vent_damage",
						find_value_type = "damage",
						armor_type = armor_types.player,
						power_level = plasmagun_p1_m1.overheat_configuration.vent_power_level[2]
					}
				},
				vent_damage_2 = {
					format_type = "number",
					find_value = {
						damage_profile_name = "plasma_vent_damage_proficiency",
						find_value_type = "damage",
						armor_type = armor_types.player,
						power_level = plasmagun_p1_m1.overheat_configuration.proficiency_vent_power_level[2]
					}
				}
			},
			passive = {
				buff_template_name = "veteran_plasma_proficiency",
				identifier = "veteran_plasma_proficiency"
			}
		},
		veteran_rending_bonus = {
			description = "loc_talent_veteran_rending_bonus_desc",
			name = "Give 20% rending to all weapons",
			display_name = "loc_talent_veteran_rending_bonus",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_1_2",
			format_values = {
				rending_multiplier = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_rending_bonus",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.rending_multiplier
						}
					}
				}
			},
			passive = {
				buff_template_name = "veteran_rending_bonus",
				identifier = "veteran_rending_bonus"
			}
		},
		veteran_bolter_proficiency = {
			description = "loc_talent_veteran_bolter_proficency_desc",
			name = "Reduced spread, recoil, and sway with bolt weapons",
			display_name = "loc_talent_veteran_bolter_proficency",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_1_2",
			format_values = {
				spread = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_bolter_proficiency",
						find_value_type = "buff_template",
						path = {
							"conditional_stat_buffs",
							stat_buffs.spread_modifier
						}
					}
				},
				recoil = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_bolter_proficiency",
						find_value_type = "buff_template",
						path = {
							"conditional_stat_buffs",
							stat_buffs.recoil_modifier
						}
					}
				},
				sway = {
					prefix = "-",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_bolter_proficiency",
						find_value_type = "buff_template",
						path = {
							"conditional_stat_buffs",
							stat_buffs.sway_modifier
						}
					}
				}
			},
			passive = {
				buff_template_name = "veteran_bolter_proficiency",
				identifier = "veteran_bolter_proficiency"
			}
		},
		veteran_ammo_increase = {
			description = "loc_talent_veteran_ammo_increase_desc",
			name = "Increased Ammo",
			display_name = "loc_talent_veteran_ammo_increase",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_1_2",
			format_values = {
				ammo = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_ammo_increase",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ammo_reserve_capacity
						}
					}
				}
			},
			passive = {
				buff_template_name = "veteran_ammo_increase",
				identifier = "veteran_ammo_increase"
			}
		},
		veteran_power_proficiency = {
			description = "loc_talent_veteran_power_proficency_description",
			name = "Reduced spread, recoil, and sway with bolt weapons",
			display_name = "loc_talent_veteran_power_proficency",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_1_2",
			format_values = {
				charges = {
					prefix = "+",
					format_type = "number",
					find_value = {
						buff_template_name = "veteran_power_proficiency",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.weapon_special_max_activations
						}
					}
				}
			},
			passive = {
				buff_template_name = "veteran_power_proficiency",
				identifier = "veteran_power_proficiency"
			}
		},
		veteran_attack_speed = {
			description = "loc_talent_veteran_attack_speed_description",
			name = "Increased Melee Attack Speed",
			display_name = "loc_talent_veteran_attack_speed",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_1_2",
			format_values = {
				melee_attack_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "veteran_attack_speed",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_attack_speed
						}
					}
				}
			},
			passive = {
				buff_template_name = "veteran_attack_speed",
				identifier = "veteran_attack_speed"
			}
		},
		veteran_cover_peeking = {
			description = "loc_talent_veteran_cover_peeking_description",
			name = "Increased Melee Attack Speed",
			display_name = "loc_talent_veteran_cover_peeking",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_1_2",
			special_rule = {
				identifier = "veteran_cover_peeking",
				special_rule_name = special_rules.veteran_cover_peeking
			}
		}
	}
}

return archetype_talents
