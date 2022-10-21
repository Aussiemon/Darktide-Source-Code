local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local FixedFrame = require("scripts/utilities/fixed_frame")
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local keywords = BuffSettings.keywords
local templates = {
	weapon_trait_bespoke_stubrevolver_p1_hipfire_while_sprinting = table.clone(BaseWeaponTraitBuffTemplates.hipfire_while_sprinting),
	weapon_trait_bespoke_stubrevolver_p1_reload_speed_on_slide = table.clone(BaseWeaponTraitBuffTemplates.reload_speed_on_slide),
	weapon_trait_bespoke_stubrevolver_p1_suppression_on_close_kill = table.clone(BaseWeaponTraitBuffTemplates.suppression_on_close_kill),
	weapon_trait_bespoke_stubrevolver_p1_crit_chance_based_on_aim_time = table.clone(BaseWeaponTraitBuffTemplates.chance_based_on_aim_time),
	weapon_trait_bespoke_stubrevolver_p1_chained_weakspot_hits_increases_power_parent = table.clone(BaseWeaponTraitBuffTemplates.chained_weakspot_hits_increases_power_ranged_parent)
}
templates.weapon_trait_bespoke_stubrevolver_p1_chained_weakspot_hits_increases_power_parent.child_buff_template = "weapon_trait_bespoke_stubrevolver_p1_chained_weakspot_hits_increases_power_child"
templates.weapon_trait_bespoke_stubrevolver_p1_chained_weakspot_hits_increases_power_child = table.clone(BaseWeaponTraitBuffTemplates.chained_weakspot_hits_increases_power_child)
templates.weapon_trait_bespoke_stubrevolver_p1_crit_chance_based_on_ammo_left = {
	predicted = false,
	stack_offset = -1,
	class_name = "stepped_stat_buff",
	stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.05
	},
	conditional_stepped_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = function (template_data, template_context)
		local item_slot_name = template_context.item_slot_name
		local unit = template_context.unit
		local unit_data_extension = unit and ScriptUnit.has_extension(unit, "unit_data_system")
		template_data.inventory_slot_component = unit_data_extension and unit_data_extension:read_component(item_slot_name)
	end,
	min_max_step_func = function (template_data, template_context)
		return 0, 10
	end,
	bonus_step_func = function (template_data, template_context)
		local inventory_slot_component = template_data.inventory_slot_component
		local current_ammunition_clip = inventory_slot_component.current_ammunition_clip
		local max_ammunition_clip = inventory_slot_component.max_ammunition_clip
		local missing_in_clip = max_ammunition_clip - current_ammunition_clip

		return missing_in_clip
	end
}
templates.weapon_trait_bespoke_stubrevolver_p1_crit_chance_bonus_on_melee_kills = {
	predicted = false,
	class_name = "proc_buff",
	active_duration = 2,
	proc_events = {
		[proc_events.on_hit] = 1
	},
	proc_stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.05
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_melee_kill
}
templates.weapon_trait_bespoke_stubrevolver_p1_toughness_on_elite_kills = table.clone(BaseWeaponTraitBuffTemplates.toughness_on_elite_kills)
templates.weapon_trait_bespoke_stubrevolver_p1_followup_shots_ranged_damage = table.clone(BaseWeaponTraitBuffTemplates.followup_shots_ranged_damage)
templates.weapon_trait_bespoke_stubrevolver_p1_rending_on_crit = table.clone(BaseWeaponTraitBuffTemplates.rending_on_crit)

return templates
