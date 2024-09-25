-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_shotgun_p2_buff_templates.lua

local Action = require("scripts/utilities/weapon/action")
local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_shotgun_p2_count_as_dodge_vs_ranged_on_close_kill = table.clone(BaseWeaponTraitBuffTemplates.count_as_dodge_vs_ranged_on_close_kill)
templates.weapon_trait_bespoke_shotgun_p2_increase_power_on_close_kill_parent = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_close_kill_parent)
templates.weapon_trait_bespoke_shotgun_p2_increase_power_on_close_kill_parent.child_buff_template = "weapon_trait_bespoke_shotgun_p2_increase_power_on_close_kill_child"
templates.weapon_trait_bespoke_shotgun_p2_increase_power_on_close_kill_child = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_close_kill_child)
templates.weapon_trait_bespoke_shotgun_p2_increase_close_damage_on_close_kill_parent = table.clone(BaseWeaponTraitBuffTemplates.increase_close_damage_on_close_kill_parent)
templates.weapon_trait_bespoke_shotgun_p2_increase_close_damage_on_close_kill_parent.child_buff_template = "weapon_trait_bespoke_shotgun_p2_increase_close_damage_on_close_kill_child"
templates.weapon_trait_bespoke_shotgun_p2_increase_close_damage_on_close_kill_child = table.clone(BaseWeaponTraitBuffTemplates.increase_close_damage_on_close_kill_child)
templates.weapon_trait_bespoke_shotgun_p2_suppression_on_close_kill = table.clone(BaseWeaponTraitBuffTemplates.suppression_on_close_kill)
templates.weapon_trait_bespoke_shotgun_p2_bleed_on_crit = table.clone(BaseWeaponTraitBuffTemplates.bleed_on_crit_pellets)
templates.weapon_trait_bespoke_shotgun_p2_cleave_on_crit = table.clone(BaseWeaponTraitBuffTemplates.infinite_cleave_on_crit)
templates.weapon_trait_bespoke_shotgun_p2_power_bonus_on_hitting_single_enemy_with_all = table.clone(BaseWeaponTraitBuffTemplates.power_bonus_on_hitting_single_enemy_with_all)
templates.weapon_trait_bespoke_shotgun_p2_crit_chance_on_hitting_multiple_with_one_shot_parent = table.clone(BaseWeaponTraitBuffTemplates.crit_chance_on_multiple_pellet_hit_parent)
templates.weapon_trait_bespoke_shotgun_p2_crit_chance_on_hitting_multiple_with_one_shot_parent.child_buff_template = "weapon_trait_bespoke_shotgun_p2_crit_chance_on_hitting_multiple_with_one_shot_child"
templates.weapon_trait_bespoke_shotgun_p2_crit_chance_on_hitting_multiple_with_one_shot_child = table.clone(BaseWeaponTraitBuffTemplates.crit_chance_on_multiple_pellet_hit_child)
templates.weapon_trait_bespoke_shotgun_p2_reload_speed_on_slide_parent = table.clone(BaseWeaponTraitBuffTemplates.reload_speed_on_close_kill_parent)
templates.weapon_trait_bespoke_shotgun_p2_reload_speed_on_slide_child = table.clone(BaseWeaponTraitBuffTemplates.reload_speed_on_close_kill_child)
templates.weapon_trait_bespoke_shotgun_p2_reload_speed_on_slide_parent.child_buff_template = "weapon_trait_bespoke_shotgun_p2_reload_speed_on_slide_child"
templates.weapon_trait_bespoke_shotgun_p2_hipfire_while_sprinting = table.clone(BaseWeaponTraitBuffTemplates.hipfire_while_sprinting)
templates.weapon_trait_bespoke_shotgun_p2_crit_chance_on_reload = {
	active_duration = 5,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_reload] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.ranged_critical_strike_chance] = 0.01,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_bespoke_shotgun_p2_reload_speed_on_ranged_weapon_special_kill = {
	class_name = "proc_buff",
	force_predicted_proc = true,
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	conditional_stat_buffs = {
		[stat_buffs.reload_speed] = 0.5,
	},
	check_proc_func = CheckProcFunctions.on_ranged_kill,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.buff_extension = ScriptUnit.extension(unit, "buff_system")

		local player_unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")

		template_data.weapon_action_component = unit_data_extension:read_component("weapon_action")
	end,
	proc_func = function (params, template_data, template_context, t)
		local weapon_action_component = template_data.weapon_action_component

		if weapon_action_component.special_active_at_start then
			local unit = template_context.unit
			local source_item = template_context.source_item

			template_data.buff_extension:add_internally_controlled_buff("weapon_trait_bespoke_shotgun_p2_reload_speed_on_ranged_weapon_special_kill_effect", t, "owner_unit", unit, "source_item", source_item)
		end
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		local owner_unit = template_context.unit
		local buff_extension = ScriptUnit.has_extension(owner_unit, "buff_system")

		return not not buff_extension and not not buff_extension:has_buff_using_buff_template("weapon_trait_bespoke_shotgun_p2_reload_speed_on_ranged_weapon_special_kill_effect")
	end,
}
templates.weapon_trait_bespoke_shotgun_p2_reload_speed_on_ranged_weapon_special_kill_effect = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_reload] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

		local unit_data_extension = ScriptUnit.extension(template_context.unit, "unit_data_system")

		template_data.weapon_action_component = unit_data_extension:read_component("weapon_action")
		template_data.inventory_component = unit_data_extension:read_component("inventory")
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.done = true
	end,
	conditional_exit_func = function (template_data, template_context)
		local inventory_component = template_data.inventory_component
		local visual_loadout_extension = template_data.visual_loadout_extension
		local wielded_slot_id = inventory_component.wielded_slot
		local weapon_template = visual_loadout_extension:weapon_template_from_slot(wielded_slot_id)
		local _, current_action = Action.current_action(template_data.weapon_action_component, weapon_template)
		local action_kind = current_action and current_action.kind
		local is_reloading = action_kind and (action_kind == "reload_shotgun" or action_kind == "reload_state" or action_kind == "ranged_load_special")

		return template_data.done and not is_reloading
	end,
}

return templates
