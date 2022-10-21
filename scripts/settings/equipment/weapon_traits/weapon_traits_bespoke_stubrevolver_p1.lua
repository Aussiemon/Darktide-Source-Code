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
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.05
			}
		},
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.075
			}
		},
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.09
			}
		},
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.1
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
				distance = 5,
				suppression_value = 15
			}
		},
		{
			suppression_settings = {
				suppression_falloff = true,
				instant_aggro = true,
				distance = 5,
				suppression_value = 20
			}
		},
		{
			suppression_settings = {
				suppression_falloff = true,
				instant_aggro = true,
				distance = 5,
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
				[stat_buffs.power_level_modifier] = 0.035
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.045
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
			proc_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.05
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.1
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.15
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.2
			}
		}
	}
}
templates.weapon_trait_bespoke_stubrevolver_p1_toughness_on_elite_kills = {
	weapon_trait_bespoke_stubrevolver_p1_toughness_on_elite_kills = {
		{
			toughness_fixed_percentage = 0.05
		},
		{
			toughness_fixed_percentage = 0.065
		},
		{
			toughness_fixed_percentage = 0.085
		},
		{
			toughness_fixed_percentage = 0.1
		}
	}
}
templates.weapon_trait_bespoke_stubrevolver_p1_followup_shots_ranged_damage = {
	weapon_trait_bespoke_stubrevolver_p1_followup_shots_ranged_damage = {
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_damage] = 0.05
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_damage] = 0.1
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_damage] = 0.13
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
				[stat_buffs.critical_strike_rending_multiplier] = 0.35
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.critical_strike_rending_multiplier] = 0.45
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
