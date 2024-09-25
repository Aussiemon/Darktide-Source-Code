-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_trait_buff_templates.lua

local Ammo = require("scripts/utilities/ammo")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local PlayerUnitAction = require("scripts/extension_systems/visual_loadout/utilities/player_unit_action")
local ReloadStates = require("scripts/extension_systems/weapon/utilities/reload_states")
local WarpCharge = require("scripts/utilities/warp_charge")
local attack_results = AttackSettings.attack_results
local damage_types = DamageSettings.damage_types
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_proc_events = BuffSettings.proc_events
local templates = {}

table.make_unique(templates)

templates.weapon_trait_ranged_first_shot_damage_increase = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[buff_stat_buffs.ranged_weakspot_damage] = 1,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return
		end

		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")
		local inventory_component = unit_data_extension:read_component("inventory")
		local wielded_slot_name = inventory_component.wielded_slot
		local inventory_slot_component = unit_data_extension:write_component(wielded_slot_name)
		local current_ammunition_clip = inventory_slot_component.current_ammunition_clip
		local max_ammo_in_clip = inventory_slot_component.max_ammunition_clip

		if current_ammunition_clip == max_ammo_in_clip then
			return true
		end

		return false
	end,
}
templates.weapon_trait_ranged_crit_chance_on_max_ammo = {
	class_name = "buff",
	predicted = true,
	lerped_stat_buffs = {
		[buff_stat_buffs.critical_strike_chance] = {
			max = 0.75,
			min = 0,
		},
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local unit_data_extension = template_data.unit_data_extension
		local inventory_component = unit_data_extension:read_component("inventory")
		local wielded_slot_name = inventory_component.wielded_slot
		local inventory_slot_component = unit_data_extension:write_component(wielded_slot_name)
		local current_ammunition_clip = inventory_slot_component.current_ammunition_clip
		local max_ammo_in_clip = inventory_slot_component.max_ammunition_clip
		local ammo_min = inventory_slot_component.max_ammunition_clip * 0.9
		local lerp = math.ilerp(ammo_min, max_ammo_in_clip, current_ammunition_clip)

		return lerp
	end,
}
templates.weapon_trait_ranged_reload_speed_on_kill = {
	active_duration = 5,
	class_name = "proc_buff",
	predicted = true,
	proc_events = {
		[buff_proc_events.on_kill] = 1,
	},
	proc_stat_buffs = {
		[buff_stat_buffs.reload_speed] = 0.5,
	},
	check_proc_func = CheckProcFunctions.on_weakspot_kill,
}
templates.weapon_trait_ranged_movement_speed_on_kill = {
	active_duration = 5,
	class_name = "proc_buff",
	predicted = true,
	proc_events = {
		[buff_proc_events.on_kill] = 1,
	},
	proc_stat_buffs = {
		[buff_stat_buffs.movement_speed] = 0.25,
	},
	check_proc_func = CheckProcFunctions.on_kill,
}
templates.weapon_trait_melee_attack_speed_on_sticky_kill = {
	active_duration = 3,
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = true,
	proc_events = {
		[buff_proc_events.on_kill] = 1,
	},
	proc_stat_buffs = {
		[buff_stat_buffs.attack_speed] = 0.25,
	},
	check_proc_func = CheckProcFunctions.on_sticky_kill,
}
templates.weapon_trait_melee_attack_speed_on_special_smite_kill = {
	active_duration = 5,
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = true,
	proc_events = {
		[buff_proc_events.on_kill] = 1,
	},
	proc_stat_buffs = {
		[buff_stat_buffs.attack_speed] = 0.2,
	},
	check_proc_func = CheckProcFunctions.on_special_smite_kill,
}
templates.weapon_trait_bash_refunds_warpcharge = {
	class_name = "proc_buff",
	predicted = true,
	proc_events = {
		[buff_proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.unit_data_extension = unit_data_extension
	end,
	proc_func = function (params, template_data, template_context)
		local damage_type = params.damage_type

		if not damage_type or damage_type ~= damage_types.bash then
			return
		end

		local remove_percentage_to_remove = 0.05
		local warp_charge_component = template_data.unit_data_extension:write_component("warp_charge")

		WarpCharge.decrease_immediate(remove_percentage_to_remove, warp_charge_component, template_context.unit)
	end,
}
templates.weapon_trait_nonlethal_bops_increase_damage_of_next = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[buff_proc_events.on_hit] = 1,
	},
	conditional_stat_buffs = {
		[buff_stat_buffs.force_staff_single_target_damage] = 0.2,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.active
	end,
	proc_func = function (params, template_data, template_context)
		local damage_type = params.damage_type

		if not damage_type or damage_type ~= damage_types.force_staff_single_target then
			return
		end

		local kill = params.attack_result == attack_results.died

		if kill then
			template_data.active = false

			return
		end

		template_data.active = true
	end,
}
templates.weapon_trait_burn_on_push = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[buff_proc_events.on_push_hit] = 1,
	},
	proc_func = function (params, template_data, template_context)
		local is_server = template_context.is_server

		if not is_server then
			return
		end

		local t = FixedFrame.get_latest_fixed_time()
		local pushing_unit = params.pushing_unit
		local pushed_unit = params.pushed_unit
		local weapon_extension = ScriptUnit.extension(pushing_unit, "weapon_system")
		local burninating_template = weapon_extension:burninating_template()
		local max_stacks = burninating_template and burninating_template.max_stacks
		local buff_extension = ScriptUnit.has_extension(pushed_unit, "buff_system")

		if buff_extension then
			local dot_buff_name = "flamer_assault"
			local start_time_with_offset = t + math.random() * 0.5

			if max_stacks then
				local current_stacks = buff_extension:current_stacks(dot_buff_name)

				if current_stacks < max_stacks then
					buff_extension:add_internally_controlled_buff(dot_buff_name, start_time_with_offset, "owner_unit", template_context.unit)
				elseif current_stacks == max_stacks then
					buff_extension:refresh_duration_of_stacking_buff(dot_buff_name, start_time_with_offset)
				end
			else
				buff_extension:add_internally_controlled_buff(dot_buff_name, start_time_with_offset, "owner_unit", template_context.unit)
			end
		end
	end,
}
templates.weapon_trait_toughness_regen_near_burning_enemies = {
	burning_enemies_for_max_effect = 15,
	class_name = "buff",
	predicted = false,
	lerped_stat_buffs = {
		[buff_stat_buffs.elusiveness_modifier] = {
			max = 2.5,
			min = 1,
		},
	},
	start_func = function (template_data, template_context)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase
		template_data.broadphase_results = {}

		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")

		template_data.enemy_side_names = enemy_side_names
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local player_unit = template_context.unit
		local player_position = POSITION_LOOKUP[player_unit]
		local broadphase = template_data.broadphase
		local enemy_side_names = template_data.enemy_side_names
		local broadphase_results = template_data.broadphase_results

		table.clear(broadphase_results)

		local num_hits = broadphase.query(broadphase, player_position, 10, broadphase_results, enemy_side_names)
		local num_burning = 0

		for i = 1, num_hits do
			local enemy_unit = broadphase_results[i]
			local buff_extension = ScriptUnit.has_extension(enemy_unit, "buff_system")

			if buff_extension and buff_extension:has_keyword(buff_keywords.burning) then
				num_burning = num_burning + 1
			end
		end

		local template = template_context.template
		local burning_enemies_for_max_effect = template.burning_enemies_for_max_effect
		local lerp = math.min(num_burning / burning_enemies_for_max_effect, 1)

		return lerp
	end,
}
templates.weapon_trait_melee_critical_strike_chance_on_weapon_special = {
	active_duration = 3,
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = true,
	proc_events = {
		[buff_proc_events.on_weapon_special_activate] = 1,
	},
	proc_stat_buffs = {
		[buff_stat_buffs.critical_strike_chance] = 1,
	},
}
templates.weapon_trait_guaranteed_critical_strike_after_non_fatal_weapon_special = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = true,
	proc_events = {
		[buff_proc_events.on_hit] = 1,
	},
	conditional_stat_buffs = {
		[buff_stat_buffs.critical_strike_chance] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.active = false
	end,
	proc_func = function (params, template_data, template_context)
		local weapon_special = params.weapon_special
		local attack_result = params.attack_result
		local died = attack_result == "died"

		if weapon_special and not died then
			template_data.active = true
		elseif attack_result then
			template_data.active = false
		end
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.active
	end,
}
templates.weapon_trait_guaranteed_crit_after_parry = {
	active_duration = 2,
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = true,
	proc_events = {
		[buff_proc_events.on_block] = 1,
	},
	conditional_stat_buffs = {
		[buff_stat_buffs.critical_strike_chance] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.active = false
	end,
	proc_func = function (params, template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local weapon_action_component = unit_data_extension:read_component("weapon_action")
		local weapon_special = PlayerUnitAction.has_current_action_keyword(weapon_action_component, "weapon_special")

		if weapon_special then
			template_data.active = true
		end
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.active
	end,
}
templates.weapon_trait_melee_damage_reduction_on_critical_strike = {
	active_duration = 10,
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[buff_proc_events.on_hit] = 1,
	},
	proc_stat_buffs = {
		[buff_stat_buffs.damage_taken_multiplier] = -0.2,
	},
	check_proc_func = CheckProcFunctions.on_crit,
}
templates.weapon_trait_attack_speed_on_critical_strike = {
	active_duration = 3,
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = true,
	proc_events = {
		[buff_proc_events.on_hit] = 1,
	},
	proc_stat_buffs = {
		[buff_stat_buffs.attack_speed] = 0.2,
	},
	check_proc_func = CheckProcFunctions.on_crit,
}
templates.weapon_trait_melee_weapon_special_max_activations = {
	class_name = "buff",
	predicted = true,
	stat_buffs = {
		[buff_stat_buffs.weapon_special_max_activations] = 1,
	},
}
templates.weapon_trait_reload_unwielded_weapons = {
	active_duration = 1,
	class_name = "timed_trigger_buff",
	trigger_function = function (data, context)
		local unit = context.unit
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local inventory_component = unit_data_extension:read_component("inventory")
		local wielded_slot = inventory_component.wielded_slot
		local slot_configuration = visual_loadout_extension:slot_configuration()

		for slot_name, config in pairs(slot_configuration) do
			local is_wielded_slot = slot_name == wielded_slot

			if config.slot_type == "weapon" and not is_wielded_slot then
				local inventory_slot_component = unit_data_extension:write_component(slot_name)
				local max_ammunition_clip = inventory_slot_component.max_ammunition_clip

				Ammo.transfer_from_reserve_to_clip(inventory_slot_component, max_ammunition_clip)

				if ReloadStates.uses_reload_states(inventory_slot_component) then
					local weapon_template = visual_loadout_extension:weapon_template_from_slot(slot_name)
					local reload_template = weapon_template.reload_template

					ReloadStates.reset(reload_template, inventory_slot_component)
				end
			end
		end
	end,
}
templates.weapon_trait_reload_speed_on_quad_sweep = {
	class_name = "proc_buff",
	predicted = true,
	proc_events = {
		[buff_proc_events.on_sweep_finish] = 1,
		[buff_proc_events.on_reload] = 1,
	},
	conditional_stat_buffs = {
		[buff_stat_buffs.reload_speed] = 0.5,
	},
	start_func = function (template_data, template_context)
		template_data.internal_stacks = 0
		template_data.max_stacks = 3
	end,
	specific_proc_func = {
		on_sweep = function (params, template_data, template_context)
			if params.num_hit_units >= 4 then
				template_data.internal_stacks = template_data.max_stacks
			end
		end,
		on_reload = function (params, template_data, template_context)
			template_data.internal_stacks = template_data.internal_stacks - 1
		end,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.internal_stacks > 0
	end,
}
templates.weapon_trait_increased_stagger_on_hip_fire = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.opt_in_stagger_duration_multiplier] = 2,
	},
}
templates.weapon_trait_uninterruptable_on_big_sweep = {
	active_duration = 4,
	class_name = "proc_buff",
	predicted = true,
	proc_events = {
		[buff_proc_events.on_sweep_finish] = 1,
	},
	proc_keywords = {
		buff_keywords.uninterruptible,
	},
	check_proc_func = function (params, template_data, template_context)
		return params.num_hit_units >= 4
	end,
}

return templates
