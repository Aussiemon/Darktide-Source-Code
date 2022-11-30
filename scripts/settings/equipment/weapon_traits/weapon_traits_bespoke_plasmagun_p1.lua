local BuffSettings = require("scripts/settings/buff/buff_settings")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
templates.weapon_trait_bespoke_plasmagun_p1_toughness_on_elite_kills = {
	weapon_trait_bespoke_plasmagun_p1_toughness_on_elite_kills = {
		{
			toughness_fixed_percentage = 0.04
		},
		{
			toughness_fixed_percentage = 0.06
		},
		{
			toughness_fixed_percentage = 0.08
		},
		{
			toughness_fixed_percentage = 0.1
		}
	}
}
templates.weapon_trait_bespoke_plasmagun_p1_targets_receive_rending_debuff = {
	weapon_trait_bespoke_plasmagun_p1_targets_receive_rending_debuff = {
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
templates.weapon_trait_bespoke_plasmagun_p1_power_bonus_on_continuous_fire = {
	weapon_trait_bespoke_plasmagun_p1_power_bonus_on_continuous_fire = {
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.02
			}
		}
	}
}
templates.weapon_trait_bespoke_plasmagun_p1_lower_overheat_gives_faster_charge = {
	weapon_trait_bespoke_plasmagun_p1_lower_overheat_gives_faster_charge = {
		{
			stat_buffs = {
				[stat_buffs.charge_up_time] = -0.01
			}
		},
		{
			stat_buffs = {
				[stat_buffs.charge_up_time] = -0.02
			}
		},
		{
			stat_buffs = {
				[stat_buffs.charge_up_time] = -0.03
			}
		},
		{
			stat_buffs = {
				[stat_buffs.charge_up_time] = -0.04
			}
		}
	}
}
templates.weapon_trait_bespoke_plasmagun_p1_crit_chance_scaled_on_heat = {
	weapon_trait_bespoke_plasmagun_p1_crit_chance_scaled_on_heat = {
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.01
			}
		},
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
		}
	}
}

return templates
