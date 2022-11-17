local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local FixedFrame = require("scripts/utilities/fixed_frame")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local attack_results = AttackSettings.attack_results
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_proc_events = BuffSettings.proc_events
local templates = {
	weapon_trait_melee_common_wield_increased_attack_buff = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.damage] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_melee_common_wield_increased_unarmored_damage_buff = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.unarmored_damage] = 0.2
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_melee_common_wield_increased_armored_damage_buff = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.armored_damage] = 0.2
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_melee_common_wield_increased_resistant_damage_buff = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.resistant_damage] = 0.2
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_melee_common_wield_increased_berserker_damage_buff = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.berserker_damage] = 0.2
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_melee_common_wield_increased_super_armor_damage_buff = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.super_armor_damage] = 0.2
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_melee_common_wield_increased_disgustingly_resilient_damage_buff = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.disgustingly_resilient_damage] = 0.2
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_melee_common_equip_decrease_corruption_damage_taken_buff = {
		predicted = false,
		class_name = "buff",
		stat_buffs = {
			[buff_stat_buffs.corruption_taken_multiplier] = 0.5
		}
	},
	weapon_trait_melee_common_wield_decrease_corruption_damage_taken_buff = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.corruption_taken_multiplier] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_melee_common_equip_decrease_toughness_damage_taken_buff = {
		predicted = false,
		class_name = "buff",
		stat_buffs = {
			[buff_stat_buffs.toughness_damage_taken_multiplier] = 0.5
		}
	},
	weapon_trait_melee_common_wield_decrease_toughness_damage_taken_buff = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.toughness_damage_taken_multiplier] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_melee_common_equip_decrease_damage_taken_buff = {
		predicted = false,
		class_name = "buff",
		stat_buffs = {
			[buff_stat_buffs.damage_taken_multiplier] = 0.5
		}
	},
	weapon_trait_melee_common_wield_decrease_damage_taken_buff = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.damage_taken_multiplier] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_melee_common_equip_increase_movement_speed_buff = {
		predicted = false,
		class_name = "buff",
		stat_buffs = {
			[buff_stat_buffs.movement_speed] = 1.5
		}
	},
	weapon_trait_melee_common_wield_increase_movement_speed_buff = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.movement_speed] = 1.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_melee_common_wield_increase_crit_chance_buff = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.critical_strike_chance] = 1
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_increase_crit_chance = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.critical_strike_chance] = 0.05
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_increase_crit_damage = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.critical_strike_damage] = 0.1
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_increase_stamina = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.stamina_modifier] = 1
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_increase_weakspot_damage = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.weakspot_damage] = 0.1
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_increase_attack_speed = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.attack_speed] = 0.05
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_increase_damage = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.damage] = 0.04
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_increase_finesse = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.finesse_modifier_bonus] = 0.04
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_increase_power = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.power_level_modifier] = 0.04
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_increase_impact = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.impact_modifier] = 0.04
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_reduced_block_cost = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.block_cost_multiplier] = 0.8
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_increase_damage_elites = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.damage_vs_elites] = 0.1
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_increase_damage_hordes = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.damage_vs_horde] = 0.1
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_increase_damage_specials = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.damage_vs_specials] = 0.1
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_reduce_sprint_cost = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.sprinting_cost_multiplier] = 0.8
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_melee_common_wield_increase_impact_buff = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.melee_impact_modifier] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_melee_common_wield_power_modifier_bonus_buff = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.power_level_modifier] = 0.1
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_melee_common_wield_finesse_modifier_bonus_buff = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.finesse_modifier_bonus] = 0.2
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_melee_common_wield_on_hit_damage_bonus_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 5,
		proc_events = {
			[buff_proc_events.on_hit] = 0.05
		},
		proc_stat_buffs = {
			[buff_stat_buffs.damage] = 0.1
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = CheckProcFunctions.on_melee_hit
	},
	weapon_trait_melee_common_wield_on_hit_power_bonus_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 5,
		proc_events = {
			[buff_proc_events.on_hit] = 0.05
		},
		proc_stat_buffs = {
			[buff_stat_buffs.power_level_modifier] = 0.1
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = CheckProcFunctions.on_melee_hit
	},
	weapon_trait_melee_common_wield_on_hit_impact_bonus_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 5,
		proc_events = {
			[buff_proc_events.on_hit] = 0.05
		},
		proc_stat_buffs = {
			[buff_stat_buffs.melee_impact_modifier] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = CheckProcFunctions.on_melee_hit
	},
	weapon_trait_melee_common_wield_on_hit_increased_unarmored_damage_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 5,
		proc_events = {
			[buff_proc_events.on_hit] = 0.05
		},
		proc_stat_buffs = {
			[buff_stat_buffs.unarmored_damage] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = CheckProcFunctions.on_melee_hit
	},
	weapon_trait_melee_common_wield_on_hit_increased_armored_damage_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 5,
		proc_events = {
			[buff_proc_events.on_hit] = 0.05
		},
		proc_stat_buffs = {
			[buff_stat_buffs.armored_damage] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = CheckProcFunctions.on_melee_hit
	},
	weapon_trait_melee_common_wield_on_hit_increased_resistant_damage_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 5,
		proc_events = {
			[buff_proc_events.on_hit] = 0.05
		},
		proc_stat_buffs = {
			[buff_stat_buffs.resistant_damage] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = CheckProcFunctions.on_melee_hit
	},
	weapon_trait_melee_common_wield_on_hit_increased_berserker_damage_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 5,
		proc_events = {
			[buff_proc_events.on_hit] = 0.05
		},
		proc_stat_buffs = {
			[buff_stat_buffs.berserker_damage] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = CheckProcFunctions.on_melee_hit
	},
	weapon_trait_melee_common_wield_on_hit_increased_super_armor_damage_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 5,
		proc_events = {
			[buff_proc_events.on_hit] = 0.05
		},
		proc_stat_buffs = {
			[buff_stat_buffs.super_armor_damage] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = CheckProcFunctions.on_melee_hit
	},
	weapon_trait_melee_common_wield_on_hit_increased_disgustingly_resilient_damage_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 5,
		proc_events = {
			[buff_proc_events.on_hit] = 0.05
		},
		proc_stat_buffs = {
			[buff_stat_buffs.disgustingly_resilient_damage] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = CheckProcFunctions.on_melee_hit
	},
	weapon_trait_melee_common_wield_on_hit_bleed_buff = {
		class_name = "proc_buff",
		predicted = false,
		proc_events = {
			[buff_proc_events.on_hit] = 0.2
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = CheckProcFunctions.on_melee_hit,
		proc_func = function (params, template_data, template_context)
			local attacked_unit = params.attacked_unit
			local attacked_unit_buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")

			if attacked_unit_buff_extension then
				local bleeding_dot_buff_name = "bleed"
				local t = FixedFrame.get_latest_fixed_time()

				attacked_unit_buff_extension:add_internally_controlled_buff(bleeding_dot_buff_name, t, "owner_unit", template_context.unit)
			end
		end
	},
	weapon_trait_melee_common_wield_on_hit_staggered_power_bonus_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 5,
		proc_events = {
			[buff_proc_events.on_hit] = 0.1
		},
		proc_stat_buffs = {
			[buff_stat_buffs.power_level_modifier] = 0.15
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = CheckProcFunctions.on_meelee_stagger_hit
	},
	weapon_trait_melee_common_wield_on_heavy_attack_grant_power_bonus_buff = {
		class_name = "proc_buff",
		predicted = false,
		proc_events = {
			[buff_proc_events.on_hit] = 0.2
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = CheckProcFunctions.on_heavy_hit,
		proc_func = function (params, template_data, template_context)
			local unit = template_context.unit
			local buff_to_add = "weapon_trait_melee_common_wield_on_heavy_attack_grant_power_bonus_temporary_buff"
			local buff_extension = ScriptUnit.extension(unit, "buff_system")
			local t = FixedFrame.get_latest_fixed_time()

			buff_extension:add_internally_controlled_buff(buff_to_add, t)
		end
	},
	weapon_trait_melee_common_wield_on_heavy_attack_grant_power_bonus_temporary_buff = {
		predicted = false,
		max_stacks = 1,
		class_name = "proc_buff",
		proc_events = {
			[buff_proc_events.on_hit] = 1
		},
		proc_stat_buffs = {
			[buff_stat_buffs.power_level_modifier] = 0.5
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		proc_func = function (params, template_data, template_context)
			template_data.finished = true
		end,
		conditional_exit_func = function (template_data, template_context)
			return template_data.finished
		end
	},
	weapon_trait_melee_common_wield_on_heavy_hit_damage_bonus_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 2.5,
		proc_events = {
			[buff_proc_events.on_hit] = 1
		},
		proc_stat_buffs = {
			[buff_stat_buffs.melee_damage] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = function (params, template_data, template_context)
			local is_heavy_attack = CheckProcFunctions.on_heavy_hit(params)

			return is_heavy_attack
		end
	},
	weapon_trait_melee_common_wield_on_heavy_hit_power_bonus_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 2.5,
		proc_events = {
			[buff_proc_events.on_hit] = 1
		},
		proc_stat_buffs = {
			[buff_stat_buffs.power_level_modifier] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = function (params, template_data, template_context)
			local is_heavy_attack = CheckProcFunctions.on_heavy_hit(params)

			return is_heavy_attack
		end
	},
	weapon_trait_melee_common_wield_on_heavy_hit_impact_bonus_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 2.5,
		proc_events = {
			[buff_proc_events.on_hit] = 1
		},
		proc_stat_buffs = {
			[buff_stat_buffs.melee_impact_modifier] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = function (params, template_data, template_context)
			local is_heavy_attack = CheckProcFunctions.on_heavy_hit(params)

			return is_heavy_attack
		end
	},
	weapon_trait_melee_common_wield_on_heavy_hit_increased_unarmored_damage_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 2.5,
		proc_events = {
			[buff_proc_events.on_hit] = 1
		},
		proc_stat_buffs = {
			[buff_stat_buffs.unarmored_damage] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = function (params, template_data, template_context)
			local is_heavy_attack = CheckProcFunctions.on_heavy_hit(params)

			return is_heavy_attack
		end
	},
	weapon_trait_melee_common_wield_on_heavy_hit_increased_armored_damage_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 2.5,
		proc_events = {
			[buff_proc_events.on_hit] = 1
		},
		proc_stat_buffs = {
			[buff_stat_buffs.armored_damage] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = function (params, template_data, template_context)
			local is_heavy_attack = CheckProcFunctions.on_heavy_hit(params)

			return is_heavy_attack
		end
	},
	weapon_trait_melee_common_wield_on_heavy_hit_increased_resistant_damage_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 2.5,
		proc_events = {
			[buff_proc_events.on_hit] = 1
		},
		proc_stat_buffs = {
			[buff_stat_buffs.resistant_damage] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = function (params, template_data, template_context)
			local is_heavy_attack = CheckProcFunctions.on_heavy_hit(params)

			return is_heavy_attack
		end
	},
	weapon_trait_melee_common_wield_on_heavy_hit_increased_berserker_damage_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 2.5,
		proc_events = {
			[buff_proc_events.on_hit] = 1
		},
		proc_stat_buffs = {
			[buff_stat_buffs.berserker_damage] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = function (params, template_data, template_context)
			local is_heavy_attack = CheckProcFunctions.on_heavy_hit(params)

			return is_heavy_attack
		end
	},
	weapon_trait_melee_common_wield_on_heavy_hit_increased_super_armor_damage_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 2.5,
		proc_events = {
			[buff_proc_events.on_hit] = 1
		},
		proc_stat_buffs = {
			[buff_stat_buffs.super_armor_damage] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = function (params, template_data, template_context)
			local is_heavy_attack = CheckProcFunctions.on_heavy_hit(params)

			return is_heavy_attack
		end
	},
	weapon_trait_melee_common_wield_on_heavy_hit_increased_disgustingly_resilient_damage_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 2.5,
		proc_events = {
			[buff_proc_events.on_hit] = 1
		},
		proc_stat_buffs = {
			[buff_stat_buffs.disgustingly_resilient_damage] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = function (params, template_data, template_context)
			local is_heavy_attack = CheckProcFunctions.on_heavy_hit(params)

			return is_heavy_attack
		end
	},
	weapon_trait_melee_common_wield_power_modifier_bonus_on_full_toughness_buff = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.power_level_modifier] = 0.15
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			return ConditionalFunctions.has_full_toughness(template_data, template_context)
		end
	},
	weapon_trait_melee_common_wield_surpression_immunity_on_full_toughness_buff = {
		predicted = false,
		class_name = "buff",
		conditional_keywords = {
			buff_keywords.suppression_immune
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			return ConditionalFunctions.has_full_toughness(template_data, template_context)
		end
	},
	weapon_trait_melee_common_wield_on_player_toughness_broken_grant_power_level_buff = {
		cooldown_duration = 2.5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 2.5,
		proc_events = {
			[buff_proc_events.on_player_toughness_broken] = 1
		},
		proc_stat_buffs = {
			[buff_stat_buffs.power_level_modifier] = 0.1
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_melee_common_wield_on_successful_dodge_grant_finess_bonus_buff = {
		class_name = "proc_buff",
		predicted = false,
		proc_events = {
			[buff_proc_events.on_successful_dodge] = 1
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		proc_func = function (params, template_data, template_context)
			local unit = template_context.unit
			local buff_to_add = "weapon_trait_melee_common_wield_on_successful_dodge_grant_finess_bonus_temporary_buff"
			local buff_extension = ScriptUnit.extension(unit, "buff_system")
			local t = FixedFrame.get_latest_fixed_time()

			buff_extension:add_internally_controlled_buff(buff_to_add, t)
		end
	},
	weapon_trait_melee_common_wield_on_successful_dodge_grant_finess_bonus_temporary_buff = {
		predicted = false,
		max_stacks = 1,
		class_name = "proc_buff",
		proc_events = {
			[buff_proc_events.on_hit] = 1
		},
		proc_stat_buffs = {
			[buff_stat_buffs.finesse_modifier_bonus] = 0.5
		},
		proc_func = function (params, template_data, template_context)
			template_data.finished = true
		end,
		conditional_exit_func = function (template_data, template_context)
			return template_data.finished
		end
	},
	weapon_trait_melee_common_wield_on_successful_dodge_grant_crit_chance_buff = {
		class_name = "proc_buff",
		predicted = false,
		proc_events = {
			[buff_proc_events.on_successful_dodge] = 1
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		proc_func = function (params, template_data, template_context)
			local unit = template_context.unit
			local buff_to_add = "weapon_trait_melee_common_wield_on_successful_dodge_grant_crit_chance_temporary_buff"
			local buff_extension = ScriptUnit.extension(unit, "buff_system")
			local t = FixedFrame.get_latest_fixed_time()

			buff_extension:add_internally_controlled_buff(buff_to_add, t)
		end
	},
	weapon_trait_melee_common_wield_on_successful_dodge_grant_crit_chance_temporary_buff = {
		predicted = false,
		max_stacks = 1,
		class_name = "proc_buff",
		proc_events = {
			[buff_proc_events.on_hit] = 1
		},
		proc_stat_buffs = {
			[buff_stat_buffs.critical_strike_chance] = 0.5
		},
		proc_func = function (params, template_data, template_context)
			template_data.finished = true
		end,
		conditional_exit_func = function (template_data, template_context)
			return template_data.finished
		end
	},
	weapon_trait_melee_common_wield_on_successful_dodge_grant_bleed_buff = {
		class_name = "proc_buff",
		predicted = false,
		proc_events = {
			[buff_proc_events.on_successful_dodge] = 1
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		proc_func = function (params, template_data, template_context)
			local unit = template_context.unit
			local buff_to_add = "weapon_trait_melee_common_wield_on_successful_dodge_grant_bleed_temporary_buff"
			local buff_extension = ScriptUnit.extension(unit, "buff_system")
			local t = FixedFrame.get_latest_fixed_time()

			buff_extension:add_internally_controlled_buff(buff_to_add, t)
		end
	},
	weapon_trait_melee_common_wield_on_successful_dodge_grant_bleed_temporary_buff = {
		predicted = false,
		max_stacks = 1,
		class_name = "proc_buff",
		proc_events = {
			[buff_proc_events.on_hit] = 1
		},
		proc_func = function (params, template_data, template_context)
			local attacked_unit = params.attacked_unit
			local attacked_unit_buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")

			if attacked_unit_buff_extension then
				local bleeding_dot_buff_name = "bleed"
				local t = FixedFrame.get_latest_fixed_time()

				attacked_unit_buff_extension:add_internally_controlled_buff(bleeding_dot_buff_name, t, "owner_unit", template_context.unit)
			end

			template_data.finished = true
		end,
		conditional_exit_func = function (template_data, template_context)
			return template_data.finished
		end
	},
	weapon_trait_melee_common_wield_low_health_grant_suppression_immunity_buff = {
		predicted = false,
		class_name = "buff",
		conditional_keywords = {
			buff_keywords.suppression_immune
		},
		start_func = function (template_data, template_context)
			local unit = template_context.unit
			template_data.health_extension = ScriptUnit.extension(unit, "health_system")
		end,
		conditional_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			local health_threshold = 0.3
			local health_extension = template_data.health_extension
			local health_percentage = health_extension:current_health_percent()
			local is_below_threshold = health_percentage <= health_threshold

			return is_below_threshold
		end
	},
	weapon_trait_melee_common_wield_low_health_grant_power_modifier_buff = {
		predicted = false,
		class_name = "buff",
		lerped_stat_buffs = {
			[buff_stat_buffs.damage] = {
				max = 0.2,
				min = 0
			}
		},
		start_func = function (template_data, template_context)
			local unit = template_context.unit
			template_data.health_extension = ScriptUnit.extension(unit, "health_system")
		end,
		conditional_lerped_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			local health_threshold = 0.3
			local health_extension = template_data.health_extension
			local health_percentage = health_extension:current_health_percent()
			local is_below_threshold = health_percentage <= health_threshold

			return is_below_threshold
		end
	},
	weapon_trait_melee_common_equip_immunity_on_all_allies_down_buff = {
		predicted = false,
		class_name = "proc_buff",
		active_duration = 5,
		proc_keywords = {
			buff_keywords.damage_immune
		},
		proc_events = {
			[buff_proc_events.on_ally_knocked_down] = 1
		},
		check_proc_func = function (params, template_data, template_context)
			local unit = template_context.unit
			local trigger_unit = params.downed_unit
			local all_knocked_down = true
			local side_system = Managers.state.extension:system("side_system")
			local side = side_system:get_side_from_name("heroes")
			local player_units = side.valid_player_units

			for i = 1, #player_units do
				local player_unit = player_units[i]

				if player_unit ~= unit and player_unit ~= trigger_unit and HEALTH_ALIVE[player_unit] then
					local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
					local character_state_component = unit_data_extension:read_component("character_state")
					local knocked_down = PlayerUnitStatus.is_knocked_down(character_state_component)

					if not knocked_down then
						all_knocked_down = false

						break
					end
				end
			end

			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local character_state_component = unit_data_extension:read_component("character_state")
			local knocked_down = PlayerUnitStatus.is_knocked_down(character_state_component)

			return all_knocked_down and not knocked_down
		end
	},
	weapon_trait_melee_common_wield_push_hit_grants_increased_attack_buff = {
		class_name = "proc_buff",
		predicted = false,
		proc_events = {
			[buff_proc_events.on_push_hit] = 1
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		proc_func = function (params, template_data, template_context)
			local buff_extension = template_context.buff_extension

			if buff_extension then
				local t = FixedFrame.get_latest_fixed_time()
				local buff_name = "weapon_trait_melee_common_wield_push_hit_grants_increased_attack_temporary_buff"

				buff_extension:add_internally_controlled_buff(buff_name, t, "item_slot_name", template_context.item_slot_name)
			end
		end
	},
	weapon_trait_melee_common_wield_push_hit_grants_increased_attack_temporary_buff = {
		unique_buff_id = "weapon_trait_melee_common_wield_grants_increased_attack_buff",
		predicted = false,
		class_name = "proc_buff",
		proc_events = {
			[buff_proc_events.on_hit] = 1
		},
		conditional_stat_buffs = {
			[buff_stat_buffs.melee_damage] = 0.5
		},
		check_proc_func = CheckProcFunctions.on_melee_and_check_item_slot,
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		proc_func = function (params, template_data, template_context)
			if template_data.used then
				return
			end

			template_data.used = true
		end,
		conditional_exit_func = function (template_data, template_context)
			return template_data.used
		end
	},
	weapon_trait_melee_common_wield_on_block_break_grant_power_bonus_buff = {
		cooldown_duration = 3,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 3,
		proc_events = {
			[buff_proc_events.on_block] = 1
		},
		proc_stat_buffs = {
			[buff_stat_buffs.power_level_modifier] = 0.15
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = CheckProcFunctions.on_block_broken
	},
	weapon_trait_melee_common_wield_on_block_damage_bonus_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 5,
		proc_events = {
			[buff_proc_events.on_block] = 0.05
		},
		proc_stat_buffs = {
			[buff_stat_buffs.damage] = 0.1
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = CheckProcFunctions.on_melee_hit
	},
	weapon_trait_melee_common_wield_on_block_power_bonus_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 5,
		proc_events = {
			[buff_proc_events.on_block] = 0.05
		},
		proc_stat_buffs = {
			[buff_stat_buffs.power_level_modifier] = 0.1
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_melee_common_wield_on_block_impact_bonus_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 5,
		proc_events = {
			[buff_proc_events.on_block] = 0.05
		},
		proc_stat_buffs = {
			[buff_stat_buffs.melee_impact_modifier] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_melee_common_wield_on_block_increased_unarmored_damage_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 5,
		proc_events = {
			[buff_proc_events.on_block] = 0.05
		},
		proc_stat_buffs = {
			[buff_stat_buffs.unarmored_damage] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_melee_common_wield_on_block_increased_armored_damage_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 5,
		proc_events = {
			[buff_proc_events.on_block] = 0.05
		},
		proc_stat_buffs = {
			[buff_stat_buffs.armored_damage] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_melee_common_wield_on_block_increased_resistant_damage_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 5,
		proc_events = {
			[buff_proc_events.on_block] = 0.05
		},
		proc_stat_buffs = {
			[buff_stat_buffs.resistant_damage] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_melee_common_wield_on_block_increased_berserker_damage_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 5,
		proc_events = {
			[buff_proc_events.on_block] = 0.05
		},
		proc_stat_buffs = {
			[buff_stat_buffs.berserker_damage] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_melee_common_wield_on_block_increased_super_armor_damage_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 5,
		proc_events = {
			[buff_proc_events.on_block] = 0.05
		},
		proc_stat_buffs = {
			[buff_stat_buffs.super_armor_damage] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_melee_common_wield_on_block_increased_disgustingly_resilient_damage_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 5,
		proc_events = {
			[buff_proc_events.on_block] = 0.05
		},
		proc_stat_buffs = {
			[buff_stat_buffs.disgustingly_resilient_damage] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_melee_common_wield_on_weakspot_grant_power_bonus_buff = {
		class_name = "proc_buff",
		predicted = false,
		proc_events = {
			[buff_proc_events.on_hit] = 0.25
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		proc_func = function (params, template_data, template_context)
			if not CheckProcFunctions.on_weakspot_hit(params) then
				return
			end

			local unit = template_context.unit
			local buff_to_add = "weapon_trait_melee_common_wield_on_weakspot_grant_power_bonus_temporary_buff"
			local buff_extension = ScriptUnit.extension(unit, "buff_system")
			local t = FixedFrame.get_latest_fixed_time()

			buff_extension:add_internally_controlled_buff(buff_to_add, t)
		end
	},
	weapon_trait_melee_common_wield_on_weakspot_grant_power_bonus_temporary_buff = {
		predicted = false,
		max_stacks = 1,
		class_name = "proc_buff",
		proc_events = {
			[buff_proc_events.on_hit] = 1
		},
		proc_stat_buffs = {
			[buff_stat_buffs.power_level_modifier] = 0.5
		},
		proc_func = function (params, template_data, template_context)
			template_data.finished = true
		end,
		conditional_exit_func = function (template_data, template_context)
			return template_data.finished
		end
	},
	weapon_trait_melee_common_wield_on_weakspot_grant_bleeding_buff = {
		cooldown_duration = 6,
		predicted = false,
		class_name = "proc_buff",
		proc_events = {
			[buff_proc_events.on_hit] = 0.2
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		proc_func = function (params, template_data, template_context)
			if not CheckProcFunctions.on_weakspot_hit(params) then
				return
			end

			local unit = template_context.unit
			local buff_to_add = "weapon_trait_melee_common_wield_on_weakspot_grant_bleeding_temporary_buff"
			local buff_extension = ScriptUnit.extension(unit, "buff_system")
			local t = FixedFrame.get_latest_fixed_time()

			buff_extension:add_internally_controlled_buff(buff_to_add, t)
		end
	},
	weapon_trait_melee_common_wield_on_weakspot_grant_bleeding_temporary_buff = {
		predicted = false,
		duration = 3,
		class_name = "proc_buff",
		allow_proc_while_active = true,
		proc_events = {
			[buff_proc_events.on_hit] = 1
		},
		check_proc_func = CheckProcFunctions.on_melee_hit,
		proc_func = function (params, template_data, template_context)
			local attacked_unit = params.attacked_unit
			local attacked_unit_buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")

			if attacked_unit_buff_extension then
				local bleeding_dot_buff_name = "bleed"
				local t = FixedFrame.get_latest_fixed_time()

				attacked_unit_buff_extension:add_internally_controlled_buff(bleeding_dot_buff_name, t, "owner_unit", template_context.unit)
			end
		end
	},
	weapon_trait_melee_common_wield_on_heavy_attack_kill_increase_attack_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 2.5,
		proc_events = {
			[buff_proc_events.on_hit] = 1
		},
		proc_stat_buffs = {
			[buff_stat_buffs.melee_damage] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = function (params, template_data, template_context)
			local is_kill = params.attack_result == attack_results.died
			local is_heavy_attack = CheckProcFunctions.on_heavy_hit(params)

			return is_kill and is_heavy_attack
		end
	},
	weapon_trait_melee_common_wield_on_heavy_attack_kill_increase_attack_speed_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 2.5,
		proc_events = {
			[buff_proc_events.on_hit] = 1
		},
		proc_stat_buffs = {
			[buff_stat_buffs.melee_attack_speed] = 0.1
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = function (params, template_data, template_context)
			local is_kill = params.attack_result == attack_results.died
			local is_heavy_attack = CheckProcFunctions.on_heavy_hit(params)

			return is_kill and is_heavy_attack
		end
	}
}

return templates
