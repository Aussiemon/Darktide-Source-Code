local BuffSettings = require("scripts/settings/buff/buff_settings")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
templates.weapon_trait_bespoke_lasgun_p2_burninating_on_crit = {
	weapon_trait_bespoke_lasgun_p2_burninating_on_crit = {
		{
			target_buff_data = {
				max_stacks = 6,
				num_stacks_on_proc = 2
			}
		},
		[4] = {
			target_buff_data = {
				max_stacks = 9,
				num_stacks_on_proc = 3
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p2_negate_stagger_reduction_on_weakspot = {
	weapon_trait_bespoke_lasgun_p2_negate_stagger_reduction_on_weakspot = {
		{
			stat_buffs = {
				[stat_buffs.stagger_weakspot_reduction_modifier] = 0.7
			}
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_weakspot_reduction_modifier] = 0.6
			}
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_weakspot_reduction_modifier] = 0.5
			}
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_weakspot_reduction_modifier] = 0.4
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p2_crit_chance_based_on_aim_time = {
	weapon_trait_bespoke_lasgun_p2_crit_chance_based_on_aim_time = {
		{
			duration_per_stack = 0.35,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.02
			}
		},
		{
			duration_per_stack = 0.35,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.03
			}
		},
		{
			duration_per_stack = 0.35,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.04
			}
		},
		{
			duration_per_stack = 0.35,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.05
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p2_followup_shots_ranged_damage = {
	weapon_trait_bespoke_lasgun_p2_followup_shots_ranged_damage = {
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_damage] = 0.06
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_damage] = 0.09
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_damage] = 0.12
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_damage] = 0.15
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p2_stagger_count_bonus_damage = {
	weapon_trait_bespoke_lasgun_p2_stagger_count_bonus_damage = {
		{
			stat_buffs = {
				[stat_buffs.stagger_count_damage] = 0.125
			}
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_count_damage] = 0.15
			}
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_count_damage] = 0.175
			}
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_count_damage] = 0.2
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p2_faster_charge_on_chained_secondary_attacks = {
	weapon_trait_bespoke_lasgun_p2_faster_charge_on_chained_secondary_attacks = {
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

return templates
