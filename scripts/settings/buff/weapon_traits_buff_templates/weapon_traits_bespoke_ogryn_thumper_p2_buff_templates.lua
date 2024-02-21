local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_ogryn_thumper_p2_toughness_on_elite_kills = table.clone(BaseWeaponTraitBuffTemplates.toughness_on_elite_kills)
templates.weapon_trait_bespoke_ogryn_thumper_p2_power_bonus_on_continuous_fire = table.merge({
	use_combo = true,
	conditional_stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.02
	}
}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire)
templates.weapon_trait_bespoke_ogryn_thumper_p2_pass_trough_armor_on_weapon_special = table.clone(BaseWeaponTraitBuffTemplates.pass_trough_armor_on_weapon_special)
templates.weapon_trait_bespoke_ogryn_thumper_p2_targets_receive_rending_debuff = table.clone(BaseWeaponTraitBuffTemplates.targets_receive_rending_debuff)
templates.weapon_trait_bespoke_ogryn_thumper_p2_targets_receive_rending_debuff.check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_ranged_hit)
templates.weapon_trait_bespoke_ogryn_thumper_p2_grenades_stick_to_monsters = table.clone(BaseWeaponTraitBuffTemplates.sticky_projectiles)

return templates
