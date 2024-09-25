-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_chainsword_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_chainsword_p1_increased_attack_cleave_on_multiple_hits = {
	buffs = {
		weapon_trait_bespoke_chainsword_p1_increased_attack_cleave_on_multiple_hits = {
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
templates.weapon_trait_bespoke_chainsword_p1_increased_melee_damage_on_multiple_hits = {
	buffs = {
		weapon_trait_bespoke_chainsword_p1_increased_melee_damage_on_multiple_hits = {
			{
				active_duration = 3.5,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.24,
				},
			},
			{
				active_duration = 3.5,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.28,
				},
			},
			{
				active_duration = 3.5,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.32,
				},
			},
			{
				active_duration = 3.5,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.36,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_chainsword_p1_infinite_melee_cleave_on_crit = {
	buffs = {
		weapon_trait_bespoke_chainsword_p1_infinite_melee_cleave_on_crit = {
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.65,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.7,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.75,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.8,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_chainsword_p1_chained_hits_increases_melee_cleave = {
	buffs = {
		weapon_trait_bespoke_chainsword_p1_chained_hits_increases_melee_cleave_parent = {
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
templates.weapon_trait_bespoke_chainsword_p1_chained_hits_increases_crit_chance = {
	buffs = {
		weapon_trait_bespoke_chainsword_p1_chained_hits_increases_crit_chance_parent = {
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
templates.weapon_trait_bespoke_chainsword_p1_guaranteed_melee_crit_on_activated_kill = {
	buffs = {
		weapon_trait_bespoke_chainsword_p1_guaranteed_melee_crit_on_activated_kill = {
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
templates.weapon_trait_bespoke_chainsword_p1_bleed_on_activated_hit = {
	buffs = {
		weapon_trait_bespoke_chainsword_p1_bleed_on_activated_hit = {
			{
				target_buff_data = {
					num_stacks_on_proc = 11,
				},
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 12,
				},
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 13,
				},
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 14,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_chainsword_p1_movement_speed_on_activation = {
	buffs = {
		weapon_trait_bespoke_chainsword_p1_movement_speed_on_activation = {
			{
				active_duration = 2,
				stat_buffs = {
					[stat_buffs.movement_speed] = 0.17,
				},
			},
			{
				active_duration = 2,
				stat_buffs = {
					[stat_buffs.movement_speed] = 0.18,
				},
			},
			{
				active_duration = 2,
				stat_buffs = {
					[stat_buffs.movement_speed] = 0.19,
				},
			},
			{
				active_duration = 2,
				stat_buffs = {
					[stat_buffs.movement_speed] = 0.2,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_chainsword_p1_movement_speed_on_activated_hit = {
	buffs = {
		weapon_trait_bespoke_chainsword_p1_movement_speed_on_activated_hit = {
			{
				stat_buffs = {
					[stat_buffs.movement_speed] = 0.125,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.movement_speed] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.movement_speed] = 0.175,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.movement_speed] = 0.2,
				},
			},
		},
	},
}

return templates
