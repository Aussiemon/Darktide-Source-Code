local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
templates.weapon_trait_bespoke_forcestaff_p4_vents_warpcharge_on_weakspot_hits = {
	weapon_trait_bespoke_forcestaff_p4_vents_warpcharge_on_weakspot_hits = {
		{
			vent_percentage = 0.02
		},
		{
			vent_percentage = 0.03
		},
		{
			vent_percentage = 0.04
		},
		{
			vent_percentage = 0.05
		}
	}
}
templates.weapon_trait_bespoke_forcestaff_p4_suppression_on_close_kill = {
	weapon_trait_bespoke_forcestaff_p4_suppression_on_close_kill = {
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
templates.weapon_trait_bespoke_forcestaff_p4_hipfire_while_sprinting = {
	weapon_trait_bespoke_forcestaff_p4_hipfire_while_sprinting = {
		{}
	}
}
templates.weapon_trait_bespoke_forcestaff_p4_followup_shots_ranged_damage = {
	weapon_trait_bespoke_forcestaff_p4_followup_shots_ranged_damage = {
		{
			conditional_stat_buffs = {
				[stat_buffs.charge_level_modifier] = 0.075
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.charge_level_modifier] = 0.1
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.charge_level_modifier] = 0.125
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.charge_level_modifier] = 0.15
			}
		}
	}
}
templates.weapon_trait_bespoke_forcestaff_p4_warpfire_on_crits = {
	weapon_trait_bespoke_forcestaff_p4_warpfire_on_crits = {
		{
			target_buff_data = {
				num_stacks_on_proc = 3
			}
		}
	}
}
templates.weapon_trait_bespoke_forcestaff_p4_warp_charge_critical_strike_chance_bonus = {
	weapon_trait_bespoke_forcestaff_p4_warp_charge_critical_strike_chance_bonus = {
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
templates.weapon_trait_bespoke_forcestaff_p4_uninterruptable_while_charging = {
	weapon_trait_bespoke_forcestaff_p4_uninterruptable_while_charging = {
		{}
	}
}
templates.weapon_trait_bespoke_forcestaff_p4_faster_charge_on_chained_secondary_attacks = {
	weapon_trait_bespoke_forcestaff_p4_faster_charge_on_chained_secondary_attacks = {
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
templates.weapon_trait_bespoke_forcestaff_p4_double_shot_on_crit = {
	weapon_trait_bespoke_forcestaff_p4_double_shot_on_crit = {
		{}
	}
}

return templates
