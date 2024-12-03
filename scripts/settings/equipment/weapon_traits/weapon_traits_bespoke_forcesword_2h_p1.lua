-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_forcesword_2h_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_forcesword_2h_p1_guaranteed_melee_crit_on_activated_kill = {
	buffs = {
		weapon_trait_bespoke_forcesword_2h_p1_guaranteed_melee_crit_on_activated_kill = {
			{
				buff_data = {
					num_stacks_on_proc = 4,
				},
			},
			{
				buff_data = {
					num_stacks_on_proc = 6,
				},
			},
			{
				buff_data = {
					num_stacks_on_proc = 8,
				},
			},
			{
				buff_data = {
					num_stacks_on_proc = 10,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_forcesword_2h_p1_warp_charge_power_bonus = {
	buffs = {
		weapon_trait_bespoke_forcesword_2h_p1_warp_charge_power_bonus = {
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.035,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.04,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.045,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.05,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_forcesword_2h_p1_can_block_ranged = {
	buffs = {
		weapon_trait_bespoke_forcesword_2h_p1_can_block_ranged = {
			{
				stat_buffs = {
					[stat_buffs.block_cost_multiplier] = 0.775,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.block_cost_multiplier] = 0.75,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.block_cost_multiplier] = 0.725,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.block_cost_multiplier] = 0.7,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_forcesword_2h_p1_warp_burninating_on_crit = {
	buffs = {
		weapon_trait_bespoke_forcesword_2h_p1_warp_burninating_on_crit = {
			{
				target_buff_data = {
					max_stacks = 3,
					num_stacks_on_proc = 1,
				},
			},
			{
				target_buff_data = {
					max_stacks = 6,
					num_stacks_on_proc = 2,
				},
			},
			{
				target_buff_data = {
					max_stacks = 9,
					num_stacks_on_proc = 3,
				},
			},
			{
				target_buff_data = {
					max_stacks = 12,
					num_stacks_on_proc = 4,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_forcesword_2h_p1_wind_slash_crits = {
	buffs = {
		weapon_trait_bespoke_forcesword_2h_p1_wind_slash_crits = {
			{
				cooldown_duration = 30,
			},
			{
				cooldown_duration = 25,
			},
			{
				cooldown_duration = 20,
			},
			{
				cooldown_duration = 15,
			},
		},
	},
}
templates.weapon_trait_bespoke_forcesword_2h_p1_increased_attack_cleave_on_multiple_hits = {
	buffs = {
		weapon_trait_bespoke_forcesword_2h_p1_increased_attack_cleave_on_multiple_hits = {
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 1.4,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 1.6,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 1.8,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 2,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_forcesword_2h_p1_chained_hits_increases_melee_cleave = {
	buffs = {
		weapon_trait_bespoke_forcesword_2h_p1_chained_hits_increases_melee_cleave_parent = {
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.25,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.3,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.35,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.4,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_forcesword_2h_p1_dodge_grants_finesse_bonus = {
	buffs = {
		weapon_trait_bespoke_forcesword_2h_p1_dodge_grants_finesse_bonus = {
			{
				active_duration = 2,
				proc_stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.45,
				},
			},
			{
				active_duration = 2,
				proc_stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.5,
				},
			},
			{
				active_duration = 2,
				proc_stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.55,
				},
			},
			{
				active_duration = 2,
				proc_stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.6,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_forcesword_2h_p1_dodge_grants_critical_strike_chance = {
	buffs = {
		weapon_trait_bespoke_forcesword_2h_p1_dodge_grants_critical_strike_chance = {
			{
				proc_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.125,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.15,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.175,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.2,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_forcesword_2h_p1_vent_warp_charge_on_multiple_hits = {
	buffs = {
		weapon_trait_bespoke_forcesword_2h_p1_vent_warp_charge_on_multiple_hits = {
			{
				vent_percentage = 0.02,
			},
			{
				vent_percentage = 0.03,
			},
			{
				vent_percentage = 0.04,
			},
			{
				vent_percentage = 0.05,
			},
		},
	},
}
templates.weapon_trait_bespoke_forcesword_2h_p1_toughness_recovery_on_multiple_hits = {
	buffs = {
		weapon_trait_bespoke_forcesword_2h_p1_toughness_recovery_on_multiple_hits = {
			{
				buff_data = {
					replenish_percentage = 0.12,
					required_num_hits = 3,
				},
			},
			{
				buff_data = {
					replenish_percentage = 0.13,
					required_num_hits = 3,
				},
			},
			{
				buff_data = {
					replenish_percentage = 0.14,
					required_num_hits = 3,
				},
			},
			{
				buff_data = {
					replenish_percentage = 0.15,
					required_num_hits = 3,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_forcesword_2h_p1_chained_hits_increases_crit_chance = {
	buffs = {
		weapon_trait_bespoke_forcesword_2h_p1_chained_hits_increases_crit_chance_parent = {
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.025,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.03,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.035,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.04,
				},
			},
		},
	},
}

return templates
