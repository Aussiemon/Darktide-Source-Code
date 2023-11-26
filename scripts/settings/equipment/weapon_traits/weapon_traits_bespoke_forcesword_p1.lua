-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_forcesword_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_forcesword_p1_guaranteed_melee_crit_on_activated_kill = {
	weapon_trait_bespoke_forcesword_p1_guaranteed_melee_crit_on_activated_kill = {
		{}
	}
}
templates.weapon_trait_bespoke_forcesword_p1_can_block_ranged = {
	weapon_trait_bespoke_forcesword_p1_can_block_ranged = {
		{
			stat_buffs = {
				[stat_buffs.block_cost_ranged_multiplier] = 0.775
			}
		},
		{
			stat_buffs = {
				[stat_buffs.block_cost_ranged_multiplier] = 0.75
			}
		},
		{
			stat_buffs = {
				[stat_buffs.block_cost_ranged_multiplier] = 0.725
			}
		},
		{
			stat_buffs = {
				[stat_buffs.block_cost_ranged_multiplier] = 0.7
			}
		}
	}
}
templates.weapon_trait_bespoke_forcesword_p1_warp_charge_power_bonus = {
	weapon_trait_bespoke_forcesword_p1_warp_charge_power_bonus = {
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.035
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.04
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
templates.weapon_trait_bespoke_forcesword_p1_stacking_rending_on_weakspot = {
	weapon_trait_bespoke_forcesword_p1_stacking_rending_on_weakspot_parent = {
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.rending_multiplier] = 0.12
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.rending_multiplier] = 0.16
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.rending_multiplier] = 0.2
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.rending_multiplier] = 0.24
			}
		}
	}
}
templates.weapon_trait_bespoke_forcesword_p1_increase_power_on_kill = {
	weapon_trait_bespoke_forcesword_p1_increase_power_on_kill_parent = {
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.05
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.06
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.07
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.08
			}
		}
	}
}
templates.weapon_trait_bespoke_forcesword_p1_dodge_grants_finesse_bonus = {
	weapon_trait_bespoke_forcesword_p1_dodge_grants_finesse_bonus = {
		{
			active_duration = 2,
			proc_stat_buffs = {
				[stat_buffs.finesse_modifier_bonus] = 0.45
			}
		},
		{
			active_duration = 2,
			proc_stat_buffs = {
				[stat_buffs.finesse_modifier_bonus] = 0.5
			}
		},
		{
			active_duration = 2,
			proc_stat_buffs = {
				[stat_buffs.finesse_modifier_bonus] = 0.55
			}
		},
		{
			active_duration = 2,
			proc_stat_buffs = {
				[stat_buffs.finesse_modifier_bonus] = 0.6
			}
		}
	}
}
templates.weapon_trait_bespoke_forcesword_p1_dodge_grants_critical_strike_chance = {
	weapon_trait_bespoke_forcesword_p1_dodge_grants_critical_strike_chance = {
		{
			proc_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.125
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.15
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.175
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.2
			}
		}
	}
}
templates.weapon_trait_bespoke_forcesword_p1_elite_kills_grants_stackable_power = {
	weapon_trait_bespoke_forcesword_p1_elite_kills_grants_stackable_power_parent = {
		{}
	}
}
templates.weapon_trait_bespoke_forcesword_p1_chained_hits_increases_crit_chance = {
	weapon_trait_bespoke_forcesword_p1_chained_hits_increases_crit_chance_parent = {
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.025
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.03
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.035
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.04
			}
		}
	}
}
templates.weapon_trait_bespoke_forcesword_p1_chained_weakspot_hits_increases_power = {
	weapon_trait_bespoke_forcesword_p1_chained_weakspot_hits_increases_power_parent = {
		{
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.045
			}
		},
		{
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.05
			}
		},
		{
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.055
			}
		},
		{
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.06
			}
		}
	}
}
templates.weapon_trait_bespoke_forcesword_p1_chained_hits_vents_warpcharge = {
	weapon_trait_bespoke_forcesword_p1_chained_hits_vents_warpcharge = {
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
templates.weapon_trait_bespoke_forcesword_p1_warp_burninating_on_crit = {
	weapon_trait_bespoke_forcesword_p1_warp_burninating_on_crit = {
		{
			target_buff_data = {
				max_stacks = 10,
				num_stacks_on_proc = 2
			}
		},
		[4] = {
			target_buff_data = {
				max_stacks = 12,
				num_stacks_on_proc = 4
			}
		}
	}
}

return templates
