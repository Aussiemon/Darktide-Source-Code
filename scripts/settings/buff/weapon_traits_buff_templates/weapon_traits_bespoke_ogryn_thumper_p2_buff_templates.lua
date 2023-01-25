local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {
	weapon_trait_bespoke_ogryn_thumper_p2_toughness_on_elite_kills = table.clone(BaseWeaponTraitBuffTemplates.toughness_on_elite_kills),
	weapon_trait_bespoke_ogryn_thumper_p2_power_bonus_on_continuous_fire = table.merge({
		use_combo = true,
		conditional_stat_buffs = {
			[stat_buffs.power_level_modifier] = 0.02
		}
	}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire),
	weapon_trait_bespoke_ogryn_thumper_p2_pass_trough_armor_on_weapon_special = table.clone(BaseWeaponTraitBuffTemplates.pass_trough_armor_on_weapon_special),
	weapon_trait_bespoke_ogryn_thumper_p2_targets_receive_rending_debuff = table.clone(BaseWeaponTraitBuffTemplates.targets_receive_rending_debuff)
}
templates.weapon_trait_bespoke_ogryn_thumper_p2_targets_receive_rending_debuff.check_proc_func = CheckProcFunctions.on_ranged_hit
templates.weapon_trait_bespoke_ogryn_thumper_p2_grenades_stick_to_monsters = table.clone(BaseWeaponTraitBuffTemplates.sticky_projectiles)

return templates
