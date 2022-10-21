local Ammo = require("scripts/utilities/ammo")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local BuffTemplate = require("scripts/utilities/buff_template")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local PlayerUnitAction = require("scripts/extension_systems/visual_loadout/utilities/player_unit_action")
local ReloadStates = require("scripts/extension_systems/weapon/utilities/reload_states")
local WarpCharge = require("scripts/utilities/warp_charge")
local attack_results = AttackSettings.attack_results
local attack_types = AttackSettings.attack_types
local damage_types = DamageSettings.damage_types
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_proc_events = BuffSettings.proc_events
local templates = {}
local example_weapon_trait_ranged_buff_stat = {
	class_name = "buff",
	name = "example_weapon_trait_ranged_buff_stat",
	predicted = false,
	conditional_keywords = {
		buff_keywords.knock_down_on_slide
	},
	conditional_stat_buffs = {
		[buff_stat_buffs.weakspot_damage_taken] = function (i)
			return -0.03 * i
		end
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_keywords_func = ConditionalFunctions.is_item_slot_wielded
}

BuffTemplate.generate_weapon_trait_buff_templates(templates, example_weapon_trait_ranged_buff_stat, 3)

local example_weapon_trait_ranged_buff_lerp = {
	name = "example_weapon_trait_ranged_buff_lerp",
	predicted = false,
	class_name = "buff",
	lerped_stat_buffs = {
		[buff_stat_buffs.damage_vs_elites] = function (i)
			local min = 0.05 * i
			local max = 0.2 + 0.05 * i

			return {
				min = min,
				max = max
			}
		end
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.health_extension = ScriptUnit.extension(unit, "health_system")
	end,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_lerped_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local health_extension = template_data.health_extension
		local max_wounds = health_extension:max_wounds()
		local num_wounds = health_extension:num_wounds()
		local lerp_value = (max_wounds - num_wounds) / (max_wounds - 1)

		return lerp_value
	end
}

BuffTemplate.generate_weapon_trait_buff_templates(templates, example_weapon_trait_ranged_buff_lerp, 3)

local example_weapon_trait_ranged_buff_proc = {
	cooldown_duration = 5,
	name = "example_weapon_trait_ranged_buff_proc",
	predicted = false,
	class_name = "proc_buff",
	active_duration = 5,
	proc_events = {
		[buff_proc_events.on_hit] = 1
	},
	proc_stat_buffs = {
		[buff_stat_buffs.damage_vs_elites] = function (i)
			return 0.1 + 0.1 * i
		end
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = function (params, template_data, template_context)
		local is_kill = params.attack_result == attack_results.died
		local is_weakspot = params.hit_weakspot

		return is_kill and is_weakspot
	end
}

BuffTemplate.generate_weapon_trait_buff_templates(templates, example_weapon_trait_ranged_buff_proc, 3)

local example_weapon_trait_ranged_buff_proc_chance = {
	name = "example_weapon_trait_ranged_buff_proc_chance",
	predicted = false,
	class_name = "proc_buff",
	active_duration = 5,
	proc_events = {
		[buff_proc_events.on_hit] = function (i)
			return 0.25 * i
		end
	},
	proc_stat_buffs = {
		[buff_stat_buffs.damage_vs_specials] = 0.25
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_crit
}

BuffTemplate.generate_weapon_trait_buff_templates(templates, example_weapon_trait_ranged_buff_proc_chance, 3)

local example_weapon_trait_ranged_buff_proc_duration = {
	name = "example_weapon_trait_ranged_buff_proc_duration",
	predicted = false,
	class_name = "proc_buff",
	active_duration = function (i)
		return 5 * i
	end,
	proc_events = {
		[buff_proc_events.on_hit] = 1
	},
	proc_stat_buffs = {
		[buff_stat_buffs.damage_vs_specials] = 0.25
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded
}

BuffTemplate.generate_weapon_trait_buff_templates(templates, example_weapon_trait_ranged_buff_proc_duration, 3)

templates.example_weapon_trait_ranged_wield_on_hit_increase_impact_buff = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[buff_proc_events.on_hit] = 1
	},
	check_proc_func = CheckProcFunctions.on_ranged_stagger_hit,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	proc_func = function (params, template_data, template_context)
		local buff_extension = template_context.buff_extension

		if buff_extension then
			local t = FixedFrame.get_latest_fixed_time()

			buff_extension:add_internally_controlled_buff("example_weapon_trait_ranged_wield_on_hit_increase_impact_result_buff", t, "item_slot_name", template_context.item_slot_name)
		end
	end
}
templates.example_weapon_trait_ranged_wield_on_hit_increase_impact_result_buff = {
	unique_buff_id = "weapon_trait_ranged_common_wield_on_hit_guaranteed_instakill_result_buff",
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[buff_proc_events.on_hit] = 1
	},
	conditional_stat_buffs = {
		[buff_stat_buffs.ranged_impact_modifier] = 0.5
	},
	check_proc_func = CheckProcFunctions.on_ranged_and_check_item_slot,
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
}

return templates
