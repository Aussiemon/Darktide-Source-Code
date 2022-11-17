local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {
	weapon_trait_bespoke_ogryn_gauntlet_p1_toughness_on_elite_kills = table.clone(BaseWeaponTraitBuffTemplates.toughness_on_elite_kills),
	weapon_trait_bespoke_ogryn_gauntlet_p1_toughness_on_crit_kills = table.clone(BaseWeaponTraitBuffTemplates.toughness_on_crit_kills),
	weapon_trait_bespoke_ogryn_gauntlet_p1_power_bonus_on_continuous_fire = table.merge({
		use_combo = true,
		stat_buffs = {
			[stat_buffs.power_level_modifier] = 0.02
		}
	}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire),
	weapon_trait_bespoke_ogryn_gauntlet_p1_windup_increases_power_parent = table.clone(BaseWeaponTraitBuffTemplates.windup_increases_power_parent)
}
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_windup_increases_power_parent.child_buff_template = "weapon_trait_bespoke_ogryn_gauntlet_p1_windup_increases_power_child"
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_windup_increases_power_child = table.clone(BaseWeaponTraitBuffTemplates.windup_increases_power_child)
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_targets_receive_rending_debuff = table.clone(BaseWeaponTraitBuffTemplates.targets_receive_rending_debuff)
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_targets_receive_rending_debuff.check_proc_func = CheckProcFunctions.on_ranged_hit

return templates
