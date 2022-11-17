local Ammo = require("scripts/utilities/ammo")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local BuffUtils = require("scripts/settings/buff/buff_utils")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local Health = require("scripts/utilities/health")
local PlayerUnitAction = require("scripts/extension_systems/visual_loadout/utilities/player_unit_action")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local ReloadStates = require("scripts/extension_systems/weapon/utilities/reload_states")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local Toughness = require("scripts/utilities/toughness/toughness")
local ToughnessSettings = require("scripts/settings/toughness/toughness_settings")
local WarpCharge = require("scripts/utilities/warp_charge")
local attack_results = AttackSettings.attack_results
local attack_types = AttackSettings.attack_types
local damage_types = DamageSettings.damage_types
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_proc_events = BuffSettings.proc_events
local replenish_types = ToughnessSettings.replenish_types
local templates = {
	weapon_trait_ranged_aimed_wield_on_weakspot_hit_increase_damage_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 3,
		proc_events = {
			[buff_proc_events.on_hit] = 0.05
		},
		proc_stat_buffs = {
			[buff_stat_buffs.damage] = 0.1
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = function (params, template_data, template_context)
			return ConditionalFunctions.is_alternative_fire(template_data, template_context) and CheckProcFunctions.on_weakspot_hit(params)
		end
	},
	weapon_trait_ranged_aimed_wield_on_weakspot_hit_increase_impact_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 3,
		proc_events = {
			[buff_proc_events.on_hit] = 0.05
		},
		proc_stat_buffs = {
			[buff_stat_buffs.ranged_impact_modifier] = 0.1
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = function (params, template_data, template_context)
			return ConditionalFunctions.is_alternative_fire(template_data, template_context) and CheckProcFunctions.on_weakspot_hit(params)
		end
	},
	weapon_trait_ranged_aimed_wield_on_weakspot_hit_apply_bleeding_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		proc_events = {
			[buff_proc_events.on_hit] = 1
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = function (params, template_data, template_context)
			return ConditionalFunctions.is_alternative_fire(template_data, template_context) and CheckProcFunctions.on_weakspot_hit(params)
		end,
		proc_func = function (params, template_data, template_context)
			local unit = template_context.unit
			local buff_to_add = "weapon_trait_ranged_aimed_wield_on_weakspot_hit_apply_bleeding_temporary_buff"
			local buff_extension = ScriptUnit.extension(unit, "buff_system")
			local t = FixedFrame.get_latest_fixed_time()

			buff_extension:add_internally_controlled_buff(buff_to_add, t)
		end
	},
	weapon_trait_ranged_aimed_wield_on_weakspot_hit_apply_bleeding_temporary_buff = {
		predicted = false,
		duration = 3,
		class_name = "proc_buff",
		allow_proc_while_active = true,
		proc_events = {
			[buff_proc_events.on_hit] = 1
		},
		check_proc_func = CheckProcFunctions.on_alternative_fire_hit,
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
	weapon_trait_ranged_aimed_wield_on_weakspot_kill_restore_toughness_buff = {
		class_name = "proc_buff",
		predicted = false,
		proc_events = {
			[buff_proc_events.on_hit] = 1
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = function (params, template_data, template_context)
			return ConditionalFunctions.is_alternative_fire(template_data, template_context) and CheckProcFunctions.on_weakspot_kill(params)
		end,
		proc_func = function (params, template_data, template_context)
			local player_unit = template_context.unit
			local toughness_percentage = 0.05

			Toughness.replenish_percentage(player_unit, toughness_percentage)
		end
	},
	weapon_trait_ranged_aimed_wield_on_weakspot_kill_heal_corruption_buff = {
		predicted = false,
		class_name = "proc_buff",
		proc_events = {
			[buff_proc_events.on_hit] = 1
		},
		start_func = function (template_data, template_context)
			local unit = template_context.unit
			local health_extension = ScriptUnit.extension(unit, "health_system")
			template_data.health_extension = health_extension
		end,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = function (params, template_data, template_context)
			return ConditionalFunctions.is_alternative_fire(template_data, template_context) and CheckProcFunctions.on_weakspot_kill(params)
		end,
		proc_func = function (params, template_data, template_context)
			local health_extension = template_data.health_extension
			local corruption_value = 20

			health_extension:reduce_permanent_damage(corruption_value)
		end
	},
	weapon_trait_ranged_aimed_wield_while_aiming_increased_attack_buff = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.damage] = 0.1
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			if not ConditionalFunctions.is_alternative_fire(template_data, template_context) then
				return
			end

			return true
		end
	},
	weapon_trait_ranged_aimed_wield_while_aiming_increased_impact_buff = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.ranged_impact_modifier] = 0.1
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			if not ConditionalFunctions.is_alternative_fire(template_data, template_context) then
				return
			end

			return true
		end
	},
	weapon_trait_ranged_aimed_wield_while_aiming_finesse_bonus_buff = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.finesse_modifier_bonus] = 0.1
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			if not ConditionalFunctions.is_alternative_fire(template_data, template_context) then
				return
			end

			return true
		end
	},
	weapon_trait_ranged_aimed_wield_while_aiming_increased_crit_chance_buff = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.critical_strike_chance] = 0.1
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			if not ConditionalFunctions.is_alternative_fire(template_data, template_context) then
				return
			end

			return true
		end
	},
	weapon_trait_ranged_aimed_wield_while_aiming_increased_unarmored_damage_buff = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.unarmored_damage] = 0.1
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			if not ConditionalFunctions.is_alternative_fire(template_data, template_context) then
				return
			end

			return true
		end
	},
	weapon_trait_ranged_aimed_wield_while_aiming_increased_armored_damage_buff = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.armored_damage] = 0.1
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			if not ConditionalFunctions.is_alternative_fire(template_data, template_context) then
				return
			end

			return true
		end
	},
	weapon_trait_ranged_aimed_wield_while_aiming_increased_resistant_damage_buff = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.resistant_damage] = 0.1
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			if not ConditionalFunctions.is_alternative_fire(template_data, template_context) then
				return
			end

			return true
		end
	},
	weapon_trait_ranged_aimed_wield_while_aiming_increased_berserker_damage_buff = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.berserker_damage] = 0.1
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			if not ConditionalFunctions.is_alternative_fire(template_data, template_context) then
				return
			end

			return true
		end
	},
	weapon_trait_ranged_aimed_wield_while_aiming_increased_super_armor_damage_buff = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.super_armor_damage] = 0.1
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			if not ConditionalFunctions.is_alternative_fire(template_data, template_context) then
				return
			end

			return true
		end
	},
	weapon_trait_ranged_aimed_wield_while_aiming_increased_disgustingly_resilient_damage_buff = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.disgustingly_resilient_damage] = 0.1
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			if not ConditionalFunctions.is_alternative_fire(template_data, template_context) then
				return
			end

			return true
		end
	},
	weapon_trait_ranged_aimed_wield_on_enter_ads_increase_damage_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 3,
		proc_events = {
			[buff_proc_events.on_alternative_fire_start] = 1
		},
		proc_stat_buffs = {
			[buff_stat_buffs.damage] = 0.1
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_ranged_aimed_wield_on_enter_ads_increase_impact_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 3,
		proc_events = {
			[buff_proc_events.on_alternative_fire_start] = 1
		},
		proc_stat_buffs = {
			[buff_stat_buffs.ranged_impact_modifier] = 0.1
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_ranged_aimed_wield_on_enter_ads_apply_bleeding_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		proc_events = {
			[buff_proc_events.on_alternative_fire_start] = 0.05
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		proc_func = function (params, template_data, template_context)
			local unit = template_context.unit
			local buff_to_add = "weapon_trait_ranged_aimed_wield_on_enter_ads_apply_bleeding_temporary_buff"
			local buff_extension = ScriptUnit.extension(unit, "buff_system")
			local t = FixedFrame.get_latest_fixed_time()

			buff_extension:add_internally_controlled_buff(buff_to_add, t)
		end
	},
	weapon_trait_ranged_aimed_wield_on_enter_ads_apply_bleeding_temporary_buff = {
		predicted = false,
		duration = 3,
		class_name = "proc_buff",
		allow_proc_while_active = true,
		proc_events = {
			[buff_proc_events.on_hit] = 1
		},
		check_proc_func = CheckProcFunctions.on_alternative_fire_hit,
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
	weapon_trait_ranged_aimed_wield_on_enter_ads_finesse_bonus_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 3,
		proc_events = {
			[buff_proc_events.on_alternative_fire_start] = 1
		},
		proc_stat_buffs = {
			[buff_stat_buffs.finesse_modifier_bonus] = 0.1
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_ranged_aimed_wield_on_enter_ads_increased_unarmored_damage_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 3,
		proc_events = {
			[buff_proc_events.on_alternative_fire_start] = 1
		},
		proc_stat_buffs = {
			[buff_stat_buffs.unarmored_damage] = 0.1
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_ranged_aimed_wield_on_enter_ads_increased_armored_damage_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 3,
		proc_events = {
			[buff_proc_events.on_alternative_fire_start] = 1
		},
		proc_stat_buffs = {
			[buff_stat_buffs.armored_damage] = 0.1
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_ranged_aimed_wield_on_enter_ads_increased_resistant_damage_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 3,
		proc_events = {
			[buff_proc_events.on_alternative_fire_start] = 1
		},
		proc_stat_buffs = {
			[buff_stat_buffs.resistant_damage] = 0.1
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_ranged_aimed_wield_on_enter_ads_increased_berserker_damage_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 3,
		proc_events = {
			[buff_proc_events.on_alternative_fire_start] = 1
		},
		proc_stat_buffs = {
			[buff_stat_buffs.berserker_damage] = 0.1
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_ranged_aimed_wield_on_enter_ads_increased_super_armor_damage_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 3,
		proc_events = {
			[buff_proc_events.on_alternative_fire_start] = 1
		},
		proc_stat_buffs = {
			[buff_stat_buffs.super_armor_damage] = 0.1
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_ranged_aimed_wield_on_enter_ads_increased_disgustingly_resilient_damage_buff = {
		cooldown_duration = 5,
		predicted = false,
		class_name = "proc_buff",
		active_duration = 3,
		proc_events = {
			[buff_proc_events.on_alternative_fire_start] = 1
		},
		proc_stat_buffs = {
			[buff_stat_buffs.disgustingly_resilient_damage] = 0.1
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded
	}
}

return templates
