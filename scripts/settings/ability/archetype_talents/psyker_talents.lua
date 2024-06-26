-- chunkname: @scripts/settings/ability/archetype_talents/psyker_talents.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local BuffTemplates = require("scripts/settings/buff/buff_templates")
local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local talent_settings = TalentSettings.psyker
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
local psyker_overcharge_increased_movement_speed_buff = BuffTemplates.psyker_overcharge_increased_movement_speed
local psyker_overcharge_reduced_warp_charge = BuffTemplates.psyker_overcharge_reduced_warp_charge
local psyker_overcharge_reduced_toughness_damage_taken_buff = BuffTemplates.psyker_overcharge_reduced_toughness_damage_taken
local max_souls_talent = talent_settings_2.offensive_2_1.max_souls_talent
local archetype_talents = {
	archetype = "psyker",
	talents = {
		psyker_combat_ability_stance = {
			description = "loc_talent_psyker_combat_ability_overcharge_stance_description",
			display_name = "loc_talent_psyker_combat_ability_overcharge_stance",
			medium_icon = "content/ui/textures/icons/talents/psyker_1/psyker_1_combat",
			name = "psyker_overcharge_stance - Bonus to damage, weakspot damage and crit chance. Lasts for 8 seconds and builds up peril while active. Reaching 100% peril removes the effect. ",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_psyker_combat_ability_overcharge_stance",
				},
				duration = {
					format_type = "number",
					value = TalentSettings.overcharge_stance.post_stance_duration,
				},
				base_damage = {
					format_type = "percentage",
					prefix = "+",
					value = psyker_overcharge_stance_buff_template.stat_buffs.damage,
				},
				weakspot_damage = {
					format_type = "percentage",
					prefix = "+",
					value = psyker_overcharge_stance_buff_template.stat_buffs.weakspot_damage,
				},
				crit_chance = {
					format_type = "percentage",
					prefix = "+",
					value = psyker_overcharge_stance_buff_template.stat_buffs.critical_strike_chance,
				},
				max_peril = {
					format_type = "percentage",
					value = psyker_overcharge_stance_buff_template.early_out_percentage,
				},
				cooldown = {
					format_type = "number",
					value = PlayerAbilities.psyker_overcharge_stance.cooldown,
				},
				damage_per_stack = {
					format_type = "percentage",
					prefix = "+",
					value = TalentSettings.overcharge_stance.damage_per_stack,
				},
				max_damage = {
					format_type = "percentage",
					prefix = "+",
					value = TalentSettings.overcharge_stance.damage_per_stack * TalentSettings.overcharge_stance.max_stacks,
				},
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.psyker_overcharge_stance,
			},
		},
		psyker_combat_ability_shout = {
			description = "loc_talent_psyker_shout_ability_description",
			display_name = "loc_talent_psyker_2_combat",
			large_icon = "content/ui/textures/icons/talents/psyker/psyker_ability_discharge",
			name = "F-Ability - Shout, knocking down enemies in front of you in a cone, and remove 50% accumulated warp charge",
			format_values = {
				warpcharge_vent = {
					format_type = "percentage",
					value = talent_settings_2.combat_ability.warpcharge_vent_base,
				},
				cooldown = {
					format_type = "number",
					value = talent_settings_2.combat_ability.cooldown,
				},
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.psyker_discharge_shout,
			},
		},
		psyker_combat_ability_force_field = {
			description = "loc_talent_psyker_combat_ability_shield_description",
			display_name = "loc_talent_psyker_combat_ability_shield",
			medium_icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_combat",
			name = "F-Ability - Channel a Shield that blocks against ranged attacks",
			format_values = {
				duration = {
					format_type = "number",
					value = talent_settings_3.combat_ability.duration,
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_psyker_combat_ability_shield",
				},
				cooldown = {
					format_type = "number",
					value = PlayerAbilities.psyker_force_field.cooldown,
				},
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.psyker_force_field,
			},
		},
		psyker_grenade_throwing_knives = {
			description = "loc_ability_psyker_blitz_throwing_knives_description",
			display_name = "loc_ability_psyker_blitz_throwing_knives",
			hud_icon = "content/ui/materials/icons/abilities/default",
			medium_icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tactical",
			name = "psyker_throwing_knives",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_ability_psyker_blitz_throwing_knives",
				},
			},
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.psyker_throwing_knives,
			},
			special_rule = {
				identifier = "disable_grenade_pickups",
				special_rule_name = special_rules.disable_grenade_pickups,
			},
			dev_info = {
				{
					damage_profile_name = "psyker_throwing_knives",
					info_func = "damage_profile",
				},
			},
			passive = {
				buff_template_name = "psyker_knife_replenishment",
				identifier = "psyker_knife_replenishment",
			},
		},
		psyker_grenade_smite = {
			description = "loc_ability_psyker_smite_description_new",
			display_name = "loc_ability_psyker_smite",
			hud_icon = "content/ui/materials/icons/abilities/default",
			icon = "content/ui/textures/icons/talents/psyker/psyker_blitz_brain_burst",
			name = "G-Ability - Target enemies to charge a Smite attack, dealing a high amount of damage",
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.psyker_smite,
			},
		},
		psyker_grenade_chain_lightning = {
			description = "loc_ability_psyker_chain_lightning_description",
			display_name = "loc_ability_psyker_chain_lightning",
			medium_icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tactical",
			name = "G-Ability - Chain lightning, Left click for a fast attack, or charge up with Right click for a longer attack",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_ability_psyker_chain_lightning",
				},
				jump_chance = talent_settings_3.passive_1.empowered_chain_lightning_chance * 100,
				damage = talent_settings_3.passive_1.chain_lightning_damage * 100,
				proc_chance = talent_settings_3.grenade.on_hit_proc_chance * 100,
			},
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.psyker_chain_lightning,
			},
			passive = {
				buff_template_name = "psyker_kills_during_smite_tracking",
				identifier = "psyker_kills_during_smite_tracking",
			},
		},
		psyker_brain_burst_improved = {
			description = "loc_talent_psyker_brain_burst_improved_description",
			display_name = "loc_talent_psyker_brain_burst_improved",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_base_2",
			name = "Increase the damage dealt by Brain Burst",
			format_values = {
				talent_new = {
					format_type = "loc_string",
					value = "loc_talent_psyker_brain_burst_improved",
				},
				talent_old = {
					format_type = "loc_string",
					value = "loc_ability_psyker_smite",
				},
				damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "psyker_brain_burst_improved",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.smite_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "psyker_brain_burst_improved",
				identifier = "psyker_brain_burst_improved",
			},
		},
		psyker_shout_reduces_warp_charge_generation = {
			description = "loc_talent_psyker_shout_reduces_warp_charge_generation_description",
			display_name = "loc_talent_psyker_shout_reduces_warp_charge_generation",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_base_2",
			name = "Your shout now vents warp charge",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_psyker_shout_vent_warp_charge",
				},
				warp_generation = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_shout_warp_generation_reduction",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.warp_charge_amount,
						},
					},
					value_manipulation = function (value)
						return (1 - value) * 100
					end,
				},
				max_stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_shout_warp_generation_reduction",
						find_value_type = "buff_template",
						path = {
							"max_stacks",
						},
					},
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_shout_warp_generation_reduction",
						find_value_type = "buff_template",
						path = {
							"duration",
						},
					},
				},
			},
			passive = {
				buff_template_name = "psyker_shout_reduces_warp_generation",
				identifier = "psyker_shout_reduces_warp_generation",
			},
		},
		psyker_shout_vent_warp_charge = {
			description = "loc_talent_psyker_shout_vent_warp_charge_description",
			display_name = "loc_talent_psyker_shout_vent_warp_charge",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_base_2",
			name = "Your shout now vents warp charge",
			format_values = {
				warpcharge_vent = {
					format_type = "percentage",
					value = talent_settings_2.combat_ability.warpcharge_vent_improved,
				},
				cooldown = {
					format_type = "number",
					value = PlayerAbilities.psyker_discharge_shout.cooldown,
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_psyker_2_combat",
				},
			},
			special_rule = {
				identifier = "shout_warp_charge_vent_improved",
				special_rule_name = "shout_warp_charge_vent_improved",
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.psyker_discharge_shout_improved,
			},
		},
		psyker_shout_damage_per_warp_charge = {
			description = "loc_talent_psyker_shout_damage_per_warp_charge_description",
			display_name = "loc_talent_psyker_shout_damage_per_warp_charge",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_base_2",
			name = "Your shout now deals damage based on Warp Charge",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_psyker_shout_vent_warp_charge",
				},
				base_damage = {
					format_type = "number",
					find_value = {
						damage_profile_name = "psyker_biomancer_shout_damage",
						find_value_type = "base_damage",
						power_level = talent_settings_2.combat_ability.power_level,
					},
				},
				max_damage = {
					format_type = "number",
					find_value = {
						damage_profile_name = "psyker_biomancer_shout_damage",
						find_value_type = "base_damage",
						power_level = talent_settings_2.combat_ability.power_level * 2,
					},
				},
			},
			special_rule = {
				identifier = "psyker_discharge_damage_per_warp_charge",
				special_rule_name = "psyker_discharge_damage_per_warp_charge",
			},
		},
		psyker_passive_souls_from_elite_kills = {
			description = "loc_talent_psyker_souls_desc",
			display_name = "loc_talent_psyker_souls",
			medium_icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_base_1",
			name = "Killing an enemy with Smite retains their soul. Each soul reduces the cd of your next combat ability. Souls are retained for 20 seconds and you can hold up to 4 souls at the same time.",
			format_values = {
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_souls",
						find_value_type = "buff_template",
						path = {
							"duration",
						},
					},
				},
				stack = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_souls",
						find_value_type = "buff_template",
						path = {
							"max_stacks",
						},
					},
				},
				cooldown_reduction = {
					format_type = "percentage",
					value = talent_settings_2.combat_ability_1.cooldown_reduction_percent,
				},
			},
			passive = {
				buff_template_name = "psyker_passive_souls_from_elite_kills",
				identifier = "psyker_passive_souls_from_elite_kills",
			},
			special_rule = {
				identifier = "psyker_restore_cooldown_per_soul",
				special_rule_name = special_rules.psyker_restore_cooldown_per_soul,
			},
		},
		psyker_chance_to_vent_on_kill = {
			description = "loc_talent_psyker_base_2_description",
			display_name = "loc_talent_psyker_base_2",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_base_2",
			name = "Passive - Your kills have 10% chance to reduce warp charge by 10%",
			format_values = {
				warp_charge_percent = {
					format_type = "percentage",
					value = talent_settings_2.passive_2.warp_charge_percent,
				},
				chance = {
					format_type = "percentage",
					value = talent_settings_2.passive_2.on_hit_proc_chance,
				},
			},
			passive = {
				buff_template_name = "psyker_chance_to_vent_on_kill",
				identifier = "psyker_chance_to_vent_on_kill",
			},
		},
		psyker_overcharge_reduced_warp_charge = {
			description = "loc_ability_psyker_overcharge_reduced_warp_charge_description",
			display_name = "loc_ability_psyker_overcharge_reduced_warp_charge",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_base_2",
			name = "Reduce charge generation - Reduces peril generation while in overcharge stance - ",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_psyker_combat_ability_overcharge_stance",
				},
				warp_charge = {
					format_type = "percentage",
					prefix = "-",
					value = psyker_overcharge_reduced_warp_charge.conditional_stat_buffs.warp_charge_amount,
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end,
				},
			},
			passive = {
				buff_template_name = "psyker_overcharge_reduced_warp_charge",
				identifier = "psyker_overcharge_reduced_warp_charge",
			},
		},
		psyker_overcharge_stance_infinite_casting = {
			description = "loc_talent_psyker_overcharge_infinite_casting_desc",
			display_name = "loc_talent_psyker_overcharge_infinite_casting",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_base_2",
			name = "Infinite Casting during stance",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_psyker_combat_ability_overcharge_stance",
				},
			},
			passive = {
				buff_template_name = "psyker_overcharge_stance_infinite_casting",
				identifier = "psyker_overcharge_stance_infinite_casting",
			},
		},
		psyker_overcharge_reduced_toughness_damage_taken = {
			description = "loc_ability_psyker_overcharge_reduced_toughness_damage_taken_description",
			display_name = "loc_ability_psyker_overcharge_reduced_toughness_damage_taken",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_base_2",
			name = "Reduce toughness dmg in stance - Reduced toughness damage taken while in overcharge stance",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_psyker_combat_ability_overcharge_stance",
				},
				tdr = {
					format_type = "percentage",
					prefix = "+",
					value = psyker_overcharge_reduced_toughness_damage_taken_buff.conditional_stat_buffs.toughness_damage_taken_multiplier,
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end,
				},
			},
			passive = {
				buff_template_name = "psyker_overcharge_reduced_toughness_damage_taken",
				identifier = "psyker_overcharge_reduced_toughness_damage_taken",
			},
		},
		psyker_overcharge_increased_movement_speed = {
			description = "loc_ability_psyker_overcharge_movement_speed_description",
			display_name = "loc_ability_psyker_overcharge_movement_speed",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_base_2",
			name = "Movespeed in stance - Increased movement speed while in overcharge stance",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_psyker_combat_ability_overcharge_stance",
				},
				movement_speed = {
					format_type = "percentage",
					prefix = "+",
					value = psyker_overcharge_increased_movement_speed_buff.conditional_stat_buffs.movement_speed,
				},
			},
			passive = {
				buff_template_name = "psyker_overcharge_increased_movement_speed",
				identifier = "psyker_overcharge_increased_movement_speed",
			},
		},
		psyker_overcharge_weakspot_kill_bonuses = {
			description = "loc_ability_psyker_overcharge_weakspot_description",
			display_name = "loc_ability_psyker_overcharge_weakspot",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_base_2",
			name = "Headshots kill grant stacking finesse dmg, until end of stance - 10% per stack/kill",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_psyker_combat_ability_overcharge_stance",
				},
				second = {
					format_type = "number",
					value = TalentSettings.overcharge_stance.second_per_weakspot,
				},
				finesse_damage_per_stack = {
					format_type = "percentage",
					prefix = "+",
					value = TalentSettings.overcharge_stance.finesse_damage_per_stack,
				},
				max_finesse_damage = {
					format_type = "percentage",
					prefix = "+",
					value = TalentSettings.overcharge_stance.finesse_damage_per_stack * TalentSettings.overcharge_stance.max_stacks,
				},
				duration = {
					format_type = "number",
					value = TalentSettings.overcharge_stance.post_stance_duration,
				},
			},
			special_rule = {
				identifier = "psyker_overchage_stance_weakspot_kills",
				special_rule_name = "psyker_overchage_stance_weakspot_kills",
			},
		},
		psyker_empowered_ability = {
			description = "loc_talent_psyker_empowered_ability_description",
			display_name = "loc_talent_psyker_empowered_ability",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_base_1",
			name = "Passive - Kills have a chance to empower your next blitz ability",
			format_values = {
				chance = {
					format_type = "percentage",
					num_decimals = 1,
					find_value = {
						buff_template_name = "psyker_empowered_grenades_passive",
						find_value_type = "buff_template",
						path = {
							"proc_events",
							proc_events.on_hit,
						},
					},
				},
				blitz_one = {
					format_type = "loc_string",
					value = "loc_talent_psyker_brain_burst_improved",
				},
				smite_cost = {
					format_type = "percentage",
					value = 1 - talent_settings_3.passive_1.psyker_smite_cost_multiplier,
				},
				smite_attack_speed = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_empowered_grenades_passive_visual_buff",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.smite_attack_speed,
						},
					},
				},
				smite_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "psyker_empowered_grenades_passive_visual_buff",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.smite_damage,
						},
					},
				},
				blitz_two = {
					format_type = "loc_string",
					value = "loc_ability_psyker_chain_lightning",
				},
				chain_lightning_damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_3.passive_1.chain_lightning_damage,
				},
				chain_lightning_jump_time_multiplier = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_empowered_grenades_passive_visual_buff",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.chain_lightning_jump_time_multiplier,
						},
					},
				},
				blitz_three = {
					format_type = "loc_string",
					value = "loc_ability_psyker_blitz_throwing_knives",
				},
				throwing_knives_cost = {
					format_type = "percentage",
					value = 1,
				},
				throwing_knives_charges = {
					format_type = "number",
					value = 0,
				},
				throwing_knives_old_damage = {
					format_type = "number",
					find_value = {
						damage_profile_name = "psyker_throwing_knives",
						find_value_type = "base_damage",
						power_level = PowerLevelSettings.default_power_level,
					},
				},
				throwing_knives_new_damage = {
					format_type = "number",
					find_value = {
						damage_profile_name = "psyker_throwing_knives_pierce",
						find_value_type = "base_damage",
						power_level = PowerLevelSettings.default_power_level,
					},
				},
			},
			passive = {
				buff_template_name = "psyker_empowered_grenades_passive",
				identifier = "psyker_empowered_grenades_passive",
			},
			special_rule = {
				identifier = "psyker_empowered_grenades",
				special_rule_name = "psyker_empowered_grenades",
			},
		},
		psyker_throwing_knives_piercing = {
			description = "loc_talent_psyker_throwing_knives_pierce_description",
			display_name = "loc_talent_psyker_throwing_knives_pierce",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_base_1",
			name = "Passive - Kills have a chance to empower your next blitz ability",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_ability_psyker_blitz_throwing_knives",
				},
			},
			passive = {
				buff_template_name = "psyker_throwing_knives_piercing",
				identifier = "psyker_throwing_knives_piercing",
			},
		},
		psyker_throwing_knives_cast_speed = {
			description = "loc_talent_psyker_throwing_knives_cast_speed_description",
			display_name = "loc_talent_psyker_throwing_knives_reduced_cooldown",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_base_1",
			name = "Passive - Kills have a chance to empower your next blitz ability",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_ability_psyker_blitz_throwing_knives",
				},
				speed = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "psyker_throwing_knife_stacking_speed_buff",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.psyker_throwing_knife_speed_modifier,
						},
					},
					value_manipulation = function (value)
						return value * 100
					end,
				},
				recharge = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_reduced_throwing_knife_cooldown",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.grenade_ability_cooldown_modifier,
						},
					},
					value_manipulation = function (value)
						return math.abs(value * 100)
					end,
				},
				stacks = {
					format_values = "number",
					find_value = {
						buff_template_name = "psyker_throwing_knife_stacking_speed_buff",
						find_value_type = "buff_template",
						path = {
							"max_stacks",
						},
					},
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_throwing_knife_stacking_speed_buff",
						find_value_type = "buff_template",
						path = {
							"duration",
						},
					},
				},
			},
			passive = {
				buff_template_name = "psyker_reduced_throwing_knife_cooldown",
				identifier = "psyker_reduced_throwing_knife_cooldown",
			},
		},
		psyker_throwing_knives_reduced_cooldown = {
			description = "loc_talent_psyker_throwing_knives_reduced_cooldown_description",
			display_name = "loc_talent_psyker_throwing_knives_reduced_cooldown",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_base_1",
			name = "Passive - Kills have a chance to empower your next blitz ability",
			format_values = {
				cooldown_multiplier = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_reduced_throwing_knife_cooldown",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.grenade_ability_cooldown_modifier,
						},
					},
					value_manipulation = function (value)
						return (value - 1) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "psyker_reduced_throwing_knife_cooldown",
				identifier = "psyker_reduced_throwing_knife_cooldown",
			},
		},
		psyker_throwing_knives_combat_ability_recharge = {
			description = "loc_talent_psyker_throwing_knives_combat_ability_recharge_desc",
			display_name = "loc_talent_psyker_throwing_knives_combat_ability_recharge",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_base_1",
			name = "Passive - Kills have a chance to empower your next blitz ability",
			format_values = {
				charges = {
					format_type = "number",
					value = talent_settings.throwing_knives.charges_restored,
				},
			},
			passive = {
				buff_template_name = "psyker_throwing_knives_ability_recharge",
				identifier = "psyker_throwing_knives_ability_recharge",
			},
		},
		psyker_chain_lightning_improved_target_buff = {
			description = "loc_talent_psyker_chain_lightning_improved_target_buff_description",
			display_name = "loc_talent_psyker_chain_lightning_improved_target_buff",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_base_1",
			name = "Your chain lightning targets take increased damage from all sources",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_ability_psyker_chain_lightning",
				},
				damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "psyker_protectorate_spread_chain_lightning_interval_improved",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.damage_taken_multiplier,
						},
					},
					value_manipulation = function (value)
						return (value - 1) * 100
					end,
				},
			},
			special_rule = {
				identifier = "psyker_chain_lightning_improved_target_buff",
				special_rule_name = "psyker_chain_lightning_improved_target_buff",
			},
		},
		psyker_aura_ability_cooldown = {
			description = "loc_talent_psyker_aura_reduced_ability_cooldown_description",
			display_name = "loc_talent_psyker_aura_reduced_ability_cooldown",
			icon = "content/ui/textures/icons/talents/psyker/psyker_aura_cooldown_regen",
			name = "Aura - Decreased ability cooldown",
			format_values = {
				cooldown_reduction = {
					format_type = "percentage",
					num_decimals = 1,
					prefix = "+",
					value = math.abs(talent_settings_3.coherency.ability_cooldown_modifier),
				},
			},
			coherency = {
				buff_template_name = "psyker_aura_ability_cooldown",
				identifier = "psyker_aura",
				priority = 1,
			},
		},
		psyker_cooldown_aura_improved = {
			description = "loc_talent_psyker_cooldown_aura_improved_description",
			display_name = "loc_talent_psyker_cooldown_aura_improved",
			medium_icon = "content/ui/textures/icons/talents/psyker/psyker_aura_seers_presence",
			name = "Aura - Decreased ability cooldown",
			format_values = {
				cooldown_reduction = {
					format_type = "percentage",
					prefix = "+",
					value = math.abs(talent_settings_3.coherency.ability_cooldown_modifier_improved),
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_psyker_aura_reduced_ability_cooldown",
				},
			},
			coherency = {
				buff_template_name = "psyker_aura_ability_cooldown_improved",
				identifier = "psyker_aura",
				priority = 2,
			},
		},
		psyker_aura_crit_chance_aura = {
			description = "loc_ability_psyker_gunslinger_aura_description",
			display_name = "loc_ability_psyker_gunslinger_aura",
			medium_icon = "content/ui/textures/icons/talents/psyker_1/psyker_1_base_1",
			name = "psyker_aura_crit_chance_aura",
			format_values = {
				critical_strike_chance = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "psyker_aura_crit_chance_aura",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.critical_strike_chance,
						},
					},
				},
				max_stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_aura_crit_chance_aura",
						find_value_type = "buff_template",
						path = {
							"max_stacks",
						},
					},
				},
			},
			coherency = {
				buff_template_name = "psyker_aura_crit_chance_aura",
				identifier = "psyker_aura",
				priority = 2,
			},
		},
		psyker_aura_damage_vs_elites = {
			description = "loc_talent_psyker_base_3_description",
			display_name = "loc_talent_psyker_base_3",
			medium_icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_aura",
			name = "Aura - Increased damage versus elites and specials",
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.coherency.damage_vs_elites,
				},
			},
			coherency = {
				buff_template_name = "psyker_aura_damage_vs_elites",
				identifier = "psyker_aura",
				priority = 2,
			},
		},
		psyker_toughness_on_soul = {
			description = "loc_talent_psyker_toughness_regen_on_soul_desc",
			display_name = "loc_talent_psyker_toughness_regen_on_soul",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_1_1",
			name = "Replenish toughness over time after gaining a soul.",
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings_2.toughness_1.percent_toughness * talent_settings_2.toughness_1.duration,
				},
				time = {
					format_type = "number",
					value = talent_settings_2.toughness_1.duration,
				},
			},
			special_rule = {
				identifier = "psyker_toughness_on_soul",
				special_rule_name = "psyker_toughness_on_soul",
			},
		},
		psyker_toughness_on_warp_kill = {
			description = "loc_talent_psyker_toughness_on_warp_kill_desc",
			display_name = "loc_talent_psyker_toughness_on_warp_kill",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_5_2",
			name = "Replenish Toughness on warp kill - Replenish toughness when killing an enemy with warp powered attacks.",
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings_2.toughness_2.percent_toughness,
				},
			},
			passive = {
				buff_template_name = "psyker_toughness_on_warp_kill",
				identifier = "psyker_toughness_on_warp_kill",
			},
		},
		psyker_toughness_on_vent = {
			description = "loc_talent_psyker_toughness_from_vent_desc",
			display_name = "loc_talent_psyker_toughness_from_vent",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_4_3",
			name = "Replenish toughness for each % of warp charge ventilated.",
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings_2.toughness_3.multiplier,
					value_manipulation = function (value)
						return value * 10
					end,
				},
				warp_charge = {
					format_type = "percentage",
					value = 0.1,
				},
			},
			passive = {
				buff_template_name = "psyker_toughness_on_vent",
				identifier = "psyker_toughness_on_vent",
			},
		},
		psyker_warp_charge_generation_generates_toughness = {
			description = "loc_talent_psyker_warp_charge_generation_generates_toughness_description",
			display_name = "loc_talent_psyker_warp_charge_generation_generates_toughness",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_1_1",
			name = "Generating Warp Charge replenishes toughness",
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings_2.toughness_4.multiplier,
					value_manipulation = function (value)
						return value * 10
					end,
				},
				warp_charge = {
					format_type = "percentage",
					value = 0.1,
				},
			},
			passive = {
				buff_template_name = "psyker_toughness_on_warp_generation",
				identifier = "psyker_toughness_on_warp_generation",
			},
		},
		psyker_increased_vent_speed = {
			description = "loc_talent_psyker_increased_vent_speed_description",
			display_name = "loc_talent_psyker_increased_vent_speed",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_1_3",
			name = "Increased venting speed",
			format_values = {
				vent_speed = {
					format_type = "percentage",
					value = 1 - talent_settings_3.mixed_3.vent_warp_charge_speed,
				},
			},
			passive = {
				buff_template_name = "psyker_increased_vent_speed",
				identifier = "psyker_increased_vent_speed",
			},
		},
		psyker_guaranteed_crit_on_multiple_weakspot_hits = {
			description = "loc_talent_psyker_weakspot_grants_crit_description",
			display_name = "loc_talent_psyker_weakspot_grants_crit",
			icon = "content/ui/textures/icons/talents/psyker_1/psyker_1_tier_1_1",
			name = "psyker_headshots_guaranteed_crit",
			format_values = {
				weakspot_hits = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_guaranteed_ranged_shot_on_stacked",
						find_value_type = "buff_template",
						path = {
							"max_stacks",
						},
					},
				},
			},
			passive = {
				buff_template_name = "psyker_guaranteed_crit_on_multiple_weakspot_hits",
				identifier = "psyker_guaranteed_crit_on_multiple_weakspot_hits",
			},
		},
		psyker_kills_stack_other_weapon_damage = {
			description = "loc_talent_psyker_kills_stack_other_weapon_damage_description",
			display_name = "loc_talent_psyker_kills_stack_other_weapon_damage",
			icon = "content/ui/textures/icons/talents/psyker_1/psyker_1_tier_1_2",
			name = "psyker_kills_stack_other_weapon_damage",
			format_values = {
				warp_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "psyker_cycle_stacking_warp_damage",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.warp_damage,
						},
					},
				},
				stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_cycle_stacking_warp_damage",
						find_value_type = "buff_template",
						path = {
							"max_stacks",
						},
					},
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_cycle_stacking_warp_damage",
						find_value_type = "buff_template",
						path = {
							"duration",
						},
					},
				},
				ranged_damage = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_cycle_stacking_ranged_damage_stacks",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ranged_damage,
						},
					},
				},
				ranged_stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_cycle_stacking_ranged_damage_stacks",
						find_value_type = "buff_template",
						path = {
							"max_stacks",
						},
					},
				},
				melee_damage = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_cycle_stacking_melee_damage_stacks",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_damage,
						},
					},
				},
				melee_stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_cycle_stacking_melee_damage_stacks",
						find_value_type = "buff_template",
						path = {
							"max_stacks",
						},
					},
				},
			},
			passive = {
				buff_template_name = "psyker_kills_stack_other_weapon_damage",
				identifier = "psyker_kills_stack_other_weapon_damage",
			},
		},
		psyker_crits_empower_next_attack = {
			description = "loc_talent_psyker_crits_empower_warp_description",
			display_name = "loc_talent_psyker_crits_empower_next_attack",
			icon = "content/ui/textures/icons/talents/psyker_1/psyker_1_tier_1_3",
			name = "psyker_crits_empower_next_attack",
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "psyker_crits_empower_warp_buff",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.warp_damage,
						},
					},
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_crits_empower_warp_buff",
						find_value_type = "buff_template",
						path = {
							"duration",
						},
					},
				},
				stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_crits_empower_warp_buff",
						find_value_type = "buff_template",
						path = {
							"max_stacks",
						},
					},
				},
			},
			passive = {
				buff_template_name = "psyker_crits_empower_warp",
				identifier = "psyker_crits_empower_warp",
			},
		},
		psyker_damage_based_on_warp_charge = {
			description = "loc_talent_psyker_damage_based_on_warp_charge_desc",
			display_name = "loc_talent_psyker_damage_based_on_warp_charge",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_1_3",
			name = "Gain damage with based on your current warp charge amount. 10-25%",
			format_values = {
				max_damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.offensive_1_1.damage,
				},
			},
			passive = {
				buff_template_name = "psyker_warp_charge_increase_force_weapon_damage",
				identifier = "psyker_warp_charge_increase_force_weapon_damage",
			},
		},
		psyker_reduced_warp_charge_cost_and_venting_speed = {
			description = "loc_talent_psyker_reduced_warp_charge_cost_venting_speed_desc",
			display_name = "loc_talent_psyker_reduced_warp_charge_cost_venting_speed",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_2_3",
			name = "Reduces warp charge generation per soul.",
			format_values = {
				warp_charge_amount = {
					format_type = "percentage",
					prefix = "-",
					value = (1 - talent_settings_2.offensive_1_2.warp_charge_capacity) / talent_settings_2.offensive_2_1.max_souls_talent,
				},
			},
			passive = {
				buff_template_name = "psyker_reduced_warp_charge_cost_and_venting_speed",
				identifier = "psyker_reduced_warp_charge_cost_and_venting_speed",
			},
		},
		psyker_souls_increase_damage = {
			description = "loc_talent_psyker_souls_increase_damage_desc",
			display_name = "loc_talent_psyker_souls_increase_damage",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_2_3",
			name = "Reduces warp charge generation per soul.",
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.passive_1.damage / talent_settings_2.offensive_2_1.max_souls_talent,
				},
			},
			passive = {
				buff_template_name = "psyker_souls_increase_damage",
				identifier = "psyker_souls_increase_damage",
			},
		},
		psyker_elite_kills_add_warpfire = {
			description = "loc_talent_psyker_elite_and_special_kills_add_warpfire_desc",
			display_name = "loc_talent_psyker_elite_kills_add_warpfire",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_2_3_b",
			name = "Killing an elite/special enemy applies 3 stack of warpfire to all nearby enemies.",
			format_values = {
				stacks = {
					format_type = "number",
					value = talent_settings_2.offensive_1_3.num_stacks,
				},
			},
			passive = {
				buff_template_name = "psyker_elite_kills_add_warpfire",
				identifier = "psyker_elite_kills_add_warpfire",
			},
		},
		psyker_increased_chain_lightning_size = {
			description = "loc_talent_psyker_increased_chain_lightning_size_description",
			display_name = "loc_talent_psyker_increased_chain_lightning_size",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_2_1",
			name = "Increase the spread and size of your chain lightning",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_ability_psyker_chain_lightning",
				},
				max_jumps = {
					format_type = "number",
					prefix = "+",
					find_value = {
						buff_template_name = "psyker_increased_chain_lightning_size",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.chain_lightning_max_jumps,
						},
					},
				},
			},
			passive = {
				buff_template_name = "psyker_increased_chain_lightning_size",
				identifier = "psyker_increased_chain_lightning_size",
			},
		},
		psyker_empowered_grenades_increased_max_stacks = {
			description = "loc_talent_psyker_increased_empowered_chain_lightning_stacks_description",
			display_name = "loc_talent_psyker_increased_empowered_chain_lightning_stacks",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_2_2",
			name = "You can store up to 3 empowered chain lightnings",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_psyker_empowered_ability",
				},
				max_stacks = {
					format_type = "number",
					value = talent_settings_3.offensive_2.max_stacks_talent,
				},
			},
			special_rule = {
				identifier = "psyker_empowered_grenades_increased_max_stacks",
				special_rule_name = "psyker_empowered_grenades_increased_max_stacks",
			},
		},
		psyker_shield_stun_passive = {
			description = "loc_talent_psyker_force_field_stun_increased_description",
			display_name = "loc_talent_psyker_force_field_stun_increased",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_2_3",
			name = "Gives chance to stun enemies that pass through your force field",
			format_values = {
				proc_chance = {
					format_type = "percentage",
					value = talent_settings_3.offensive_3.proc_chance,
				},
				special_proc_chance = {
					format_type = "percentage",
					value = talent_settings_3.offensive_3.special_proc_chance,
				},
				ability = {
					format_type = "loc_string",
					value = "loc_talent_psyker_combat_ability_shield",
				},
			},
			passive = {
				buff_template_name = "psyker_shield_stun_passive",
				identifier = "psyker_shield_stun_passive",
			},
		},
		psyker_coherency_aura_size_increase = {
			description = "loc_talent_psyker_coherency_size_increase_description",
			display_name = "loc_talent_psyker_coherency_size_increase",
			icon = "content/ui/textures/icons/talents/psyker_1/psyker_1_tier_3_1",
			name = "psyker_coherency_aura_size_increase",
			format_values = {
				radius_modifier = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "coherency_aura_size_increase",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.coherency_radius_modifier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "coherency_aura_size_increase",
				identifier = "coherency",
			},
		},
		psyker_1_tier_3_name_2 = {
			description = "loc_talent_psyker_improved_coherency_efficiency_description",
			display_name = "loc_talent_psyker_improved_coherency_efficiency",
			icon = "content/ui/textures/icons/talents/psyker_1/psyker_1_tier_3_2",
			name = "psyker_aura_crit_chance_aura_improved",
			format_values = {
				crit_chance = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "psyker_aura_crit_chance_aura_improved",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.critical_strike_chance,
						},
					},
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_ability_psyker_gunslinger_aura",
				},
			},
			coherency = {
				buff_template_name = "psyker_aura_crit_chance_aura_improved",
				identifier = "psyker_aura",
			},
		},
		psyker_aura_souls_on_kill = {
			description = "loc_talent_psyker_souls_on_kill_coop_desc",
			display_name = "loc_talent_psyker_souls_on_kill_coop",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_3_2",
			name = "Whenever you or an ally in coherency kills an enemy you have a chance to gain a soul.",
			format_values = {
				soul_chance = {
					format_type = "percentage",
					value = talent_settings_2.coop_1.on_kill_proc_chance,
				},
			},
			passive = {
				buff_template_name = "psyker_aura_souls_on_kill",
				identifier = "psyker_aura_souls_on_kill",
			},
		},
		psyker_2_tier_3_name_2 = {
			description = "loc_talent_psyker_elite_kills_give_combat_ability_cd_coherency_desc",
			display_name = "loc_talent_psyker_elite_kills_give_combat_ability_cd_coherency",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_5_3",
			name = "Killing an elite enemy restores combat ability cooldown to allies in coherency",
			format_values = {
				cooldown = {
					format_type = "percentage",
					value = talent_settings_2.coop_2.percent,
				},
			},
			passive = {
				buff_template_name = "psyker_aura_cooldown_reduction_on_elite_kill",
				identifier = "psyker_aura_cooldown_reduction_on_elite_kill",
			},
		},
		psyker_2_tier_3_name_3 = {
			description = "loc_talent_biomancer_smite_increases_non_warp_damage_desc",
			display_name = "loc_talent_biomancer_smite_increases_non_warp_damage",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_3_3",
			name = "Damaging an enemy with your smite ability causes them to take increased damage from all sources for 5 seconds.",
			format_values = {
				damage = math_round((talent_settings_2.coop_3.damage_taken_multiplier - 1) * 100),
				time = talent_settings_2.coop_3.duration,
			},
			passive = {
				buff_template_name = "psyker_smite_makes_victim_vulnerable",
				identifier = "psyker_smite_makes_victim_vulnerable",
			},
		},
		psyker_aura_toughness_on_ally_knocked_down = {
			description = "loc_talent_psyker_restore_toughness_to_allies_when_ally_down_description",
			display_name = "loc_talent_psyker_restore_toughness_to_allies_when_ally_down",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_4_1",
			name = "Fully restores toughness on allies in coherency, when an ally gets knocked down.",
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings_3.coop_1.toughness_percent,
				},
			},
			passive = {
				buff_template_name = "psyker_aura_toughness_on_ally_knocked_down",
				identifier = "psyker_aura_toughness_on_ally_knocked_down",
			},
		},
		psyker_3_tier_3_name_2 = {
			description = "loc_talent_psyker_increased_aura_efficiency_description",
			display_name = "loc_talent_psyker_increased_aura_efficiency",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_4_2",
			name = "Increased the efficiency of your aura",
			format_values = {
				cooldown_reduction = {
					format_type = "percentage",
					prefix = "-",
					value = talent_settings_3.coop_2.ability_cooldown_modifier,
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_psyker_3_passive_2",
				},
			},
			coherency = {
				buff_template_name = "psyker_aura_ability_cooldown_improved",
				identifier = "psyker_aura",
			},
		},
		psyker_toughness_regen_at_shield = {
			description = "loc_talent_psyker_force_field_restores_toughness_description",
			display_name = "loc_talent_psyker_force_field_restores_toughness",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_4_3",
			name = "Your shield periodically grants toughness to nearby allies",
			format_values = {
				toughness = talent_settings_3.coop_3.toughness_percentage * 100,
				interval = talent_settings_3.coop_3.interval,
			},
			passive = {
				buff_template_name = "psyker_toughness_regen_at_shield",
				identifier = "psyker_toughness_regen_at_shield",
			},
		},
		psyker_dodge_after_crits = {
			description = "loc_talent_psyker_dodge_after_crits_description",
			display_name = "loc_talent_psyker_dodge_after_crits",
			icon = "content/ui/textures/icons/talents/psyker_1/psyker_1_tier_2_1",
			name = "psyker_dodge_after_crits",
			format_values = {
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_dodge_after_crits",
						find_value_type = "buff_template",
						path = {
							"active_duration",
						},
					},
				},
			},
			passive = {
				buff_template_name = "psyker_dodge_after_crits",
				identifier = "psyker_dodge_after_crits",
			},
		},
		psyker_crits_regen_toughness_movement_speed = {
			description = "loc_talent_psyker_crits_regen_tougness_and_movement_speed_description",
			display_name = "loc_talent_psyker_crits_regen_tougness_and_movement_speed",
			icon = "content/ui/textures/icons/talents/psyker_1/psyker_1_tier_2_2",
			name = "psyker_crits_regen_toughness_movement_speed",
			format_values = {
				toughness = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_crits_regen_toughness_movement_speed",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"toughness_percentage",
						},
					},
				},
				movement_speed = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "psyker_stacking_movement_buff",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.movement_speed,
						},
					},
				},
				seconds = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_stacking_movement_buff",
						find_value_type = "buff_template",
						path = {
							"duration",
						},
					},
				},
				stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_stacking_movement_buff",
						find_value_type = "buff_template",
						path = {
							"max_stacks",
						},
					},
				},
			},
			passive = {
				buff_template_name = "psyker_crits_regen_toughness_movement_speed",
				identifier = "psyker_crits_regen_toughness_movement_speed",
			},
		},
		psyker_improved_dodge = {
			description = "loc_talent_psyker_improved_dodge_description",
			display_name = "loc_talent_psyker_improved_dodge",
			icon = "content/ui/textures/icons/talents/psyker_1/psyker_1_tier_2_3",
			name = "psyker_better_dodges",
			format_values = {
				dodge_linger_time = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "psyker_improved_dodge",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.dodge_linger_time_modifier,
						},
					},
				},
				extra_consecutive_dodges = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_improved_dodge",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.extra_consecutive_dodges,
						},
					},
				},
			},
			passive = {
				buff_template_name = "psyker_improved_dodge",
				identifier = "psyker_improved_dodge",
			},
		},
		psyker_block_costs_warp_charge = {
			description = "loc_talent_psyker_block_costs_warp_charge_desc",
			display_name = "loc_talent_psyker_block_costs_warp_charge",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_4_1",
			name = "While below critical warp charge, blocking an attack causes you to gain warp charge instead of losing stamina.",
			format_values = {
				warp_charge_block_cost = {
					format_type = "percentage",
					value = talent_settings_2.defensive_1.warp_charge_cost_multiplier,
				},
			},
			passive = {
				buff_template_name = "psyker_block_costs_warp_charge",
				identifier = "psyker_block_costs_warp_charge",
			},
		},
		psyker_warp_charge_reduces_toughness_damage_taken = {
			description = "loc_talent_psyker_toughness_damage_reduction_from_warp_charge_desc",
			display_name = "loc_talent_psyker_toughness_damage_reduction_from_warp_charge",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_2_2",
			name = "Take reduced toughness damage based on your current warp charge amount.",
			format_values = {
				min_damage = {
					format_type = "percentage",
					prefix = "+",
					value = 1 - talent_settings_2.defensive_2.min_toughness_damage_multiplier,
				},
				max_damage = {
					format_type = "percentage",
					prefix = "+",
					value = 1 - talent_settings_2.defensive_2.max_toughness_damage_multiplier,
				},
			},
			passive = {
				buff_template_name = "psyker_warp_charge_reduces_toughness_damage_taken",
				identifier = "psyker_warp_charge_reduces_toughness_damage_taken",
			},
		},
		psyker_venting_improvements = {
			description = "loc_talent_psyker_venting_doesnt_slow_desc",
			display_name = "loc_talent_psyker_venting_doesnt_slow",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_3_1",
			name = "Venting no longer slows your movement speed.",
			format_values = {},
			passive = {
				buff_template_name = "psyker_venting_improvements",
				identifier = "psyker_venting_improvements",
			},
		},
		psyker_boost_allies_in_sphere = {
			description = "loc_talent_psyker_force_field_grants_toughness_desc",
			display_name = "loc_talent_psyker_force_field_grants_toughness",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_3_1",
			name = "",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_psyker_combat_ability_shield",
				},
				toughness_damage_reduction = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_3.combat_ability.toughness_damage_reduction,
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end,
				},
				toughness = {
					format_type = "percentage",
					value = talent_settings_3.combat_ability.toughness_for_allies,
				},
				duration = {
					format_type = "number",
					value = talent_settings_3.combat_ability.toughness_duration,
				},
			},
			special_rule = {
				identifier = "psyker_boost_allies_in_sphere",
				special_rule_name = "psyker_boost_allies_in_sphere",
			},
		},
		psyker_boost_allies_passing_through_force_field = {
			description = "loc_talent_psyker_force_field_grants_movement_and_toughness_dr_description",
			display_name = "loc_talent_psyker_force_field_grants_movement_and_toughness_dr",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_3_1",
			name = "Allies passing through your Shield gain 10% movement speed and 20% toughness damage reduction for 6 seconds",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_psyker_combat_ability_shield",
				},
				movement_speed = {
					format_type = "percentage",
					prefix = "+",
					value = psyker_force_field_buff.stat_buffs.movement_speed,
				},
				toughness_dr = {
					format_type = "percentage",
					prefix = "+",
					value = psyker_force_field_buff.stat_buffs.toughness_damage_taken_multiplier,
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end,
				},
				duration = {
					format_type = "number",
					value = psyker_force_field_buff.duration,
				},
			},
			passive = {
				buff_template_name = "psyker_boost_allies_passing_through_force_field",
				identifier = "psyker_boost_allies_passing_through_force_field",
			},
		},
		psyker_chain_lightning_increases_movement_speed = {
			description = "loc_talent_psyker_empowered_chain_lighting_movement_speed_description",
			display_name = "loc_talent_psyker_empowered_chain_lighting_movement_speed",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_3_3",
			name = "Chain lighting grants a short burst of movement speed",
			format_values = {
				movement_speed = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_3.defensive_3.movement_speed,
				},
				duration = {
					format_type = "number",
					value = talent_settings_3.defensive_3.active_duration,
				},
				ability = {
					format_type = "loc_string",
					value = "loc_ability_psyker_chain_lightning",
				},
			},
			passive = {
				buff_template_name = "psyker_chain_lightning_increases_movement_speed",
				identifier = "psyker_chain_lightning_increases_movement_speed",
			},
		},
		psyker_increased_max_souls = {
			description = "loc_talent_psyker_increased_souls_desc",
			display_name = "loc_talent_psyker_increased_souls",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_5_1",
			name = "Increases the maximum amount of souls you can have to 6.",
			format_values = {
				soul_amount = {
					format_type = "number",
					value = max_souls_talent,
				},
			},
			special_rule = {
				identifier = "psyker_increased_max_souls",
				special_rule_name = "psyker_increased_max_souls",
			},
		},
		psyker_spread_warpfire_on_kill = {
			description = "loc_talent_psyker_warpfire_spread_desc",
			display_name = "loc_talent_psyker_warpfire_spread",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_1_2",
			name = "Whenever an enemy you've affected with Warpfire dies, they spread up to 4 stacks evenly to enemies nearby",
			format_values = {
				stacks = {
					format_type = "number",
					value = talent_settings_2.offensive_2_2.stacks_to_share,
				},
			},
			special_rule = {
				identifier = "psyker_spread_warpfire_on_kill",
				special_rule_name = "psyker_spread_warpfire_on_kill",
			},
		},
		psyker_smite_on_hit = {
			description = "loc_talent_psyker_smite_on_hit_desc",
			display_name = "loc_talent_psyker_smite_on_hit",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_2_1",
			name = "All attacks have a chance on hit to smite the target. This cannot occur while at critical warp charge and has a cooldown.",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_psyker_brain_burst_improved",
				},
				smite_chance = {
					format_type = "percentage",
					value = talent_settings_2.offensive_2_3.smite_chance,
				},
				time = {
					format_type = "number",
					value = talent_settings_2.offensive_2_3.cooldown,
				},
			},
			passive = {
				buff_template_name = "psyker_smite_on_hit",
				identifier = "psyker_smite_on_hit",
			},
		},
		psyker_empowered_chain_lightnings_replenish_toughness_to_allies = {
			description = "loc_talent_psyker_empowered_chain_lightnings_replenish_toughness_to_allies_description",
			display_name = "loc_talent_psyker_empowered_chain_lightnings_replenish_toughness_to_allies",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_5_1",
			name = "Your empowered chain lightning replenishes toughness for allies in coherency",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_psyker_empowered_ability",
				},
				toughness = {
					format_type = "percentage",
					value = talent_settings_3.spec_passive_1.toughness_for_allies,
				},
			},
			special_rule = {
				identifier = "psyker_empowered_grenades_toughness_on_attack",
				special_rule_name = "psyker_empowered_grenades_toughness_on_attack",
			},
		},
		psyker_empowered_grenades_passive_improved = {
			description = "loc_talent_psyker_increase_empower_chain_lighting_chance_description",
			display_name = "loc_talent_psyker_increase_empower_chain_lighting_chance",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_5_2",
			name = "Increase the chance for kills to generate Empowered Chain Lightnings",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_psyker_empowered_ability",
				},
				proc_chance_before = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_empowered_grenades_passive",
						find_value_type = "buff_template",
						path = {
							"proc_events",
							proc_events.on_hit,
						},
					},
				},
				proc_chance_after = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_empowered_grenades_passive_improved",
						find_value_type = "buff_template",
						path = {
							"proc_events",
							proc_events.on_hit,
						},
					},
				},
			},
			passive = {
				buff_template_name = "psyker_empowered_grenades_passive_improved",
				identifier = "psyker_empowered_grenades_passive",
			},
		},
		psyker_empowered_ability_on_elite_kills = {
			description = "loc_talent_psyker_empowered_ability_on_elite_kills_description",
			display_name = "loc_talent_psyker_empowered_ability_on_elite_kills",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_5_2",
			name = "Increase the chance for kills to generate Empowered Chain Lightnings",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_psyker_empowered_ability",
				},
			},
			special_rule = {
				identifier = "psyker_empowered_grenades_stack_on_elite_kills",
				special_rule_name = "psyker_empowered_grenades_stack_on_elite_kills",
			},
		},
		psyker_souls_restore_cooldown_on_ability = {
			description = "loc_talent_psyker_souls_restore_cooldown_on_ability_increased_souls_desc",
			display_name = "loc_talent_psyker_souls_restore_cooldown_on_ability",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_6_1",
			name = "Using Unleash the warp removes all souls and reduces the cooldown for each soul removed",
			format_values = {
				stacks = 2,
				cooldown = talent_settings_2.combat_ability_1.cooldown_reduction_percent * 100,
			},
			special_rule = {
				identifier = "psyker_restore_cooldown_per_soul",
				special_rule_name = special_rules.psyker_restore_cooldown_per_soul,
			},
		},
		psyker_warpfire_on_shout = {
			description = "loc_talent_psyker_warpfire_on_shout_desc",
			display_name = "loc_talent_psyker_warpfire_on_shout",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_6_2",
			name = "Using Unleash the Warp applies warpfire to targets hit based on warp charge",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_psyker_shout_vent_warp_charge",
				},
				min_stacks = {
					format_type = "string",
					value = "1-",
				},
				warpfire_stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_shout_applies_warpfire",
						find_value_type = "buff_template",
						path = {
							"warpfire_max_stacks",
						},
					},
				},
			},
			passive = {
				buff_template_name = "psyker_shout_applies_warpfire",
				identifier = "psyker_shout_applies_warpfire",
			},
		},
		psyker_warpfire_generate_souls = {
			description = "loc_talent_psyker_warpfire_generates_souls_desc",
			display_name = "loc_talent_psyker_warpfire_generates_souls",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_6_2",
			name = "Enemies that die from warpfire have a chance to grant you a soul.",
			format_values = {
				chance = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_soul_on_warpfire_kill",
						find_value_type = "buff_template",
						path = {
							"proc_events",
							proc_events.on_minion_death,
						},
					},
				},
			},
			passive = {
				buff_template_name = "psyker_soul_on_warpfire_kill",
				identifier = "psyker_soul_on_warpfire_kill",
			},
		},
		psyker_ability_increase_brain_burst_speed = {
			description = "loc_talent_psyker_ability_increase_brain_burst_speed_desc",
			display_name = "loc_talent_psyker_ability_increase_brain_burst_speed",
			icon = "content/ui/textures/icons/talents/psyker_2/psyker_2_tier_6_3",
			name = "For seconds after using your combat ability, your smite will charge faster and cost less warp charge.",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_psyker_brain_burst_improved",
				},
				smite_attack_speed = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.combat_ability_3.smite_attack_speed,
				},
				warp_charge_cost = {
					format_type = "percentage",
					value = talent_settings_2.combat_ability_3.warp_charge_amount_smite,
				},
				duration = {
					format_type = "number",
					value = talent_settings_2.combat_ability_3.duration,
				},
			},
			passive = {
				buff_template_name = "psyker_ability_increase_brain_burst_speed",
				identifier = "psyker_ability_increase_brain_burst_speed",
			},
		},
		psyker_shield_extra_charge = {
			description = "loc_talent_psyker_force_field_charges_description",
			display_name = "loc_talent_psyker_force_field_charges",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_1",
			name = "Increase charges of your combat ability by 1",
			format_values = {
				max_charges = {
					format_type = "number",
					value = psyker_force_field.max_charges + psyker_combat_ability_extra_charge.stat_buffs.ability_extra_charges,
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_psyker_combat_ability_shield",
				},
			},
			passive = {
				buff_template_name = "psyker_combat_ability_extra_charge",
				identifier = "psyker_combat_ability_extra_charge",
			},
		},
		psyker_sphere_shield = {
			description = "loc_talent_psyker_force_field_dome_new_desc",
			display_name = "loc_talent_psyker_force_field_dome",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			name = "Your shield takes the shape of a sphere and forms around you",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_psyker_combat_ability_shield",
				},
				duration = {
					format_type = "number",
					value = talent_settings_3.combat_ability.sphere_duration,
				},
			},
			player_ability = {
				ability_type = "combat_ability",
				priority = 1,
				ability = PlayerAbilities.psyker_force_field_dome,
			},
			special_rule = {
				identifier = "psyker_sphere_shield",
				special_rule_name = "psyker_sphere_shield",
			},
		},
		psyker_new_mark_passive = {
			description = "loc_talent_psyker_marked_enemies_passive_new_desc",
			display_name = "loc_talent_psyker_marked_enemies_passive",
			name = "Mark enemies. Killing marked enemies grants bonuses",
			format_values = {
				radius = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive",
						find_value_type = "buff_template",
						path = {
							"target_distance_base",
						},
					},
				},
				toughness = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive",
						find_value_type = "buff_template",
						path = {
							"toughness_percentage",
						},
					},
				},
				move_speed = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive_bonus",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.movement_speed,
						},
					},
				},
				move_speed_duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive_bonus",
						find_value_type = "buff_template",
						path = {
							"duration",
						},
					},
				},
				base_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive_bonus_stacking",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.damage,
						},
					},
				},
				crit_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive_bonus_stacking",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.critical_strike_damage,
						},
					},
				},
				weakspot_damage = {
					format_type = "percentage",
					num_decimals = 1,
					prefix = "+",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive_bonus_stacking",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.weakspot_damage,
						},
					},
				},
				bonus_duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive_bonus_stacking",
						find_value_type = "buff_template",
						path = {
							"duration",
						},
					},
				},
				bonus_stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive_bonus_stacking",
						find_value_type = "buff_template",
						path = {
							"max_stacks",
						},
					},
				},
			},
			passive = {
				buff_template_name = "psyker_marked_enemies_passive",
				identifier = "psyker_marked_enemies_passive",
			},
		},
		psyker_weakspot_kills_can_refund_knife = {
			description = "loc_talent_psyker_weakspot_kills_can_refund_knife_description",
			display_name = "loc_talent_psyker_weakspot_kills_can_refund_knife",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			name = "Killing enemies marked by passive refunds 1 knife",
			passive = {
				buff_template_name = "psyker_weakspot_kills_can_refund_knife",
				identifier = "psyker_weakspot_kills_can_refund_knife",
			},
		},
		psyker_mark_increased_range = {
			description = "loc_talent_psyker_mark_increased_range_description",
			display_name = "loc_talent_psyker_mark_increased_range",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			name = "Increased mark range",
			format_values = {
				radius_prev = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive",
						find_value_type = "buff_template",
						path = {
							"target_distance_base",
						},
					},
				},
				radius = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive",
						find_value_type = "buff_template",
						path = {
							"target_distance_improved",
						},
					},
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_psyker_marked_enemies_passive",
				},
			},
			special_rule = {
				identifier = "psyker_mark_increased_range",
				special_rule_name = "psyker_mark_increased_range",
			},
		},
		psyker_mark_increased_max_stacks = {
			description = "loc_talent_psyker_mark_increased_max_stacks_description",
			display_name = "loc_talent_psyker_mark_increased_max_stacks",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			name = "Your shield takes the shape of a sphere and forms around you",
			format_values = {
				stacks_previous = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive_bonus_stacking",
						find_value_type = "buff_template",
						path = {
							"max_stacks",
						},
					},
				},
				stacks_after = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive_bonus_stacking_increased_stacks",
						find_value_type = "buff_template",
						path = {
							"max_stacks",
						},
					},
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_psyker_marked_enemies_passive",
				},
			},
			special_rule = {
				identifier = "psyker_mark_increased_max_stacks",
				special_rule_name = "psyker_mark_increased_max_stacks",
			},
		},
		psyker_mark_increased_duration = {
			description = "loc_talent_psyker_mark_increased_duration_description",
			display_name = "loc_talent_psyker_mark_increased_duration",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			name = "Your shield takes the shape of a sphere and forms around you",
			format_values = {
				duration_previous = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive_bonus_stacking",
						find_value_type = "buff_template",
						path = {
							"duration",
						},
					},
				},
				duration_after = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive_bonus_stacking_increased_duration",
						find_value_type = "buff_template",
						path = {
							"duration",
						},
					},
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_psyker_marked_enemies_passive",
				},
			},
			special_rule = {
				identifier = "psyker_mark_increased_duration",
				special_rule_name = "psyker_mark_increased_duration",
			},
		},
		psyker_mark_increased_mark_targets = {
			description = "loc_talent_psyker_mark_increased_mark_targets_description",
			display_name = "loc_talent_psyker_mark_increased_mark_targets",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			name = "???",
			special_rule = {
				identifier = "psyker_mark_increased_mark_targets",
				special_rule_name = "psyker_mark_increased_mark_targets",
			},
		},
		psyker_mark_kills_can_vent = {
			description = "loc_talent_psyker_mark_kills_can_vent_description",
			display_name = "loc_talent_psyker_mark_kills_can_vent",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			name = "Mark kills can vent a portion of your warp charge",
			format_values = {
				chance = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive",
						find_value_type = "buff_template",
						path = {
							"chance_to_vent_proc_chance",
						},
					},
				},
				warp_charge_percentage = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_marked_enemies_passive",
						find_value_type = "buff_template",
						path = {
							"chance_to_vent_warp_charge_percent",
						},
					},
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_psyker_marked_enemies_passive",
				},
			},
			special_rule = {
				identifier = "psyker_mark_kills_can_vent",
				special_rule_name = "psyker_mark_kills_can_vent",
			},
		},
		psyker_mark_weakspot_kills = {
			description = "loc_talent_psyker_mark_weakspot_stacks_description",
			display_name = "loc_talent_psyker_mark_weakspot_stacks",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			name = "Mark kills can vent a portion of your warp charge",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_psyker_marked_enemies_passive",
				},
				stacks = {
					format_type = "number",
					value = TalentSettings.mark_passive.weakspot_stacks - 1,
				},
			},
			special_rule = {
				identifier = "psyker_mark_weakspot_kills",
				special_rule_name = "psyker_mark_weakspot_kills",
			},
		},
		psyker_melee_attack_speed = {
			description = "loc_talent_psyker_melee_attack_speed_desc",
			display_name = "loc_talent_psyker_melee_attack_speed",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			name = "Melee Attack Speed",
			format_values = {
				melee_attack_speed = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "psyker_melee_attack_speed",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_attack_speed,
						},
					},
				},
			},
			passive = {
				buff_template_name = "psyker_melee_attack_speed",
				identifier = "psyker_melee_attack_speed",
			},
		},
		psyker_cleave_from_peril = {
			description = "loc_talent_psyker_cleave_from_peril_desc",
			display_name = "loc_talent_psyker_cleave_from_peril",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			name = "Increased Cleave per Peril",
			format_values = {
				max_cleave = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cleave_from_peril.max,
				},
			},
			passive = {
				buff_template_name = "psyker_cleave_from_peril",
				identifier = "psyker_cleave_from_peril",
			},
		},
		psyker_blocking_soulblaze = {
			description = "loc_talent_psyker_blocking_soulblaze_desc",
			display_name = "loc_talent_psyker_blocking_soulblaze",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			name = "Blocking adds Soublaze to target",
			format_values = {
				stacks = {
					format_type = "number",
					value = talent_settings.blocking_soulbaze.stacks,
				},
			},
			passive = {
				buff_template_name = "psyker_blocking_soulblaze",
				identifier = "psyker_blocking_soulblaze",
			},
		},
		psyker_nearby_soulblaze_reduced_damage = {
			description = "loc_talent_psyker_nearby_soulblaze_reduced_damage_desc",
			display_name = "loc_talent_psyker_nearby_soulblaze_reduced_damage",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			name = "Killing enemies marked by passive refunds 1 knife",
			format_values = {
				max_dr = {
					format_type = "percentage",
					prefix = "+",
					value = (1 - talent_settings.nearby_soublaze_defense.max) / talent_settings.nearby_soublaze_defense.max_stacks,
				},
				max_stacks = {
					format_type = "number",
					value = talent_settings.nearby_soublaze_defense.max_stacks,
				},
			},
			passive = {
				buff_template_name = "psyker_nearby_soulblaze_reduced_damage",
				identifier = "psyker_nearby_soulblaze_reduced_damage",
			},
		},
		psyker_warp_attacks_rending = {
			description = "loc_talent_psyker_warp_attacks_rending_desc",
			display_name = "loc_talent_psyker_warp_attacks_rending",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			name = "Warp Attacks Have Rending",
			format_values = {
				rending = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "psyker_warp_attacks_rending",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.warp_attacks_rending_multiplier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "psyker_warp_attacks_rending",
				identifier = "psyker_warp_attacks_rending",
			},
		},
		psyker_warp_glass_cannon = {
			description = "loc_talent_psyker_warp_glass_cannon_desc",
			display_name = "loc_talent_psyker_warp_glass_cannon",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			name = "Reduced Peril Regen, Reduces Toughness regen",
			format_values = {
				toughness_reduction = {
					format_type = "percentage",
					prefix = "-",
					find_value = {
						buff_template_name = "psyker_warp_glass_cannon",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_replenish_multiplier,
						},
					},
					value_manipulation = function (value)
						return (1 - math.abs(value)) * 100
					end,
				},
				peril_reduction = {
					format_type = "percentage",
					prefix = "-",
					find_value = {
						buff_template_name = "psyker_warp_glass_cannon",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.warp_charge_amount,
						},
					},
					value_manipulation = function (value)
						return (1 - value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "psyker_warp_glass_cannon",
				identifier = "psyker_warp_glass_cannon",
			},
		},
		psyker_soulblaze_reduces_damage_taken = {
			description = "loc_talent_psyker_soulblaze_reduces_damage_taken_desc",
			display_name = "loc_talent_psyker_soulblaze_reduces_damage_taken",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			name = "Soulblaze application reduces damage taken",
			format_values = {
				tdr = {
					format_type = "percentage",
					prefix = "-",
					find_value = {
						buff_template_name = "psyker_soulblaze_reduces_damage_taken",
						find_value_type = "buff_template",
						path = {
							"proc_stat_buffs",
							stat_buffs.toughness_damage_taken_multiplier,
						},
					},
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end,
				},
				time = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_soulblaze_reduces_damage_taken",
						find_value_type = "buff_template",
						path = {
							"active_duration",
						},
					},
				},
			},
			passive = {
				buff_template_name = "psyker_soulblaze_reduces_damage_taken",
				identifier = "psyker_soulblaze_reduces_damage_taken",
			},
		},
		psyker_ranged_shots_soulblaze = {
			description = "loc_talent_psyker_ranged_shots_soulblaze_desc",
			display_name = "loc_talent_psyker_ranged_shots_soulblaze",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			name = "Ranged crits apply soulblaze",
			format_values = {
				chance = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_ranged_shots_soulblaze",
						find_value_type = "buff_template",
						path = {
							"proc_events",
							proc_events.on_hit,
						},
					},
				},
				stacks = {
					format_type = "number",
					value = talent_settings.ranged_shots_soulblaze.stacks,
				},
			},
			passive = {
				buff_template_name = "psyker_ranged_shots_soulblaze",
				identifier = "psyker_ranged_shots_soulblaze",
			},
		},
		psyker_chain_lightning_heavy_attacks = {
			description = "loc_talent_psyker_chain_lightning_heavy_attacks_desc",
			display_name = "loc_talent_psyker_chain_lightning_heavy_attacks",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			name = "Heavy Attacks Electrocute enemies",
			format_values = {},
			passive = {
				buff_template_name = "psyker_chain_lightning_heavy_attacks",
				identifier = "psyker_chain_lightning_heavy_attacks",
			},
		},
		psyker_force_staff_quick_attack_bonus = {
			description = "loc_talent_psyker_force_staff_quick_attack_bonus_desc",
			display_name = "loc_talent_psyker_force_staff_quick_attack_bonus",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			name = "Force Staff Left Clicks increase Warp Damage taken by target",
			format_values = {
				damage_taken = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "psyker_force_staff_quick_attack_debuff",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.warp_damage_taken_multiplier,
						},
					},
					value_manipulation = function (value)
						return (value - 1) * 100
					end,
				},
				max_stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_force_staff_quick_attack_debuff",
						find_value_type = "buff_template",
						path = {
							"max_stacks",
						},
					},
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_force_staff_quick_attack_debuff",
						find_value_type = "buff_template",
						path = {
							"duration",
						},
					},
				},
			},
			passive = {
				buff_template_name = "psyker_force_staff_quick_attack_bonus",
				identifier = "psyker_force_staff_quick_attack_bonus",
			},
		},
		psyker_force_staff_melee_attack_bonus = {
			description = "loc_talent_psyker_force_staff_melee_attack_bonus_desc",
			display_name = "loc_talent_psyker_force_staff_melee_attack_bonus",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			name = "Force Staff Melees Vent and deal more damage based on Peril",
			format_values = {
				damage = {
					format_type = "percentage",
					value = talent_settings.psyker_force_staff_melee_attack_bonus.max,
				},
				venting = {
					format_type = "percentage",
					value = talent_settings.psyker_force_staff_melee_attack_bonus.venting,
				},
			},
			passive = {
				buff_template_name = "psyker_force_staff_melee_attack_bonus",
				identifier = "psyker_force_staff_melee_attack_bonus",
			},
		},
		psyker_alternative_peril_explosion = {
			description = "loc_talent_psyker_alternative_peril_explosion_desc",
			display_name = "loc_talent_psyker_alternative_peril_explosion",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			name = "Peril Explosions no longer knock you down",
			special_rule = {
				identifier = "psyker_no_knock_down_overload",
				special_rule_name = special_rules.psyker_no_knock_down_overload,
			},
			passive = {
				buff_template_name = "psyker_alternative_peril_explosion",
				identifier = "psyker_alternative_peril_explosion",
			},
		},
		psyker_force_staff_bonus = {
			description = "loc_talent_psyker_force_staff_bonus_desc",
			display_name = "loc_talent_psyker_force_staff_bonus",
			icon = "content/ui/textures/icons/talents/psyker_3/psyker_3_tier_6_3",
			name = "Force Staff Secondaries increase damage of Primaries",
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "psyker_force_staff_bonus_buff",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.force_staff_single_target_damage,
						},
					},
				},
				time = {
					format_type = "number",
					find_value = {
						buff_template_name = "psyker_force_staff_bonus_buff",
						find_value_type = "buff_template",
						path = {
							"duration",
						},
					},
				},
			},
			passive = {
				buff_template_name = "psyker_force_staff_bonus",
				identifier = "psyker_force_staff_bonus",
			},
		},
	},
}

return archetype_talents
