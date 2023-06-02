local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_power_bonus_on_continuous_fire = {
	weapon_trait_bespoke_ogryn_gauntlet_p1_power_bonus_on_continuous_fire = {
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.1
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_toughness_on_elite_kills = {
	weapon_trait_bespoke_ogryn_gauntlet_p1_toughness_on_elite_kills = {
		{
			toughness_fixed_percentage = 0.1
		},
		{
			toughness_fixed_percentage = 0.17
		},
		{
			toughness_fixed_percentage = 0.24
		},
		{
			toughness_fixed_percentage = 0.3
		}
	}
}
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_toughness_on_crit_kills = {
	weapon_trait_bespoke_ogryn_gauntlet_p1_toughness_on_crit_kills = {
		{
			toughness_fixed_percentage = 0.15
		},
		{
			toughness_fixed_percentage = 0.2
		},
		{
			toughness_fixed_percentage = 0.25
		},
		{
			toughness_fixed_percentage = 0.3
		}
	}
}
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_windup_increases_power = {
	weapon_trait_bespoke_ogryn_gauntlet_p1_windup_increases_power_parent = {
		{
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.05
			}
		},
		{
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.1
			}
		},
		{
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.15
			}
		},
		{
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.2
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_targets_receive_rending_debuff = {
	weapon_trait_bespoke_ogryn_gauntlet_p1_targets_receive_rending_debuff = {
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
