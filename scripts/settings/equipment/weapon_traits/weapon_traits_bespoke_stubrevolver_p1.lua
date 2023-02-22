local BuffSettings = require("scripts/settings/buff/buff_settings")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
templates.weapon_trait_bespoke_stubrevolver_p1_hipfire_while_sprinting = {
	weapon_trait_bespoke_stubrevolver_p1_hipfire_while_sprinting = {
		{}
	}
}
templates.weapon_trait_bespoke_stubrevolver_p1_reload_speed_on_slide = {
	weapon_trait_bespoke_stubrevolver_p1_reload_speed_on_slide = {
		{
			active_duration = 4,
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.1
			}
		},
		{
			active_duration = 4,
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.12
			}
		},
		{
			active_duration = 4,
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.14
			}
		},
		{
			active_duration = 4,
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.16
			}
		}
	}
}
templates.weapon_trait_bespoke_stubrevolver_p1_suppression_on_close_kill = {
	weapon_trait_bespoke_stubrevolver_p1_suppression_on_close_kill = {
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
templates.weapon_trait_bespoke_stubrevolver_p1_crit_chance_based_on_aim_time = {
	weapon_trait_bespoke_stubrevolver_p1_crit_chance_based_on_aim_time = {
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.02
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.03
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.04
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.05
			}
		}
	}
}
templates.weapon_trait_bespoke_stubrevolver_p1_crit_chance_based_on_ammo_left = {
	weapon_trait_bespoke_stubrevolver_p1_crit_chance_based_on_ammo_left = {
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.02
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.03
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.04
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.05
			}
		}
	}
}
templates.weapon_trait_bespoke_stubrevolver_p1_chained_weakspot_hits_increases_power = {
	weapon_trait_bespoke_stubrevolver_p1_chained_weakspot_hits_increases_power_parent = {
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.02
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.03
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.04
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.05
			}
		}
	}
}
templates.weapon_trait_bespoke_stubrevolver_p1_crit_chance_bonus_on_melee_kills = {
	weapon_trait_bespoke_stubrevolver_p1_crit_chance_bonus_on_melee_kills = {
		{
			active_duration = 2.5,
			proc_stat_buffs = {
				[stat_buffs.ranged_critical_strike_chance] = 0.05
			}
		},
		{
			active_duration = 2.5,
			proc_stat_buffs = {
				[stat_buffs.ranged_critical_strike_chance] = 0.1
			}
		},
		{
			active_duration = 2.5,
			proc_stat_buffs = {
				[stat_buffs.ranged_critical_strike_chance] = 0.15
			}
		},
		{
			active_duration = 2.5,
			proc_stat_buffs = {
				[stat_buffs.ranged_critical_strike_chance] = 0.2
			}
		}
	}
}
templates.weapon_trait_bespoke_stubrevolver_p1_toughness_on_elite_kills = {
	weapon_trait_bespoke_stubrevolver_p1_toughness_on_elite_kills = {
		{
			toughness_fixed_percentage = 0.1
		},
		{
			toughness_fixed_percentage = 0.15
		},
		{
			toughness_fixed_percentage = 0.2
		},
		{
			toughness_fixed_percentage = 0.25
		}
	}
}
templates.weapon_trait_bespoke_stubrevolver_p1_followup_shots_ranged_damage = {
	weapon_trait_bespoke_stubrevolver_p1_followup_shots_ranged_damage = {
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_damage] = 0.06
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_damage] = 0.09
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_damage] = 0.12
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_damage] = 0.15
			}
		}
	}
}
templates.weapon_trait_bespoke_stubrevolver_p1_rending_on_crit = {
	weapon_trait_bespoke_stubrevolver_p1_rending_on_crit = {
		{
			conditional_stat_buffs = {
				[stat_buffs.critical_strike_rending_multiplier] = 0.2
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.critical_strike_rending_multiplier] = 0.3
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.critical_strike_rending_multiplier] = 0.4
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.critical_strike_rending_multiplier] = 0.5
			}
		}
	}
}

return templates
