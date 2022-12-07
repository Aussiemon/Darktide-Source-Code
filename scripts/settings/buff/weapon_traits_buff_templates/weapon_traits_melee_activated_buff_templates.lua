local Ammo = require("scripts/utilities/ammo")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local PlayerUnitAction = require("scripts/extension_systems/visual_loadout/utilities/player_unit_action")
local ReloadStates = require("scripts/extension_systems/weapon/utilities/reload_states")
local Toughness = require("scripts/utilities/toughness/toughness")
local WarpCharge = require("scripts/utilities/warp_charge")
local attack_results = AttackSettings.attack_results
local attack_types = AttackSettings.attack_types
local damage_types = DamageSettings.damage_types
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_proc_events = BuffSettings.proc_events
local templates = {
	weapon_trait_melee_activated_wield_during_weapon_special_reduce_damage_taken = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.damage_taken_multiplier] = 0.8
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			return ConditionalFunctions.melee_weapon_special_active(template_data, template_context)
		end
	},
	weapon_trait_melee_activated_wield_during_weapon_special_increased_crit_chance = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.critical_strike_chance] = 0.1
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			return ConditionalFunctions.melee_weapon_special_active(template_data, template_context)
		end
	},
	weapon_trait_melee_activated_wield_during_weapon_special_increased_impact = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.melee_impact_modifier] = 0.5
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			return ConditionalFunctions.melee_weapon_special_active(template_data, template_context)
		end
	},
	weapon_trait_melee_activated_wield_during_weapon_special_increased_attack = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.melee_damage] = 0.2
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			return ConditionalFunctions.melee_weapon_special_active(template_data, template_context)
		end
	},
	weapon_trait_melee_activated_wield_during_weapon_special_increased_movement_speed = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.movement_speed] = 0.15
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			return ConditionalFunctions.melee_weapon_special_active(template_data, template_context)
		end
	},
	weapon_trait_melee_activated_wield_during_weapon_special_reduce_corruption_taken = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.corruption_taken_multiplier] = 0.66
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			return ConditionalFunctions.melee_weapon_special_active(template_data, template_context)
		end
	},
	weapon_trait_melee_activated_wield_during_weapon_special_reduce_toughness_taken = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.toughness_damage_taken_modifier] = 0.66
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			return ConditionalFunctions.melee_weapon_special_active(template_data, template_context)
		end
	},
	weapon_trait_melee_activated_wield_during_weapon_special_finesse_bonus = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.finesse_modifier_bonus] = 0.2
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			return ConditionalFunctions.melee_weapon_special_active(template_data, template_context)
		end
	},
	weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_unarmored = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.unarmored_damage] = 0.4
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			return ConditionalFunctions.melee_weapon_special_active(template_data, template_context)
		end
	},
	weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_armored = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.armored_damage] = 0.4
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			return ConditionalFunctions.melee_weapon_special_active(template_data, template_context)
		end
	},
	weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_resistant = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.resistant_damage] = 0.4
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			return ConditionalFunctions.melee_weapon_special_active(template_data, template_context)
		end
	},
	weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_berserker = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.berserker_damage] = 0.4
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			return ConditionalFunctions.melee_weapon_special_active(template_data, template_context)
		end
	},
	weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_super_armor = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.super_armor_damage] = 0.4
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			return ConditionalFunctions.melee_weapon_special_active(template_data, template_context)
		end
	},
	weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_disgustingly_resilient_damage = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.disgustingly_resilient_damage] = 0.4
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			return ConditionalFunctions.melee_weapon_special_active(template_data, template_context)
		end
	},
	weapon_trait_melee_activated_wield_on_weapon_special_increase_impact_of_next_attack = {
		class_name = "proc_buff",
		predicted = false,
		proc_events = {
			[buff_proc_events.on_weapon_special] = 1
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		proc_func = function (params, template_data, template_context)
			local unit = template_context.unit
			local buff_to_add = "weapon_trait_melee_activated_wield_on_weapon_special_increase_impact_of_next_attack_buff"
			local buff_extension = ScriptUnit.extension(unit, "buff_system")
			local t = FixedFrame.get_latest_fixed_time()

			buff_extension:add_internally_controlled_buff(buff_to_add, t, "item_slot_name", template_context.item_slot_name)
		end
	},
	weapon_trait_melee_activated_wield_on_weapon_special_increase_impact_of_next_attack_buff = {
		unique_buff_id = "weapon_trait_melee_activated_wield_on_weapon_special_increase_impact_of_next_attack_buff",
		predicted = false,
		class_name = "proc_buff",
		proc_events = {
			[buff_proc_events.on_hit] = 1
		},
		stat_buffs = {
			[buff_stat_buffs.melee_impact_modifier] = 0.5
		},
		proc_func = function (params, template_data, template_context)
			template_data.finished = true
		end,
		conditional_exit_func = function (template_data, template_context)
			local special_inactive = not ConditionalFunctions.melee_weapon_special_active(template_data, template_context)

			return template_data.finished or special_inactive
		end
	},
	weapon_trait_melee_activated_wield_on_weapon_special_increase_attack_of_next_attack = {
		class_name = "proc_buff",
		predicted = false,
		proc_events = {
			[buff_proc_events.on_weapon_special] = 1
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		proc_func = function (params, template_data, template_context)
			local unit = template_context.unit
			local buff_to_add = "weapon_trait_melee_activated_wield_on_weapon_special_increase_attack_of_next_attack_buff"
			local buff_extension = ScriptUnit.extension(unit, "buff_system")
			local t = FixedFrame.get_latest_fixed_time()

			buff_extension:add_internally_controlled_buff(buff_to_add, t, "item_slot_name", template_context.item_slot_name)
		end
	},
	weapon_trait_melee_activated_wield_on_weapon_special_increase_attack_of_next_attack_buff = {
		unique_buff_id = "weapon_trait_melee_activated_wield_on_weapon_special_increase_attack_of_next_attack_buff",
		predicted = false,
		class_name = "proc_buff",
		proc_events = {
			[buff_proc_events.on_hit] = 1
		},
		stat_buffs = {
			[buff_stat_buffs.melee_damage] = 0.3
		},
		proc_func = function (params, template_data, template_context)
			template_data.finished = true
		end,
		conditional_exit_func = function (template_data, template_context)
			local special_inactive = not ConditionalFunctions.melee_weapon_special_active(template_data, template_context)

			return template_data.finished or special_inactive
		end
	},
	weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_attack = {
		predicted = false,
		class_name = "proc_buff",
		active_duration = 5,
		proc_events = {
			[buff_proc_events.on_kill] = 0.33
		},
		proc_stat_buffs = {
			[buff_stat_buffs.melee_damage] = 0.3
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = CheckProcFunctions.on_weapon_special_kill
	},
	weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_impact = {
		predicted = false,
		class_name = "proc_buff",
		active_duration = 5,
		proc_events = {
			[buff_proc_events.on_kill] = 0.33
		},
		proc_stat_buffs = {
			[buff_stat_buffs.melee_impact_modifier] = 0.5
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = CheckProcFunctions.on_weapon_special_kill
	},
	weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_reduce_toughness_damage_taken = {
		predicted = false,
		class_name = "proc_buff",
		active_duration = 5,
		proc_events = {
			[buff_proc_events.on_kill] = 0.33
		},
		proc_stat_buffs = {
			[buff_stat_buffs.toughness_damage_taken_modifier] = 0.66
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = CheckProcFunctions.on_weapon_special_kill
	},
	weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_finesse_modifier_bonus = {
		predicted = false,
		class_name = "proc_buff",
		active_duration = 5,
		proc_events = {
			[buff_proc_events.on_kill] = 0.33
		},
		proc_stat_buffs = {
			[buff_stat_buffs.finesse_modifier_bonus] = 0.33
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = CheckProcFunctions.on_weapon_special_kill
	},
	weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_replenish_toughness = {
		class_name = "proc_buff",
		predicted = false,
		proc_events = {
			[buff_proc_events.on_kill] = 0.33
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = CheckProcFunctions.on_weapon_special_kill,
		proc_func = function (params, template_data, template_context)
			local unit = template_context.unit
			local percentage = 0.25

			Toughness.replenish_percentage(unit, percentage)
		end
	},
	weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_remove_corruption = {
		class_name = "proc_buff",
		predicted = false,
		proc_events = {
			[buff_proc_events.on_kill] = 0.33
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = CheckProcFunctions.on_weapon_special_kill,
		proc_func = function (params, template_data, template_context)
			local unit = template_context.unit
			local health_extension = ScriptUnit.extension(unit, "health_system")
			local corruption_value = 25

			health_extension:reduce_permanent_damage(corruption_value)
		end
	}
}

return templates
