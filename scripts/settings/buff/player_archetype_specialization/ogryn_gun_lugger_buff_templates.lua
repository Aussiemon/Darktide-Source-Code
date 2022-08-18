local Ammo = require("scripts/utilities/ammo")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local PlayerUnitAction = require("scripts/extension_systems/visual_loadout/utilities/player_unit_action")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local Toughness = require("scripts/utilities/toughness/toughness")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local Threat = require("scripts/utilities/threat")
local CheckProcFunctionTemplates = require("scripts/settings/buff/check_proc_function_templates")
local ConditionalFunctionTemplates = require("scripts/settings/buff/conditional_function_templates")
local keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local special_rules = SpecialRulesSetting.special_rules
local templates = {
	ogryn_ranged_stance = {
		unique_buff_id = "ogryn_ranged_stance",
		predicted = true,
		unique_buff_priority = 1,
		duration = 5,
		class_name = "buff",
		keywords = {
			keywords.stun_immune,
			keywords.slowdown_immune,
			keywords.ranged_alternate_fire_interrupt_immune,
			keywords.uninterruptible
		},
		stat_buffs = {},
		conditional_stat_buffs = {
			[stat_buffs.ranged_damage_taken_multiplier] = 0.05
		},
		start_func = function (template_data, template_context)
			local unit = template_context.unit
			template_data.specialization_extension = ScriptUnit.extension(unit, "specialization_system")
			local buff_extension = ScriptUnit.extension(unit, "buff_system")
			local coherency_system = Managers.state.extension:system("coherency_system")
			template_data.coherency_system = coherency_system
			local reduced_damage_coherency = special_rules.ogryn_gun_lugger_damage_taken_coherency

			if template_data.specialization_extension:has_special_rule(reduced_damage_coherency) then
				local buff_name = "ogryn_gun_lugger_damage_taken_contact"
				slot7 = coherency_system:add_external_buff(unit, buff_name)
			end

			local reduced_damage_coherency = special_rules.ogryn_gun_lugger_combat_no_movement_penalty

			if template_data.specialization_extension:has_special_rule(reduced_damage_coherency) then
				local buff_name = "ogryn_gun_lugger_no_movement_penalty_buff"
				local t = Managers.time:time("gameplay")

				buff_extension:add_internally_controlled_buff(buff_name, t)
			end

			local increased_suppression_coherency = special_rules.ogryn_gun_lugger_revive_speed_coherency

			if template_data.specialization_extension:has_special_rule(increased_suppression_coherency) then
				local buff_name = "ogryn_gun_lugger_suppression"
				local id = coherency_system:add_external_buff(unit, buff_name)
				template_data.suppression_coherency_buff_id = id
			end

			local unit = template_context.unit
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			template_data.unit_data_extension = unit_data_extension
			template_data.inventory_component = unit_data_extension:read_component("inventory")
			template_data.disabled_character_state_component = unit_data_extension:read_component("disabled_character_state")
			local wielded_slot = template_data.inventory_component.wielded_slot
			local percentage_clip_size = 1
			template_data.max_shots = math.floor(math.max(Ammo.max_slot_clip_amount(unit, wielded_slot) * percentage_clip_size, 2))
			template_data.shot_count = 0
			local ammo_to_refund = template_data.max_shots
			local inventory_component = template_data.inventory_component
			local wielded_slot = inventory_component.wielded_slot
			template_data.inventory_slot_component = template_data.unit_data_extension:write_component(wielded_slot)

			Ammo.add_to_clip(template_data.inventory_slot_component, ammo_to_refund)
		end,
		stop_func = function (template_data, template_context)
			return
		end,
		conditional_stat_buffs_func = function (template_data, template_context)
			local specialization_extension = template_data.specialization_extension
			local lunge_stagger_special_rule = special_rules.ogryn_gun_lugger_combat_reduced_ranged_damage

			return specialization_extension:has_special_rule(lunge_stagger_special_rule)
		end,
		conditional_exit_func = function (template_data, template_context)
			local unit = template_context.unit
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local sprint_character_state_component = unit_data_extension:read_component("sprint_character_state")

			return Sprint.is_sprinting(sprint_character_state_component)
		end,
		player_effects = {
			on_screen_effect = "content/fx/particles/screenspace/screen_ogryn_gunlugger",
			looping_wwise_start_event = "wwise/events/player/play_player_veteran_combat_ability_enter",
			looping_wwise_stop_event = "wwise/events/player/play_player_veteran_combat_ability_exit",
			wwise_state = {
				group = "player_ability",
				on_state = "veteran_combat_ability",
				off_state = "none"
			}
		}
	},
	ogryn_gun_lugger_no_ammo_consumption_passive = {
		predicted = false,
		class_name = "proc_buff",
		proc_events = {
			[proc_events.on_ammo_consumed] = 0.08
		},
		start_func = function (template_data, template_context)
			local unit = template_context.unit
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			template_data.weapon_component = unit_data_extension:read_component("weapon_action")
		end,
		proc_func = function (params, template_data, template_context)
			local unit = template_context.unit
			local buff_to_add = "ogryn_gun_lugger_passive_proc_buff"
			local buff_extension = ScriptUnit.extension(unit, "buff_system")
			local t = Managers.time:time("gameplay")

			buff_extension:add_internally_controlled_buff(buff_to_add, t)
		end,
		conditional_stat_buffs = {
			[stat_buffs.damage_taken_multiplier] = 0.75
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			local weapon_component = template_data.weapon_component
			local braced = PlayerUnitAction.has_current_action_keyword(weapon_component, "braced")

			return braced
		end
	},
	ogryn_gun_lugger_ammo_passive = {
		predicted = false,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.ammo_reserve_capacity] = 0.5
		}
	},
	ogryn_gun_lugger_passive_proc_buff = {
		predicted = false,
		class_name = "proc_buff",
		keywords = {
			keywords.no_ammo_consumption
		},
		conditional_keywords = {
			keywords.guaranteed_ranged_critical_strike
		},
		proc_events = {
			[proc_events.on_ammo_consumed] = 1
		},
		proc_func = function (params, template_data, template_context)
			local specialization_extension = template_data.specialization_extension
			local lunge_stagger_special_rule = special_rules.ogryn_gun_lugger_passive_proc_combat_ability_cooldown_reduction

			if specialization_extension:has_special_rule(lunge_stagger_special_rule) then
				local percentage = 0.2
				local remaining_time = template_data.ability_extension:remaining_ability_cooldown("combat_ability")
				local time_reduction = (remaining_time and remaining_time * percentage) or 0

				if time_reduction > 0 then
					template_data.ability_extension:reduce_ability_cooldown_time("combat_ability", time_reduction)
				end
			end

			template_data.finish = true
		end,
		start_func = function (template_data, template_context)
			local unit = template_context.unit
			template_data.specialization_extension = ScriptUnit.extension(unit, "specialization_system")
			template_data.ability_extension = ScriptUnit.has_extension(unit, "ability_system")
		end,
		conditional_keywords_func = function (template_data, template_context)
			local specialization_extension = template_data.specialization_extension

			return specialization_extension:has_special_rule(special_rules.ogryn_gun_lugger_passive_crit)
		end,
		conditional_exit_func = function (template_data, template_context)
			return template_data.finish
		end
	},
	ogryn_gun_lugger_passive_improved = {
		predicted = false,
		class_name = "proc_buff",
		proc_events = {
			[proc_events.on_ammo_consumed] = 0.12
		},
		start_func = function (template_data, template_context)
			local unit = template_context.unit
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			template_data.unit_data_extension = unit_data_extension
			template_data.inventory_component = unit_data_extension:read_component("inventory")
		end,
		proc_func = function (params, template_data, template_context)
			local ammo_to_refund = params.ammo_usage
			local inventory_component = template_data.inventory_component
			local wielded_slot = inventory_component.wielded_slot
			local inventory_slot_component = template_data.unit_data_extension:write_component(wielded_slot)

			Ammo.add_to_clip(inventory_slot_component, ammo_to_refund)
		end,
		stat_buffs = {
			[stat_buffs.ammo_reserve_capacity] = 0.5
		},
		conditional_stat_buffs = {
			[stat_buffs.damage_taken_multiplier] = 0.75
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			local unit = template_context.unit
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local weapon_component = unit_data_extension:read_component("weapon_action")
			local braced = PlayerUnitAction.has_current_action_keyword(weapon_component, "braced")

			return braced
		end
	},
	ogryn_gun_lugger_vs_suppression_aura = {
		predicted = false,
		coherency_priority = 2,
		coherency_id = "ogryn_gun_lugger_coherency_aura",
		max_stacks = 1,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.damage_vs_suppressed] = 0.2
		}
	},
	ogryn_gun_lugger_vs_suppression_aura_improved = {
		predicted = false,
		coherency_priority = 1,
		coherency_id = "ogryn_gun_lugger_coherency_aura",
		max_stacks = 1,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.damage_vs_suppressed] = 0.3
		}
	},
	ogryn_gun_reduced_ranged_damage_aura = {
		predicted = false,
		coherency_priority = 1,
		coherency_id = "gun_lugger_reduced_ranged_damage_aura",
		max_stacks = 1,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.ranged_damage_taken_multiplier] = 0.85
		}
	},
	ogryn_gun_lugger_increased_damage_vs_hordes = {
		predicted = false,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.damage_vs_horde] = 0.1
		}
	},
	ogryn_gun_lugger_toughness_on_ranged_kill = {
		predicted = false,
		class_name = "proc_buff",
		proc_events = {
			[proc_events.on_hit] = 1
		},
		start_func = function (template_data, template_context)
			local unit = template_context.unit
			local toughness_extension = ScriptUnit.extension(unit, "toughness_system")
			template_data.toughness_extension = toughness_extension
		end,
		check_proc_func = CheckProcFunctionTemplates.on_ranged_kill,
		proc_func = function (params, template_data, template_context)
			local toughness_extension = template_data.toughness_extension
			local ignore_stat_buffs = true
			local fixed_percentage = 0.02

			toughness_extension:recover_percentage_toughness(fixed_percentage, ignore_stat_buffs)
		end
	},
	ogryn_gun_lugger_clip_size = {
		predicted = false,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.clip_size_modifier] = 0.5
		}
	},
	ogryn_gun_lugger_increased_damage_to_close_enemies = {
		predicted = false,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.damage_near] = 0.2
		}
	},
	ogryn_gun_lugger_crit_on_kills = {
		class_name = "proc_buff",
		predicted = false,
		proc_events = {
			[proc_events.on_hit] = 1
		},
		check_proc_func = CheckProcFunctionTemplates.on_melee_kill,
		proc_func = function (params, template_data, template_context)
			local unit = template_context.unit
			local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

			if buff_extension then
				local t = Managers.time:time("gameplay")

				buff_extension:add_internally_controlled_buff("ogryn_gun_lugger_crit_on_kill_buff", t)
			end
		end,
		check_proc_func = CheckProcFunctionTemplates.on_kill
	},
	ogryn_gun_lugger_crit_on_kill_buff = {
		predicted = false,
		max_stacks_cap = 15,
		refresh_duration_on_stack = true,
		max_stacks = 15,
		duration = 5,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.critical_strike_chance] = 0.01
		}
	},
	ogryn_gun_lugger_increased_suppression = {
		predicted = false,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.increased_suppression] = 0.25
		}
	},
	ogryn_gun_lugger_buff_on_suppressing_enemies = {
		predicted = false,
		class_name = "proc_buff",
		proc_events = {
			[proc_events.on_suppress] = 1
		},
		start_func = function (template_data, template_context)
			template_data.suppressed_units = {}
			template_data.num_suppressed_units = 0
			template_data.num_required_suppresses = 5
			template_data.suppress_duration = 5
			template_data.last_buff_application_t = 0
		end,
		update_func = function (template_data, template_context)
			local num_suppressed_units = template_data.num_suppressed_units

			if num_suppressed_units > 0 then
				local t = Managers.time:time("gameplay")
				local suppressed_units = template_data.suppressed_units

				for unit, unit_t in pairs(suppressed_units) do
					if unit_t < t then
						template_data.num_suppressed_units = template_data.num_suppressed_units - 1
						suppressed_units[unit] = nil
					end
				end
			end
		end,
		proc_func = function (params, template_data, template_context)
			local t = Managers.time:time("gameplay")

			if template_data.last_buff_application_t == t then
				return
			end

			local unit = params.suppressed_unit
			local suppressed_units = template_data.suppressed_units
			local num_suppressed_units = template_data.num_suppressed_units

			if not suppressed_units[unit] then
				num_suppressed_units = num_suppressed_units + 1
				template_data.num_suppressed_units = num_suppressed_units
			end

			if template_data.num_required_suppresses <= num_suppressed_units then
				local player_unit = template_context.unit
				local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
				local suppressed_debuff = "ogryn_gun_lugger_suppressing_bonus_buff"
				template_data.last_buff_application_t = t

				buff_extension:add_internally_controlled_buff(suppressed_debuff, t)
			end

			suppressed_units[unit] = t + template_data.suppress_duration
		end
	},
	ogryn_gun_lugger_suppressing_bonus_buff = {
		predicted = false,
		refresh_duration_on_stack = true,
		max_stacks = 1,
		duration = 5,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.damage] = 0.15,
			[stat_buffs.reload_speed] = 0.25
		}
	},
	ogryn_gun_lugger_reload_speed_on_final_shot = {
		predicted = false,
		class_name = "proc_buff",
		proc_events = {
			[proc_events.on_ammo_consumed] = 1
		},
		proc_func = function (params, template_data, template_context)
			local unit = template_context.unit
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local inventory_slot_component = unit_data_extension:write_component("slot_secondary")
			local max_ammo_in_clip = inventory_slot_component.max_ammunition_clip
			local current_ammo_in_clip = inventory_slot_component.current_ammunition_clip

			if current_ammo_in_clip <= 0 then
				local unit = template_context.unit
				local buff_to_add = "ogryn_gun_lugger_reload_speed_buff"
				local buff_extension = ScriptUnit.extension(unit, "buff_system")
				local t = Managers.time:time("gameplay")

				buff_extension:add_internally_controlled_buff(buff_to_add, t)
			end
		end
	},
	ogryn_gun_lugger_reload_speed_buff = {
		predicted = false,
		refresh_duration_on_stack = true,
		max_stacks = 1,
		duration = 3,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.reload_speed] = 0.25
		}
	},
	ogryn_gun_lugger_movement_speed_on_ranged_kill = {
		predicted = true,
		class_name = "proc_buff",
		active_duration = 5,
		proc_events = {
			[proc_events.on_hit] = 1
		},
		proc_stat_buffs = {
			[stat_buffs.movement_speed] = 1.2
		},
		check_proc_func = CheckProcFunctionTemplates.on_ranged_kill
	},
	ogryn_gun_lugger_suppressing_taunts_ranged_enemies = {
		predicted = false,
		class_name = "proc_buff",
		proc_events = {
			[proc_events.on_suppress] = 1
		},
		start_func = function (template_data, template_context)
			template_data.suppressed_units = {}
		end,
		proc_func = function (params, template_data, template_context)
			local unit = params.suppressed_unit
			local suppressed_units = template_data.suppressed_units

			if suppressed_units[unit] then
				return
			end

			local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

			if buff_extension then
				local suppressed_debuff = "ogryn_gun_lugger_suppressed_minion_debuff"
				local t = Managers.time:time("gameplay")

				buff_extension:add_internally_controlled_buff(suppressed_debuff, t)

				suppressed_units[unit] = true
				local ogryn_unit = template_context.unit

				Threat.add_flat_threat(unit, ogryn_unit, 500)
				Threat.set_threat_decay_enabled(unit, false)
			end
		end
	},
	ogryn_gun_lugger_suppressed_minion_debuff = {
		predicted = false,
		max_stacks = 1,
		duration = 15,
		class_name = "buff",
		stop_func = function (template_data, template_context)
			local unit = template_context.unit

			Threat.set_threat_decay_enabled(unit, true)
		end,
		stat_buffs = {}
	},
	ogryn_gun_lugger_increased_movement_on_braced_shooting = {
		predicted = true,
		class_name = "buff",
		conditional_stat_buffs = {
			[stat_buffs.movement_speed] = 2.5
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			local unit = template_context.unit
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local weapon_component = unit_data_extension:read_component("weapon_action")
			local braced_shooting = PlayerUnitAction.has_current_action_keyword(weapon_component, "braced_shooting")

			return braced_shooting
		end
	},
	ogryn_gun_lugger_regen_toughness_on_braced = {
		class_name = "buff",
		update_func = function (template_data, template_context)
			if not template_context.is_server then
				return
			end

			local unit = template_context.unit
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local weapon_component = unit_data_extension:read_component("weapon_action")
			local braced = PlayerUnitAction.has_current_action_keyword(weapon_component, "braced")

			if braced then
				Toughness.replenish(unit, "ogryn_braced_regen")
			end
		end
	},
	ogryn_gun_lugger_damage_taken_contact = {
		predicted = false,
		duration = 3,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.ranged_damage_taken_multiplier] = 0.25
		}
	},
	ogryn_gun_lugger_no_movement_penalty_buff = {
		predicted = false,
		duration = 6,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = 0,
			[stat_buffs.weapon_action_movespeed_reduction_multiplier] = 0,
			[stat_buffs.damage_near] = 0.25
		}
	},
	ogryn_gun_lugger_suppression = {
		predicted = false,
		duration = 6,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.revive_speed_modifier] = 0.6
		}
	}
}

return templates
