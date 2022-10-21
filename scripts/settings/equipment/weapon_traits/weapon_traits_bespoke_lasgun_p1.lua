local BuffSettings = require("scripts/settings/buff/buff_settings")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
templates.weapon_trait_bespoke_lasgun_p1_increased_zoom = {
	weapon_trait_bespoke_lasgun_p1_increased_zoom = {
		{
			stat_buffs = {
				[stat_buffs.fov_multiplier] = 0.85
			}
		},
		{
			stat_buffs = {
				[stat_buffs.fov_multiplier] = 0.85
			}
		},
		{
			stat_buffs = {
				[stat_buffs.fov_multiplier] = 0.85
			}
		},
		{
			stat_buffs = {
				[stat_buffs.fov_multiplier] = 0.85
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p1_first_shot_ammo_cost_reduction = {
	weapon_trait_bespoke_lasgun_p1_first_shot_ammo_cost_reduction = {
		{
			cooldown_duration = 5.5,
			proc_events = {
				[proc_events.on_shoot] = 1
			}
		},
		{
			cooldown_duration = 5,
			proc_events = {
				[proc_events.on_shoot] = 1
			}
		},
		{
			cooldown_duration = 4.5,
			proc_events = {
				[proc_events.on_shoot] = 1
			}
		},
		{
			cooldown_duration = 4,
			proc_events = {
				[proc_events.on_shoot] = 1
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p1_suppression_negation_on_weakspot = {
	weapon_trait_bespoke_lasgun_p1_suppression_negation_on_weakspot = {
		{
			active_duration = 0.5
		},
		{
			active_duration = 0.7
		},
		{
			active_duration = 0.85
		},
		{
			active_duration = 0.9
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p1_stacking_crit_chance_on_weakspot = {
	weapon_trait_bespoke_lasgun_p1_stacking_crit_chance_on_weakspot_parent = {
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.02
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.03
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.04
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.05
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p1_count_as_dodge_vs_ranged_on_weakspot = {
	weapon_trait_bespoke_lasgun_p1_count_as_dodge_vs_ranged_on_weakspot = {
		{
			active_duration = 0.5
		},
		{
			active_duration = 0.75
		},
		{
			active_duration = 0.9
		},
		{
			active_duration = 1
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p1_negate_stagger_reduction_on_weakspot = {
	weapon_trait_bespoke_lasgun_p1_negate_stagger_reduction_on_weakspot = {
		{
			stat_buffs = {
				[stat_buffs.stagger_weakspot_reduction_modifier] = 0.7
			}
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_weakspot_reduction_modifier] = 0.6
			}
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_weakspot_reduction_modifier] = 0.5
			}
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_weakspot_reduction_modifier] = 0.4
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p1_stagger_count_bonus_damage = {
	weapon_trait_bespoke_lasgun_p1_stagger_count_bonus_damage = {
		{
			stat_buffs = {
				[stat_buffs.stagger_count_damage] = 0.1
			}
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_count_damage] = 0.15
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
templates.weapon_trait_bespoke_lasgun_p1_burninating_on_crit = {
	weapon_trait_bespoke_lasgun_p1_burninating_on_crit = {
		{
			dot_data = {
				num_stacks_on_proc = 2
			}
		},
		{
			dot_data = {
				num_stacks_on_proc = 4
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p1_crit_weakspot_finesse = {
	weapon_trait_bespoke_lasgun_p1_crit_weakspot_finesse = {
		{
			stat_buffs = {
				[stat_buffs.critical_strike_weakspot_damage] = 0.3
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_weakspot_damage] = 0.4
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_weakspot_damage] = 0.475
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_weakspot_damage] = 0.5
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p1_power_bonus_on_first_shot = {
	weapon_trait_bespoke_lasgun_p1_power_bonus_on_first_shot = {
		{
			stat_buffs = {
				[stat_buffs.ranged_power_level_modifier] = 0.05
			}
		},
		{
			stat_buffs = {
				[stat_buffs.ranged_power_level_modifier] = 0.1
			}
		},
		{
			stat_buffs = {
				[stat_buffs.ranged_power_level_modifier] = 0.13
			}
		},
		{
			stat_buffs = {
				[stat_buffs.ranged_power_level_modifier] = 0.15
			}
		}
	}
}

return templates
