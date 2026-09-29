-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_ogryn_hammer_2h_p1_buff_templates.lua

local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local SharedBuffFunctions = require("scripts/settings/buff/helper_functions/shared_buff_functions")
local keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_ogryn_hammer_2h_p1_stacking_increase_impact_on_hit_parent = table.clone(BaseWeaponTraitBuffTemplates.stacking_increase_impact_on_hit_parent)
templates.weapon_trait_bespoke_ogryn_hammer_2h_p1_stacking_increase_impact_on_hit_child = table.clone(BaseWeaponTraitBuffTemplates.stacking_increase_impact_on_hit_child)
templates.weapon_trait_bespoke_ogryn_hammer_2h_p1_stacking_increase_impact_on_hit_parent.child_buff_template = "weapon_trait_bespoke_ogryn_hammer_2h_p1_stacking_increase_impact_on_hit_child"
templates.weapon_trait_bespoke_ogryn_hammer_2h_p1_stagger_bonus_damage = table.clone(BaseWeaponTraitBuffTemplates.stagger_bonus_damage)
templates.weapon_trait_bespoke_ogryn_hammer_2h_p1_power_bonus_scaled_on_stamina = table.clone(BaseWeaponTraitBuffTemplates.power_bonus_scaled_on_stamina)

templates.weapon_trait_bespoke_ogryn_hammer_2h_p1_power_bonus_scaled_on_stamina.bonus_step_func = function (template_data, template_context)
	local current_stamina_fraction = template_data.stamina_read_component.current_fraction
	local steps = math.floor((1 - current_stamina_fraction) / 0.125)

	return steps
end

templates.weapon_trait_bespoke_ogryn_hammer_2h_p1_power_bonus_on_first_attack = table.clone(BaseWeaponTraitBuffTemplates.power_bonus_on_first_attack)
templates.weapon_trait_bespoke_ogryn_hammer_2h_p1_toughness_on_hit_based_on_charge_time = {
	allow_proc_while_active = true,
	child_buff_template = "weapon_trait_bespoke_ogryn_hammer_2h_p1_toughness_on_hit_based_on_charge_time_visual_stack_count",
	class_name = "weapon_trait_parent_proc_buff",
	predicted = false,
	show_in_hud_if_slot_is_wielded = true,
	toughness_fixed_percentage = 0.05,
	proc_events = {
		[proc_events.on_windup_trigger] = 1,
		[proc_events.on_hit] = 1,
		[proc_events.on_action_start] = 1,
		[proc_events.on_sweep_finish] = 1,
		[proc_events.on_wield] = 1,
	},
	check_proc_func = ConditionalFunctions.is_item_slot_wielded,
	specific_proc_func = {
		on_windup_trigger = function (params, template_data, template_context)
			template_data.num_windup_procs = (template_data.num_windup_procs or 0) + 1
		end,
		on_hit = function (params, template_data, template_context)
			if not CheckProcFunctions.on_item_match(params, template_data, template_context) then
				return
			end

			local num_windup_procs = template_data.num_windup_procs or 0

			template_data.toughness_regain_multiplier = math.min(num_windup_procs, 3)

			SharedBuffFunctions.regain_toughness_proc_func(params, template_data, template_context)

			template_data.num_windup_procs = 0
		end,
		on_sweep_finish = function (params, template_data, template_context)
			template_data.num_windup_procs = 0
		end,
		on_wield = function (params, template_data, template_context)
			template_data.num_windup_procs = 0
		end,
	},
	add_child_proc_events = {
		[proc_events.on_windup_trigger] = 1,
	},
	clear_child_stacks_proc_events = {
		[proc_events.on_hit] = true,
		[proc_events.on_sweep_finish] = true,
		[proc_events.on_wield] = true,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_bespoke_ogryn_hammer_2h_p1_toughness_on_hit_based_on_charge_time_visual_stack_count = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 3,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_bespoke_ogryn_hammer_2h_p1_hit_mass_consumption_reduction_on_kill = {
	active_duration = 3,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.consumed_hit_mass_modifier] = 0.5,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_kill),
}
templates.weapon_trait_bespoke_ogryn_hammer_2h_p1_pass_past_armor_on_heavy_attack = {
	class_name = "proc_buff",
	force_predicted_proc = true,
	predicted = false,
	keywords = {
		keywords.fully_charged_attacks_infinite_cleave,
	},
	stat_buffs = {
		[stat_buffs.melee_fully_charged_damage] = 0.025,
	},
	proc_events = {
		[proc_events.on_sweep_start] = 1,
		[proc_events.on_sweep_finish] = 1,
	},
	conditional_keywords = {
		keywords.ignore_armor_aborts_attack,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.active and ConditionalFunctions.is_item_slot_wielded(template_data, template_context)
	end,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	specific_proc_func = {
		[proc_events.on_sweep_start] = function (params, template_data, template_context)
			if params.is_heavy and ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				template_data.active = true
			end
		end,
		[proc_events.on_sweep_finish] = function (params, template_data, template_context)
			template_data.active = false
		end,
	},
	check_active_func = function (template_data, template_context)
		return ConditionalFunctions.is_item_slot_wielded(template_data, template_context) and template_data.active
	end,
}
templates.weapon_trait_bespoke_ogryn_hammer_2h_p1_increased_weakspot_damage_on_push = {
	active_duration = 6,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_push_finish] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.weakspot_damage] = 0.01,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = function (params, template_data, template_context)
		return params.num_hit_units and params.num_hit_units > 0
	end,
}

return templates
