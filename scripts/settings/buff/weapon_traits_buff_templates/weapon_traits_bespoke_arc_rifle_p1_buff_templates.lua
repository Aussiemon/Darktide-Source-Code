-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_arc_rifle_p1_buff_templates.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local FireStepFunctions = require("scripts/settings/buff/fire_step_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_arc_rifle_p1_consecutive_hits_increases_close_damage_parent = table.clone(BaseWeaponTraitBuffTemplates.consecutive_hits_increases_close_damage_parent)
templates.weapon_trait_bespoke_arc_rifle_p1_consecutive_hits_increases_close_damage_child = table.clone(BaseWeaponTraitBuffTemplates.consecutive_hits_increases_close_damage_child)
templates.weapon_trait_bespoke_arc_rifle_p1_consecutive_hits_increases_close_damage_parent.child_buff_template = "weapon_trait_bespoke_arc_rifle_p1_consecutive_hits_increases_close_damage_child"
templates.weapon_trait_bespoke_arc_rifle_p1_power_bonus_on_continuous_fire = table.merge({
	conditional_stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.02,
	},
	continuous_fire_step_func = FireStepFunctions.default_continuous_fire_step_func,
}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire)
templates.weapon_trait_bespoke_arc_rifle_p1_stacking_crit_bonus_on_continuous_fire = table.merge({
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.01,
	},
	continuous_fire_step_func = FireStepFunctions.default_continuous_fire_step_func,
}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire)
templates.weapon_trait_bespoke_arc_rifle_p1_ammo_from_reserve_on_crit = table.clone(BaseWeaponTraitBuffTemplates.move_ammo_from_reserve_to_clip_on_crit)
templates.weapon_trait_bespoke_arc_rifle_p1_stagger_count_bonus_damage = table.clone(BaseWeaponTraitBuffTemplates.stagger_count_bonus_damage)
templates.weapon_trait_bespoke_arc_rifle_p1_consecutive_hits_increases_ranged_power_parent = table.clone(BaseWeaponTraitBuffTemplates.consecutive_hits_increases_ranged_power_parent)
templates.weapon_trait_bespoke_arc_rifle_p1_consecutive_hits_increases_ranged_power_child = table.clone(BaseWeaponTraitBuffTemplates.consecutive_hits_increases_ranged_power_child)
templates.weapon_trait_bespoke_arc_rifle_p1_consecutive_hits_increases_ranged_power_parent.child_buff_template = "weapon_trait_bespoke_arc_rifle_p1_consecutive_hits_increases_ranged_power_child"
templates.weapon_trait_bespoke_arc_rifle_p1_movement_speed_on_continous_fire = table.merge({
	conditional_stat_buffs = {
		[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = 0.5,
		[stat_buffs.weapon_action_movespeed_reduction_multiplier] = 0.5,
	},
	continuous_fire_step_func = FireStepFunctions.movement_speed_continuous_fire_step_func,
}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire)
templates.weapon_trait_bespoke_arc_rifle_p1_enhanced_arc_jumps_angle = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.chain_lightning_arc_rifle_max_angle] = math.degrees_to_radians(10),
		[stat_buffs.chain_lightning_arc_rifle_max_jumps] = 1,
		[stat_buffs.chain_lightning_arc_rifle_max_radius] = 0.5,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_bespoke_arc_rifle_p1_toughness_on_continuous_fire = table.merge({
	toughness_fixed_percentage = 0.1,
	continuous_fire_step_func = FireStepFunctions.toughness_regen_continuous_fire_step_func,
}, BaseWeaponTraitBuffTemplates.toughness_on_continuous_fire)

return templates
