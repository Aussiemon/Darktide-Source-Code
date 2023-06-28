local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
templates.weapon_trait_bespoke_flamer_p1_toughness_on_continuous_fire = {
	weapon_trait_bespoke_flamer_p1_toughness_on_continuous_fire = {
		{
			toughness_fixed_percentage = 0.04
		}
	}
}
templates.weapon_trait_bespoke_flamer_p1_power_bonus_on_continuous_fire = {
	weapon_trait_bespoke_flamer_p1_power_bonus_on_continuous_fire = {
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.1
			}
		}
	}
}
templates.weapon_trait_bespoke_flamer_p1_faster_reload_on_empty_clip = {
	weapon_trait_bespoke_flamer_p1_faster_reload_on_empty_clip = {
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.18
			}
		},
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.2
			}
		},
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.22
			}
		},
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.24
			}
		}
	}
}
templates.weapon_trait_bespoke_flamer_p1_power_scales_with_clip_percentage = {
	weapon_trait_bespoke_flamer_p1_power_scales_with_clip_percentage = {
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
templates.weapon_trait_bespoke_flamer_p1_negate_stagger_reduction_with_primary_on_burning = {
	weapon_trait_bespoke_flamer_p1_negate_stagger_reduction_with_primary_on_burning = {
		{
			conditional_stat_buffs = {
				[stat_buffs.stagger_burning_reduction_modifier] = 0.7
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.stagger_burning_reduction_modifier] = 0.6
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.stagger_burning_reduction_modifier] = 0.5
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.stagger_burning_reduction_modifier] = 0.4
			}
		}
	}
}
templates.weapon_trait_bespoke_flamer_p1_chance_to_explode_elites_on_kill = {
	weapon_trait_bespoke_flamer_p1_chance_to_explode_elites_on_kill = {
		{
			proc_events = {
				[proc_events.on_minion_death] = 0.05
			}
		},
		{
			proc_events = {
				[proc_events.on_minion_death] = 0.1
			}
		},
		{
			proc_events = {
				[proc_events.on_minion_death] = 0.15
			}
		},
		{
			proc_events = {
				[proc_events.on_minion_death] = 0.2
			}
		}
	}
}

return templates
