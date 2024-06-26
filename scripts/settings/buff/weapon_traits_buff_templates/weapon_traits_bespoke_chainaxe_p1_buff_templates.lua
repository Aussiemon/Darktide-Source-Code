﻿-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_chainaxe_p1_buff_templates.lua

local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_chainaxe_p1_guaranteed_melee_crit_on_activated_kill = table.clone(BaseWeaponTraitBuffTemplates.guaranteed_melee_crit_on_activated_kill)
templates.weapon_trait_bespoke_chainaxe_p1_guaranteed_melee_crit_on_activated_kill.buff_data.internal_buff_name = "weapon_trait_bespoke_chainaxe_p1_guaranteed_melee_crit_on_activated_kill_effect"
templates.weapon_trait_bespoke_chainaxe_p1_guaranteed_melee_crit_on_activated_kill_effect = table.clone(BaseWeaponTraitBuffTemplates.guaranteed_melee_crit_on_activated_kill_effect_percentage)
templates.weapon_trait_bespoke_chainaxe_p1_bleed_on_activated_hit = table.clone(BaseWeaponTraitBuffTemplates.bleed_on_activated_hit)
templates.weapon_trait_bespoke_chainaxe_p1_movement_speed_on_activation = table.clone(BaseWeaponTraitBuffTemplates.movement_speed_on_activation)
templates.weapon_trait_bespoke_chainaxe_p1_increase_power_on_hit_parent = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_hit_parent)
templates.weapon_trait_bespoke_chainaxe_p1_increase_power_on_hit_parent.child_buff_template = "weapon_trait_bespoke_chainaxe_p1_increase_power_on_hit_child"
templates.weapon_trait_bespoke_chainaxe_p1_increase_power_on_hit_child = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_hit_child)
templates.weapon_trait_bespoke_chainaxe_p1_increase_power_on_kill_parent = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_kill_parent)
templates.weapon_trait_bespoke_chainaxe_p1_increase_power_on_kill_parent.child_buff_template = "weapon_trait_bespoke_chainaxe_p1_increase_power_on_kill_child"
templates.weapon_trait_bespoke_chainaxe_p1_increase_power_on_kill_child = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_kill_child)
templates.weapon_trait_bespoke_chainaxe_p1_windup_increases_power_parent = table.clone(BaseWeaponTraitBuffTemplates.windup_increases_power_parent)
templates.weapon_trait_bespoke_chainaxe_p1_windup_increases_power_parent.child_buff_template = "weapon_trait_bespoke_chainaxe_p1_windup_increases_power_child"
templates.weapon_trait_bespoke_chainaxe_p1_windup_increases_power_child = table.clone(BaseWeaponTraitBuffTemplates.windup_increases_power_child)
templates.weapon_trait_bespoke_chainaxe_p1_targets_receive_rending_debuff = table.clone(BaseWeaponTraitBuffTemplates.targets_receive_rending_debuff)
templates.weapon_trait_bespoke_chainaxe_p1_rending_vs_staggered = table.clone(BaseWeaponTraitBuffTemplates.rending_vs_staggered)

return templates
