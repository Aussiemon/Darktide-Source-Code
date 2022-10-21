local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
templates.weapon_trait_bespoke_forcestaff_p1_vents_warpcharge_on_weakspot_hits = {
	weapon_trait_bespoke_forcestaff_p1_vents_warpcharge_on_weakspot_hits = {
		{
			vent_percentage = 0.02
		},
		{
			vent_percentage = 0.035
		},
		{
			vent_percentage = 0.045
		},
		{
			vent_percentage = 0.05
		}
	}
}
templates.weapon_trait_bespoke_forcestaff_p1_suppression_on_close_kill = {
	weapon_trait_bespoke_forcestaff_p1_suppression_on_close_kill = {
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
templates.weapon_trait_bespoke_forcestaff_p1_hipfire_while_sprinting = {
	weapon_trait_bespoke_forcestaff_p1_hipfire_while_sprinting = {
		{}
	}
}
templates.weapon_trait_bespoke_forcestaff_p1_followup_shots_ranged_damage = {
	weapon_trait_bespoke_forcestaff_p1_followup_shots_ranged_damage = {
		{
			conditional_stat_buffs = {
				[stat_buffs.charge_level_modifier] = 0.05
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.charge_level_modifier] = 0.1
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.charge_level_modifier] = 0.13
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.charge_level_modifier] = 0.15
			}
		}
	}
}
templates.weapon_trait_bespoke_forcestaff_p1_warpfire_on_crits = {
	weapon_trait_bespoke_forcestaff_p1_warpfire_on_crits = {
		{}
	}
}
templates.weapon_trait_bespoke_forcestaff_p1_warp_charge_critical_strike_chance_bonus = {
	weapon_trait_bespoke_forcestaff_p1_warp_charge_critical_strike_chance_bonus = {
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
templates.weapon_trait_bespoke_forcestaff_p1_rend_armor_on_aoe_charge = {
	weapon_trait_bespoke_forcestaff_p1_rend_armor_on_aoe_charge = {
		{
			max_num_stacks = 2
		},
		{
			max_num_stacks = 4
		},
		{
			max_num_stacks = 6
		},
		{
			max_num_stacks = 8
		}
	}
}
templates.weapon_trait_bespoke_forcestaff_p1_uninterruptable_while_charging = {
	weapon_trait_bespoke_forcestaff_p1_uninterruptable_while_charging = {
		{}
	}
}
templates.weapon_trait_bespoke_forcestaff_p1_faster_charge_on_chained_secondary_attacks = {
	weapon_trait_bespoke_forcestaff_p1_faster_charge_on_chained_secondary_attacks = {
		{
			stat_buffs = {
				[stat_buffs.charge_up_time] = -0.04
			}
		},
		{
			stat_buffs = {
				[stat_buffs.charge_up_time] = -0.06
			}
		},
		{
			stat_buffs = {
				[stat_buffs.charge_up_time] = -0.08
			}
		},
		{
			stat_buffs = {
				[stat_buffs.charge_up_time] = -0.1
			}
		}
	}
}
templates.weapon_trait_bespoke_forcestaff_p1_double_shot_on_crit = {
	weapon_trait_bespoke_forcestaff_p1_double_shot_on_crit = {
		{}
	}
}

return templates
