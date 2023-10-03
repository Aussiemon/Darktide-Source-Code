local BuffSettings = require("scripts/settings/buff/buff_settings")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
templates.weapon_trait_bespoke_shotgun_p1_increase_power_on_close_kill = {
	weapon_trait_bespoke_shotgun_p1_increase_power_on_close_kill_parent = {
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.05
			}
		},
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.055
			}
		},
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.06
			}
		},
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.065
			}
		}
	}
}
templates.weapon_trait_bespoke_shotgun_p1_increase_close_damage_on_close_kill = {
	weapon_trait_bespoke_shotgun_p1_increase_close_damage_on_close_kill_parent = {
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.ranged_attack_speed] = 0.07
			}
		},
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.ranged_attack_speed] = 0.08
			}
		},
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.ranged_attack_speed] = 0.09
			}
		},
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.ranged_attack_speed] = 0.1
			}
		}
	}
}
templates.weapon_trait_bespoke_shotgun_p1_count_as_dodge_vs_ranged_on_close_kill = {
	weapon_trait_bespoke_shotgun_p1_count_as_dodge_vs_ranged_on_close_kill = {
		{
			active_duration = 0.7
		},
		{
			active_duration = 0.8
		},
		{
			active_duration = 0.9
		},
		{
			active_duration = 1
		}
	}
}
templates.weapon_trait_bespoke_shotgun_p1_suppression_on_close_kill = {
	weapon_trait_bespoke_shotgun_p1_suppression_on_close_kill = {
		{
			suppression_settings = {
				suppression_falloff = false,
				instant_aggro = true,
				distance = 12,
				suppression_value = 15
			}
		},
		{
			suppression_settings = {
				suppression_falloff = false,
				instant_aggro = true,
				distance = 12,
				suppression_value = 20
			}
		},
		{
			suppression_settings = {
				suppression_falloff = false,
				instant_aggro = true,
				distance = 12,
				suppression_value = 25
			}
		},
		{
			suppression_settings = {
				suppression_falloff = false,
				instant_aggro = true,
				distance = 12,
				suppression_value = 30
			}
		}
	}
}
templates.weapon_trait_bespoke_shotgun_p1_power_bonus_on_hitting_single_enemy_with_all = {
	weapon_trait_bespoke_shotgun_p1_power_bonus_on_hitting_single_enemy_with_all = {
		{
			proc_stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.14
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.16
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.18
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.2
			}
		}
	}
}
templates.weapon_trait_bespoke_shotgun_p1_bleed_on_crit = {
	weapon_trait_bespoke_shotgun_p1_bleed_on_crit = {
		{
			target_buff_data = {
				num_stacks_on_proc = 6
			}
		}
	}
}
templates.weapon_trait_bespoke_shotgun_p1_crit_chance_on_hitting_multiple_with_one_shot = {
	weapon_trait_bespoke_shotgun_p1_crit_chance_on_hitting_multiple_with_one_shot_parent = {
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_critical_strike_chance] = 0.06
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_critical_strike_chance] = 0.08
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_critical_strike_chance] = 0.1
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_critical_strike_chance] = 0.12
			}
		}
	}
}
templates.weapon_trait_bespoke_shotgun_p1_stagger_count_bonus_damage = {
	weapon_trait_bespoke_shotgun_p1_stagger_count_bonus_damage = {
		{
			stat_buffs = {
				[stat_buffs.stagger_count_damage] = 0.14
			}
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_count_damage] = 0.16
			}
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_count_damage] = 0.18
			}
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_count_damage] = 0.2
			}
		}
	}
}
templates.weapon_trait_bespoke_shotgun_p1_cleave_on_crit = {
	weapon_trait_bespoke_shotgun_p1_cleave_on_crit = {
		{}
	}
}

return templates
