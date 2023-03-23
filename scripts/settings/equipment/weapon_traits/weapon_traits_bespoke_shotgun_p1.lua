local BuffSettings = require("scripts/settings/buff/buff_settings")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
templates.weapon_trait_bespoke_shotgun_p1_increase_power_on_close_kill = {
	weapon_trait_bespoke_shotgun_p1_increase_power_on_close_kill_parent = {
		{
			child_duration = 2.75,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.05
			}
		},
		{
			child_duration = 2.75,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.055
			}
		},
		{
			child_duration = 2.75,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.06
			}
		},
		{
			child_duration = 2.75,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.065
			}
		}
	}
}
templates.weapon_trait_bespoke_shotgun_p1_increase_close_damage_on_close_kill = {
	weapon_trait_bespoke_shotgun_p1_increase_close_damage_on_close_kill_parent = {
		{
			child_duration = 2.75,
			stat_buffs = {
				[stat_buffs.damage_near] = 0.04
			}
		},
		{
			child_duration = 2.75,
			stat_buffs = {
				[stat_buffs.damage_near] = 0.06
			}
		},
		{
			child_duration = 2.75,
			stat_buffs = {
				[stat_buffs.damage_near] = 0.8
			}
		},
		{
			child_duration = 2.75,
			stat_buffs = {
				[stat_buffs.damage_near] = 0.1
			}
		}
	}
}
templates.weapon_trait_bespoke_shotgun_p1_count_as_dodge_vs_ranged_on_close_kill = {
	weapon_trait_bespoke_shotgun_p1_count_as_dodge_vs_ranged_on_close_kill = {
		{
			active_duration = 0.4
		},
		{
			active_duration = 0.5
		},
		{
			active_duration = 0.6
		},
		{
			active_duration = 0.7
		}
	}
}
templates.weapon_trait_bespoke_shotgun_p1_suppression_on_close_kill = {
	weapon_trait_bespoke_shotgun_p1_suppression_on_close_kill = {
		{
			suppression_settings = {
				suppression_falloff = true,
				instant_aggro = true,
				distance = 5,
				suppression_value = 10
			}
		},
		{
			suppression_settings = {
				suppression_falloff = true,
				instant_aggro = true,
				distance = 6,
				suppression_value = 15
			}
		},
		{
			suppression_settings = {
				suppression_falloff = true,
				instant_aggro = true,
				distance = 7,
				suppression_value = 20
			}
		},
		{
			suppression_settings = {
				suppression_falloff = true,
				instant_aggro = true,
				distance = 8,
				suppression_value = 25
			}
		}
	}
}
templates.weapon_trait_bespoke_shotgun_p1_power_bonus_on_hitting_single_enemy_with_all = {
	weapon_trait_bespoke_shotgun_p1_power_bonus_on_hitting_single_enemy_with_all = {
		{
			proc_stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.075
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.1
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.125
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.15
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
	weapon_trait_bespoke_shotgun_p1_crit_chance_on_hitting_multiple_with_one_shot = {
		{
			proc_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.02
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.03
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.04
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.05
			}
		}
	}
}
templates.weapon_trait_bespoke_shotgun_p1_stagger_count_bonus_damage = {
	weapon_trait_bespoke_shotgun_p1_stagger_count_bonus_damage = {
		{
			stat_buffs = {
				[stat_buffs.stagger_count_damage] = 0.125
			}
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_count_damage] = 0.15
			}
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_count_damage] = 0.175
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
