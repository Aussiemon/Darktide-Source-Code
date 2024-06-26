﻿-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_autogun_p3_buff_templates.lua

local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_autogun_p3_crit_chance_based_on_ammo_left = table.clone(BaseWeaponTraitBuffTemplates.crit_chance_based_on_ammo_left)
templates.weapon_trait_bespoke_autogun_p3_stacking_crit_chance_on_weakspot_parent = table.clone(BaseWeaponTraitBuffTemplates.stacking_crit_chance_on_weakspot_parent)
templates.weapon_trait_bespoke_autogun_p3_stacking_crit_chance_on_weakspot_parent.child_buff_template = "weapon_trait_bespoke_autogun_p3_stacking_crit_chance_on_weakspot_child"
templates.weapon_trait_bespoke_autogun_p3_stacking_crit_chance_on_weakspot_child = table.clone(BaseWeaponTraitBuffTemplates.stacking_crit_chance_on_weakspot_child)
templates.weapon_trait_bespoke_autogun_p3_suppression_negation_on_weakspot = table.clone(BaseWeaponTraitBuffTemplates.suppression_negation_on_weakspot)
templates.weapon_trait_bespoke_autogun_p3_count_as_dodge_vs_ranged_on_weakspot = table.clone(BaseWeaponTraitBuffTemplates.count_as_dodge_vs_ranged_on_weakspot)
templates.weapon_trait_bespoke_autogun_p3_negate_stagger_reduction_on_weakspot = table.clone(BaseWeaponTraitBuffTemplates.negate_stagger_reduction_on_weakspot)
templates.weapon_trait_bespoke_autogun_p3_stagger_count_bonus_damage = table.clone(BaseWeaponTraitBuffTemplates.stagger_count_bonus_damage)
templates.weapon_trait_bespoke_autogun_p3_crit_chance_based_on_aim_time = table.clone(BaseWeaponTraitBuffTemplates.chance_based_on_aim_time)
templates.weapon_trait_bespoke_autogun_p3_crit_weakspot_finesse = table.clone(BaseWeaponTraitBuffTemplates.crit_weakspot_finesse)
templates.weapon_trait_bespoke_autogun_p3_power_bonus_on_first_shot = table.clone(BaseWeaponTraitBuffTemplates.power_bonus_on_first_shot)

return templates
