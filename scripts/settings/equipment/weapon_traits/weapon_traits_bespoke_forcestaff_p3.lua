local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
templates.weapon_trait_bespoke_forcestaff_p3_suppression_on_close_kill = {
	weapon_trait_bespoke_forcestaff_p3_suppression_on_close_kill = {
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
templates.weapon_trait_bespoke_forcestaff_p3_hipfire_while_sprinting = {
	weapon_trait_bespoke_forcestaff_p3_hipfire_while_sprinting = {
		{}
	}
}
templates.weapon_trait_bespoke_forcestaff_p3_warp_charge_critical_strike_chance_bonus = {
	weapon_trait_bespoke_forcestaff_p3_warp_charge_critical_strike_chance_bonus = {
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.035
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.04
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.045
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.05
			}
		}
	}
}
templates.weapon_trait_bespoke_forcestaff_p3_uninterruptable_while_charging = {
	weapon_trait_bespoke_forcestaff_p3_uninterruptable_while_charging = {
		{}
	}
}
templates.weapon_trait_bespoke_forcestaff_p3_faster_charge_on_chained_secondary_attacks = {
	weapon_trait_bespoke_forcestaff_p3_faster_charge_on_chained_secondary_attacks = {
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
		},
		{
			stat_buffs = {
				[stat_buffs.charge_up_time] = -0.12
			}
		}
	}
}
templates.weapon_trait_bespoke_forcestaff_p3_faster_charge_on_chained_secondary_attacks = {
	weapon_trait_bespoke_forcestaff_p3_faster_charge_on_chained_secondary_attacks_parent = {
		{
			stat_buffs = {
				[stat_buffs.charge_up_time] = -0.055
			}
		},
		{
			stat_buffs = {
				[stat_buffs.charge_up_time] = -0.065
			}
		},
		{
			stat_buffs = {
				[stat_buffs.charge_up_time] = -0.075
			}
		},
		{
			stat_buffs = {
				[stat_buffs.charge_up_time] = -0.085
			}
		}
	}
}
templates.weapon_trait_bespoke_forcestaff_p3_increased_max_jumps = {
	weapon_trait_bespoke_forcestaff_p3_increased_max_jumps = {
		{
			stat_buffs = {
				[stat_buffs.chain_lightning_staff_max_jumps] = 1
			}
		}
	}
}
templates.weapon_trait_bespoke_forcestaff_p3_electrocuted_targets_receive_increased_damage_debuff = {
	weapon_trait_bespoke_forcestaff_p3_electrocuted_targets_receive_increased_damage_debuff = {
		{
			target_buff_data = {
				num_stacks_on_proc = 1
			}
		},
		{
			target_buff_data = {
				num_stacks_on_proc = 2
			}
		},
		{
			target_buff_data = {
				num_stacks_on_proc = 3
			}
		},
		{
			target_buff_data = {
				num_stacks_on_proc = 4
			}
		}
	}
}

return templates
