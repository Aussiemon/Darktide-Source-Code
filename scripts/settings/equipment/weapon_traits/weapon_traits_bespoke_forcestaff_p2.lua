local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
templates.weapon_trait_bespoke_forcestaff_p2_suppression_on_close_kill = {
	weapon_trait_bespoke_forcestaff_p2_suppression_on_close_kill = {
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
templates.weapon_trait_bespoke_forcestaff_p2_hipfire_while_sprinting = {
	weapon_trait_bespoke_forcestaff_p2_hipfire_while_sprinting = {
		{}
	}
}
templates.weapon_trait_bespoke_forcestaff_p2_warp_charge_critical_strike_chance_bonus = {
	weapon_trait_bespoke_forcestaff_p2_warp_charge_critical_strike_chance_bonus = {
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
templates.weapon_trait_bespoke_forcestaff_p2_uninterruptable_while_charging = {
	weapon_trait_bespoke_forcestaff_p2_uninterruptable_while_charging = {
		{}
	}
}
templates.weapon_trait_bespoke_forcestaff_p2_faster_charge_on_chained_secondary_attacks = {
	weapon_trait_bespoke_forcestaff_p2_faster_charge_on_chained_secondary_attacks_parent = {
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
templates.weapon_trait_bespoke_forcestaff_p2_burned_targets_receive_rending_debuff = {
	weapon_trait_bespoke_forcestaff_p2_burned_targets_receive_rending_debuff = {
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
templates.weapon_trait_bespoke_forcestaff_p2_chance_to_explode_elites_on_kill = {
	weapon_trait_bespoke_forcestaff_p2_chance_to_explode_elites_on_kill = {
		{
			proc_events = {
				[proc_events.on_kill] = 0.14
			}
		},
		{
			proc_events = {
				[proc_events.on_kill] = 0.16
			}
		},
		{
			proc_events = {
				[proc_events.on_kill] = 0.18
			}
		},
		{
			proc_events = {
				[proc_events.on_kill] = 0.2
			}
		}
	}
}
templates.weapon_trait_bespoke_forcestaff_p2_bonus_melee_damage_on_burninating = {
	weapon_trait_bespoke_forcestaff_p2_bonus_melee_damage_on_burninating = {
		{
			target_buff_data = {
				max_stacks = 10,
				num_stacks_on_proc = 2
			}
		},
		{
			target_buff_data = {
				max_stacks = 15,
				num_stacks_on_proc = 2
			}
		},
		{
			target_buff_data = {
				max_stacks = 20,
				num_stacks_on_proc = 2
			}
		},
		{
			target_buff_data = {
				max_stacks = 25,
				num_stacks_on_proc = 2
			}
		}
	}
}

return templates
