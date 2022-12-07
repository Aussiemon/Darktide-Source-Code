local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {
	weapon_trait_bespoke_ogryn_thumper_p1_hipfire_while_sprinting = table.clone(BaseWeaponTraitBuffTemplates.hipfire_while_sprinting),
	weapon_trait_bespoke_ogryn_thumper_p1_suppression_on_close_kill = table.clone(BaseWeaponTraitBuffTemplates.suppression_on_close_kill),
	weapon_trait_bespoke_ogryn_thumper_p1_toughness_on_continuous_fire = table.merge({
		use_combo = true,
		stat_buffs = {
			[stat_buffs.toughness_extra_regen_rate] = 0.05
		}
	}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire),
	weapon_trait_bespoke_ogryn_thumper_p1_power_bonus_on_continuous_fire = table.merge({
		use_combo = true,
		stat_buffs = {
			[stat_buffs.power_level_modifier] = 0.02
		}
	}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire),
	weapon_trait_bespoke_ogryn_thumper_p1_crit_chance_based_on_aim_time = table.clone(BaseWeaponTraitBuffTemplates.chance_based_on_aim_time),
	weapon_trait_bespoke_ogryn_thumper_p1_crit_chance_based_on_aim_time = table.clone(BaseWeaponTraitBuffTemplates.chance_based_on_aim_time),
	weapon_trait_bespoke_ogryn_thumper_p1_weapon_special_power_bonus_after_one_shots = {
		predicted = false,
		allow_proc_while_active = true,
		max_stacks = 1,
		class_name = "proc_buff",
		active_duration = 4,
		proc_events = {
			[proc_events.on_shoot] = 1
		},
		proc_stat_buffs = {
			[stat_buffs.melee_power_level_modifier] = 0.05
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = CheckProcFunctions.on_shoot_hit_multiple
	},
	weapon_trait_bespoke_ogryn_thumper_p1_power_bonus_on_hitting_single_enemy_with_all = table.clone(BaseWeaponTraitBuffTemplates.power_bonus_on_hitting_single_enemy_with_all),
	weapon_trait_bespoke_ogryn_thumper_p1_shot_power_bonus_after_weapon_special_cleave = {
		predicted = false,
		allow_proc_while_active = true,
		class_name = "proc_buff",
		active_duration = 3,
		proc_events = {
			[proc_events.on_hit] = 1
		},
		buff_data = {
			required_num_hits = 3
		},
		proc_stat_buffs = {
			[stat_buffs.ranged_power_level_modifier] = 0.05
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = CheckProcFunctions.on_multiple_melee_hit
	},
	weapon_trait_bespoke_ogryn_thumper_p1_pass_trough_armor_on_weapon_special = table.clone(BaseWeaponTraitBuffTemplates.pass_trough_armor_on_weapon_special)
}

return templates
