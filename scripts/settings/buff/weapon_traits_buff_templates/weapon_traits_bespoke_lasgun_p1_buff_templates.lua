-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_lasgun_p1_buff_templates.lua

local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_lasgun_p1_increased_zoom = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.fov_multiplier] = 0.95
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return
		end

		return ConditionalFunctions.is_alternative_fire(template_data, template_context)
	end
}
templates.weapon_trait_bespoke_lasgun_p1_first_shot_ammo_cost_reduction = {
	cooldown_duration = 1,
	show_in_hud_if_slot_is_wielded = true,
	predicted = false,
	class_name = "proc_buff",
	always_show_in_hud = true,
	proc_events = {
		[proc_events.on_shoot] = 1
	},
	off_cooldown_keywords = {
		keywords.reduced_ammo_consumption
	}
}
templates.weapon_trait_bespoke_lasgun_p1_suppression_negation_on_weakspot = table.clone(BaseWeaponTraitBuffTemplates.suppression_negation_on_weakspot)
templates.weapon_trait_bespoke_lasgun_p1_stacking_crit_chance_on_weakspot_parent = table.clone(BaseWeaponTraitBuffTemplates.stacking_crit_chance_on_weakspot_parent)
templates.weapon_trait_bespoke_lasgun_p1_stacking_crit_chance_on_weakspot_parent.child_buff_template = "weapon_trait_bespoke_lasgun_p1_stacking_crit_chance_on_weakspot_child"
templates.weapon_trait_bespoke_lasgun_p1_stacking_crit_chance_on_weakspot_child = table.clone(BaseWeaponTraitBuffTemplates.stacking_crit_chance_on_weakspot_child)
templates.weapon_trait_bespoke_lasgun_p1_count_as_dodge_vs_ranged_on_weakspot = table.clone(BaseWeaponTraitBuffTemplates.count_as_dodge_vs_ranged_on_weakspot)
templates.weapon_trait_bespoke_lasgun_p1_negate_stagger_reduction_on_weakspot = table.clone(BaseWeaponTraitBuffTemplates.negate_stagger_reduction_on_weakspot)
templates.weapon_trait_bespoke_lasgun_p1_stagger_count_bonus_damage = table.clone(BaseWeaponTraitBuffTemplates.stagger_count_bonus_damage)
templates.weapon_trait_bespoke_lasgun_p1_burninating_on_crit = table.clone(BaseWeaponTraitBuffTemplates.burninating_on_crit_ranged)
templates.weapon_trait_bespoke_lasgun_p1_crit_weakspot_finesse = table.clone(BaseWeaponTraitBuffTemplates.crit_weakspot_finesse)
templates.weapon_trait_bespoke_lasgun_p1_power_bonus_on_first_shot = table.clone(BaseWeaponTraitBuffTemplates.power_bonus_on_first_shot)

return templates
