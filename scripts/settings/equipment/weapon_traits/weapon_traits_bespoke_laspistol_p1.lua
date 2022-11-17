local BuffSettings = require("scripts/settings/buff/buff_settings")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
templates.weapon_trait_bespoke_laspistol_p1_hipfire_while_sprinting = {
	weapon_trait_bespoke_laspistol_p1_hipfire_while_sprinting = {
		{}
	}
}
templates.weapon_trait_bespoke_laspistol_p1_reload_speed_on_slide = {
	weapon_trait_bespoke_laspistol_p1_reload_speed_on_slide = {
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.05
			}
		},
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.075
			}
		},
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.09
			}
		},
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.1
			}
		}
	}
}
templates.weapon_trait_bespoke_laspistol_p1_burninating_on_crit = {
	weapon_trait_bespoke_laspistol_p1_burninating_on_crit = {
		{
			dot_data = {
				num_stacks_on_proc = 2
			}
		},
		{
			dot_data = {
				num_stacks_on_proc = 4
			}
		}
	}
}
templates.weapon_trait_bespoke_laspistol_p1_allow_flanking_and_increased_damage_when_flanking = {
	weapon_trait_bespoke_laspistol_p1_allow_flanking_and_increased_damage_when_flanking = {
		{
			stat_buffs = {
				[stat_buffs.flanking_damage] = 0.15
			}
		},
		{
			stat_buffs = {
				[stat_buffs.flanking_damage] = 0.225
			}
		},
		{
			stat_buffs = {
				[stat_buffs.flanking_damage] = 0.275
			}
		},
		{
			stat_buffs = {
				[stat_buffs.flanking_damage] = 0.3
			}
		}
	}
}
templates.weapon_trait_bespoke_laspistol_p1_suppression_negation_on_weakspot = {
	weapon_trait_bespoke_laspistol_p1_suppression_negation_on_weakspot = {
		{
			active_duration = 0.5
		},
		{
			active_duration = 0.7
		},
		{
			active_duration = 0.85
		},
		{
			active_duration = 0.9
		}
	}
}
templates.weapon_trait_bespoke_laspistol_p1_count_as_dodge_vs_ranged_on_weakspot = {
	weapon_trait_bespoke_laspistol_p1_count_as_dodge_vs_ranged_on_weakspot = {
		{
			active_duration = 0.5
		},
		{
			active_duration = 0.75
		},
		{
			active_duration = 0.9
		},
		{
			active_duration = 1
		}
	}
}
templates.weapon_trait_bespoke_laspistol_p1_consecutive_hits_increases_close_damage = {
	weapon_trait_bespoke_laspistol_p1_consecutive_hits_increases_close_damage_parent = {
		{
			stat_buffs = {
				[stat_buffs.damage_near] = 0.01
			}
		},
		{
			stat_buffs = {
				[stat_buffs.damage_near] = 0.015
			}
		},
		{
			stat_buffs = {
				[stat_buffs.damage_near] = 0.02
			}
		},
		{
			stat_buffs = {
				[stat_buffs.damage_near] = 0.025
			}
		}
	}
}
templates.weapon_trait_bespoke_laspistol_p1_toughness_on_crit_kills = {
	weapon_trait_bespoke_laspistol_p1_toughness_on_crit_kills = {
		{
			toughness_fixed_percentage = 0.05
		},
		{
			toughness_fixed_percentage = 0.065
		},
		{
			toughness_fixed_percentage = 0.085
		},
		{
			toughness_fixed_percentage = 0.1
		}
	}
}

return templates
