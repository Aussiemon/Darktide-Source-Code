local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local TalentSettings = require("scripts/settings/buff/talent_settings")
local talent_settings = TalentSettings.psyker_2
local math_round = math.round
math_round = math_round or function (value)
	if value >= 0 then
		return math.floor(value + 0.5)
	else
		return math.ceil(value - 0.5)
	end
end
local max_souls_talent = talent_settings.offensive_2_1.max_souls_talent
local archetype_talents = {
	archetype = "psyker",
	specialization = "psyker_2",
	talents = {
		psyker_2_combat = {
			large_icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_combat",
			name = "F-Ability - Shout, knocking down enemies in front of you in a cone, and remove all accumilated warp charge",
			display_name = "loc_talent_psyker_2_combat",
			description = "loc_talent_psyker_2_combat_description",
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.psyker_discharge_shout
			},
			special_rule = {
				special_rule_name = "shout_drains_warp_charge",
				identifier = "shout_drains_warp_charge"
			}
		},
		psyker_2_smite = {
			description = "loc_ability_psyker_smite_description",
			name = "G-Ability - Target enemies to charge a Smite attack, dealing a high amount of damage",
			hud_icon = "content/ui/materials/icons/abilities/default",
			display_name = "loc_ability_psyker_smite",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tactical",
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.psyker_smite
			}
		},
		psyker_2_base_1 = {
			description = "loc_talent_biomancer_souls_desc",
			name = "Killing an enemy with Smite retains their soul. Each soul increase the damage you do. Souls are retained for 20 seconds and you can hold up to 4 souls at the same time.",
			display_name = "loc_talent_biomancer_souls",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_base_1",
			format_values = {
				damage = talent_settings.passive_1.damage * 100 / max_souls_talent,
				stack = talent_settings.passive_1.base_max_souls,
				time = talent_settings.passive_1.soul_duration
			},
			passive = {
				buff_template_name = "psyker_biomancer_passive",
				identifier = "psyker_biomancer_passive"
			}
		},
		psyker_2_base_2 = {
			description = "loc_talent_psyker_2_base_2b_description",
			name = "Passive - Your kills have 10% chance to reduce warp charge by 10%",
			display_name = "loc_talent_psyker_2_base_2b",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_base_2",
			format_values = {
				warp_charge_percent = talent_settings.passive_2.warp_charge_percent * 100,
				chance = talent_settings.passive_2.on_hit_proc_chance * 100
			},
			passive = {
				buff_template_name = "psyker_biomancer_base_passive",
				identifier = "psyker_biomancer_base_passive"
			}
		},
		psyker_2_base_3 = {
			description = "loc_talent_psyker_2_base_3_description",
			name = "Aura - Increased damage versus elites and specials",
			display_name = "loc_talent_psyker_2_base_3",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_aura",
			format_values = {
				damage = talent_settings.coherency.damage_vs_elites * 100
			},
			coherency = {
				buff_template_name = "psyker_biomancer_coherency_damage_vs_elites",
				identifier = "damage_vs_elite"
			}
		},
		psyker_2_tier_1_name_1 = {
			description = "loc_talent_biomancer_toughness_regen_on_soul_desc",
			name = "Replenish toughness over time after gaining a soul.",
			display_name = "loc_talent_biomancer_toughness_regen_on_soul",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_1_1",
			format_values = {
				toughness = talent_settings.toughness_1.percent_toughness * talent_settings.toughness_1.duration * 100,
				time = talent_settings.toughness_1.duration
			},
			special_rule = {
				special_rule_name = "psyker_biomancer_toughness_on_soul",
				identifier = "psyker_biomancer_toughness_on_soul"
			}
		},
		psyker_2_tier_1_name_2 = {
			description = "loc_talent_biomancer_toughness_on_warp_kill_desc",
			name = "Replenish toughness when killing an enemy with warp powered attacks.",
			display_name = "loc_talent_biomancer_toughness_on_warp_kill",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_5_2",
			format_values = {
				toughness = talent_settings.toughness_2.percent_toughness * 100
			},
			passive = {
				buff_template_name = "psyker_biomancer_toughness_on_warp_kill",
				identifier = "toughness"
			}
		},
		psyker_2_tier_1_name_3 = {
			description = "loc_talent_biomancer_toughness_from_vent_desc",
			name = "Replenish toughness for each % of warp charge ventilated.",
			display_name = "loc_talent_biomancer_toughness_from_vent",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_4_3",
			format_values = {
				warp_charge = 10,
				toughness = talent_settings.toughness_3.multiplier * 10
			},
			passive = {
				buff_template_name = "psyker_biomancer_toughness_on_vent",
				identifier = "toughness"
			}
		},
		psyker_2_tier_2_name_1 = {
			description = "loc_talent_biomancer_damage_from_warp_charge_desc",
			name = "Gain damage with warp attacks based on your current warp charge amount.",
			display_name = "loc_talent_biomancer_damage_from_warp_charge",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_1_3",
			format_values = {
				min_damage = talent_settings.offensive_1_1.damage_min * 100,
				max_damage = talent_settings.offensive_1_1.damage * 100
			},
			passive = {
				buff_template_name = "psyker_biomancer_warp_charge_increase_force_weapon_damage",
				identifier = "offensive_1"
			}
		},
		psyker_2_tier_2_name_2 = {
			description = "loc_talent_biomancer_reduced_warp_charge_cost_venting_speed_desc",
			name = "Reduces warp charge generation per soul.",
			display_name = "loc_talent_biomancer_reduced_warp_charge_cost_venting_speed",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_2_3",
			format_values = {
				warp_charge_generation = (1 - talent_settings.offensive_1_2.warp_charge_capacity) * 100 / max_souls_talent,
				venting_speed = talent_settings.offensive_1_2.vent_speed * 100 / max_souls_talent
			},
			passive = {
				buff_template_name = "psyker_biomancer_souls_increase_warp_charge_decrease_venting",
				identifier = "offensive_1"
			}
		},
		psyker_2_tier_2_name_3 = {
			description = "loc_talent_biomancer_smite_kills_add_warp_fire_desc",
			name = "Killing an elite enemy with Smite applies one stack of warpfire to all nearby enemies.",
			display_name = "loc_talent_biomancer_smite_kills_add_warp_fire",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_2_3_b",
			format_values = {
				range = talent_settings.offensive_1_3.distance,
				stacks = talent_settings.offensive_1_3.num_stacks
			},
			passive = {
				buff_template_name = "psyker_biomancer_smite_kills_add_warpfire",
				identifier = "offensive_1"
			}
		},
		psyker_2_tier_3_name_1 = {
			description = "loc_talent_biomancer_souls_on_kill_coop_desc",
			name = "Whenever you or an ally in coherency kills an enemy you have a chance to gain a soul.",
			display_name = "loc_talent_biomancer_souls_on_kill_coop",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_3_2",
			format_values = {
				soul_chance = talent_settings.coop_1.on_kill_proc_chance * 100
			},
			coherency = {
				buff_template_name = "psyker_biomancer_coherency_souls_on_kill",
				identifier = "souls_on_kill"
			},
			special_rule = {
				special_rule_name = "psyker_biomancer_coherency_souls_on_kill",
				identifier = "psyker_biomancer_coherency_souls_on_kill"
			}
		},
		psyker_2_tier_3_name_2 = {
			description = "loc_talent_biomancer_elite_kills_give_cooldown_coop_desc",
			name = "Killing an elite enemy restores combat ability cooldown to allies in coherency",
			display_name = "loc_talent_biomancer_elite_kills_give_cooldown_coop",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_5_3",
			format_values = {
				cooldown = talent_settings.coop_2.percent * 100
			},
			passive = {
				buff_template_name = "psyker_biomancer_cooldown_reduction_on_elite_kill_for_coherency",
				identifier = "coop"
			}
		},
		psyker_2_tier_3_name_3 = {
			description = "loc_talent_biomancer_smite_increases_non_warp_damage_desc",
			name = "Damaging an enemy with your smite ability causes them to take increased damage from all non-warp sources for {time:%d} seconds.",
			display_name = "loc_talent_biomancer_smite_increases_non_warp_damage",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_3_3",
			format_values = {
				damage = math_round((talent_settings.coop_3.damage_taken_multiplier - 1) * 100),
				time = talent_settings.coop_3.duration
			},
			passive = {
				buff_template_name = "psyker_biomancer_smite_makes_victim_vulnerable",
				identifier = "coop"
			}
		},
		psyker_2_tier_4_name_1 = {
			description = "loc_talent_biomancer_block_costs_warp_charge_desc",
			name = "While below critical warp charge, blocking an attack causes you to gain warp charge instead of losing stamina.",
			display_name = "loc_talent_biomancer_block_costs_warp_charge",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_4_1",
			format_values = {},
			passive = {
				buff_template_name = "psyker_biomancer_block_costs_warp_charge",
				identifier = "defensive"
			}
		},
		psyker_2_tier_4_name_2 = {
			description = "loc_talent_biomancer_toughness_damage_reduction_from_warp_charge_desc",
			name = "Take reduced toughness damage based on your current warp charge amount.",
			display_name = "loc_talent_biomancer_toughness_damage_reduction_from_warp_charge",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_2_2",
			format_values = {
				min_damage = math_round((1 - talent_settings.defensive_2.min_toughness_damage_multiplier) * 100),
				max_damage = math_round((1 - talent_settings.defensive_2.max_toughness_damage_multiplier) * 100)
			},
			passive = {
				buff_template_name = "psyker_biomancer_warp_charge_reduces_toughness_damage_taken",
				identifier = "defensive"
			}
		},
		psyker_2_tier_4_name_3 = {
			description = "loc_talent_biomancer_venting_doesnt_slow_desc",
			name = "Venting no longer slows your movement speed.",
			display_name = "loc_talent_biomancer_venting_doesnt_slow",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_3_1",
			format_values = {},
			passive = {
				buff_template_name = "psyker_biomancer_venting_improvements",
				identifier = "defensive"
			}
		},
		psyker_2_tier_5_name_1 = {
			description = "loc_talent_biomancer_increased_souls_desc",
			name = "Increases the maximum amount of souls you can have to 6.",
			display_name = "loc_talent_biomancer_increased_souls",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_5_1",
			format_values = {
				soul_amount = max_souls_talent
			},
			special_rule = {
				special_rule_name = "psyker_biomancer_increased_max_souls",
				identifier = "psyker_biomancer_increased_max_souls"
			}
		},
		psyker_2_tier_5_name_2 = {
			description = "loc_talent_biomancer_warpfire_on_max_souls_desc",
			name = "While you have maximum souls, gaining a soul instead applies a stack of warpfire to a nearby enemy, prioritizing elite enemies.",
			display_name = "loc_talent_biomancer_warpfire_on_max_souls",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_1_2",
			format_values = {
				stacks = talent_settings.offensive_2_2.num_stacks
			},
			special_rule = {
				special_rule_name = "psyker_biomancer_warpfire_on_max_souls",
				identifier = "psyker_biomancer_warpfire_on_max_souls"
			}
		},
		psyker_2_tier_5_name_3 = {
			description = "loc_talent_biomancer_smite_on_hit_desc",
			name = "All attacks have a chance on hit to smite the target. This cannot occur while at critical warp charge and has a cooldown.",
			display_name = "loc_talent_biomancer_smite_on_hit",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_2_1",
			format_values = {
				smite_chance = talent_settings.offensive_2_3.smite_chance * 100,
				time = talent_settings.offensive_2_3.cooldown
			},
			passive = {
				buff_template_name = "psyker_biomancer_smite_on_hit",
				identifier = "offensive_2"
			}
		},
		psyker_2_tier_6_name_1 = {
			description = "loc_talent_biomancer_combat_ability_cooldown_per_soul_desc",
			name = "Using Unleash the warp removes all souls and reduces the cooldown for each soul removed.",
			display_name = "loc_talent_biomancer_combat_ability_cooldown_per_soul",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_6_1",
			format_values = {
				cooldown = talent_settings.combat_ability_1.cooldown_reduction_percent * 100
			},
			special_rule = {
				special_rule_name = "psyker_biomancer_restore_cooldown_per_soul",
				identifier = "psyker_biomancer_restore_cooldown_per_soul"
			}
		},
		psyker_2_tier_6_name_2 = {
			description = "loc_talent_biomancer_combat_ability_warpfire_desc",
			name = "Using Unleash the Warp removes all souls and applies stacks of warpfire to all enemies hit. Enemies that die from warpfire have a chance to grant you a soul.",
			display_name = "loc_talent_biomancer_combat_ability_warpfire",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_6_2",
			format_values = {
				stacks = 1,
				soul_chance = talent_settings.combat_ability_2.soul_chance * 100
			},
			special_rule = {
				special_rule_name = "psyker_biomancer_discharge_applies_warpfire",
				identifier = "psyker_biomancer_discharge_applies_warpfire"
			},
			passive = {
				buff_template_name = "psyker_biomancer_warpfire_grants_souls",
				identifier = "combat_ability"
			}
		},
		psyker_2_tier_6_name_3 = {
			description = "loc_talent_biomancer_combat_ability_smite_speed_desc",
			name = "For seconds after using your combat ability, your smite will charge faster and cost less warp charge.",
			display_name = "loc_talent_biomancer_combat_ability_smite_speed",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_6_3",
			format_values = {
				time = talent_settings.combat_ability_3.duration,
				charge_speed = math_round((1 - talent_settings.combat_ability_3.smite_attack_speed) * 100),
				warp_charge = talent_settings.combat_ability_3.warp_charge_amount_smite * 100
			},
			special_rule = {
				special_rule_name = "psyker_biomancer_efficient_smites",
				identifier = "psyker_biomancer_efficient_smites"
			}
		}
	}
}

return archetype_talents
