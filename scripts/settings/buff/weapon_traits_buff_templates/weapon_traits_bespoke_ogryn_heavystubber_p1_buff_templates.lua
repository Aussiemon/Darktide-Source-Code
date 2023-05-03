local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local heavystubber_fire_step = 25
local templates = {
	weapon_trait_bespoke_ogryn_heavystubber_p1_toughness_on_continuous_fire = table.merge({
		conditional_stat_buffs = {
			[stat_buffs.toughness_extra_regen_rate] = 0.1
		},
		continuous_fire_step = heavystubber_fire_step
	}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire),
	weapon_trait_bespoke_ogryn_heavystubber_p1_power_bonus_on_continuous_fire = table.merge({
		conditional_stat_buffs = {
			[stat_buffs.power_level_modifier] = 0.02
		},
		continuous_fire_step = heavystubber_fire_step
	}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire),
	weapon_trait_bespoke_ogryn_heavystubber_p1_increase_power_on_close_kill_parent = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_close_kill_parent),
	weapon_trait_bespoke_ogryn_heavystubber_p1_increase_power_on_close_kill_child = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_close_kill_child)
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_increase_power_on_close_kill_parent.child_buff_template = "weapon_trait_bespoke_ogryn_heavystubber_p1_increase_power_on_close_kill_child"
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_increased_suppression_on_continuous_fire = table.merge({
	conditional_stat_buffs = {
		[stat_buffs.increased_suppression] = 0.02
	},
	continuous_fire_step = heavystubber_fire_step
}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire)
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_consecutive_hits_increases_ranged_power_parent = table.clone(BaseWeaponTraitBuffTemplates.consecutive_hits_increases_ranged_power_parent)
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_consecutive_hits_increases_ranged_power_child = table.clone(BaseWeaponTraitBuffTemplates.consecutive_hits_increases_ranged_power_child)
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_consecutive_hits_increases_ranged_power_parent.child_buff_template = "weapon_trait_bespoke_ogryn_heavystubber_p1_consecutive_hits_increases_ranged_power_child"
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_consecutive_hits_increases_ranged_power_parent.number_of_hits_per_stack = 10
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_movement_speed_on_continous_fire = table.merge({
	conditional_stat_buffs = {
		[stat_buffs.movement_speed] = 1.1
	},
	continuous_fire_step = heavystubber_fire_step
}, BaseWeaponTraitBuffTemplates.conditional_buff_on_continuous_fire)
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_ammo_from_reserve_on_crit = table.clone(BaseWeaponTraitBuffTemplates.move_ammo_from_reserve_to_clip_on_crit)

return templates
