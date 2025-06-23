-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_ogryn_pickaxe_2h_p1_buff_templates.lua

local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local SharedBuffFunctions = require("scripts/settings/buff/helper_functions/shared_buff_functions")
local proc_events = BuffSettings.proc_events
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_windup_increases_power_parent = table.clone(BaseWeaponTraitBuffTemplates.windup_increases_power_parent)
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_windup_increases_power_parent.child_buff_template = "weapon_trait_bespoke_ogryn_pickaxe_2h_p1_windup_increases_power_child"
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_windup_increases_power_child = table.clone(BaseWeaponTraitBuffTemplates.windup_increases_power_child)
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_power_bonus_on_first_attack = table.clone(BaseWeaponTraitBuffTemplates.power_bonus_on_first_attack)
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_increase_power_on_kill_parent = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_kill_parent)
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_increase_power_on_kill_parent.child_buff_template = "weapon_trait_bespoke_ogryn_pickaxe_2h_p1_increase_power_on_kill_child"
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_increase_power_on_kill_child = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_kill_child)
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_increase_power_on_hit_parent = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_hit_parent)
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_increase_power_on_hit_parent.child_buff_template = "weapon_trait_bespoke_ogryn_pickaxe_2h_p1_increase_power_on_hit_child"
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_increase_power_on_hit_child = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_hit_child)
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_power_bonus_scaled_on_stamina = table.clone(BaseWeaponTraitBuffTemplates.power_bonus_scaled_on_stamina)
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_chained_hits_increases_melee_cleave_parent = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_melee_cleave_parent)
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_chained_hits_increases_melee_cleave_parent.child_buff_template = "weapon_trait_bespoke_ogryn_pickaxe_2h_p1_chained_hits_increases_melee_cleave_child"
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_chained_hits_increases_melee_cleave_child = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_melee_cleave_child)
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_increase_power_on_weapon_special_hit_parent = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_hit_parent)
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_increase_power_on_weapon_special_hit_parent.child_buff_template = "weapon_trait_bespoke_ogryn_pickaxe_2h_p1_increase_power_on_weapon_special_hit_child"
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_increase_power_on_weapon_special_hit_parent.check_proc_func = CheckProcFunctions.on_melee_weapon_special_hit
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_increase_power_on_weapon_special_hit_child = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_hit_child)
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_increase_power_on_weapon_special_hit_child.max_stacks = 1
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_toughness_recovery_on_chained_attacks = table.clone(BaseWeaponTraitBuffTemplates.toughness_recovery_on_chained_attacks)
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_targets_receive_rending_debuff = table.clone(BaseWeaponTraitBuffTemplates.targets_receive_rending_debuff)
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_toughness_on_hit_based_on_charge_time = {
	child_buff_template = "weapon_trait_bespoke_ogryn_pickaxe_2h_p1_toughness_on_hit_based_on_charge_time_visual_stack_count",
	predicted = false,
	toughness_fixed_percentage = 0.05,
	allow_proc_while_active = true,
	class_name = "weapon_trait_parent_proc_buff",
	show_in_hud_if_slot_is_wielded = true,
	proc_events = {
		[proc_events.on_windup_trigger] = 1,
		[proc_events.on_hit] = 1,
		[proc_events.on_action_start] = 1,
		[proc_events.on_sweep_finish] = 1,
		[proc_events.on_wield] = 1
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
		end
	},
	add_child_proc_events = {
		[proc_events.on_windup_trigger] = 1
	},
	clear_child_stacks_proc_events = {
		[proc_events.on_hit] = true,
		[proc_events.on_sweep_finish] = true,
		[proc_events.on_wield] = true
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_toughness_on_hit_based_on_charge_time_visual_stack_count = {
	hide_icon_in_hud = true,
	predicted = false,
	stack_offset = -1,
	max_stacks = 3,
	class_name = "buff",
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_targets_receive_increased_damage_debuff_on_weapon_special = table.clone(BaseWeaponTraitBuffTemplates.targets_receive_increased_damage_debuff_on_weapon_special)

return templates
