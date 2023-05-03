local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
templates.weapon_trait_bespoke_chainaxe_p1_guaranteed_melee_crit_on_activated_kill = {
	weapon_trait_bespoke_chainaxe_p1_guaranteed_melee_crit_on_activated_kill = {
		{}
	}
}
templates.weapon_trait_bespoke_chainaxe_p1_bleed_on_activated_hit = {
	weapon_trait_bespoke_chainaxe_p1_bleed_on_activated_hit = {
		{
			target_buff_data = {
				num_stacks_on_proc = 8
			}
		},
		{
			target_buff_data = {
				num_stacks_on_proc = 10
			}
		},
		{
			target_buff_data = {
				num_stacks_on_proc = 12
			}
		},
		{
			target_buff_data = {
				num_stacks_on_proc = 14
			}
		}
	}
}
templates.weapon_trait_bespoke_chainaxe_p1_movement_speed_on_activation = {
	weapon_trait_bespoke_chainaxe_p1_movement_speed_on_activation = {
		{
			active_duration = 3,
			stat_buffs = {
				[stat_buffs.movement_speed] = 1.075
			}
		},
		{
			active_duration = 3,
			stat_buffs = {
				[stat_buffs.movement_speed] = 1.1
			}
		},
		{
			active_duration = 3,
			stat_buffs = {
				[stat_buffs.movement_speed] = 1.125
			}
		},
		{
			active_duration = 3,
			stat_buffs = {
				[stat_buffs.movement_speed] = 1.15
			}
		}
	}
}
templates.weapon_trait_bespoke_chainaxe_p1_increase_power_on_hit = {
	weapon_trait_bespoke_chainaxe_p1_increase_power_on_hit_parent = {
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
templates.weapon_trait_bespoke_chainaxe_p1_increase_power_on_kill = {
	weapon_trait_bespoke_chainaxe_p1_increase_power_on_kill_parent = {
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.075
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.1
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.125
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.15
			}
		}
	}
}
templates.weapon_trait_bespoke_chainaxe_p1_windup_increases_power = {
	weapon_trait_bespoke_chainaxe_p1_windup_increases_power_parent = {
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.05
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.1
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.15
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.2
			}
		}
	}
}
templates.weapon_trait_bespoke_chainaxe_p1_targets_receive_rending_debuff = {
	weapon_trait_bespoke_chainaxe_p1_targets_receive_rending_debuff = {
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
