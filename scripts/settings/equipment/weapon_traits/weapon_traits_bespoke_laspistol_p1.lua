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
				[stat_buffs.reload_speed] = 0.04
			}
		},
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.06
			}
		},
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.08
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
				max_stacks = 6,
				num_stacks_on_proc = 2
			}
		},
		[4] = {
			dot_data = {
				max_stacks = 9,
				num_stacks_on_proc = 3
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
				[stat_buffs.flanking_damage] = 0.2
			}
		},
		{
			stat_buffs = {
				[stat_buffs.flanking_damage] = 0.25
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
			active_duration = 0.6
		},
		{
			active_duration = 0.7
		},
		{
			active_duration = 0.8
		},
		{
			active_duration = 0.9
		}
	}
}
templates.weapon_trait_bespoke_laspistol_p1_count_as_dodge_vs_ranged_on_weakspot = {
	weapon_trait_bespoke_laspistol_p1_count_as_dodge_vs_ranged_on_weakspot = {
		{
			active_duration = 0.4
		},
		{
			active_duration = 0.6
		},
		{
			active_duration = 0.8
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

return templates
