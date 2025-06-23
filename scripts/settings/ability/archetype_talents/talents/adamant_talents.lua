-- chunkname: @scripts/settings/ability/archetype_talents/talents/adamant_talents.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local proc_events = BuffSettings.proc_events
local special_rules = SpecialRulesSettings.special_rules
local stat_buffs = BuffSettings.stat_buffs
local talent_settings = TalentSettings.adamant
local math_round = math.round

math_round = math_round or function (value)
	if value >= 0 then
		return math.floor(value + 0.5)
	else
		return math.ceil(value - 0.5)
	end
end

local archetype_talents = {
	archetype = "adamant",
	talents = {
		adamant_companion_damage_per_level = {
			description = "loc_talent_arbites_mastiff_description",
			name = "Companion Damage per Level",
			display_name = "-",
			passive = {
				buff_template_name = "adamant_companion_damage_per_level",
				identifier = "adamant_companion_damage_per_level"
			}
		},
		adamant_command_tog_with_tag = {
			description = "loc_talent_arbites_mastiff_target_description",
			name = "",
			display_name = "-"
		},
		adamant_shout = {
			description = "loc_talent_adamant_shout_ability_description",
			name = "Base Shout",
			display_name = "loc_talent_adamant_shout_ability_name",
			large_icon = "content/ui/textures/icons/talents/adamant/adamant_ability_shout",
			format_values = {
				cooldown = {
					format_type = "number",
					value = PlayerAbilities.adamant_shout.cooldown
				},
				range = {
					format_type = "number",
					value = talent_settings.combat_ability.shout.range
				},
				far_range = {
					format_type = "number",
					value = talent_settings.combat_ability.shout.far_range
				}
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.adamant_shout
			}
		},
		adamant_shout_improved = {
			description = "loc_talent_adamant_shout_improved_ability_description",
			name = "Shout",
			display_name = "loc_talent_adamant_shout_ability_name",
			large_icon = "content/ui/textures/icons/talents/adamant/adamant_ability_shout_improved",
			format_values = {
				cooldown = {
					format_type = "number",
					value = PlayerAbilities.adamant_shout_improved.cooldown
				},
				talent_name = {
					value = "loc_talent_adamant_shout_ability_name",
					format_type = "loc_string"
				},
				range = {
					format_type = "number",
					value = talent_settings.combat_ability.shout_improved.range
				},
				far_range = {
					format_type = "number",
					value = talent_settings.combat_ability.shout_improved.far_range
				},
				toughness = {
					format_type = "percentage",
					value = talent_settings.combat_ability.shout_improved.toughness
				}
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.adamant_shout_improved
			}
		},
		adamant_charge = {
			description = "loc_talent_adamant_bash_ability_description",
			name = "Improved Charge",
			display_name = "loc_talent_adamant_charge_ability_name",
			large_icon = "content/ui/textures/icons/talents/adamant/adamant_ability_charge",
			format_values = {
				cooldown = {
					format_type = "number",
					value = PlayerAbilities.adamant_charge.cooldown
				},
				range = {
					format_type = "number",
					value = talent_settings.combat_ability.charge.range
				},
				duration = {
					format_type = "number",
					value = talent_settings.combat_ability.charge.duration
				},
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.combat_ability.charge.damage
				},
				stagger = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.combat_ability.charge.impact
				}
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.adamant_charge
			},
			passive = {
				buff_template_name = "adamant_charge_passive_buff",
				identifier = "adamant_charge_passive_buff"
			}
		},
		adamant_charge_cooldown_reduction = {
			description = "loc_talent_adamant_charge_cooldown_alt_description",
			name = "Charge and Cooldown",
			display_name = "loc_talent_adamant_charge_cooldown_name",
			format_values = {
				cooldown = {
					format_type = "number",
					value = talent_settings.combat_ability.charge.cooldown_reduction
				},
				cooldown_elite = {
					format_type = "number",
					value = talent_settings.combat_ability.charge.cooldown_elite
				},
				max_cooldown = {
					format_type = "number",
					value = talent_settings.combat_ability.charge.cooldown_max
				}
			},
			passive = {
				buff_template_name = "adamant_charge_cooldown_buff",
				identifier = "adamant_charge_cooldown_buff"
			}
		},
		adamant_charge_toughness = {
			description = "loc_talent_adamant_charge_toughness_alt_description",
			name = "Toughness and Stamina",
			display_name = "loc_talent_adamant_charge_toughness_name",
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings.combat_ability.charge.toughness
				},
				stamina = {
					format_type = "percentage",
					value = talent_settings.combat_ability.charge.stamina
				},
				toughness_max = {
					format_type = "percentage",
					value = talent_settings.combat_ability.charge.toughness_max
				},
				stamina_max = {
					format_type = "percentage",
					value = talent_settings.combat_ability.charge.stamina_max
				}
			},
			passive = {
				buff_template_name = "adamant_charge_toughness_buff",
				identifier = "adamant_charge_toughness_buff"
			}
		},
		adamant_charge_longer_distance = {
			description = "loc_talent_adamant_charge_longer_distance_desc",
			name = "",
			display_name = "loc_talent_adamant_charge_longer_distance",
			format_values = {
				distance = {
					format_type = "value",
					value = talent_settings.combat_ability.charge.distance_increase + talent_settings.combat_ability.charge.range
				},
				charge_ability_name = {
					value = "loc_talent_adamant_charge_ability_name",
					format_type = "loc_string"
				}
			},
			passive = {
				buff_template_name = "adamant_charge_increased_distance",
				identifier = "adamant_charge_increased_distance"
			}
		},
		adamant_stance = {
			description = "loc_talent_adamant_stance_ability_alt_description",
			name = "Stance",
			display_name = "loc_talent_adamant_stance_ability_name",
			large_icon = "content/ui/textures/icons/talents/adamant/adamant_ability_stance",
			format_values = {
				cooldown = {
					format_type = "number",
					value = talent_settings.combat_ability.stance.cooldown
				},
				talent_name = {
					value = "loc_talent_adamant_stance_ability_name",
					format_type = "loc_string"
				},
				duration = {
					format_type = "number",
					value = talent_settings.combat_ability.stance.duration
				},
				movement_speed = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.combat_ability.stance.movement_speed
				},
				movement_reduction = {
					format_type = "percentage",
					value = talent_settings.combat_ability.stance.movement_speed_reduction_multiplier,
					value_manipulation = function (value)
						return 100 * (1 - value)
					end
				},
				damage_taken = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.combat_ability.stance.damage_taken_multiplier,
					value_manipulation = function (value)
						return 100 * (1 - value)
					end
				},
				cooldown_percent = {
					format_type = "percentage",
					value = talent_settings.combat_ability.stance.cooldown_reduction
				}
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.adamant_stance
			}
		},
		adamant_stance_dog_bloodlust = {
			description = "loc_talent_adamant_stance_bloodlust_desc",
			name = "",
			display_name = "loc_talent_adamant_stance_bloodlust",
			format_values = {
				stance_name = {
					value = "loc_talent_adamant_stance_ability_name",
					format_type = "loc_string"
				},
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.combat_ability.stance.companion_damage
				}
			},
			passive = {
				buff_template_name = "adamant_hunt_stance_dog_bloodlust",
				identifier = "adamant_hunt_stance_dog_bloodlust"
			}
		},
		adamant_stance_damage = {
			description = "loc_talent_adamant_stance_damage_desc",
			name = "",
			display_name = "loc_talent_adamant_stance_damage",
			format_values = {
				stance_name = {
					value = "loc_talent_adamant_stance_ability_name",
					format_type = "loc_string"
				},
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.combat_ability.stance.damage
				}
			}
		},
		adamant_stance_elite_kills_stack_damage = {
			description = "loc_talent_adamant_stance_elite_kills_stack_damage_desc",
			name = "",
			display_name = "loc_talent_adamant_stance_elite_kills_stack_damage",
			format_values = {
				stance_name = {
					value = "loc_talent_adamant_stance_ability_name",
					format_type = "loc_string"
				},
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.combat_ability.stance.damage_talent_damage
				},
				duration = {
					format_type = "number",
					value = talent_settings.combat_ability.stance.damage_talent_duration
				},
				stacks = {
					format_type = "number",
					value = talent_settings.combat_ability.stance.damage_talent_stacks
				}
			},
			special_rule = {
				identifier = "adamant_stance_elite_kills_stack_damage",
				special_rule_name = special_rules.adamant_stance_elite_kills_stack_damage
			}
		},
		adamant_stance_ranged_kills_transfer_ammo = {
			description = "loc_talent_adamant_stance_ranged_kills_transfer_ammo_desc",
			name = "",
			display_name = "loc_talent_adamant_stance_ranged_kills_transfer_ammo",
			format_values = {
				ammo = {
					format_type = "percentage",
					value = talent_settings.combat_ability.stance.ammo_percent
				},
				cooldown = {
					format_type = "number",
					value = talent_settings.combat_ability.stance.ammo_icd
				},
				stance_name = {
					value = "loc_talent_adamant_stance_ability_name",
					format_type = "loc_string"
				}
			},
			special_rule = {
				identifier = "adamant_stance_ammo_from_reserve",
				special_rule_name = special_rules.adamant_stance_ammo_from_reserve
			}
		},
		adamant_whistle = {
			description = "loc_talent_ability_detonate_description",
			name = "Base Order",
			display_name = "loc_talent_ability_detonate",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			icon = "content/ui/textures/icons/talents/veteran/veteran_blitz_frag_grenade",
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.adamant_whistle
			},
			format_values = {
				cooldown = {
					format_type = "number",
					value = talent_settings.blitz_ability.whistle.cooldown
				},
				max_charges = {
					format_type = "number",
					value = talent_settings.blitz_ability.whistle.charges
				}
			},
			special_rule = {
				identifier = {
					"no_grenades",
					"adamant_whistle"
				},
				special_rule_name = {
					special_rules.disable_grenade_pickups,
					special_rules.adamant_whistle
				}
			},
			passive = {
				buff_template_name = "adamant_whistle_replenishment",
				identifier = "adamant_whistle_replenishment"
			}
		},
		adamant_grenade = {
			description = "loc_talent_ability_adamant_grenade_description",
			name = "Base adamant Grenade",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			display_name = "loc_talent_ability_adamant_grenade",
			icon = "content/ui/textures/icons/talents/veteran/veteran_blitz_frag_grenade",
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.adamant_grenade
			},
			format_values = {
				charges = {
					format_type = "number",
					value = talent_settings.blitz_ability.grenade.base_charges
				}
			},
			special_rule = {
				identifier = {
					"no_grenades",
					"adamant_whistle"
				},
				special_rule_name = {
					special_rules.adamant_hack_to_allow_grenades,
					special_rules.adamant_hack_to_allow_grenades
				}
			}
		},
		adamant_grenade_improved = {
			description = "loc_talent_ability_adamant_grenade_improved_description",
			name = "Base adamant Grenade",
			display_name = "loc_talent_ability_adamant_grenade_improved",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			icon = "content/ui/textures/icons/talents/veteran/veteran_blitz_frag_grenade",
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.adamant_grenade_improved
			},
			format_values = {
				charges = {
					format_type = "number",
					value = talent_settings.blitz_ability.grenade.improved_charges
				},
				talent_name = {
					value = "loc_talent_ability_adamant_grenade",
					format_type = "loc_string"
				}
			},
			special_rule = {
				identifier = {
					"no_grenades",
					"adamant_whistle"
				},
				special_rule_name = {
					special_rules.adamant_hack_to_allow_grenades,
					special_rules.adamant_hack_to_allow_grenades
				}
			},
			passive = {
				buff_template_name = "adamant_grenade_cluster_kills_tracking_buff",
				identifier = "adamant_whistle_replenishment"
			}
		},
		adamant_grenade_increased_radius = {
			description = "loc_talent_ability_adamant_grenade_radius_increase_description",
			name = "Base adamant Grenade",
			display_name = "loc_talent_ability_adamant_grenade_radius_increase",
			format_values = {
				radius = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.blitz_ability.grenade.radius_increase
				}
			},
			passive = {
				buff_template_name = "adamant_grenade_radius_increase",
				identifier = "adamant_grenade_radius_increase"
			}
		},
		adamant_grenade_increased_damage = {
			description = "loc_talent_ability_adamant_grenade_damage_increase_description",
			name = "Base adamant Grenade",
			display_name = "loc_talent_ability_adamant_grenade_damage_increase",
			format_values = {
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.blitz_ability.grenade.damage_increase
				}
			},
			passive = {
				buff_template_name = "adamant_grenade_damage_increase",
				identifier = "adamant_grenade_damage_increase"
			}
		},
		adamant_shock_mine = {
			description = "loc_talent_ability_shock_mine_description",
			name = "Shock Mine",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			display_name = "loc_talent_ability_shock_mine",
			icon = "content/ui/textures/icons/talents/veteran/veteran_blitz_frag_grenade",
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.adamant_shock_mine
			},
			format_values = {
				talent_name = {
					value = "loc_talent_ability_shock_mine",
					format_type = "loc_string"
				},
				range = {
					format_type = "number",
					value = talent_settings.blitz_ability.shock_mine.range
				},
				duration = {
					format_type = "number",
					value = talent_settings.blitz_ability.shock_mine.duration
				}
			},
			special_rule = {
				identifier = {
					"no_grenades",
					"adamant_whistle"
				},
				special_rule_name = {
					special_rules.adamant_hack_to_allow_grenades,
					special_rules.adamant_hack_to_allow_grenades
				}
			}
		},
		adamant_area_buff_drone = {
			large_icon = "content/ui/textures/icons/talents/adamant/adamant_ability_area_buff_drone",
			name = "Nuncio-Aquila",
			display_name = "loc_talent_ability_area_buff_drone",
			description = "loc_talent_adamant_ability_nuncio_base_desc",
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.adamant_area_buff_drone
			},
			format_values = {
				talent_name = {
					value = "loc_talent_ability_area_buff_drone",
					format_type = "loc_string"
				},
				range = {
					format_type = "number",
					value = talent_settings.blitz_ability.drone.range
				},
				duration = {
					format_type = "number",
					value = talent_settings.blitz_ability.drone.duration
				},
				damage_taken = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.blitz_ability.drone.damage_taken,
					value_manipulation = function (value)
						return math_round((value - 1) * 100)
					end
				},
				toughness = {
					format_type = "percentage",
					value = talent_settings.blitz_ability.drone.toughness
				}
			}
		},
		adamant_area_buff_drone_improved = {
			large_icon = "content/ui/textures/icons/talents/adamant/adamant_ability_area_buff_drone",
			name = "Nuncio-Aquila",
			display_name = "loc_talent_ability_area_buff_drone",
			description = "loc_talent_ability_area_buff_drone_ct_description",
			format_values = {
				nuncio_name = {
					value = "loc_talent_ability_area_buff_drone",
					format_type = "loc_string"
				},
				range = {
					format_type = "number",
					value = talent_settings.blitz_ability.drone.range
				},
				duration = {
					format_type = "number",
					value = talent_settings.blitz_ability.drone.duration
				},
				damage_taken = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.blitz_ability.drone.damage_taken,
					value_manipulation = function (value)
						return math_round((value - 1) * 100)
					end
				},
				suppression = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.blitz_ability.drone.suppression
				},
				impact = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.blitz_ability.drone.impact
				},
				toughness = {
					format_type = "percentage",
					value = talent_settings.blitz_ability.drone.toughness_improved
				},
				recoil = {
					format_type = "percentage",
					value = talent_settings.blitz_ability.drone.recoil_modifier
				}
			},
			special_rule = {
				identifier = "adamant_buff_drone_improved",
				special_rule_name = special_rules.adamant_buff_drone_improved
			}
		},
		adamant_drone_buff_talent = {
			description = "loc_talent_adamant_drone_buff_talent_alt_desc",
			name = "",
			display_name = "loc_talent_adamant_drone_buff_talent",
			format_values = {
				tdr = {
					format_type = "percentage",
					value = talent_settings.blitz_ability.drone.tdr
				},
				revive_speed = {
					format_type = "percentage",
					value = talent_settings.blitz_ability.drone.revive_speed_modifier
				},
				attack_speed = {
					format_type = "percentage",
					value = talent_settings.blitz_ability.drone.attack_speed
				}
			},
			special_rule = {
				identifier = "adamant_drone_buff_talent",
				special_rule_name = special_rules.adamant_drone_buff_talent
			}
		},
		adamant_drone_debuff_talent = {
			description = "loc_talent_adamant_drone_debuff_talent_desc",
			name = "",
			display_name = "loc_talent_adamant_drone_debuff_talent",
			format_values = {
				attack_speed_reduction = {
					format_type = "percentage",
					value = talent_settings.blitz_ability.drone.enemy_melee_attack_speed,
					value_manipulation = function (value)
						return 50
					end
				},
				damage_reduction = {
					format_type = "percentage",
					value = talent_settings.blitz_ability.drone.enemy_melee_damage,
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			special_rule = {
				identifier = "adamant_drone_debuff_talent",
				special_rule_name = special_rules.adamant_drone_debuff_talent
			}
		},
		adamant_wield_speed_aura = {
			description = "loc_talent_adamant_wield_speed_aura_alt_desc",
			name = "Aura - Wield Speed",
			display_name = "loc_talent_adamant_wield_speed_aura",
			format_values = {
				wield_speed = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.coherency.adamant_wield_speed_aura.wield_speed
				}
			},
			special_rule = {
				identifier = "adamant_dog_counts_towards_coherency",
				special_rule_name = special_rules.adamant_no_companion_coherency
			},
			coherency = {
				identifier = "adamant_aura",
				priority = 1,
				buff_template_name = "adamant_wield_speed_aura"
			},
			passive = {
				buff_template_name = "adamant_no_companion_coherency",
				identifier = "adamant_companion_counts_for_coherency"
			}
		},
		adamant_reload_speed_aura = {
			description = "loc_talent_adamant_reload_speed_aura_desc",
			name = "",
			display_name = "loc_talent_adamant_wield_speed_aura",
			format_values = {
				reload_speed = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.coherency.reload_speed_aura.reload_speed
				}
			},
			special_rule = {
				identifier = "adamant_dog_counts_towards_coherency",
				special_rule_name = special_rules.adamant_no_companion_coherency
			},
			coherency = {
				identifier = "adamant_aura",
				priority = 1,
				buff_template_name = "adamant_reload_speed_aura"
			},
			passive = {
				buff_template_name = "adamant_no_companion_coherency",
				identifier = "adamant_companion_counts_for_coherency"
			}
		},
		adamant_damage_vs_staggered_aura = {
			description = "loc_talent_adamant_damage_vs_staggered_aura_alt_desc",
			name = "Aura - Damage vs Staggered",
			display_name = "loc_talent_adamant_damage_vs_staggered_aura",
			format_values = {
				damage_vs_stagger = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.coherency.adamant_damage_vs_staggered_aura.damage_vs_staggered
				}
			},
			special_rule = {
				identifier = "adamant_dog_counts_towards_coherency",
				special_rule_name = special_rules.adamant_no_companion_coherency
			},
			coherency = {
				identifier = "adamant_aura",
				priority = 1,
				buff_template_name = "adamant_damage_vs_staggered_aura"
			},
			passive = {
				buff_template_name = "adamant_no_companion_coherency",
				identifier = "adamant_companion_counts_for_coherency"
			}
		},
		adamant_companion_aura = {
			description = "loc_talent_adamant_companion_coherency_desc",
			name = "Aura - Wield Speed",
			display_name = "loc_talent_adamant_companion_coherency",
			large_icon = "content/ui/textures/icons/talents/adamant/adamant_companion_coherency",
			icon = "content/ui/textures/icons/talents/adamant/adamant_companion_coherency",
			format_values = {},
			special_rule = {
				identifier = "adamant_dog_counts_towards_coherency",
				special_rule_name = special_rules.adamant_dog_counts_towards_coherency
			},
			passive = {
				buff_template_name = "adamant_companion_counts_for_coherency",
				identifier = "adamant_companion_counts_for_coherency"
			},
			coherency = {
				identifier = "adamant_aura",
				priority = 1,
				buff_template_name = "adamant_companion_aura_base"
			}
		},
		adamant_companion_coherency = {
			description = "loc_talent_adamant_companion_coherency_alt_desc",
			name = "Aura - Wield Speed",
			display_name = "loc_talent_adamant_companion_coherency",
			large_icon = "content/ui/textures/icons/talents/adamant/adamant_companion_coherency",
			icon = "content/ui/textures/icons/buffs/hud/adamant/adamant_companion_coherency",
			format_values = {
				tdr = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.coherency.companion.tdr,
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			special_rule = {
				identifier = "adamant_dog_counts_towards_coherency",
				special_rule_name = special_rules.adamant_dog_counts_towards_coherency
			},
			passive = {
				buff_template_name = "adamant_companion_counts_for_coherency",
				identifier = "adamant_companion_counts_for_coherency"
			},
			coherency = {
				identifier = "adamant_aura",
				priority = 1,
				buff_template_name = "adamant_companion_aura"
			}
		},
		adamant_disable_companion = {
			description = "loc_talent_adamant_disable_companion_replenish_desc",
			name = "Aura - Wield Speed",
			display_name = "loc_talent_adamant_disable_companion",
			format_values = {
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.disable_companion.damage
				},
				tdr = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.disable_companion.tdr,
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				},
				attack_speed = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.disable_companion.attack_speed
				},
				charges = {
					prefix = "+",
					format_type = "number",
					value = talent_settings.disable_companion.extra_max_amount_of_grenades
				},
				time = {
					format_type = "number",
					value = talent_settings.disable_companion.blitz_replenish_time
				}
			},
			passive = {
				identifier = {
					"adamant_disable_companion_buff",
					"adamant_grenade_replenishment"
				},
				buff_template_name = {
					"adamant_disable_companion_buff",
					"adamant_grenade_replenishment"
				}
			},
			special_rule = {
				identifier = "disable_companion",
				special_rule_name = special_rules.disable_companion
			}
		},
		adamant_elite_special_kills_offensive_boost = {
			description = "loc_talent_adamant_elite_special_kills_offensive_boost_alt_desc",
			name = "",
			display_name = "loc_talent_adamant_elite_special_kills_offensive_boost",
			format_values = {
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.elite_special_kills_offensive_boost.damage
				},
				movement_speed = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.elite_special_kills_offensive_boost.movement_speed
				},
				duration = {
					format_type = "number",
					value = talent_settings.elite_special_kills_offensive_boost.duration
				}
			},
			passive = {
				buff_template_name = "adamant_elite_special_kills_offensive_boost",
				identifier = "adamant_elite_special_kills_offensive_boost"
			}
		},
		adamant_damage_reduction_after_elite_kill = {
			description = "loc_talent_adamant_damage_reduction_after_elite_kill_desc",
			name = "adamant_damage_reduction_after_elite_kill",
			display_name = "loc_talent_adamant_damage_reduction_after_elite_kill",
			format_values = {
				damage_reduction = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.damage_reduction_after_elite_kill.damage_taken_multiplier,
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end
				},
				duration = {
					format_type = "number",
					value = talent_settings.damage_reduction_after_elite_kill.duration
				}
			},
			passive = {
				buff_template_name = "adamant_damage_reduction_after_elite_kill",
				identifier = "adamant_damage_reduction_after_elite_kill"
			}
		},
		adamant_toughness_regen_near_companion = {
			description = "loc_talent_adamant_toughness_regen_near_companion_desc",
			name = "",
			display_name = "loc_talent_adamant_toughness_regen_near_companion",
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings.toughness_regen_near_companion.toughness_percentage_per_second
				},
				range = {
					format_type = "number",
					value = talent_settings.toughness_regen_near_companion.range
				}
			},
			passive = {
				buff_template_name = "adamant_toughness_regen_near_companion",
				identifier = "adamant_toughness_regen_near_companion"
			}
		},
		adamant_perfect_block_damage_boost = {
			description = "loc_talent_adamant_perfect_block_damage_boost_alt_desc",
			name = "",
			display_name = "loc_talent_adamant_perfect_block_damage_boost",
			format_values = {
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.perfect_block_damage_boost.damage
				},
				attack_speed = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.perfect_block_damage_boost.attack_speed
				},
				duration = {
					format_type = "number",
					value = talent_settings.perfect_block_damage_boost.duration
				},
				block_cost = {
					format_type = "percentage",
					value = talent_settings.perfect_block_damage_boost.block_cost,
					value_manipulation = function (value)
						return (1 - value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "adamant_perfect_block_damage_boost",
				identifier = "adamant_perfect_block_damage_boost"
			}
		},
		adamant_staggers_reduce_damage_taken = {
			description = "loc_talent_adamant_staggers_reduce_damage_taken_alt_desc",
			name = "",
			display_name = "loc_talent_adamant_staggers_reduce_damage_taken",
			format_values = {
				ogryn_stacks = {
					format_type = "number",
					value = talent_settings.staggers_reduce_damage_taken.ogryn_stacks
				},
				normal_stacks = {
					format_type = "number",
					value = talent_settings.staggers_reduce_damage_taken.normal_stacks
				},
				max_stacks = {
					format_type = "number",
					value = talent_settings.staggers_reduce_damage_taken.max_stacks
				},
				damage_taken_multiplier = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.staggers_reduce_damage_taken.damage_taken_multiplier,
					value_manipulation = function (value)
						return (1 - value) * 100
					end
				},
				duration = {
					format_type = "number",
					value = talent_settings.staggers_reduce_damage_taken.duration
				}
			},
			passive = {
				buff_template_name = "adamant_staggers_reduce_damage_taken",
				identifier = "adamant_staggers_reduce_damage_taken"
			}
		},
		adamant_damage_after_reloading = {
			description = "loc_talent_adamant_damage_after_reloading_desc",
			name = "",
			display_name = "loc_talent_adamant_damage_after_reloading",
			format_values = {
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.damage_after_reloading.ranged_damage
				},
				duration = {
					format_type = "number",
					value = talent_settings.damage_after_reloading.duration
				}
			},
			passive = {
				buff_template_name = "adamant_damage_after_reloading",
				identifier = "adamant_damage_after_reloading"
			}
		},
		adamant_multiple_hits_attack_speed = {
			description = "loc_talent_adamant_multiple_hits_attack_speed_desc",
			name = "",
			display_name = "loc_talent_adamant_multiple_hits_attack_speed",
			format_values = {
				melee_attack_speed = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.multiple_hits_attack_speed.melee_attack_speed
				},
				hits = {
					format_type = "number",
					value = talent_settings.multiple_hits_attack_speed.num_hits
				},
				duration = {
					format_type = "number",
					value = talent_settings.multiple_hits_attack_speed.duration
				}
			},
			passive = {
				buff_template_name = "adamant_multiple_hits_attack_speed",
				identifier = "adamant_multiple_hits_attack_speed"
			}
		},
		adamant_dog_kills_replenish_toughness = {
			description = "loc_talent_adamant_dog_kills_replenish_toughness_desc",
			name = "",
			display_name = "loc_talent_adamant_dog_kills_replenish_toughness",
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings.dog_kills_replenish_toughness.toughness * talent_settings.dog_kills_replenish_toughness.duration
				},
				duration = {
					format_type = "number",
					value = talent_settings.dog_kills_replenish_toughness.duration
				}
			},
			passive = {
				buff_template_name = "adamant_dog_kills_replenish_toughness",
				identifier = "adamant_dog_kills_replenish_toughness"
			}
		},
		adamant_elite_special_kills_replenish_toughness = {
			description = "loc_talent_adamant_elite_special_kills_replenish_toughness_desc",
			name = "",
			display_name = "loc_talent_adamant_elite_special_kills_replenish_toughness",
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings.elite_special_kills_replenish_toughness.toughness * talent_settings.elite_special_kills_replenish_toughness.duration
				},
				instant_toughness = {
					format_type = "percentage",
					value = talent_settings.elite_special_kills_replenish_toughness.instant_toughness
				},
				duration = {
					format_type = "number",
					value = talent_settings.elite_special_kills_replenish_toughness.duration
				}
			},
			passive = {
				buff_template_name = "adamant_elite_special_kills_replenish_toughness",
				identifier = "adamant_elite_special_kills_replenish_toughness"
			}
		},
		adamant_close_kills_restore_toughness = {
			description = "loc_talent_adamant_close_kills_restore_toughness_desc",
			name = "",
			display_name = "loc_talent_adamant_close_kills_restore_toughness",
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings.close_kills_restore_toughness.toughness
				}
			},
			passive = {
				buff_template_name = "adamant_close_kills_restore_toughness",
				identifier = "adamant_close_kills_restore_toughness"
			}
		},
		adamant_staggers_replenish_toughness = {
			description = "loc_talent_adamant_staggers_replenish_toughness_melee_desc",
			name = "",
			display_name = "loc_talent_adamant_staggers_replenish_toughness",
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings.staggers_replenish_toughness.toughness
				}
			},
			passive = {
				buff_template_name = "adamant_staggers_replenish_toughness",
				identifier = "adamant_staggers_replenish_toughness"
			}
		},
		adamant_dog_attacks_electrocute = {
			description = "loc_talent_adamant_dog_attacks_electrocute_desc",
			name = "",
			display_name = "loc_talent_adamant_dog_attacks_electrocute",
			format_values = {
				duration = {
					format_type = "number",
					value = talent_settings.dog_attacks_electrocute.duration
				}
			},
			passive = {
				buff_template_name = "adamant_dog_attacks_electrocute",
				identifier = "adamant_dog_attacks_electrocute"
			}
		},
		adamant_increased_damage_vs_horde = {
			description = "loc_talent_adamant_increased_damage_vs_horde_desc",
			name = "",
			display_name = "loc_talent_adamant_increased_damage_vs_horde",
			format_values = {
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.increased_damage_vs_horde.damage
				}
			},
			passive = {
				buff_template_name = "adamant_increased_damage_vs_horde",
				identifier = "adamant_increased_damage_vs_horde"
			}
		},
		adamant_limit_dmg_taken_from_hits = {
			description = "loc_talent_adamant_limit_dmg_taken_from_hits_desc",
			name = "",
			display_name = "loc_talent_adamant_limit_dmg_taken_from_hits",
			format_values = {
				limit = {
					format_type = "number",
					value = talent_settings.limit_dmg_taken_from_hits.limit
				}
			},
			passive = {
				buff_template_name = "adamant_limit_dmg_taken_from_hits",
				identifier = "adamant_limit_dmg_taken_from_hits"
			}
		},
		adamant_armor = {
			description = "loc_talent_adamant_armor_desc",
			name = "",
			display_name = "loc_talent_adamant_armor",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "number",
					value = talent_settings.armor.toughness
				}
			},
			passive = {
				buff_template_name = "adamant_armor",
				identifier = "adamant_armor"
			}
		},
		adamant_mag_strips = {
			description = "loc_talent_adamant_mag_strips_desc",
			name = "",
			display_name = "loc_talent_adamant_mag_strips",
			format_values = {
				wield_speed = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.mag_strips.wield_speed
				}
			},
			passive = {
				buff_template_name = "adamant_mag_strips",
				identifier = "adamant_mag_strips"
			}
		},
		adamant_plasteel_plates = {
			description = "loc_talent_adamant_plasteel_plates_desc",
			name = "",
			display_name = "loc_talent_adamant_plasteel_plates",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "number",
					value = talent_settings.plasteel_plates.toughness
				}
			},
			passive = {
				buff_template_name = "adamant_plasteel_plates",
				identifier = "adamant_plasteel_plates"
			}
		},
		adamant_verispex = {
			description = "loc_talent_adamant_verispex_desc",
			name = "",
			display_name = "loc_talent_adamant_verispex",
			format_values = {
				range = {
					format_type = "number",
					value = talent_settings.verispex.range
				}
			},
			passive = {
				buff_template_name = "adamant_verispex",
				identifier = "adamant_verispex"
			}
		},
		adamant_ammo_belt = {
			description = "loc_talent_adamant_ammo_belt_desc",
			name = "",
			display_name = "loc_talent_adamant_ammo_belt",
			format_values = {
				ammo = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.ammo_belt.ammo_reserve_capacity
				}
			},
			passive = {
				buff_template_name = "adamant_ammo_belt",
				identifier = "adamant_ammo_belt"
			}
		},
		adamant_rebreather = {
			description = "loc_talent_adamant_rebreather_desc",
			name = "",
			display_name = "loc_talent_adamant_rebreather",
			format_values = {
				corruption = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.rebreather.corruption_taken_multiplier,
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end
				},
				toxic_reduction = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.rebreather.damage_taken_from_toxic_gas_multiplier,
					value_manipulation = function (value)
						return (1 - value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "adamant_rebreather",
				identifier = "adamant_rebreather"
			}
		},
		adamant_riot_pads = {
			description = "loc_talent_adamant_riot_pads_desc",
			name = "",
			display_name = "loc_talent_adamant_riot_pads",
			format_values = {
				stacks = {
					format_type = "number",
					value = talent_settings.riot_pads.stacks
				},
				cooldown = {
					format_type = "number",
					value = talent_settings.riot_pads.cooldown
				}
			},
			passive = {
				buff_template_name = "adamant_riot_pads",
				identifier = "adamant_riot_pads"
			}
		},
		adamant_gutter_forged = {
			description = "loc_talent_adamant_gutter_forged_desc",
			name = "",
			display_name = "loc_talent_adamant_gutter_forged",
			format_values = {
				tdr = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.gutter_forged.tdr,
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				},
				movement_speed = {
					format_type = "percentage",
					value = talent_settings.gutter_forged.movement_speed
				}
			},
			passive = {
				buff_template_name = "adamant_gutter_forged",
				identifier = "adamant_gutter_forged"
			}
		},
		adamant_shield_plates = {
			description = "loc_talent_adamant_shield_plates_alt_desc",
			name = "",
			display_name = "loc_talent_adamant_shield_plates",
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings.shield_plates.toughness
				},
				perfect_toughness = {
					format_type = "percentage",
					value = talent_settings.shield_plates.perfect_toughness
				},
				duration = {
					format_type = "number",
					value = talent_settings.shield_plates.duration
				},
				cooldown = {
					format_type = "number",
					value = talent_settings.shield_plates.icd
				}
			},
			passive = {
				buff_template_name = "adamant_shield_plates",
				identifier = "adamant_shield_plates"
			}
		},
		adamant_cleave_after_push = {
			description = "loc_talent_adamant_cleave_after_push_desc",
			name = "",
			display_name = "loc_talent_adamant_cleave_after_push",
			format_values = {
				cleave = {
					format_type = "percentage",
					value = talent_settings.cleave_after_push.cleave
				},
				duration = {
					format_type = "number",
					value = talent_settings.cleave_after_push.duration
				}
			},
			passive = {
				buff_template_name = "adamant_cleave_after_push",
				identifier = "adamant_cleave_after_push"
			}
		},
		adamant_melee_attacks_on_staggered_rend = {
			description = "loc_talent_adamant_melee_attacks_on_staggered_rend_alt_desc",
			name = "",
			display_name = "loc_talent_adamant_melee_attacks_on_staggered_rend",
			format_values = {
				rending = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.melee_attacks_on_staggered_rend.rending_multiplier
				}
			},
			passive = {
				buff_template_name = "adamant_melee_attacks_on_staggered_rend",
				identifier = "adamant_melee_attacks_on_staggered_rend"
			}
		},
		adamant_wield_speed_on_melee_kill = {
			description = "loc_talent_adamant_wield_speed_on_melee_kill_desc",
			name = "",
			display_name = "loc_talent_adamant_wield_speed_on_melee_kill",
			format_values = {
				wield_speed = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.wield_speed_on_melee_kill.wield_speed_per_stack
				},
				duration = {
					format_type = "number",
					value = talent_settings.wield_speed_on_melee_kill.duration
				},
				stacks = {
					format_type = "number",
					value = talent_settings.wield_speed_on_melee_kill.max_stacks
				}
			},
			passive = {
				buff_template_name = "adamant_wield_speed_on_melee_kill",
				identifier = "adamant_wield_speed_on_melee_kill"
			}
		},
		adamant_heavy_attacks_increase_damage = {
			description = "loc_talent_adamant_heavy_attacks_increase_damage_desc",
			name = "",
			display_name = "loc_talent_adamant_heavy_attacks_increase_damage",
			format_values = {
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.heavy_attacks_increase_damage.damage
				},
				duration = {
					format_type = "number",
					value = talent_settings.heavy_attacks_increase_damage.duration
				}
			},
			passive = {
				buff_template_name = "adamant_heavy_attacks_increase_damage",
				identifier = "adamant_heavy_attacks_increase_damage"
			}
		},
		adamant_dog_damage_after_ability = {
			description = "loc_talent_adamant_dog_damage_after_ability_desc",
			name = "",
			display_name = "loc_talent_adamant_dog_damage_after_ability",
			format_values = {
				companion_damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.dog_damage_after_ability.damage
				},
				duration = {
					format_type = "number",
					value = talent_settings.dog_damage_after_ability.duration
				}
			},
			passive = {
				buff_template_name = "adamant_dog_damage_after_ability",
				identifier = "adamant_dog_damage_after_ability"
			}
		},
		adamant_hitting_multiple_gives_tdr = {
			description = "loc_talent_adamant_hitting_multiple_gives_tdr_desc",
			name = "",
			display_name = "loc_talent_adamant_hitting_multiple_gives_tdr",
			format_values = {
				tdr = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.hitting_multiple_gives_tdr.tdr,
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end
				},
				hits = {
					format_type = "number",
					value = talent_settings.hitting_multiple_gives_tdr.num_hits
				},
				duration = {
					format_type = "number",
					value = talent_settings.hitting_multiple_gives_tdr.duration
				}
			},
			passive = {
				buff_template_name = "adamant_hitting_multiple_gives_tdr",
				identifier = "adamant_hitting_multiple_gives_tdr"
			}
		},
		adamant_restore_toughness_to_allies_on_combat_ability = {
			description = "loc_talent_adamant_restore_toughness_to_allies_on_combat_ability_desc",
			name = "",
			display_name = "loc_talent_adamant_restore_toughness_to_allies_on_combat_ability",
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings.restore_toughness_to_allies_on_combat_ability.toughness_percent
				}
			},
			passive = {
				buff_template_name = "adamant_restore_toughness_to_allies_on_combat_ability",
				identifier = "adamant_restore_toughness_to_allies_on_combat_ability"
			}
		},
		adamant_dog_pounces_bleed_nearby = {
			description = "loc_talent_adamant_dog_pounces_bleed_nearby_desc",
			name = "",
			display_name = "loc_talent_adamant_dog_pounces_bleed_nearby",
			format_values = {
				stacks = {
					format_type = "number",
					value = talent_settings.dog_pounces_bleed_nearby.bleed_stacks
				}
			},
			passive = {
				buff_template_name = "adamant_dog_pounces_bleed_nearby",
				identifier = "adamant_dog_pounces_bleed_nearby"
			}
		},
		adamant_dog_applies_brittleness = {
			description = "loc_talent_adamant_dog_applies_brittleness_desc",
			name = "",
			display_name = "loc_talent_adamant_dog_applies_brittleness",
			format_values = {
				stacks = {
					format_type = "number",
					value = talent_settings.dog_applies_brittleness.stacks
				}
			},
			passive = {
				buff_template_name = "adamant_dog_applies_brittleness",
				identifier = "adamant_dog_applies_brittleness"
			}
		},
		adamant_no_movement_penalty = {
			description = "loc_talent_adamant_no_movement_penalty_desc",
			name = "",
			display_name = "loc_talent_adamant_no_movement_penalty",
			format_values = {
				reduction = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.no_movement_penalty.reduced_move_penalty
				}
			},
			passive = {
				buff_template_name = "adamant_no_movement_penalty",
				identifier = "adamant_no_movement_penalty"
			}
		},
		adamant_forceful = {
			description = "loc_talent_adamant_forceful_base_alt_desc",
			name = "",
			display_name = "loc_talent_adamant_forceful",
			format_values = {
				impact = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.forceful.impact
				},
				dr = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.forceful.dr,
					value_manipulation = function (value)
						return (1 - value) * 100
					end
				},
				stacks = {
					format_type = "number",
					value = talent_settings.forceful.stacks
				},
				duration = {
					format_type = "number",
					value = talent_settings.forceful.stack_duration
				},
				forceful_name = {
					value = "loc_talent_adamant_forceful",
					format_type = "loc_string"
				}
			},
			passive = {
				buff_template_name = "adamant_forceful",
				identifier = "adamant_forceful"
			}
		},
		adamant_forceful_toughness_regen_per_stack = {
			description = "loc_talent_adamant_forceful_toughness_regen_per_stack_desc",
			name = "",
			display_name = "loc_talent_adamant_forceful_toughness_regen",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.forceful.toughness
				}
			},
			special_rule = {
				identifier = "adamant_forceful_toughness_regen",
				special_rule_name = special_rules.adamant_forceful_toughness_regen
			}
		},
		adamant_forceful_stun_immune_and_block_all = {
			description = "loc_talent_adamant_forceful_stun_immune_and_block_all_linger_desc",
			name = "",
			display_name = "loc_talent_adamant_forceful_stamina_block_and_push_alt",
			format_values = {
				duration = {
					format_type = "number",
					value = talent_settings.forceful.stun_immune_linger_time
				}
			},
			special_rule = {
				identifier = "adamant_forceful_stun_immune",
				special_rule_name = special_rules.adamant_forceful_stun_immune
			}
		},
		adamant_forceful_ranged = {
			description = "loc_talent_adamant_forceful_ranged_alt_desc",
			name = "",
			display_name = "loc_talent_adamant_forceful_ranged",
			format_values = {
				ranged_attack_speed = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.forceful.ranged_attack_speed
				},
				reload_speed = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.forceful.reload_speed
				}
			},
			special_rule = {
				identifier = "adamant_forceful_ranged",
				special_rule_name = special_rules.adamant_forceful_ranged
			}
		},
		adamant_forceful_ability_damage = {
			description = "loc_talent_adamant_forceful_ability_damage",
			name = "",
			display_name = "loc_talent_adamant_forceful_refresh_on_ability",
			format_values = {
				strength = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.forceful.strength
				},
				duration = {
					format_type = "number",
					value = talent_settings.forceful.strength_duration
				}
			},
			special_rule = {
				identifier = "adamant_forceful_ability_strength",
				special_rule_name = special_rules.adamant_forceful_ability_strength
			}
		},
		adamant_forceful_stagger_on_low_high = {
			description = "loc_talent_adamant_forceful_stagger_on_low_high_desc",
			name = "",
			display_name = "loc_talent_adamant_forceful_melee",
			format_values = {
				low_stacks = {
					format_type = "number",
					value = talent_settings.forceful.low_stacks
				},
				high_stacks = {
					format_type = "number",
					value = talent_settings.forceful.high_stacks
				},
				cooldown = {
					format_type = "number",
					value = talent_settings.forceful.internal_cd
				}
			},
			passive = {
				buff_template_name = "adamant_forceful_stagger",
				identifier = "adamant_forceful_stagger"
			}
		},
		adamant_forceful_offensive = {
			description = "loc_talent_adamant_forceful_melee_alt_desc",
			name = "",
			display_name = "loc_talent_adamant_forceful_ranged",
			format_values = {
				duration = {
					format_type = "number",
					value = talent_settings.forceful.stun_immune_linger_time
				},
				attack_speed = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.forceful.attack_speed
				},
				cleave = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.forceful.cleave
				}
			},
			special_rule = {
				identifier = "adamant_forceful_offensive",
				special_rule_name = special_rules.adamant_forceful_offensive
			}
		},
		adamant_stance_dance = {
			description = "loc_talent_stance_dance_description",
			name = "",
			display_name = "loc_talent_adamant_bullet_rain",
			format_values = {
				melee_damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.stance_dance.melee_damage
				},
				ranged_damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.stance_dance.ranged_damage
				},
				melee_attack_speed = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.stance_dance.melee_attack_speed
				},
				suppression = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.stance_dance.suppression_dealt
				},
				t_p = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.stance_dance.toughness_share
				},
				power = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.stance_dance.shared_power
				},
				sprint_cost = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.stance_dance.sprint_cost,
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end
				},
				time = {
					format_type = "number",
					value = talent_settings.stance_dance.time
				}
			},
			passive = {
				identifier = {
					"adamant_stance_dance_melee",
					"adamant_stance_dance_ranged"
				},
				buff_template_name = {
					"adamant_stance_dance_melee",
					"adamant_stance_dance_ranged"
				}
			}
		},
		adamant_stance_dance_elite_kills = {
			description = "loc_talent_stance_dance_elite_kills_description",
			name = "",
			display_name = "loc_talent_adamant_bullet_rain_tdr",
			format_values = {
				damage_reduction = {
					format_type = "percentage",
					value = talent_settings.stance_dance.damage_reduction,
					value_manipulation = function (value)
						return (1 - value) * 100
					end
				},
				crit_chance = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.stance_dance.crit_chance
				},
				time = {
					format_type = "number",
					value = talent_settings.stance_dance.time
				}
			},
			special_rule = {
				identifier = "adamant_stance_dance_elite",
				special_rule_name = special_rules.adamant_stance_dance_elite
			}
		},
		adamant_stance_dance_reload_speed = {
			description = "loc_talent_stance_dance_reload_speed_description",
			name = "",
			display_name = "loc_talent_adamant_bullet_rain_fire_rate",
			format_values = {
				fire_rate = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.stance_dance.fire_rate
				},
				reload_speed = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.stance_dance.reload_speed
				},
				time = {
					format_type = "number",
					value = talent_settings.stance_dance.time
				}
			},
			passive = {
				buff_template_name = "adamant_stance_dance_reload_speed",
				identifier = "adamant_stance_dance_reload_speed"
			}
		},
		adamant_stance_dance_cleave = {
			description = "loc_talent_stance_dance_cleave_description",
			name = "",
			display_name = "loc_talent_adamant_bullet_rain_toughness",
			format_values = {
				hits = {
					format_type = "number",
					value = talent_settings.stance_dance.hits
				},
				cleave = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.stance_dance.cleave
				},
				time = {
					format_type = "number",
					value = talent_settings.stance_dance.time
				}
			},
			passive = {
				buff_template_name = "adamant_stance_dance_cleave",
				identifier = "adamant_stance_dance_cleave"
			}
		},
		adamant_stance_dance_weakspots = {
			description = "loc_talent_stance_dance_weakspots_description",
			name = "",
			display_name = "loc_talent_adamant_bullet_rain_ability",
			format_values = {
				power = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.stance_dance.power
				},
				crit_damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.stance_dance.crit_damage
				},
				weakspot_damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.stance_dance.weakspot_damage
				},
				melee_time = {
					format_type = "number",
					value = talent_settings.stance_dance.time
				},
				ranged_time = {
					format_type = "number",
					value = talent_settings.stance_dance.time
				}
			},
			passive = {
				identifier = {
					"adamant_stance_dance_weakspots_melee",
					"adamant_stance_dance_weakspots_ranged"
				},
				buff_template_name = {
					"adamant_stance_dance_weakspots_melee",
					"adamant_stance_dance_weakspots_ranged"
				}
			}
		},
		adamant_terminus_warrant = {
			description = "loc_talent_adamant_terminus_warrant_shortened_alt_desc",
			name = "",
			display_name = "loc_talent_adamant_bullet_rain",
			format_values = {
				melee_damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.terminus_warrant.melee_damage
				},
				melee_cleave = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.terminus_warrant.melee_cleave
				},
				melee_impact = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.terminus_warrant.melee_impact
				},
				melee_remove = {
					format_type = "number",
					value = talent_settings.terminus_warrant.melee_remove
				},
				ranged_remove = {
					format_type = "number",
					value = talent_settings.terminus_warrant.ranged_remove
				},
				ranged_damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.terminus_warrant.ranged_damage
				},
				suppression = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.terminus_warrant.suppression_dealt
				},
				ranged_cleave = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.terminus_warrant.ranged_max_hit_mass_attack_modifier
				},
				melee_attack_speed = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.terminus_warrant.melee_attack_speed
				},
				fire_rate = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.terminus_warrant.fire_rate
				},
				max_stacks = {
					format_type = "number",
					value = talent_settings.terminus_warrant.max_stacks
				},
				swap_stacks = {
					format_type = "number",
					value = talent_settings.terminus_warrant.swap_stacks
				},
				duration = {
					format_type = "number",
					value = talent_settings.terminus_warrant.duration
				}
			},
			passive = {
				buff_template_name = "adamant_terminus_warrant",
				identifier = "adamant_terminus_warrant"
			}
		},
		adamant_terminus_warrant_upgrade = {
			description = "loc_talent_adamant_terminus_warrant_upgrade_alt_desc",
			name = "",
			display_name = "loc_talent_adamant_bullet_rain_tdr",
			format_values = {
				melee_attack_speed = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.terminus_warrant.melee_attack_speed
				},
				fire_rate = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.terminus_warrant.fire_rate
				},
				swap_stacks = {
					format_type = "number",
					value = talent_settings.terminus_warrant.swap_stacks
				},
				duration = {
					format_type = "number",
					value = talent_settings.terminus_warrant.duration
				}
			},
			special_rule = {
				identifier = "adamant_terminus_warrant_upgrade_talent",
				special_rule_name = special_rules.adamant_terminus_warrant_upgrade_talent
			}
		},
		adamant_terminus_warrant_ranged = {
			description = "loc_talent_adamant_terminus_warrant_ranged_alt_desc",
			name = "",
			display_name = "loc_talent_adamant_bullet_rain_fire_rate",
			format_values = {
				reload_speed = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.terminus_warrant.reload_speed
				},
				bonus_stacks = {
					format_type = "number",
					value = talent_settings.terminus_warrant.bonus_stacks
				}
			},
			special_rule = {
				identifier = "adamant_terminus_warrant_ranged_talent",
				special_rule_name = special_rules.adamant_terminus_warrant_ranged_talent
			}
		},
		adamant_terminus_warrant_melee = {
			description = "loc_talent_adamant_terminus_warrant_toughness_desc",
			name = "",
			display_name = "loc_talent_adamant_bullet_rain_toughness",
			format_values = {
				melee_toughness = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.terminus_warrant.melee_toughness
				},
				bonus_stacks = {
					format_type = "number",
					value = talent_settings.terminus_warrant.bonus_stacks
				},
				toughness = {
					format_type = "percentage",
					value = talent_settings.terminus_warrant.toughness_shared
				}
			},
			special_rule = {
				identifier = "adamant_terminus_warrant_melee_talent",
				special_rule_name = special_rules.adamant_terminus_warrant_melee_talent
			}
		},
		adamant_terminus_warrant_improved = {
			description = "loc_talent_adamant_terminus_warrant_improved_alt_desc",
			name = "",
			display_name = "loc_talent_adamant_bullet_rain_ability",
			format_values = {
				melee_rending = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.terminus_warrant.melee_rending
				},
				ranged_rending = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.terminus_warrant.ranged_rending
				},
				crit_damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.terminus_warrant.crit_damage
				},
				weakspot_damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.terminus_warrant.weakspot_damage
				},
				talent_max_stacks = {
					format_type = "number",
					value = talent_settings.terminus_warrant.swap_stacks_talent
				},
				duration = {
					format_type = "number",
					value = talent_settings.terminus_warrant.duration
				}
			},
			special_rule = {
				identifier = "adamant_terminus_warrant_improved_talent",
				special_rule_name = special_rules.adamant_terminus_warrant_improved_talent
			}
		},
		adamant_exterminator = {
			description = "loc_talent_adamant_exterminator_desc",
			name = "",
			display_name = "loc_talent_adamant_exterminator",
			format_values = {
				talent_name = {
					value = "loc_talent_adamant_exterminator",
					format_type = "loc_string"
				},
				companion_damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.exterminator.companion_damage
				},
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.exterminator.damage
				},
				max_stacks = {
					format_type = "number",
					value = talent_settings.exterminator.max_stacks
				},
				duration = {
					format_type = "number",
					value = talent_settings.exterminator.duration
				}
			},
			passive = {
				buff_template_name = "adamant_mark_enemies_passive",
				identifier = "adamant_mark_enemies_passive"
			}
		},
		adamant_execution_order = {
			description = "loc_talent_execution_order_description",
			name = "",
			display_name = "loc_talent_adamant_exterminator",
			format_values = {
				time = {
					format_type = "number",
					value = talent_settings.execution_order.time
				},
				toughness = {
					format_type = "percentage",
					value = talent_settings.execution_order.toughness
				},
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.execution_order.damage
				},
				dog_damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.execution_order.companion_damage
				},
				attack_speed = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.execution_order.attack_speed
				}
			},
			passive = {
				buff_template_name = "adamant_execution_order",
				identifier = "adamant_execution_order"
			}
		},
		adamant_execution_order_crit = {
			description = "loc_talent_execution_order_crit_description",
			name = "",
			display_name = "loc_talent_adamant_exterminator_toughness",
			format_values = {
				time = {
					format_type = "number",
					value = talent_settings.execution_order.time
				},
				crit_chance = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.execution_order.crit_chance
				},
				crit_damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.execution_order.crit_damage
				}
			},
			special_rule = {
				identifier = "adamant_execution_order_crit",
				special_rule_name = special_rules.adamant_execution_order_crit
			}
		},
		adamant_execution_order_rending = {
			description = "loc_talent_execution_order_command_applies_brittleness_description",
			name = "",
			display_name = "loc_talent_adamant_exterminator_stack_during_activation",
			format_values = {
				time = {
					format_type = "number",
					value = talent_settings.execution_order.time
				},
				rending = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.execution_order.rending
				}
			},
			special_rule = {
				identifier = "adamant_execution_order_rending",
				special_rule_name = special_rules.adamant_execution_order_rending
			}
		},
		adamant_execution_order_permastack = {
			description = "loc_talent_execution_order_perma_buff_new_description",
			name = "",
			display_name = "loc_talent_execution_order_perma_buff",
			format_values = {
				max_stacks = {
					format_type = "number",
					value = talent_settings.execution_order.perma_max_stack
				},
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.execution_order.damage_vs_monsters
				},
				damage_red = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.execution_order.damage_taken_vs_monsters,
					value_manipulation = function (value)
						return (1 - value) * 100
					end
				}
			},
			special_rule = {
				identifier = "adamant_execution_order_permastack",
				special_rule_name = special_rules.adamant_execution_order_permastack
			}
		},
		adamant_execution_order_monster_debuff = {
			description = "loc_talent_execution_order_monster_description",
			name = "",
			display_name = "loc_talent_adamant_exterminator_boss_damage",
			format_values = {
				damage = {
					format_type = "percentage",
					value = talent_settings.execution_order.monster_damage,
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			special_rule = {
				identifier = "adamant_execution_order_monster_debuff",
				special_rule_name = special_rules.adamant_execution_order_monster_debuff
			}
		},
		adamant_execution_order_cdr = {
			description = "loc_talent_execution_order_cdr_on_kill_description",
			name = "",
			display_name = "loc_talent_adamant_exterminator_ability_cooldown",
			format_values = {
				time = {
					format_type = "number",
					value = talent_settings.execution_order.time
				},
				regen = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.execution_order.cdr
				}
			},
			special_rule = {
				identifier = "adamant_execution_order_cdr",
				special_rule_name = special_rules.adamant_execution_order_cdr
			}
		},
		adamant_execution_order_ally_toughness = {
			description = "loc_talent_adamant_execution_order_allied_kills_toughness_desc",
			name = "",
			display_name = "loc_talent_adamant_exterminator_boss_damage",
			format_values = {
				keystone_name = {
					value = "loc_talent_adamant_exterminator",
					format_type = "loc_string"
				},
				toughness = {
					format_type = "percentage",
					value = talent_settings.execution_order.ally_toughness
				}
			},
			special_rule = {
				identifier = "adamant_execution_order_ally_toughness",
				special_rule_name = special_rules.adamant_execution_order_ally_toughness
			}
		},
		adamant_exterminator_toughness = {
			description = "loc_talent_adamant_exterminator_toughness_desc",
			name = "",
			display_name = "loc_talent_adamant_exterminator_toughness",
			format_values = {
				talent_name = {
					value = "loc_talent_adamant_exterminator",
					format_type = "loc_string"
				},
				toughness = {
					format_type = "percentage",
					value = talent_settings.exterminator.toughness
				}
			},
			special_rule = {
				identifier = "adamant_exterminator_toughness",
				special_rule_name = special_rules.adamant_exterminator_toughness
			}
		},
		adamant_exterminator_boss_damage = {
			description = "loc_talent_adamant_exterminator_boss_damage_desc",
			name = "",
			display_name = "loc_talent_adamant_exterminator_boss_damage",
			format_values = {
				talent_name = {
					value = "loc_talent_adamant_exterminator",
					format_type = "loc_string"
				},
				boss_damage = {
					format_type = "percentage",
					value = talent_settings.exterminator.boss_damage
				}
			},
			special_rule = {
				identifier = "adamant_exterminator_boss_damage",
				special_rule_name = special_rules.adamant_exterminator_boss_damage
			}
		},
		adamant_exterminator_ability_cooldown = {
			description = "loc_talent_adamant_exterminator_ability_cooldown_desc",
			name = "",
			display_name = "loc_talent_adamant_exterminator_ability_cooldown",
			format_values = {
				talent_name = {
					value = "loc_talent_adamant_exterminator",
					format_type = "loc_string"
				},
				cooldown = {
					format_type = "percentage",
					value = talent_settings.exterminator.cooldown
				}
			},
			special_rule = {
				identifier = "adamant_exterminator_ability_cooldown",
				special_rule_name = special_rules.adamant_exterminator_ability_cooldown
			}
		},
		adamant_exterminator_stack_during_activation = {
			description = "loc_talent_adamant_exterminator_stack_during_activation_desc",
			name = "",
			display_name = "loc_talent_adamant_exterminator_stack_during_activation",
			format_values = {
				talent_name = {
					value = "loc_talent_adamant_exterminator",
					format_type = "loc_string"
				},
				stacks = {
					format_type = "number",
					value = talent_settings.exterminator.stacks
				}
			},
			special_rule = {
				identifier = "adamant_exterminator_stack_during_activation",
				special_rule_name = special_rules.adamant_exterminator_stack_during_activation
			}
		},
		adamant_exterminator_stamina_ammo = {
			description = "loc_talent_adamant_exterminator_stamina_ammo_desc",
			name = "",
			display_name = "loc_talent_adamant_exterminator_stamina_ammo",
			format_values = {
				talent_name = {
					value = "loc_talent_adamant_exterminator",
					format_type = "loc_string"
				},
				stamina = {
					format_type = "percentage",
					value = talent_settings.exterminator.stamina
				},
				ammo = {
					format_type = "percentage",
					value = talent_settings.exterminator.ammo
				}
			},
			special_rule = {
				identifier = "adamant_exterminator_stamina_ammo",
				special_rule_name = special_rules.adamant_exterminator_stamina_ammo
			}
		},
		adamant_crit_chance_on_kill = {
			description = "loc_talent_adamant_crit_chance_on_kill_desc",
			name = "",
			display_name = "loc_talent_adamant_crit_chance_on_kill",
			format_values = {
				crit_chance = {
					format_type = "percentage",
					value = talent_settings.crit_chance_on_kill.crit_chance
				},
				duration = {
					format_type = "number",
					value = talent_settings.crit_chance_on_kill.duration
				},
				max_stacks = {
					format_type = "number",
					value = talent_settings.crit_chance_on_kill.max_stacks
				}
			},
			passive = {
				buff_template_name = "adamant_crit_chance_on_kill",
				identifier = "adamant_crit_chance_on_kill"
			}
		},
		adamant_crits_rend = {
			description = "loc_talent_adamant_crits_rend_alt_desc",
			name = "",
			display_name = "loc_talent_adamant_crits_rend",
			format_values = {
				rending = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.crits_rend.rending
				}
			},
			passive = {
				buff_template_name = "adamant_crits_rend",
				identifier = "adamant_crits_rend"
			}
		},
		adamant_companion_focus_melee = {
			description = "loc_talent_adamant_cyber_mastiff_melee_desc",
			name = "",
			display_name = "loc_talent_adamant_cyber_mastiff_melee",
			format_values = {
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.companion_focus_melee.damage
				}
			},
			passive = {
				buff_template_name = "adamant_companion_focus_melee",
				identifier = "adamant_companion_focus_melee"
			},
			special_rule = {
				identifier = "adamant_companion_melee_focus",
				special_rule_name = special_rules.adamant_companion_melee_focus
			}
		},
		adamant_companion_focus_ranged = {
			description = "loc_talent_adamant_cyber_mastiff_ranged_desc",
			name = "",
			display_name = "loc_talent_adamant_cyber_mastiff_ranged",
			format_values = {
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.companion_focus_ranged.damage
				}
			},
			passive = {
				buff_template_name = "adamant_companion_focus_ranged",
				identifier = "adamant_companion_focus_ranged"
			},
			special_rule = {
				identifier = "adamant_companion_ranged_focus",
				special_rule_name = special_rules.adamant_companion_ranged_focus
			}
		},
		adamant_companion_focus_elite = {
			description = "loc_talent_adamant_cyber_mastiff_elites_desc",
			name = "",
			display_name = "loc_talent_adamant_cyber_mastiff_elites",
			format_values = {
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.companion_focus_elite.damage
				}
			},
			passive = {
				buff_template_name = "adamant_companion_focus_elite",
				identifier = "adamant_companion_focus_elite"
			},
			special_rule = {
				identifier = "adamant_companion_elite_focus",
				special_rule_name = special_rules.adamant_companion_elite_focus
			}
		},
		adamant_suppression_immunity = {
			description = "loc_talent_adamant_suppression_immunity_desc",
			name = "",
			display_name = "loc_talent_adamant_suppression_immunity",
			format_values = {},
			passive = {
				buff_template_name = "adamant_suppression_immunity",
				identifier = "adamant_suppression_immunity"
			}
		},
		adamant_damage_vs_suppressed = {
			description = "loc_talent_adamant_damage_vs_suppressed_desc",
			name = "",
			display_name = "loc_talent_adamant_damage_vs_suppressed",
			format_values = {
				damage_vs_suppressed = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.damage_vs_suppressed.damage_vs_suppressed
				}
			},
			passive = {
				buff_template_name = "adamant_damage_vs_suppressed",
				identifier = "adamant_damage_vs_suppressed"
			}
		},
		adamant_clip_size = {
			description = "loc_talent_adamant_clip_size_alt_desc",
			name = "",
			display_name = "loc_talent_adamant_clip_size",
			format_values = {
				clip_size = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.clip_size.clip_size_modifier
				}
			},
			passive = {
				buff_template_name = "adamant_clip_size",
				identifier = "adamant_clip_size"
			}
		},
		adamant_stacking_damage = {
			description = "loc_talent_adamant_stacking_damage_desc",
			name = "",
			display_name = "loc_talent_adamant_stacking_damage",
			format_values = {
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.stacking_damage.damage
				},
				duration = {
					format_type = "number",
					value = talent_settings.stacking_damage.duration
				},
				stacks = {
					format_type = "number",
					value = talent_settings.stacking_damage.stacks
				}
			},
			passive = {
				buff_template_name = "adamant_stacking_damage",
				identifier = "adamant_stacking_damage"
			}
		},
		adamant_staggering_enemies_take_more_damage = {
			description = "loc_talent_ogryn_big_bully_heavy_hits_new_desc",
			name = "",
			display_name = "loc_talent_adamant_staggered_enemies_take_more_damage",
			format_values = {
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.staggering_enemies_take_more_damage.damage
				},
				duration = {
					format_type = "number",
					value = talent_settings.staggering_enemies_take_more_damage.duration
				}
			},
			passive = {
				buff_template_name = "adamant_staggering_increases_damage_taken",
				identifier = "adamant_staggering_increases_damage_taken"
			}
		},
		adamant_staggered_enemies_deal_less_damage = {
			description = "loc_talent_adamant_staggered_enemies_deal_less_damage_desc",
			name = "",
			display_name = "loc_talent_adamant_staggered_enemies_deal_less_damage",
			format_values = {
				damage = {
					format_type = "percentage",
					value = talent_settings.staggered_enemies_deal_less_damage.damage
				},
				duration = {
					format_type = "number",
					value = talent_settings.staggered_enemies_deal_less_damage.duration
				}
			},
			passive = {
				buff_template_name = "adamant_staggered_enemies_deal_less_damage",
				identifier = "adamant_staggered_enemies_deal_less_damage"
			}
		},
		adamant_melee_weakspot_hits_count_as_stagger = {
			description = "loc_talent_adamant_melee_weakspot_hits_count_as_stagger_desc",
			name = "",
			display_name = "loc_talent_adamant_melee_weakspot_hits_count_as_stagger",
			format_values = {
				duration = {
					format_type = "number",
					value = talent_settings.melee_weakspot_hits_count_as_stagger.duration
				}
			},
			passive = {
				buff_template_name = "adamant_melee_weakspot_hits_count_as_stagger",
				identifier = "adamant_melee_weakspot_hits_count_as_stagger"
			},
			special_rule = {
				identifier = "adamant_melee_weakspots_count_as_staggered",
				special_rule_name = special_rules.adamant_melee_weakspots_count_as_staggered
			}
		},
		adamant_weapon_handling = {
			description = "loc_talent_adamant_weapon_handling_desc",
			name = "",
			display_name = "loc_talent_adamant_weapon_handling",
			format_values = {
				recoil = {
					format_type = "percentage",
					value = talent_settings.weapon_handling.recoil
				},
				spread = {
					format_type = "percentage",
					value = talent_settings.weapon_handling.spread
				},
				time = {
					num_decimals = 1,
					format_type = "number",
					value = talent_settings.weapon_handling.time
				},
				stacks = {
					format_type = "number",
					value = talent_settings.weapon_handling.stacks
				}
			},
			passive = {
				buff_template_name = "adamant_weapon_handling",
				identifier = "adamant_weapon_handling"
			}
		},
		adamant_electrified_enemies_deal_less_damage = {
			description = "loc_talent_adamant_electrified_enemies_deal_less_damage_desc",
			name = "",
			display_name = "loc_talent_adamant_electrified_enemies_deal_less_damage"
		},
		adamant_increased_damage_to_high_health = {
			description = "loc_talent_adamant_increased_damage_to_high_health_desc",
			name = "",
			display_name = "loc_talent_adamant_increased_damage_to_high_health",
			format_values = {
				damage = {
					format_type = "percentage",
					value = talent_settings.increased_damage_to_high_health.damage
				},
				health = {
					format_type = "percentage",
					value = talent_settings.increased_damage_to_high_health.health
				}
			},
			passive = {
				buff_template_name = "adamant_increased_damage_to_high_health",
				identifier = "adamant_increased_damage_to_high_health"
			}
		},
		adamant_movement_speed_on_block = {
			description = "loc_talent_adamant_movement_speed_on_block_alt_desc",
			name = "",
			display_name = "loc_talent_adamant_movement_speed_on_block",
			format_values = {
				movement_speed = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.movement_speed_on_block.movement_speed
				},
				duration = {
					format_type = "number",
					value = talent_settings.movement_speed_on_block.duration
				}
			},
			passive = {
				buff_template_name = "adamant_movement_speed_on_block",
				identifier = "adamant_movement_speed_on_block"
			}
		},
		adamant_elite_special_kills_reload_speed = {
			description = "loc_talent_adamant_elite_special_kills_reload_speed_desc",
			name = "",
			display_name = "loc_talent_adamant_elite_special_kills_reload_speed",
			format_values = {
				reload_speed = {
					format_type = "percentage",
					value = talent_settings.elite_special_kills_reload_speed.reload_speed
				}
			},
			passive = {
				buff_template_name = "adamant_elite_special_kills_reload_speed",
				identifier = "adamant_elite_special_kills_reload_speed"
			}
		},
		adamant_dodge_grants_damage = {
			description = "loc_talent_adamant_dodge_grants_damage_desc",
			name = "",
			display_name = "loc_talent_adamant_dodge_grants_damage",
			format_values = {
				damage = {
					format_type = "percentage",
					value = talent_settings.dodge_grants_damage.damage
				},
				duration = {
					format_type = "number",
					value = talent_settings.dodge_grants_damage.duration
				}
			},
			passive = {
				buff_template_name = "adamant_dodge_grants_damage",
				identifier = "adamant_dodge_grants_damage"
			}
		},
		adamant_stacking_weakspot_strength = {
			description = "loc_talent_adamant_stacking_weakspot_strength_duration_desc",
			name = "",
			display_name = "loc_talent_adamant_stacking_weakspot_strength",
			format_values = {
				strength = {
					format_type = "percentage",
					value = talent_settings.stacking_weakspot_strength.strength
				},
				max_stacks = {
					format_type = "number",
					value = talent_settings.stacking_weakspot_strength.max_stacks
				},
				duration = {
					format_type = "number",
					value = talent_settings.stacking_weakspot_strength.duration
				}
			},
			passive = {
				buff_template_name = "adamant_stacking_weakspot_strength",
				identifier = "adamant_stacking_weakspot_strength"
			}
		},
		adamant_ranged_damage_on_melee_stagger = {
			description = "loc_talent_adamant_ranged_damage_on_melee_stagger_desc",
			name = "",
			display_name = "loc_talent_adamant_ranged_damage_on_melee_stagger",
			format_values = {
				damage = {
					format_type = "percentage",
					value = talent_settings.ranged_damage_on_melee_stagger.ranged_damage
				},
				duration = {
					format_type = "number",
					value = talent_settings.ranged_damage_on_melee_stagger.duration
				}
			},
			passive = {
				buff_template_name = "adamant_ranged_damage_on_melee_stagger",
				identifier = "adamant_ranged_damage_on_melee_stagger"
			}
		},
		adamant_dodge_improvement = {
			description = "loc_talent_adamant_dodge_improvement_desc",
			name = "",
			display_name = "loc_talent_adamant_dodge_improvement",
			format_values = {
				dodge = {
					prefix = "+",
					format_type = "number",
					value = talent_settings.dodge_improvement.dodge
				},
				dodge_duration = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.dodge_improvement.dodge_duration
				}
			},
			passive = {
				buff_template_name = "adamant_dodge_improvement",
				identifier = "adamant_dodge_improvement"
			}
		},
		adamant_stamina_spent_replenish_toughness = {
			description = "loc_talent_adamant_stamina_spent_replenish_toughness_desc",
			name = "",
			display_name = "loc_talent_adamant_stamina_regens_toughness",
			format_values = {
				stamina = {
					format_type = "number",
					value = talent_settings.stamina_spent_replenish_toughness.stamina
				},
				toughness = {
					format_type = "percentage",
					value = talent_settings.stamina_spent_replenish_toughness.toughness
				},
				duration = {
					format_type = "number",
					value = talent_settings.stamina_spent_replenish_toughness.duration
				}
			},
			passive = {
				buff_template_name = "adamant_stamina_spent_replenish_toughness",
				identifier = "adamant_stamina_spent_replenish_toughness"
			}
		},
		adamant_monster_hunter = {
			description = "loc_talent_adamant_monster_hunter_desc",
			name = "",
			display_name = "loc_talent_adamant_monster_hunter",
			format_values = {
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.monster_hunter.damage
				}
			},
			passive = {
				buff_template_name = "adamant_monster_hunter",
				identifier = "adamant_monster_hunter"
			}
		},
		adamant_uninterruptible_heavies = {
			description = "loc_talent_adamant_uninterruptible_heavies_desc",
			name = "",
			display_name = "loc_talent_adamant_uninterruptible_heavies",
			format_values = {},
			passive = {
				buff_template_name = "adamant_uninterruptible_heavies",
				identifier = "adamant_uninterruptible_heavies"
			}
		},
		adamant_first_melee_hit_increased_damage = {
			description = "loc_talent_adamant_first_melee_hit_increased_damage_desc",
			name = "",
			display_name = "loc_talent_adamant_first_melee_hit_increased_damage",
			format_values = {
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.first_melee_hit_increased_damage.damage
				},
				impact = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.first_melee_hit_increased_damage.impact
				}
			},
			passive = {
				buff_template_name = "adamant_first_melee_hit_increased_damage",
				identifier = "adamant_first_melee_hit_increased_damage"
			}
		},
		adamant_pinning_dog_bonus_moving_towards = {
			description = "loc_talent_adamant_pinning_dog_bonus_moving_towards_description",
			name = "",
			display_name = "loc_talent_adamant_pinning_dog_bonus_moving_towards",
			format_values = {
				movement_speed = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.pinning_dog_bonus_moving_towards.movement_speed
				},
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.pinning_dog_bonus_moving_towards.damage
				},
				time = {
					format_type = "number",
					value = talent_settings.pinning_dog_bonus_moving_towards.time
				}
			},
			passive = {
				buff_template_name = "adamant_pinning_dog_bonus_moving_towards",
				identifier = "adamant_pinning_dog_bonus_moving_towards"
			}
		},
		adamant_pinning_dog_cleave_bonus = {
			description = "loc_talent_adamant_pinning_dog_cleave_bonus_description",
			name = "",
			display_name = "loc_talent_adamant_pinning_dog_cleave_bonus",
			format_values = {
				cleave = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.pinning_dog_cleave_bonus.cleave
				},
				time = {
					format_type = "number",
					value = talent_settings.pinning_dog_cleave_bonus.time
				}
			}
		},
		adamant_pinning_dog_elite_damage = {
			description = "loc_talent_adamant_pinning_dog_elite_damage_description",
			name = "",
			display_name = "loc_talent_adamant_pinning_dog_elite_damage",
			format_values = {
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.pinning_dog_elite_damage.damage
				},
				time = {
					format_type = "number",
					value = talent_settings.pinning_dog_elite_damage.duration
				}
			},
			passive = {
				buff_template_name = "adamant_pinning_dog_elite_damage",
				identifier = "adamant_pinning_dog_elite_damage"
			}
		},
		adamant_pinning_dog_permanent_stacks = {
			description = "loc_talent_adamant_pinning_dog_permanent_stacks_description",
			name = "",
			display_name = "loc_talent_adamant_pinning_dog_permanent_stacks",
			format_values = {
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.pinning_dog_permanent_stacks.damage
				},
				stacks = {
					format_type = "number",
					value = talent_settings.pinning_dog_permanent_stacks.stacks
				}
			},
			passive = {
				buff_template_name = "adamant_pinning_dog_permanent_stacks",
				identifier = "adamant_pinning_dog_permanent_stacks"
			}
		},
		adamant_pinning_dog_kills_buff_allies = {
			description = "loc_talent_adamant_pinning_dog_kills_buff_allies_description",
			name = "",
			display_name = "loc_talent_adamant_pinning_dog_kills_buff_allies",
			format_values = {
				tdr = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.pinning_dog_kills_buff_allies.tdr,
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end
				},
				toughness = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.pinning_dog_kills_buff_allies.toughness
				},
				duration = {
					format_type = "number",
					value = talent_settings.pinning_dog_kills_buff_allies.duration
				}
			},
			passive = {
				buff_template_name = "adamant_pinning_dog_kills_buff_allies",
				identifier = "adamant_pinning_dog_kills_buff_allies"
			}
		},
		adamant_pinning_dog_kills_cdr = {
			description = "loc_talent_adamant_pinning_dog_kills_cdr_description",
			name = "",
			display_name = "loc_talent_adamant_pinning_dog_kills_cdr",
			format_values = {
				regen = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.pinning_dog_kills_cdr.regen
				},
				time = {
					format_type = "number",
					value = talent_settings.pinning_dog_kills_cdr.time
				}
			},
			passive = {
				buff_template_name = "adamant_pinning_dog_kills_cdr",
				identifier = "adamant_pinning_dog_kills_cdr"
			}
		},
		adamant_sprinting_sliding = {
			description = "loc_talent_adamant_sprinting_sliding_description",
			name = "",
			display_name = "loc_talent_adamant_sprinting_sliding",
			format_values = {
				speed = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.sprinting_sliding.speed
				},
				stamina = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings.sprinting_sliding.stamina
				},
				duration = {
					format_type = "number",
					value = talent_settings.sprinting_sliding.duration
				},
				cd = {
					format_type = "number",
					value = talent_settings.sprinting_sliding.cd
				}
			},
			passive = {
				identifier = {
					"adamant_sprinting_sliding",
					"adamant_sprinting_sliding_kills"
				},
				buff_template_name = {
					"adamant_sprinting_sliding",
					"adamant_sprinting_sliding_kills"
				}
			}
		},
		adamant_shockmine_duration = {
			description = "loc_talent_ability_adamant_shockmine_duration_description",
			name = "",
			display_name = "loc_talent_ability_adamant_shockmine_duration",
			format_values = {}
		},
		adamant_shockmine_damage = {
			description = "loc_talent_ability_adamant_shockmine_damage_description",
			name = "",
			display_name = "loc_talent_ability_adamant_shockmine_damage",
			format_values = {}
		},
		adamant_temp_judge_dredd = {
			description = "loc_talent_adamant_temp_judge_dredd_description",
			name = "Dev Stat Block - Judge Dredd",
			display_name = "loc_talent_adamant_temp_judge_dredd_name",
			icon = "content/ui/textures/icons/talents/adamant/adamant_ability_charge",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "number",
					find_value = {
						buff_template_name = "adamant_temp_judge_dredd",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness
						}
					}
				},
				tdr = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_judge_dredd",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ranged_toughness_damage_taken_multiplier
						}
					},
					value_manipulation = function (value)
						return (1 - value) * 100
					end
				},
				reload_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_judge_dredd",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.reload_speed
						}
					}
				},
				power_level_modifier = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_judge_dredd",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.power_level_modifier
						}
					}
				},
				suppression_dealt = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_judge_dredd",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.suppression_dealt
						}
					}
				},
				ranged_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_judge_dredd",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ranged_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "adamant_temp_judge_dredd",
				identifier = "adamant_temp_judge_dredd"
			}
		},
		adamant_temp_riot_control = {
			description = "loc_talent_adamant_temp_riot_control_description",
			name = "Dev Stat Block - riot_control",
			display_name = "loc_talent_adamant_temp_riot_control_name",
			icon = "content/ui/textures/icons/talents/adamant/adamant_ability_charge",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "number",
					find_value = {
						buff_template_name = "adamant_temp_riot_control",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness
						}
					}
				},
				tdr = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_riot_control",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_multiplier
						}
					},
					value_manipulation = function (value)
						return (1 - value) * 100
					end
				},
				stagger = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_riot_control",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.impact_modifier
						}
					}
				},
				cleave = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_riot_control",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.max_melee_hit_mass_attack_modifier
						}
					}
				},
				melee_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_riot_control",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_damage
						}
					}
				},
				toughness_melee_replenish = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_riot_control",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_melee_replenish
						}
					}
				}
			},
			passive = {
				buff_template_name = "adamant_temp_riot_control",
				identifier = "adamant_temp_riot_control"
			}
		},
		adamant_temp_enforcer = {
			description = "loc_talent_adamant_temp_enforcer_description",
			name = "Dev Stat Block - Enforcer",
			display_name = "loc_talent_adamant_temp_enforcer_name",
			icon = "content/ui/textures/icons/talents/adamant/adamant_ability_charge",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "number",
					find_value = {
						buff_template_name = "adamant_temp_enforcer",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness
						}
					}
				},
				tdr = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_enforcer",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_multiplier
						}
					},
					value_manipulation = function (value)
						return (1 - value) * 100
					end
				},
				stagger = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_enforcer",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.impact_modifier
						}
					}
				},
				cleave = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_enforcer",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.max_melee_hit_mass_attack_modifier
						}
					}
				},
				melee_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_enforcer",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_damage
						}
					}
				},
				melee_attack_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_enforcer",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_attack_speed
						}
					}
				},
				movement_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_enforcer",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.movement_speed
						}
					}
				}
			},
			passive = {
				buff_template_name = "adamant_temp_enforcer",
				identifier = "adamant_temp_enforcer"
			}
		},
		adamant_temp_handler = {
			description = "loc_talent_adamant_temp_handler_description",
			name = "Dev Stat Block - handler",
			display_name = "loc_talent_adamant_temp_handler_name",
			icon = "content/ui/textures/icons/talents/adamant/adamant_ability_charge",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "number",
					find_value = {
						buff_template_name = "adamant_temp_handler",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness
						}
					}
				},
				tdr = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_handler",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ranged_toughness_damage_taken_multiplier
						}
					},
					value_manipulation = function (value)
						return (1 - value) * 100
					end
				},
				suppression = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_handler",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.suppression_dealt
						}
					}
				},
				companion_damage_modifier = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_handler",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.companion_damage_modifier
						}
					}
				},
				ranged_damge = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_handler",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ranged_damage
						}
					}
				},
				movement_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_handler",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.movement_speed
						}
					}
				}
			},
			passive = {
				buff_template_name = "adamant_temp_handler",
				identifier = "adamant_temp_handler"
			}
		},
		adamant_temp_beast_master = {
			description = "loc_talent_adamant_temp_beast_master_description",
			name = "Dev Stat Block - beast_master",
			display_name = "loc_talent_adamant_temp_beast_master_name",
			icon = "content/ui/textures/icons/talents/adamant/adamant_ability_charge",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "number",
					find_value = {
						buff_template_name = "adamant_temp_beast_master",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness
						}
					}
				},
				tdr = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_beast_master",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_multiplier
						}
					},
					value_manipulation = function (value)
						return (1 - value) * 100
					end
				},
				melee_attack_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_beast_master",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_attack_speed
						}
					}
				},
				companion_damage_modifier = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_beast_master",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.companion_damage_modifier
						}
					}
				},
				melee_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_beast_master",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_damage
						}
					}
				},
				movement_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_beast_master",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.movement_speed
						}
					}
				}
			},
			passive = {
				buff_template_name = "adamant_temp_beast_master",
				identifier = "adamant_temp_beast_master"
			}
		},
		adamant_temp_investigator = {
			description = "loc_talent_adamant_temp_investigator_description",
			name = "Dev Stat Block - investigator",
			display_name = "loc_talent_adamant_temp_investigator_name",
			icon = "content/ui/textures/icons/talents/adamant/adamant_ability_charge",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "number",
					find_value = {
						buff_template_name = "adamant_temp_investigator",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness
						}
					}
				},
				tdr = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_investigator",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_multiplier
						}
					},
					value_manipulation = function (value)
						return (1 - value) * 100
					end
				},
				toughness_replenish_modifier = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_investigator",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_replenish_modifier
						}
					}
				},
				wield_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_investigator",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.wield_speed
						}
					}
				},
				damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_investigator",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.damage
						}
					}
				},
				movement_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_investigator",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.movement_speed
						}
					}
				},
				reload_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_investigator",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.reload_speed
						}
					}
				}
			},
			passive = {
				buff_template_name = "adamant_temp_investigator",
				identifier = "adamant_temp_investigator"
			}
		},
		adamant_temp_supportive_fire = {
			description = "loc_talent_adamant_temp_supportive_fire_description",
			name = "Dev Stat Block - supportive_fire",
			display_name = "loc_talent_adamant_temp_supportive_fire_name",
			icon = "content/ui/textures/icons/talents/adamant/adamant_ability_charge",
			format_values = {
				tdr = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_supportive_fire",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ranged_toughness_damage_taken_multiplier
						}
					},
					value_manipulation = function (value)
						return (1 - value) * 100
					end
				},
				toughness_replenish_modifier = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_supportive_fire",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_replenish_modifier
						}
					}
				},
				ranged_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_supportive_fire",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ranged_damage
						}
					}
				},
				suppression_dealt = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_supportive_fire",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.suppression_dealt
						}
					}
				},
				spread_modifier = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_supportive_fire",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.spread_modifier
						}
					}
				},
				recoil_modifier = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_supportive_fire",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.recoil_modifier
						}
					}
				},
				sway_modifier = {
					prefix = "-",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_supportive_fire",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.sway_modifier
						}
					}
				}
			},
			passive = {
				buff_template_name = "adamant_temp_supportive_fire",
				identifier = "adamant_temp_supportive_fire"
			}
		},
		adamant_temp_fire_wall = {
			description = "loc_talent_adamant_temp_fire_wall_description",
			name = "Dev Stat Block - fire_wall",
			display_name = "loc_talent_adamant_temp_fire_wall_name",
			icon = "content/ui/textures/icons/talents/adamant/adamant_ability_charge",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "number",
					find_value = {
						buff_template_name = "adamant_temp_fire_wall",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness
						}
					}
				},
				stamina_cost = {
					prefix = "-",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_fire_wall",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.stamina_cost_multiplier
						}
					},
					value_manipulation = function (value)
						return (1 - value) * 100
					end
				},
				toughness_replenish_modifier = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_fire_wall",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_replenish_modifier
						}
					}
				},
				wield_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_fire_wall",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.wield_speed
						}
					}
				},
				damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_fire_wall",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.damage
						}
					}
				},
				movement_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_fire_wall",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.movement_speed
						}
					}
				},
				suppression_dealt = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_fire_wall",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.suppression_dealt
						}
					}
				},
				tdr = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "adamant_temp_investigator",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_multiplier
						}
					},
					value_manipulation = function (value)
						return (1 - value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "adamant_temp_fire_wall",
				identifier = "adamant_temp_fire_wall"
			}
		}
	}
}

return archetype_talents
