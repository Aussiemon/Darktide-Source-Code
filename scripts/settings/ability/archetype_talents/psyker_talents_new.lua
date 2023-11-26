-- chunkname: @scripts/settings/ability/archetype_talents/psyker_talents_new.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local BuffTemplates = require("scripts/settings/buff/buff_templates")
local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings_new")
local talent_settings_2 = TalentSettings.psyker_2
local talent_settings_3 = TalentSettings.psyker_3
local special_rules = SpecialRulesSetting.special_rules
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local math_round = math.round

math_round = math_round or function (value)
	if value >= 0 then
		return math.floor(value + 0.5)
	else
		return math.ceil(value - 0.5)
	end
end

local psyker_combat_ability_extra_charge = BuffTemplates.psyker_combat_ability_extra_charge
local psyker_force_field_buff = BuffTemplates.psyker_force_field_buff
local psyker_force_field = PlayerAbilities.psyker_force_field
local psyker_overcharge_stance_buff_template = BuffTemplates[PlayerAbilities.psyker_overcharge_stance.ability_template_tweak_data.buff_to_add]
local psyker_overcharge_weakspot_kill_bonuses_buff = BuffTemplates.psyker_overcharge_weakspot_kill_bonuses_buff
local psyker_overcharge_increased_movement_speed_buff = BuffTemplates.psyker_overcharge_increased_movement_speed
local psyker_overcharge_reduced_warp_charge = BuffTemplates.psyker_overcharge_reduced_warp_charge
local psyker_overcharge_reduced_toughness_damage_taken_buff = BuffTemplates.psyker_overcharge_reduced_toughness_damage_taken
local max_souls_talent = talent_settings_2.offensive_2_1.max_souls_talent
local archetype_talents = {
	archetype = "psyker",
	specialization = "psyker_2",
	talents = {
		psyker_combat_ability_stance = {
			description = "loc_talent_psyker_combat_ability_overcharge_stance_description",
			name = "psyker_overcharge_stance - Bonus to damage, weakspot damage and crit chance. Lasts for 8 seconds and builds up peril while active. Reaching 100% peril removes the effect. ",
			display_name = "loc_talent_psyker_combat_ability_overcharge_stance",
			medium_icon = "content/ui/textures/icons/talents/psyker_1/psyker_1_combat",
			format_values = {
				talent_name = {
					value = "loc_talent_psyker_combat_ability_overcharge_stance",
					format_type = "loc_string"
				},
				duration = {
					format_type = "number",
					value = TalentSettings.overcharge_stance.post_stance_duration
				},
				base_damage = {
					prefix = "+",
					format_type = "percentage",
					value = psyker_overcharge_stance_buff_template.stat_buffs.damage
				},
				weakspot_damage = {
					prefix = "+",
					format_type = "percentage",
					value = psyker_overcharge_stance_buff_template.stat_buffs.weakspot_damage
				},
				crit_chance = {
					prefix = "+",
					format_type = "percentage",
					value = psyker_overcharge_stance_buff_template.stat_buffs.critical_strike_chance
				},
				max_peril = {
					format_type = "percentage",
					value = psyker_overcharge_stance_buff_template.early_out_percentage
				},
				cooldown = {
					format_type = "number",
					value = PlayerAbilities.psyker_overcharge_stance.cooldown
				},
				damage_per_stack = {
					prefix = "+",
					format_type = "percentage",
					value = TalentSettings.overcharge_stance.damage_per_stack
				},
				max_damage = {
					prefix = "+",
					format_type = "percentage",
					value = TalentSettings.overcharge_stance.damage_per_stack * TalentSettings.overcharge_stance.max_stacks
				}
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.psyker_overcharge_stance
			}
		},
		psyker_combat_ability_shout = {
			large_icon = "content/ui/textures/icons/talents/psyker/psyker_ability_discharge",
			name = "F-Ability - Shout, knocking down enemies in front of you in a cone, and remove 50% accumulated warp charge",
			display_name = "loc_talent_psyker_2_combat",
			description = "loc_talent_psyker_shout_ability_description",
			format_values = {
				warpcharge_vent = {
					format_type = "percentage",
					value = talent_settings_2.combat_ability.warpcharge_vent_base
				},
				cooldown = {
					format_type = "number",
					value = talent_settings_2.combat_ability.cooldown
				}
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.psyker_discharge_shout
			}
		},
		psyker_combat_ability_force_field = {
			description = "loc_talent_psyker_combat_ability_shield_description",
			name = "F-Ability - Channel a Shield that blocks against ranged attacks",
			display_name = "loc_talent_psyker_combat_ability_shield",
			medium_icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_combat",
			format_values = {
				duration = {
					format_type = "number",
					value = talent_settings_3.combat_ability.duration
				},
				talent_name = {
					value = "loc_talent_psyker_combat_ability_shield",
					format_type = "loc_string"
				},
				cooldown = {
					format_type = "number",
					value = PlayerAbilities.psyker_force_field.cooldown
				}
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.psyker_force_field
			}
		},
		psyker_grenade_throwing_knives = {
			description = "loc_ability_psyker_blitz_throwing_knives_description",
			name = "psyker_throwing_knives",
			display_name = "loc_ability_psyker_blitz_throwing_knives",
			medium_icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tactical",
			hud_icon = "content/ui/materials/icons/abilities/default",
			format_values = {
				talent_name = {
					value = "loc_ability_psyker_blitz_throwing_knives",
					format_type = "loc_string"
				}
			},
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.psyker_throwing_knives
			},
			special_rule = {
				identifier = "disable_grenade_pickups",
				special_rule_name = special_rules.disable_grenade_pickups
			},
			dev_info = {
				{
					damage_profile_name = "psyker_throwing_knives",
					info_func = "damage_profile"
				}
			},
			passive = {
				buff_template_name = "psyker_knife_replenishment",
				identifier = "psyker_knife_replenishment"
			}
		},
		psyker_grenade_smite = {
			description = "loc_ability_psyker_smite_description_new",
			name = "G-Ability - Target enemies to charge a Smite attack, dealing a high amount of damage",
			hud_icon = "content/ui/materials/icons/abilities/default",
			display_name = "loc_ability_psyker_smite",
			icon = "content/ui/textures/icons/talents/psyker/psyker_blitz_brain_burst",
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.psyker_smite
			}
		},
		psyker_grenade_chain_lightning = {
			description = "loc_ability_psyker_chain_lightning_description",
			name = "G-Ability - Chain lightning, Left click for a fast attack, or charge up with Right click for a longer attack",
			display_name = "loc_ability_psyker_chain_lightning",
			medium_icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tactical",
			format_values = {
				talent_name = {
					value = "loc_ability_psyker_chain_lightning",
					format_type = "loc_string"
				},
				jump_chance = talent_settings_3.passive_1.empowered_chain_lightning_chance * 100,
				damage = talent_settings_3.passive_1.chain_lightning_damage * 100,
				proc_chance = talent_settings_3.grenade.on_hit_proc_chance * 100
			},
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.psyker_chain_lightning
			}
		},
		psyker_brain_burst_improved = {
			description = "loc_talent_psyker_brain_burst_improved_description",
			name = "Increase the damage dealt by Brain Burst",
			display_name = "loc_talent_psyker_brain_burst_improved",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_base_2",
			format_values = {
				talent_new = {
					value = "loc_talent_psyker_brain_burst_improved",
					format_type = "loc_string"
				},
				talent_old = {
					value = "loc_ability_psyker_smite",
					format_type = "loc_string"
				},
				damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_brain_burst_improved",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.smite_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "psyker_brain_burst_improved",
				identifier = "psyker_brain_burst_improved"
			}
		},
		psyker_shout_reduces_warp_charge_generation = {
			description = "loc_talent_psyker_shout_reduces_warp_charge_generation_description",
			name = "Your shout now vents warp charge",
			display_name = "loc_talent_psyker_shout_reduces_warp_charge_generation",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_base_2",
			format_values = {
				talent_name = {
					value = "loc_talent_psyker_shout_vent_warp_charge",
					format_type = "loc_string"
				},
				warp_generation = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_shout_warp_generation_reduction",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.warp_charge_amount
						}
					},
					value_manipulation = function (value)
						return (1 - value) * 100
					end
				},
				max_stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_shout_warp_generation_reduction",
						find_value_type = "buff_template",
						path = {
							"max_stacks"
						}
					}
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_shout_warp_generation_reduction",
						find_value_type = "buff_template",
						path = {
							"duration"
						}
					}
				}
			},
			passive = {
				buff_template_name = "psyker_shout_reduces_warp_generation",
				identifier = "psyker_shout_reduces_warp_generation"
			}
		},
		psyker_shout_vent_warp_charge = {
			description = "loc_talent_psyker_shout_vent_warp_charge_description",
			name = "Your shout now vents warp charge",
			display_name = "loc_talent_psyker_shout_vent_warp_charge",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_base_2",
			format_values = {
				warpcharge_vent = {
					format_type = "percentage",
					value = talent_settings_2.combat_ability.warpcharge_vent_improved
				},
				cooldown = {
					format_type = "number",
					value = PlayerAbilities.psyker_discharge_shout.cooldown
				},
				talent_name = {
					value = "loc_talent_psyker_2_combat",
					format_type = "loc_string"
				}
			},
			special_rule = {
				special_rule_name = "shout_warp_charge_vent_improved",
				identifier = "shout_warp_charge_vent_improved"
			}
		},
		psyker_shout_damage_per_warp_charge = {
			description = "loc_talent_psyker_shout_damage_per_warp_charge_description",
			name = "Your shout now deals damage based on Warp Charge",
			display_name = "loc_talent_psyker_shout_damage_per_warp_charge",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_base_2",
			format_values = {
				talent_name = {
					value = "loc_talent_psyker_shout_vent_warp_charge",
					format_type = "loc_string"
				},
				base_damage = {
					format_type = "number",
					find_value = {
						damage_profile_name = "psyker_biomancer_shout_damage",
						find_value_type = "base_damage",
						power_level = talent_settings_2.combat_ability.power_level
					}
				},
				max_damage = {
					format_type = "number",
					find_value = {
						damage_profile_name = "psyker_biomancer_shout_damage",
						find_value_type = "base_damage",
						power_level = talent_settings_2.combat_ability.power_level * 2
					}
				}
			},
			special_rule = {
				special_rule_name = "psyker_discharge_damage_per_warp_charge",
				identifier = "psyker_discharge_damage_per_warp_charge"
			}
		},
		psyker_passive_souls_from_elite_kills = {
			description = "loc_talent_psyker_souls_desc",
			name = "Killing an enemy with Smite retains their soul. Each soul reduces the cd of your next combat ability. Souls are retained for 20 seconds and you can hold up to 4 souls at the same time.",
			display_name = "loc_talent_psyker_souls",
			medium_icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_base_1",
			format_values = {
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_souls",
						find_value_type = "buff_template",
						path = {
							"duration"
						}
					}
				},
				stack = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_souls",
						find_value_type = "buff_template",
						path = {
							"max_stacks"
						}
					}
				},
				cooldown_reduction = {
					format_type = "percentage",
					value = talent_settings_2.combat_ability_1.cooldown_reduction_percent
				}
			},
			passive = {
				buff_template_name = "psyker_passive_souls_from_elite_kills",
				identifier = "psyker_passive_souls_from_elite_kills"
			},
			special_rule = {
				identifier = "psyker_restore_cooldown_per_soul",
				special_rule_name = special_rules.psyker_restore_cooldown_per_soul
			}
		},
		psyker_chance_to_vent_on_kill = {
			description = "loc_talent_psyker_base_2_description",
			name = "Passive - Your kills have 10% chance to reduce warp charge by 10%",
			display_name = "loc_talent_psyker_base_2",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_base_2",
			format_values = {
				warp_charge_percent = {
					format_type = "percentage",
					value = talent_settings_2.passive_2.warp_charge_percent
				},
				chance = {
					format_type = "percentage",
					value = talent_settings_2.passive_2.on_hit_proc_chance
				}
			},
			passive = {
				buff_template_name = "psyker_chance_to_vent_on_kill",
				identifier = "psyker_chance_to_vent_on_kill"
			}
		},
		psyker_overcharge_reduced_warp_charge = {
			description = "loc_ability_psyker_overcharge_reduced_warp_charge_description",
			name = "Reduce charge generation - Reduces peril generation while in overcharge stance - ",
			display_name = "loc_ability_psyker_overcharge_reduced_warp_charge",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_base_2",
			format_values = {
				talent_name = {
					value = "loc_talent_psyker_combat_ability_overcharge_stance",
					format_type = "loc_string"
				},
				warp_charge = {
					prefix = "-",
					format_type = "percentage",
					value = psyker_overcharge_reduced_warp_charge.conditional_stat_buffs.warp_charge_amount,
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end
				}
			},
			passive = {
				buff_template_name = "psyker_overcharge_reduced_warp_charge",
				identifier = "psyker_overcharge_reduced_warp_charge"
			}
		},
		psyker_overcharge_reduced_toughness_damage_taken = {
			description = "loc_ability_psyker_overcharge_reduced_toughness_damage_taken_description",
			name = "Reduce toughness dmg in stance - Reduced toughness damage taken while in overcharge stance",
			display_name = "loc_ability_psyker_overcharge_reduced_toughness_damage_taken",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_base_2",
			format_values = {
				talent_name = {
					value = "loc_talent_psyker_combat_ability_overcharge_stance",
					format_type = "loc_string"
				},
				tdr = {
					prefix = "+",
					format_type = "percentage",
					value = psyker_overcharge_reduced_toughness_damage_taken_buff.conditional_stat_buffs.toughness_damage_taken_multiplier,
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end
				}
			},
			passive = {
				buff_template_name = "psyker_overcharge_reduced_toughness_damage_taken",
				identifier = "psyker_overcharge_reduced_toughness_damage_taken"
			}
		},
		psyker_overcharge_increased_movement_speed = {
			description = "loc_ability_psyker_overcharge_movement_speed_description",
			name = "Movespeed in stance - Increased movement speed while in overcharge stance",
			display_name = "loc_ability_psyker_overcharge_movement_speed",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_base_2",
			format_values = {
				talent_name = {
					value = "loc_talent_psyker_combat_ability_overcharge_stance",
					format_type = "loc_string"
				},
				movement_speed = {
					prefix = "+",
					format_type = "percentage",
					value = psyker_overcharge_increased_movement_speed_buff.conditional_stat_buffs.movement_speed
				}
			},
			passive = {
				buff_template_name = "psyker_overcharge_increased_movement_speed",
				identifier = "psyker_overcharge_increased_movement_speed"
			}
		},
		psyker_overcharge_weakspot_kill_bonuses = {
			description = "loc_ability_psyker_overcharge_weakspot_description",
			name = "Headshots kill grant stacking finesse dmg, until end of stance - 10% per stack/kill",
			display_name = "loc_ability_psyker_overcharge_weakspot",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_base_2",
			format_values = {
				talent_name = {
					value = "loc_talent_psyker_combat_ability_overcharge_stance",
					format_type = "loc_string"
				},
				second = {
					format_type = "number",
					value = TalentSettings.overcharge_stance.second_per_weakspot
				},
				finesse_damage_per_stack = {
					prefix = "+",
					format_type = "percentage",
					value = TalentSettings.overcharge_stance.finesse_damage_per_stack
				},
				max_finesse_damage = {
					prefix = "+",
					format_type = "percentage",
					value = TalentSettings.overcharge_stance.finesse_damage_per_stack * TalentSettings.overcharge_stance.max_stacks
				},
				duration = {
					format_type = "number",
					value = TalentSettings.overcharge_stance.post_stance_duration
				}
			},
			special_rule = {
				special_rule_name = "psyker_overchage_stance_weakspot_kills",
				identifier = "psyker_overchage_stance_weakspot_kills"
			}
		},
		psyker_empowered_ability = {
			description = "loc_talent_psyker_empowered_ability_description",
			name = "Passive - Kills have a chance to empower your next blitz ability",
			display_name = "loc_talent_psyker_empowered_ability",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_base_1",
			format_values = {
				chance = {
					num_decimals = 1,
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_empowered_grenades_passive",
						find_value_type = "buff_template",
						path = {
							"proc_events",
							proc_events.on_hit
						}
					}
				},
				blitz_one = {
					value = "loc_talent_psyker_brain_burst_improved",
					format_type = "loc_string"
				},
				smite_cost = {
					format_type = "percentage",
					value = 1 - talent_settings_3.passive_1.psyker_smite_cost_multiplier
				},
				smite_attack_speed = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_empowered_grenades_passive_visual_buff",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.smite_attack_speed
						}
					}
				},
				smite_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_empowered_grenades_passive_visual_buff",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.smite_damage
						}
					}
				},
				blitz_two = {
					value = "loc_ability_psyker_chain_lightning",
					format_type = "loc_string"
				},
				chain_lightning_damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings_3.passive_1.chain_lightning_damage
				},
				chain_lightning_jump_time_multiplier = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_empowered_grenades_passive_visual_buff",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.chain_lightning_jump_time_multiplier
						}
					}
				},
				blitz_three = {
					value = "loc_ability_psyker_blitz_throwing_knives",
					format_type = "loc_string"
				},
				throwing_knives_cost = {
					value = 1,
					format_type = "percentage"
				},
				throwing_knives_charges = {
					value = 0,
					format_type = "number"
				},
				throwing_knives_old_damage = {
					format_type = "number",
					find_value = {
						damage_profile_name = "psyker_throwing_knives",
						find_value_type = "base_damage",
						power_level = PowerLevelSettings.default_power_level
					}
				},
				throwing_knives_new_damage = {
					format_type = "number",
					find_value = {
						damage_profile_name = "psyker_throwing_knives_pierce",
						find_value_type = "base_damage",
						power_level = PowerLevelSettings.default_power_level
					}
				}
			},
			passive = {
				buff_template_name = "psyker_empowered_grenades_passive",
				identifier = "psyker_empowered_grenades_passive"
			},
			special_rule = {
				special_rule_name = "psyker_empowered_grenades",
				identifier = "psyker_empowered_grenades"
			}
		},
		psyker_throwing_knives_piercing = {
			description = "loc_talent_psyker_throwing_knives_pierce_description",
			name = "Passive - Kills have a chance to empower your next blitz ability",
			display_name = "loc_talent_psyker_throwing_knives_pierce",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_base_1",
			format_values = {
				talent_name = {
					value = "loc_ability_psyker_blitz_throwing_knives",
					format_type = "loc_string"
				}
			},
			passive = {
				buff_template_name = "psyker_throwing_knives_piercing",
				identifier = "psyker_throwing_knives_piercing"
			}
		},
		psyker_throwing_knives_cast_speed = {
			description = "loc_talent_psyker_throwing_knives_cast_speed_description",
			name = "Passive - Kills have a chance to empower your next blitz ability",
			display_name = "loc_talent_psyker_throwing_knives_reduced_cooldown",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_base_1",
			format_values = {
				talent_name = {
					value = "loc_ability_psyker_blitz_throwing_knives",
					format_type = "loc_string"
				},
				speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_throwing_knife_stacking_speed_buff",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.psyker_throwing_knife_speed_modifier
						}
					},
					value_manipulation = function (value)
						return value * 100
					end
				},
				recharge = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_reduced_throwing_knife_cooldown",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.grenade_ability_cooldown_modifier
						}
					},
					value_manipulation = function (value)
						return math.abs(value * 100)
					end
				},
				stacks = {
					format_values = "number",
					find_value = {
						buff_template_name = "psyker_throwing_knife_stacking_speed_buff",
						find_value_type = "buff_template",
						path = {
							"max_stacks"
						}
					}
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_throwing_knife_stacking_speed_buff",
						find_value_type = "buff_template",
						path = {
							"duration"
						}
					}
				}
			},
			passive = {
				buff_template_name = "psyker_reduced_throwing_knife_cooldown",
				identifier = "psyker_reduced_throwing_knife_cooldown"
			}
		},
		psyker_throwing_knives_reduced_cooldown = {
			description = "loc_talent_psyker_throwing_knives_reduced_cooldown_description",
			name = "Passive - Kills have a chance to empower your next blitz ability",
			display_name = "loc_talent_psyker_throwing_knives_reduced_cooldown",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_base_1",
			format_values = {
				cooldown_multiplier = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_reduced_throwing_knife_cooldown",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.grenade_ability_cooldown_modifier
						}
					},
					value_manipulation = function (value)
						return (value - 1) * 100
					end
				}
			},
			passive = {
				buff_template_name = "psyker_reduced_throwing_knife_cooldown",
				identifier = "psyker_reduced_throwing_knife_cooldown"
			}
		},
		psyker_chain_lightning_improved_target_buff = {
			description = "loc_talent_psyker_chain_lightning_improved_target_buff_description",
			name = "Your chain lightning targets take increased damage from all sources",
			display_name = "loc_talent_psyker_chain_lightning_improved_target_buff",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_base_1",
			format_values = {
				talent_name = {
					value = "loc_ability_psyker_chain_lightning",
					format_type = "loc_string"
				},
				damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_protectorate_spread_chain_lightning_interval_improved",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.damage_taken_multiplier
						}
					},
					value_manipulation = function (value)
						return (value - 1) * 100
					end
				}
			},
			special_rule = {
				special_rule_name = "psyker_chain_lightning_improved_target_buff",
				identifier = "psyker_chain_lightning_improved_target_buff"
			}
		},
		psyker_3_base_4 = {
			description = "loc_talent_psyker_more_damage_vs_electrocuted_description",
			name = "Fulmination - Deal more damage vs electrocuted enemies",
			display_name = "loc_talent_psyker_more_damage_vs_electrocuted",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_base_4",
			format_values = {
				damage = talent_settings_3.passive_4.damage * 100
			},
			passive = {
				buff_template_name = "psyker_protectorate_damage_vs_electrocuted",
				identifier = "psyker_protectorate_damage_vs_electrocuted"
			}
		},
		psyker_aura_ability_cooldown = {
			description = "loc_talent_psyker_aura_reduced_ability_cooldown_description",
			name = "Aura - Decreased ability cooldown",
			display_name = "loc_talent_psyker_aura_reduced_ability_cooldown",
			icon = "content/ui/textures/icons/talents/psyker/psyker_aura_cooldown_regen",
			format_values = {
				cooldown_reduction = {
					prefix = "+",
					num_decimals = 1,
					format_type = "percentage",
					value = math.abs(talent_settings_3.coherency.ability_cooldown_modifier)
				}
			},
			coherency = {
				identifier = "psyker_aura",
				priority = 1,
				buff_template_name = "psyker_aura_ability_cooldown"
			}
		},
		psyker_cooldown_aura_improved = {
			description = "loc_talent_psyker_cooldown_aura_improved_description",
			name = "Aura - Decreased ability cooldown",
			display_name = "loc_talent_psyker_cooldown_aura_improved",
			medium_icon = "content/ui/textures/icons/talents/psyker/psyker_aura_seers_presence",
			format_values = {
				cooldown_reduction = {
					prefix = "+",
					format_type = "percentage",
					value = math.abs(talent_settings_3.coherency.ability_cooldown_modifier_improved)
				},
				talent_name = {
					value = "loc_talent_psyker_aura_reduced_ability_cooldown",
					format_type = "loc_string"
				}
			},
			coherency = {
				identifier = "psyker_aura",
				priority = 2,
				buff_template_name = "psyker_aura_ability_cooldown_improved"
			}
		},
		psyker_aura_crit_chance_aura = {
			description = "loc_ability_psyker_gunslinger_aura_description",
			name = "psyker_aura_crit_chance_aura",
			display_name = "loc_ability_psyker_gunslinger_aura",
			medium_icon = "content/ui/textures/icons/talents/psyker_1/psyker_1_base_1",
			format_values = {
				critical_strike_chance = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_aura_crit_chance_aura",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.critical_strike_chance
						}
					}
				},
				max_stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_aura_crit_chance_aura",
						find_value_type = "buff_template",
						path = {
							"max_stacks"
						}
					}
				}
			},
			coherency = {
				identifier = "psyker_aura_crit_chance_aura",
				priority = 2,
				buff_template_name = "psyker_aura_crit_chance_aura"
			}
		},
		psyker_aura_damage_vs_elites = {
			description = "loc_talent_psyker_base_3_description",
			name = "Aura - Increased damage versus elites and specials",
			display_name = "loc_talent_psyker_base_3",
			medium_icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_aura",
			format_values = {
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings_2.coherency.damage_vs_elites
				}
			},
			coherency = {
				identifier = "psyker_aura",
				priority = 2,
				buff_template_name = "psyker_aura_damage_vs_elites"
			}
		},
		psyker_toughness_on_soul = {
			description = "loc_talent_psyker_toughness_regen_on_soul_desc",
			name = "Replenish toughness over time after gaining a soul.",
			display_name = "loc_talent_psyker_toughness_regen_on_soul",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_1_1",
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings_2.toughness_1.percent_toughness * talent_settings_2.toughness_1.duration
				},
				time = {
					format_type = "number",
					value = talent_settings_2.toughness_1.duration
				}
			},
			special_rule = {
				special_rule_name = "psyker_toughness_on_soul",
				identifier = "psyker_toughness_on_soul"
			}
		},
		psyker_toughness_on_warp_kill = {
			description = "loc_talent_psyker_toughness_on_warp_kill_desc",
			name = "Replenish Toughness on warp kill - Replenish toughness when killing an enemy with warp powered attacks.",
			display_name = "loc_talent_psyker_toughness_on_warp_kill",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_5_2",
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings_2.toughness_2.percent_toughness
				}
			},
			passive = {
				buff_template_name = "psyker_toughness_on_warp_kill",
				identifier = "psyker_toughness_on_warp_kill"
			}
		},
		psyker_toughness_on_vent = {
			description = "loc_talent_psyker_toughness_from_vent_desc",
			name = "Replenish toughness for each % of warp charge ventilated.",
			display_name = "loc_talent_psyker_toughness_from_vent",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_4_3",
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings_2.toughness_3.multiplier,
					value_manipulation = function (value)
						return value * 10
					end
				},
				warp_charge = {
					value = 0.1,
					format_type = "percentage"
				}
			},
			passive = {
				buff_template_name = "psyker_toughness_on_vent",
				identifier = "psyker_toughness_on_vent"
			}
		},
		psyker_warp_charge_generation_generates_toughness = {
			description = "loc_talent_psyker_warp_charge_generation_generates_toughness_description",
			name = "Generating Warp Charge replenishes toughness",
			display_name = "loc_talent_psyker_warp_charge_generation_generates_toughness",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_1_1",
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings_2.toughness_4.multiplier,
					value_manipulation = function (value)
						return value * 10
					end
				},
				warp_charge = {
					value = 0.1,
					format_type = "percentage"
				}
			},
			passive = {
				buff_template_name = "psyker_toughness_on_warp_generation",
				identifier = "psyker_toughness_on_warp_generation"
			}
		},
		psyker_increased_vent_speed = {
			description = "loc_talent_psyker_increased_vent_speed_description",
			name = "Increased venting speed",
			display_name = "loc_talent_psyker_increased_vent_speed",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_1_3",
			format_values = {
				vent_speed = {
					format_type = "percentage",
					value = 1 - talent_settings_3.mixed_3.vent_warp_charge_speed
				}
			},
			passive = {
				buff_template_name = "psyker_increased_vent_speed",
				identifier = "psyker_increased_vent_speed"
			}
		},
		psyker_guaranteed_crit_on_multiple_weakspot_hits = {
			description = "loc_talent_psyker_weakspot_grants_crit_description",
			name = "psyker_headshots_guaranteed_crit",
			display_name = "loc_talent_psyker_weakspot_grants_crit",
			icon = "content/ui/textures/icons/talents/psyker_1/psyker_1_tier_1_1",
			format_values = {
				weakspot_hits = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_guaranteed_ranged_shot_on_stacked",
						find_value_type = "buff_template",
						path = {
							"max_stacks"
						}
					}
				}
			},
			passive = {
				buff_template_name = "psyker_guaranteed_crit_on_multiple_weakspot_hits",
				identifier = "psyker_guaranteed_crit_on_multiple_weakspot_hits"
			}
		},
		psyker_kills_stack_other_weapon_damage = {
			description = "loc_talent_psyker_kills_stack_other_weapon_damage_description",
			name = "psyker_kills_stack_other_weapon_damage",
			display_name = "loc_talent_psyker_kills_stack_other_weapon_damage",
			icon = "content/ui/textures/icons/talents/psyker_1/psyker_1_tier_1_2",
			format_values = {
				warp_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_cycle_stacking_warp_damage",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.warp_damage
						}
					}
				},
				stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_cycle_stacking_warp_damage",
						find_value_type = "buff_template",
						path = {
							"max_stacks"
						}
					}
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_cycle_stacking_warp_damage",
						find_value_type = "buff_template",
						path = {
							"duration"
						}
					}
				},
				ranged_damage = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_cycle_stacking_ranged_damage_stacks",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ranged_damage
						}
					}
				},
				ranged_stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_cycle_stacking_ranged_damage_stacks",
						find_value_type = "buff_template",
						path = {
							"max_stacks"
						}
					}
				},
				melee_damage = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_cycle_stacking_melee_damage_stacks",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_damage
						}
					}
				},
				melee_stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_cycle_stacking_melee_damage_stacks",
						find_value_type = "buff_template",
						path = {
							"max_stacks"
						}
					}
				}
			},
			passive = {
				buff_template_name = "psyker_kills_stack_other_weapon_damage",
				identifier = "psyker_kills_stack_other_weapon_damage"
			}
		},
		psyker_crits_empower_next_attack = {
			description = "loc_talent_psyker_crits_empower_warp_description",
			name = "psyker_crits_empower_next_attack",
			display_name = "loc_talent_psyker_crits_empower_next_attack",
			icon = "content/ui/textures/icons/talents/psyker_1/psyker_1_tier_1_3",
			format_values = {
				damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_crits_empower_warp_buff",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.warp_damage
						}
					}
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_crits_empower_warp_buff",
						find_value_type = "buff_template",
						path = {
							"duration"
						}
					}
				},
				stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_crits_empower_warp_buff",
						find_value_type = "buff_template",
						path = {
							"max_stacks"
						}
					}
				}
			},
			passive = {
				buff_template_name = "psyker_crits_empower_warp",
				identifier = "psyker_crits_empower_warp"
			}
		},
		psyker_damage_based_on_warp_charge = {
			description = "loc_talent_psyker_damage_based_on_warp_charge_desc",
			name = "Gain damage with based on your current warp charge amount. 10-25%",
			display_name = "loc_talent_psyker_damage_based_on_warp_charge",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_1_3",
			format_values = {
				max_damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings_2.offensive_1_1.damage
				}
			},
			passive = {
				buff_template_name = "psyker_warp_charge_increase_force_weapon_damage",
				identifier = "psyker_warp_charge_increase_force_weapon_damage"
			}
		},
		psyker_reduced_warp_charge_cost_and_venting_speed = {
			description = "loc_talent_psyker_reduced_warp_charge_cost_venting_speed_desc",
			name = "Reduces warp charge generation per soul.",
			display_name = "loc_talent_psyker_reduced_warp_charge_cost_venting_speed",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_2_3",
			format_values = {
				warp_charge_amount = {
					prefix = "-",
					format_type = "percentage",
					value = (1 - talent_settings_2.offensive_1_2.warp_charge_capacity) / talent_settings_2.offensive_2_1.max_souls_talent
				}
			},
			passive = {
				buff_template_name = "psyker_reduced_warp_charge_cost_and_venting_speed",
				identifier = "psyker_reduced_warp_charge_cost_and_venting_speed"
			}
		},
		psyker_souls_increase_damage = {
			description = "loc_talent_psyker_souls_increase_damage_desc",
			name = "Reduces warp charge generation per soul.",
			display_name = "loc_talent_psyker_souls_increase_damage",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_2_3",
			format_values = {
				damage = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings_2.passive_1.damage / talent_settings_2.offensive_2_1.max_souls_talent
				}
			},
			passive = {
				buff_template_name = "psyker_souls_increase_damage",
				identifier = "psyker_souls_increase_damage"
			}
		},
		psyker_elite_kills_add_warpfire = {
			description = "loc_talent_psyker_elite_and_special_kills_add_warpfire_desc",
			name = "Killing an elite/special enemy applies 3 stack of warpfire to all nearby enemies.",
			display_name = "loc_talent_psyker_elite_kills_add_warpfire",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_2_3_b",
			format_values = {
				stacks = {
					format_type = "number",
					value = talent_settings_2.offensive_1_3.num_stacks
				}
			},
			passive = {
				buff_template_name = "psyker_elite_kills_add_warpfire",
				identifier = "psyker_elite_kills_add_warpfire"
			}
		},
		psyker_increased_chain_lightning_size = {
			description = "loc_talent_psyker_increased_chain_lightning_size_description",
			name = "Increase the spread and size of your chain lightning",
			display_name = "loc_talent_psyker_increased_chain_lightning_size",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_2_1",
			format_values = {
				talent_name = {
					value = "loc_ability_psyker_chain_lightning",
					format_type = "loc_string"
				},
				max_jumps = {
					prefix = "+",
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_increased_chain_lightning_size",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.chain_lightning_max_jumps
						}
					}
				}
			},
			passive = {
				buff_template_name = "psyker_increased_chain_lightning_size",
				identifier = "psyker_increased_chain_lightning_size"
			}
		},
		psyker_empowered_grenades_increased_max_stacks = {
			description = "loc_talent_psyker_increased_empowered_chain_lightning_stacks_description",
			name = "You can store up to 3 empowered chain lightnings",
			display_name = "loc_talent_psyker_increased_empowered_chain_lightning_stacks",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_2_2",
			format_values = {
				talent_name = {
					value = "loc_talent_psyker_empowered_ability",
					format_type = "loc_string"
				},
				max_stacks = {
					format_type = "number",
					value = talent_settings_3.offensive_2.max_stacks_talent
				}
			},
			special_rule = {
				special_rule_name = "psyker_empowered_grenades_increased_max_stacks",
				identifier = "psyker_empowered_grenades_increased_max_stacks"
			}
		},
		psyker_shield_stun_passive = {
			description = "loc_talent_psyker_force_field_stun_increased_description",
			name = "Gives chance to stun enemies that pass through your force field",
			display_name = "loc_talent_psyker_force_field_stun_increased",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_2_3",
			format_values = {
				proc_chance = {
					format_type = "percentage",
					value = talent_settings_3.offensive_3.proc_chance
				},
				special_proc_chance = {
					format_type = "percentage",
					value = talent_settings_3.offensive_3.special_proc_chance
				},
				ability = {
					value = "loc_talent_psyker_combat_ability_shield",
					format_type = "loc_string"
				}
			},
			passive = {
				buff_template_name = "psyker_shield_stun_passive",
				identifier = "psyker_shield_stun_passive"
			}
		},
		psyker_coherency_aura_size_increase = {
			description = "loc_talent_psyker_coherency_size_increase_description",
			name = "psyker_coherency_aura_size_increase",
			display_name = "loc_talent_psyker_coherency_size_increase",
			icon = "content/ui/textures/icons/talents/psyker_1/psyker_1_tier_3_1",
			format_values = {
				radius_modifier = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "coherency_aura_size_increase",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.coherency_radius_modifier
						}
					}
				}
			},
			passive = {
				buff_template_name = "coherency_aura_size_increase",
				identifier = "coherency"
			}
		},
		psyker_1_tier_3_name_2 = {
			description = "loc_talent_psyker_improved_coherency_efficiency_description",
			name = "psyker_aura_crit_chance_aura_improved",
			display_name = "loc_talent_psyker_improved_coherency_efficiency",
			icon = "content/ui/textures/icons/talents/psyker_1/psyker_1_tier_3_2",
			format_values = {
				crit_chance = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_aura_crit_chance_aura_improved",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.critical_strike_chance
						}
					}
				},
				talent_name = {
					value = "loc_ability_psyker_gunslinger_aura",
					format_type = "loc_string"
				}
			},
			coherency = {
				buff_template_name = "psyker_aura_crit_chance_aura_improved",
				identifier = "psyker_aura"
			}
		},
		psyker_coherency_aura_lingers = {
			description = "loc_talent_psyker_coherency_aura_lingers_description",
			name = "psyker_coherency_aura_lingers",
			display_name = "loc_talent_psyker_coherency_aura_lingers",
			icon = "content/ui/textures/icons/talents/psyker_1/psyker_1_tier_3_3",
			passive = {
				buff_template_name = "coherency_aura_lingers",
				identifier = "coherency"
			}
		},
		psyker_aura_souls_on_kill = {
			description = "loc_talent_psyker_souls_on_kill_coop_desc",
			name = "Whenever you or an ally in coherency kills an enemy you have a chance to gain a soul.",
			display_name = "loc_talent_psyker_souls_on_kill_coop",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_3_2",
			format_values = {
				soul_chance = {
					format_type = "percentage",
					value = talent_settings_2.coop_1.on_kill_proc_chance
				}
			},
			passive = {
				buff_template_name = "psyker_aura_souls_on_kill",
				identifier = "psyker_aura_souls_on_kill"
			}
		},
		psyker_2_tier_3_name_2 = {
			description = "loc_talent_psyker_elite_kills_give_combat_ability_cd_coherency_desc",
			name = "Killing an elite enemy restores combat ability cooldown to allies in coherency",
			display_name = "loc_talent_psyker_elite_kills_give_combat_ability_cd_coherency",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_5_3",
			format_values = {
				cooldown = {
					format_type = "percentage",
					value = talent_settings_2.coop_2.percent
				}
			},
			passive = {
				buff_template_name = "psyker_aura_cooldown_reduction_on_elite_kill",
				identifier = "psyker_aura_cooldown_reduction_on_elite_kill"
			}
		},
		psyker_2_tier_3_name_3 = {
			description = "loc_talent_biomancer_smite_increases_non_warp_damage_desc",
			name = "Damaging an enemy with your smite ability causes them to take increased damage from all sources for 5 seconds.",
			display_name = "loc_talent_biomancer_smite_increases_non_warp_damage",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_3_3",
			format_values = {
				damage = math_round((talent_settings_2.coop_3.damage_taken_multiplier - 1) * 100),
				time = talent_settings_2.coop_3.duration
			},
			passive = {
				buff_template_name = "psyker_smite_makes_victim_vulnerable",
				identifier = "psyker_smite_makes_victim_vulnerable"
			}
		},
		psyker_aura_toughness_on_ally_knocked_down = {
			description = "loc_talent_psyker_restore_toughness_to_allies_when_ally_down_description",
			name = "Fully restores toughness on allies in coherency, when an ally gets knocked down.",
			display_name = "loc_talent_psyker_restore_toughness_to_allies_when_ally_down",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_4_1",
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings_3.coop_1.toughness_percent
				}
			},
			passive = {
				buff_template_name = "psyker_aura_toughness_on_ally_knocked_down",
				identifier = "psyker_aura_toughness_on_ally_knocked_down"
			}
		},
		psyker_3_tier_3_name_2 = {
			description = "loc_talent_psyker_increased_aura_efficiency_description",
			name = "Increased the efficiency of your aura",
			display_name = "loc_talent_psyker_increased_aura_efficiency",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_4_2",
			format_values = {
				cooldown_reduction = {
					prefix = "-",
					format_type = "percentage",
					value = talent_settings_3.coop_2.ability_cooldown_modifier
				},
				talent_name = {
					value = "loc_talent_psyker_3_passive_2",
					format_type = "loc_string"
				}
			},
			coherency = {
				buff_template_name = "psyker_aura_ability_cooldown_improved",
				identifier = "psyker_aura"
			}
		},
		psyker_toughness_regen_at_shield = {
			description = "loc_talent_psyker_force_field_restores_toughness_description",
			name = "Your shield periodically grants toughness to nearby allies",
			display_name = "loc_talent_psyker_force_field_restores_toughness",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_4_3",
			format_values = {
				toughness = talent_settings_3.coop_3.toughness_percentage * 100,
				interval = talent_settings_3.coop_3.interval
			},
			passive = {
				buff_template_name = "psyker_toughness_regen_at_shield",
				identifier = "psyker_toughness_regen_at_shield"
			}
		},
		psyker_dodge_after_crits = {
			description = "loc_talent_psyker_dodge_after_crits_description",
			name = "psyker_dodge_after_crits",
			display_name = "loc_talent_psyker_dodge_after_crits",
			icon = "content/ui/textures/icons/talents/psyker_1/psyker_1_tier_2_1",
			format_values = {
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_dodge_after_crits",
						find_value_type = "buff_template",
						path = {
							"active_duration"
						}
					}
				}
			},
			passive = {
				buff_template_name = "psyker_dodge_after_crits",
				identifier = "psyker_dodge_after_crits"
			}
		},
		psyker_crits_regen_toughness_movement_speed = {
			description = "loc_talent_psyker_crits_regen_tougness_and_movement_speed_description",
			name = "psyker_crits_regen_toughness_movement_speed",
			display_name = "loc_talent_psyker_crits_regen_tougness_and_movement_speed",
			icon = "content/ui/textures/icons/talents/psyker_1/psyker_1_tier_2_2",
			format_values = {
				toughness = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_crits_regen_toughness_movement_speed",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"toughness_percentage"
						}
					}
				},
				movement_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_stacking_movement_buff",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.movement_speed
						}
					}
				},
				seconds = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_stacking_movement_buff",
						find_value_type = "buff_template",
						path = {
							"duration"
						}
					}
				},
				stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_stacking_movement_buff",
						find_value_type = "buff_template",
						path = {
							"max_stacks"
						}
					}
				}
			},
			passive = {
				buff_template_name = "psyker_crits_regen_toughness_movement_speed",
				identifier = "psyker_crits_regen_toughness_movement_speed"
			}
		},
		psyker_improved_dodge = {
			description = "loc_talent_psyker_improved_dodge_description",
			name = "psyker_better_dodges",
			display_name = "loc_talent_psyker_improved_dodge",
			icon = "content/ui/textures/icons/talents/psyker_1/psyker_1_tier_2_3",
			format_values = {
				dodge_linger_time = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_improved_dodge",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.dodge_linger_time_modifier
						}
					}
				},
				extra_consecutive_dodges = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_improved_dodge",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.extra_consecutive_dodges
						}
					}
				}
			},
			passive = {
				buff_template_name = "psyker_improved_dodge",
				identifier = "psyker_improved_dodge"
			}
		},
		psyker_block_costs_warp_charge = {
			description = "loc_talent_psyker_block_costs_warp_charge_desc",
			name = "While below critical warp charge, blocking an attack causes you to gain warp charge instead of losing stamina.",
			display_name = "loc_talent_psyker_block_costs_warp_charge",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_4_1",
			format_values = {
				warp_charge_block_cost = {
					format_type = "percentage",
					value = talent_settings_2.defensive_1.warp_charge_cost_multiplier
				}
			},
			passive = {
				buff_template_name = "psyker_block_costs_warp_charge",
				identifier = "psyker_block_costs_warp_charge"
			}
		},
		psyker_warp_charge_reduces_toughness_damage_taken = {
			description = "loc_talent_psyker_toughness_damage_reduction_from_warp_charge_desc",
			name = "Take reduced toughness damage based on your current warp charge amount.",
			display_name = "loc_talent_psyker_toughness_damage_reduction_from_warp_charge",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_2_2",
			format_values = {
				min_damage = {
					prefix = "+",
					format_type = "percentage",
					value = 1 - talent_settings_2.defensive_2.min_toughness_damage_multiplier
				},
				max_damage = {
					prefix = "+",
					format_type = "percentage",
					value = 1 - talent_settings_2.defensive_2.max_toughness_damage_multiplier
				}
			},
			passive = {
				buff_template_name = "psyker_warp_charge_reduces_toughness_damage_taken",
				identifier = "psyker_warp_charge_reduces_toughness_damage_taken"
			}
		},
		psyker_venting_improvements = {
			description = "loc_talent_psyker_venting_doesnt_slow_desc",
			name = "Venting no longer slows your movement speed.",
			display_name = "loc_talent_psyker_venting_doesnt_slow",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_3_1",
			format_values = {},
			passive = {
				buff_template_name = "psyker_venting_improvements",
				identifier = "psyker_venting_improvements"
			}
		},
		psyker_boost_allies_in_sphere = {
			description = "loc_talent_psyker_force_field_grants_toughness_desc",
			name = "",
			display_name = "loc_talent_psyker_force_field_grants_toughness",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_3_1",
			format_values = {
				talent_name = {
					value = "loc_talent_psyker_combat_ability_shield",
					format_type = "loc_string"
				},
				toughness_damage_reduction = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings_3.combat_ability.toughness_damage_reduction,
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end
				},
				toughness = {
					format_type = "percentage",
					value = talent_settings_3.combat_ability.toughness_for_allies
				},
				duration = {
					format_type = "number",
					value = talent_settings_3.combat_ability.toughness_duration
				}
			},
			special_rule = {
				special_rule_name = "psyker_boost_allies_in_sphere",
				identifier = "psyker_boost_allies_in_sphere"
			}
		},
		psyker_boost_allies_passing_through_force_field = {
			description = "loc_talent_psyker_force_field_grants_movement_and_toughness_dr_description",
			name = "Allies passing through your Shield gain 10% movement speed and 20% toughness damage reduction for 6 seconds",
			display_name = "loc_talent_psyker_force_field_grants_movement_and_toughness_dr",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_3_1",
			format_values = {
				talent_name = {
					value = "loc_talent_psyker_combat_ability_shield",
					format_type = "loc_string"
				},
				movement_speed = {
					prefix = "+",
					format_type = "percentage",
					value = psyker_force_field_buff.stat_buffs.movement_speed
				},
				toughness_dr = {
					prefix = "+",
					format_type = "percentage",
					value = psyker_force_field_buff.stat_buffs.toughness_damage_taken_multiplier,
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end
				},
				duration = {
					format_type = "number",
					value = psyker_force_field_buff.duration
				}
			},
			passive = {
				buff_template_name = "psyker_boost_allies_passing_through_force_field",
				identifier = "psyker_boost_allies_passing_through_force_field"
			}
		},
		psyker_chain_lightning_increases_movement_speed = {
			description = "loc_talent_psyker_empowered_chain_lighting_movement_speed_description",
			name = "Chain lighting grants a short burst of movement speed",
			display_name = "loc_talent_psyker_empowered_chain_lighting_movement_speed",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_3_3",
			format_values = {
				movement_speed = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings_3.defensive_3.movement_speed
				},
				duration = {
					format_type = "number",
					value = talent_settings_3.defensive_3.active_duration
				},
				ability = {
					value = "loc_ability_psyker_chain_lightning",
					format_type = "loc_string"
				}
			},
			passive = {
				buff_template_name = "psyker_chain_lightning_increases_movement_speed",
				identifier = "psyker_chain_lightning_increases_movement_speed"
			}
		},
		psyker_increased_max_souls = {
			description = "loc_talent_psyker_increased_souls_desc",
			name = "Increases the maximum amount of souls you can have to 6.",
			display_name = "loc_talent_psyker_increased_souls",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_5_1",
			format_values = {
				soul_amount = {
					format_type = "number",
					value = max_souls_talent
				}
			},
			special_rule = {
				special_rule_name = "psyker_increased_max_souls",
				identifier = "psyker_increased_max_souls"
			}
		},
		psyker_spread_warpfire_on_kill = {
			description = "loc_talent_psyker_warpfire_spread_desc",
			name = "Whenever an enemy you've affected with Warpfire dies, they spread up to 4 stacks evenly to enemies nearby",
			display_name = "loc_talent_psyker_warpfire_spread",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_1_2",
			format_values = {
				stacks = {
					format_type = "number",
					value = talent_settings_2.offensive_2_2.stacks_to_share
				}
			},
			special_rule = {
				special_rule_name = "psyker_spread_warpfire_on_kill",
				identifier = "psyker_spread_warpfire_on_kill"
			}
		},
		psyker_smite_on_hit = {
			description = "loc_talent_psyker_smite_on_hit_desc",
			name = "All attacks have a chance on hit to smite the target. This cannot occur while at critical warp charge and has a cooldown.",
			display_name = "loc_talent_psyker_smite_on_hit",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_2_1",
			format_values = {
				talent_name = {
					value = "loc_talent_psyker_brain_burst_improved",
					format_type = "loc_string"
				},
				smite_chance = {
					format_type = "percentage",
					value = talent_settings_2.offensive_2_3.smite_chance
				},
				time = {
					format_type = "number",
					value = talent_settings_2.offensive_2_3.cooldown
				}
			},
			passive = {
				buff_template_name = "psyker_smite_on_hit",
				identifier = "psyker_smite_on_hit"
			}
		},
		psyker_empowered_chain_lightnings_replenish_toughness_to_allies = {
			description = "loc_talent_psyker_empowered_chain_lightnings_replenish_toughness_to_allies_description",
			name = "Your empowered chain lightning replenishes toughness for allies in coherency",
			display_name = "loc_talent_psyker_empowered_chain_lightnings_replenish_toughness_to_allies",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_5_1",
			format_values = {
				talent_name = {
					value = "loc_talent_psyker_empowered_ability",
					format_type = "loc_string"
				},
				toughness = {
					format_type = "percentage",
					value = talent_settings_3.spec_passive_1.toughness_for_allies
				}
			},
			special_rule = {
				special_rule_name = "psyker_empowered_grenades_toughness_on_attack",
				identifier = "psyker_empowered_grenades_toughness_on_attack"
			}
		},
		psyker_empowered_grenades_passive_improved = {
			description = "loc_talent_psyker_increase_empower_chain_lighting_chance_description",
			name = "Increase the chance for kills to generate Empowered Chain Lightnings",
			display_name = "loc_talent_psyker_increase_empower_chain_lighting_chance",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_5_2",
			format_values = {
				talent_name = {
					value = "loc_talent_psyker_empowered_ability",
					format_type = "loc_string"
				},
				proc_chance_before = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_empowered_grenades_passive",
						find_value_type = "buff_template",
						path = {
							"proc_events",
							proc_events.on_hit
						}
					}
				},
				proc_chance_after = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_empowered_grenades_passive_improved",
						find_value_type = "buff_template",
						path = {
							"proc_events",
							proc_events.on_hit
						}
					}
				}
			},
			passive = {
				buff_template_name = "psyker_empowered_grenades_passive_improved",
				identifier = "psyker_empowered_grenades_passive"
			}
		},
		psyker_empowered_ability_on_elite_kills = {
			description = "loc_talent_psyker_empowered_ability_on_elite_kills_description",
			name = "Increase the chance for kills to generate Empowered Chain Lightnings",
			display_name = "loc_talent_psyker_empowered_ability_on_elite_kills",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_5_2",
			format_values = {
				talent_name = {
					value = "loc_talent_psyker_empowered_ability",
					format_type = "loc_string"
				}
			},
			special_rule = {
				special_rule_name = "psyker_empowered_grenades_stack_on_elite_kills",
				identifier = "psyker_empowered_grenades_stack_on_elite_kills"
			}
		},
		psyker_souls_restore_cooldown_on_ability = {
			description = "loc_talent_psyker_souls_restore_cooldown_on_ability_increased_souls_desc",
			name = "Using Unleash the warp removes all souls and reduces the cooldown for each soul removed",
			display_name = "loc_talent_psyker_souls_restore_cooldown_on_ability",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_6_1",
			format_values = {
				stacks = 2,
				cooldown = talent_settings_2.combat_ability_1.cooldown_reduction_percent * 100
			},
			special_rule = {
				identifier = "psyker_restore_cooldown_per_soul",
				special_rule_name = special_rules.psyker_restore_cooldown_per_soul
			}
		},
		psyker_warpfire_on_shout = {
			description = "loc_talent_psyker_warpfire_on_shout_desc",
			name = "Using Unleash the Warp applies warpfire to targets hit based on warp charge",
			display_name = "loc_talent_psyker_warpfire_on_shout",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_6_2",
			format_values = {
				talent_name = {
					value = "loc_talent_psyker_shout_vent_warp_charge",
					format_type = "loc_string"
				},
				min_stacks = {
					value = "1-",
					format_type = "string"
				},
				warpfire_stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_shout_applies_warpfire",
						find_value_type = "buff_template",
						path = {
							"warpfire_max_stacks"
						}
					}
				}
			},
			passive = {
				buff_template_name = "psyker_shout_applies_warpfire",
				identifier = "psyker_shout_applies_warpfire"
			}
		},
		psyker_warpfire_generate_souls = {
			description = "loc_talent_psyker_warpfire_generates_souls_desc",
			name = "Enemies that die from warpfire have a chance to grant you a soul.",
			display_name = "loc_talent_psyker_warpfire_generates_souls",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_6_2",
			format_values = {
				chance = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_soul_on_warpfire_kill",
						find_value_type = "buff_template",
						path = {
							"proc_events",
							proc_events.on_minion_death
						}
					}
				}
			},
			passive = {
				buff_template_name = "psyker_soul_on_warpfire_kill",
				identifier = "psyker_soul_on_warpfire_kill"
			}
		},
		psyker_ability_increase_brain_burst_speed = {
			description = "loc_talent_psyker_ability_increase_brain_burst_speed_desc",
			name = "For seconds after using your combat ability, your smite will charge faster and cost less warp charge.",
			display_name = "loc_talent_psyker_ability_increase_brain_burst_speed",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_6_3",
			format_values = {
				talent_name = {
					value = "loc_talent_psyker_brain_burst_improved",
					format_type = "loc_string"
				},
				smite_attack_speed = {
					prefix = "+",
					format_type = "percentage",
					value = talent_settings_2.combat_ability_3.smite_attack_speed
				},
				warp_charge_cost = {
					format_type = "percentage",
					value = talent_settings_2.combat_ability_3.warp_charge_amount_smite
				},
				duration = {
					format_type = "number",
					value = talent_settings_2.combat_ability_3.duration
				}
			},
			passive = {
				buff_template_name = "psyker_ability_increase_brain_burst_speed",
				identifier = "psyker_ability_increase_brain_burst_speed"
			}
		},
		psyker_shield_extra_charge = {
			description = "loc_talent_psyker_force_field_charges_description",
			name = "Increase charges of your combat ability by 1",
			display_name = "loc_talent_psyker_force_field_charges",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_1",
			format_values = {
				max_charges = {
					format_type = "number",
					value = psyker_force_field.max_charges + psyker_combat_ability_extra_charge.stat_buffs.ability_extra_charges
				},
				talent_name = {
					value = "loc_talent_psyker_combat_ability_shield",
					format_type = "loc_string"
				}
			},
			passive = {
				buff_template_name = "psyker_combat_ability_extra_charge",
				identifier = "psyker_combat_ability_extra_charge"
			}
		},
		psyker_sphere_shield = {
			description = "loc_talent_psyker_force_field_dome_new_desc",
			name = "Your shield takes the shape of a sphere and forms around you",
			display_name = "loc_talent_psyker_force_field_dome",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			format_values = {
				talent_name = {
					value = "loc_talent_psyker_combat_ability_shield",
					format_type = "loc_string"
				},
				duration = {
					format_type = "number",
					value = talent_settings_3.combat_ability.sphere_duration
				}
			},
			player_ability = {
				priority = 1,
				ability_type = "combat_ability",
				ability = PlayerAbilities.psyker_force_field_dome
			},
			special_rule = {
				special_rule_name = "psyker_sphere_shield",
				identifier = "psyker_sphere_shield"
			}
		},
		psyker_new_mark_passive = {
			description = "loc_talent_psyker_marked_enemies_passive_desc",
			name = "Mark enemies. Killing marked enemies grants bonuses",
			display_name = "loc_talent_psyker_marked_enemies_passive",
			format_values = {
				radius = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive",
						find_value_type = "buff_template",
						path = {
							"target_distance_base"
						}
					}
				},
				toughness = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive",
						find_value_type = "buff_template",
						path = {
							"toughness_percentage"
						}
					}
				},
				move_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive_bonus",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.movement_speed
						}
					}
				},
				move_speed_duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive_bonus",
						find_value_type = "buff_template",
						path = {
							"duration"
						}
					}
				},
				base_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive_bonus_stacking",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.damage
						}
					}
				},
				crit_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive_bonus_stacking",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.critical_strike_damage
						}
					}
				},
				weakspot_damage = {
					prefix = "+",
					num_decimals = 1,
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive_bonus_stacking",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.weakspot_damage
						}
					}
				},
				bonus_duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive_bonus_stacking",
						find_value_type = "buff_template",
						path = {
							"duration"
						}
					}
				},
				bonus_stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive_bonus_stacking",
						find_value_type = "buff_template",
						path = {
							"max_stacks"
						}
					}
				}
			},
			passive = {
				buff_template_name = "psyker_marked_enemies_passive",
				identifier = "psyker_marked_enemies_passive"
			}
		},
		psyker_weakspot_kills_can_refund_knife = {
			description = "loc_talent_psyker_weakspot_kills_can_refund_knife_description",
			name = "Killing enemies marked by passive refunds 1 knife",
			display_name = "loc_talent_psyker_weakspot_kills_can_refund_knife",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			passive = {
				buff_template_name = "psyker_weakspot_kills_can_refund_knife",
				identifier = "psyker_weakspot_kills_can_refund_knife"
			}
		},
		psyker_mark_increased_range = {
			description = "loc_talent_psyker_mark_increased_range_description",
			name = "Increased mark range",
			display_name = "loc_talent_psyker_mark_increased_range",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			format_values = {
				radius_prev = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive",
						find_value_type = "buff_template",
						path = {
							"target_distance_base"
						}
					}
				},
				radius = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive",
						find_value_type = "buff_template",
						path = {
							"target_distance_improved"
						}
					}
				},
				talent_name = {
					value = "loc_talent_psyker_marked_enemies_passive",
					format_type = "loc_string"
				}
			},
			special_rule = {
				special_rule_name = "psyker_mark_increased_range",
				identifier = "psyker_mark_increased_range"
			}
		},
		psyker_mark_increased_max_stacks = {
			description = "loc_talent_psyker_mark_increased_max_stacks_description",
			name = "Your shield takes the shape of a sphere and forms around you",
			display_name = "loc_talent_psyker_mark_increased_max_stacks",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			format_values = {
				stacks_previous = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive_bonus_stacking",
						find_value_type = "buff_template",
						path = {
							"max_stacks"
						}
					}
				},
				stacks_after = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive_bonus_stacking_increased_stacks",
						find_value_type = "buff_template",
						path = {
							"max_stacks"
						}
					}
				},
				talent_name = {
					value = "loc_talent_psyker_marked_enemies_passive",
					format_type = "loc_string"
				}
			},
			special_rule = {
				special_rule_name = "psyker_mark_increased_max_stacks",
				identifier = "psyker_mark_increased_max_stacks"
			}
		},
		psyker_mark_increased_duration = {
			description = "loc_talent_psyker_mark_increased_duration_description",
			name = "Your shield takes the shape of a sphere and forms around you",
			display_name = "loc_talent_psyker_mark_increased_duration",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			format_values = {
				duration_previous = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive_bonus_stacking",
						find_value_type = "buff_template",
						path = {
							"duration"
						}
					}
				},
				duration_after = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive_bonus_stacking_increased_duration",
						find_value_type = "buff_template",
						path = {
							"duration"
						}
					}
				},
				talent_name = {
					value = "loc_talent_psyker_marked_enemies_passive",
					format_type = "loc_string"
				}
			},
			special_rule = {
				special_rule_name = "psyker_mark_increased_duration",
				identifier = "psyker_mark_increased_duration"
			}
		},
		psyker_mark_increased_mark_targets = {
			description = "loc_talent_psyker_mark_increased_mark_targets_description",
			name = "???",
			display_name = "loc_talent_psyker_mark_increased_mark_targets",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			special_rule = {
				special_rule_name = "psyker_mark_increased_mark_targets",
				identifier = "psyker_mark_increased_mark_targets"
			}
		},
		psyker_mark_kills_can_vent = {
			description = "loc_talent_psyker_mark_kills_can_vent_description",
			name = "Mark kills can vent a portion of your warp charge",
			display_name = "loc_talent_psyker_mark_kills_can_vent",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			format_values = {
				chance = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive",
						find_value_type = "buff_template",
						path = {
							"chance_to_vent_proc_chance"
						}
					}
				},
				warp_charge_percentage = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive",
						find_value_type = "buff_template",
						path = {
							"chance_to_vent_warp_charge_percent"
						}
					}
				},
				talent_name = {
					value = "loc_talent_psyker_marked_enemies_passive",
					format_type = "loc_string"
				}
			},
			special_rule = {
				special_rule_name = "psyker_mark_kills_can_vent",
				identifier = "psyker_mark_kills_can_vent"
			}
		},
		psyker_mark_weakspot_kills = {
			description = "loc_talent_psyker_mark_weakspot_stacks_description",
			name = "Mark kills can vent a portion of your warp charge",
			display_name = "loc_talent_psyker_mark_weakspot_stacks",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			format_values = {
				talent_name = {
					value = "loc_talent_psyker_marked_enemies_passive",
					format_type = "loc_string"
				},
				stacks = {
					format_type = "number",
					value = TalentSettings.mark_passive.weakspot_stacks - 1
				}
			},
			special_rule = {
				special_rule_name = "psyker_mark_weakspot_kills",
				identifier = "psyker_mark_weakspot_kills"
			}
		}
	}
}

return archetype_talents
