local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
templates.weapon_trait_bespoke_powersword_p1_chained_hits_increases_melee_cleave = {
	weapon_trait_bespoke_powersword_p1_chained_hits_increases_melee_cleave_parent = {
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.1
			}
		},
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.15
			}
		},
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.175
			}
		},
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.2
			}
		}
	}
}
templates.weapon_trait_bespoke_powersword_p1_increased_melee_damage_on_multiple_hits = {
	weapon_trait_bespoke_powersword_p1_increased_melee_damage_on_multiple_hits = {
		{
			buff_data = {
				required_num_hits = 3
			},
			stat_buffs = {
				[stat_buffs.melee_damage] = 0.1
			}
		},
		{
			buff_data = {
				required_num_hits = 3
			},
			stat_buffs = {
				[stat_buffs.melee_damage] = 0.15
			}
		},
		{
			buff_data = {
				required_num_hits = 3
			},
			stat_buffs = {
				[stat_buffs.melee_damage] = 0.175
			}
		},
		{
			buff_data = {
				required_num_hits = 3
			},
			stat_buffs = {
				[stat_buffs.melee_damage] = 0.2
			}
		}
	}
}
templates.weapon_trait_bespoke_powersword_p1_infinite_melee_cleave_on_weakspot_kill = {
	weapon_trait_bespoke_powersword_p1_infinite_melee_cleave_on_weakspot_kill = {
		{
			active_duration = 2
		},
		{
			active_duration = 3
		},
		{
			active_duration = 3.5
		},
		{
			active_duration = 4
		}
	}
}
templates.weapon_trait_bespoke_powersword_p1_increase_power_on_kill = {
	weapon_trait_bespoke_powersword_p1_increase_power_on_kill_parent = {
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
templates.weapon_trait_bespoke_powersword_p1_targets_receive_rending_debuff_on_weapon_special_attacks = {
	weapon_trait_bespoke_powersword_p1_targets_receive_rending_debuff_on_weapon_special_attacks = {
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
templates.weapon_trait_bespoke_powersword_p1_pass_past_armor_on_weapon_special = {
	weapon_trait_bespoke_powersword_p1_pass_past_armor_on_weapon_special = {
		{}
	}
}
templates.weapon_trait_bespoke_powersword_p1_extended_activation_duration_on_chained_attacks = {
	weapon_trait_bespoke_powersword_p1_extended_activation_duration_on_chained_attacks = {
		{}
	}
}

return templates
