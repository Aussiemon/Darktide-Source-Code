local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_ogryn_powermaul_p1_toughness_recovery_on_chained_attacks = table.clone(BaseWeaponTraitBuffTemplates.toughness_recovery_on_chained_attacks)
templates.weapon_trait_bespoke_ogryn_powermaul_p1_staggered_targets_receive_increased_damage_debuff = table.clone(BaseWeaponTraitBuffTemplates.staggered_targets_receive_increased_damage_debuff)
templates.weapon_trait_bespoke_ogryn_powermaul_p1_infinite_melee_cleave_on_weakspot_kill = table.clone(BaseWeaponTraitBuffTemplates.infinite_melee_cleave_on_weakspot_kill)
templates.weapon_trait_bespoke_ogryn_powermaul_p1_staggered_targets_receive_increased_stagger_debuff = table.clone(BaseWeaponTraitBuffTemplates.staggered_targets_receive_increased_stagger_debuff)
templates.weapon_trait_bespoke_ogryn_powermaul_p1_targets_receive_rending_debuff_on_weapon_special_attacks = table.clone(BaseWeaponTraitBuffTemplates.targets_receive_rending_debuff_on_weapon_special_attacks)
templates.weapon_trait_bespoke_ogryn_powermaul_p1_pass_past_armor_on_crit = table.clone(BaseWeaponTraitBuffTemplates.pass_past_armor_on_crit)
templates.weapon_trait_bespoke_ogryn_powermaul_p1_rending_vs_staggered = table.clone(BaseWeaponTraitBuffTemplates.rending_vs_staggered)
templates.weapon_trait_bespoke_ogryn_powermaul_p1_extra_explosion_on_activated_attacks_on_armor = table.clone(BaseWeaponTraitBuffTemplates.extra_explosion_on_activated_attacks_on_armor)

return templates
