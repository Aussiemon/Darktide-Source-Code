local BuffSettings = require("scripts/settings/buff/buff_settings")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local templates = {}

function _degrees_to_radians(degrees)
	return degrees * 0.0174532925
end

local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
templates.weapon_trait_bespoke_autogun_p1_consecutive_hits_increases_close_damage = {
	weapon_trait_bespoke_autogun_p1_consecutive_hits_increases_close_damage_parent = {
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
templates.weapon_trait_bespoke_autogun_p1_hipfire_while_sprinting = {
	weapon_trait_bespoke_autogun_p1_hipfire_while_sprinting = {
		{}
	}
}
templates.weapon_trait_bespoke_autogun_p1_increase_power_on_close_kill = {
	weapon_trait_bespoke_autogun_p1_increase_power_on_close_kill = {
		{
			active_duration = 1,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.05
			}
		},
		{
			active_duration = 1.2,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.055
			}
		},
		{
			active_duration = 1.3,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.06
			}
		},
		{
			active_duration = 1.375,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.065
			}
		}
	}
}
templates.weapon_trait_bespoke_autogun_p1_increase_close_damage_on_close_kill = {
	weapon_trait_bespoke_autogun_p1_increase_close_damage_on_close_kill = {
		{
			stat_buffs = {
				[stat_buffs.damage_near] = 0.04
			}
		},
		{
			stat_buffs = {
				[stat_buffs.damage_near] = 0.06
			}
		},
		{
			stat_buffs = {
				[stat_buffs.damage_near] = 0.08
			}
		},
		{
			stat_buffs = {
				[stat_buffs.damage_near] = 0.1
			}
		}
	}
}
templates.weapon_trait_bespoke_autogun_p1_increase_damage_on_close_kill = {
	weapon_trait_bespoke_autogun_p1_increase_damage_on_close_kill = {
		{
			stat_buffs = {
				[stat_buffs.damage] = 0.02
			}
		},
		{
			stat_buffs = {
				[stat_buffs.damage] = 0.03
			}
		},
		{
			stat_buffs = {
				[stat_buffs.damage] = 0.04
			}
		},
		{
			stat_buffs = {
				[stat_buffs.damage] = 0.05
			}
		}
	}
}
templates.weapon_trait_bespoke_autogun_p1_suppression_on_close_kill = {
	weapon_trait_bespoke_autogun_p1_suppression_on_close_kill = {
		{
			suppression_settings = {
				suppression_falloff = true,
				instant_aggro = true,
				distance = 5,
				suppression_value = 10
			}
		},
		{
			suppression_settings = {
				suppression_falloff = true,
				instant_aggro = true,
				distance = 6,
				suppression_value = 15
			}
		},
		{
			suppression_settings = {
				suppression_falloff = true,
				instant_aggro = true,
				distance = 7,
				suppression_value = 20
			}
		},
		{
			suppression_settings = {
				suppression_falloff = true,
				instant_aggro = true,
				distance = 8,
				suppression_value = 25
			}
		}
	}
}
templates.weapon_trait_bespoke_autogun_p1_count_as_dodge_vs_ranged_on_close_kill = {
	weapon_trait_bespoke_autogun_p1_count_as_dodge_vs_ranged_on_close_kill = {
		{
			active_duration = 0.4
		},
		{
			active_duration = 0.5
		},
		{
			active_duration = 0.6
		},
		{
			active_duration = 0.7
		}
	}
}
templates.weapon_trait_bespoke_autogun_p1_reload_speed_on_dodge = {
	weapon_trait_bespoke_autogun_p1_reload_speed_on_dodge = {
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.35
			}
		},
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.425
			}
		},
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.475
			}
		},
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.5
			}
		}
	}
}
templates.weapon_trait_bespoke_autogun_p1_reload_speed_on_slide = {
	weapon_trait_bespoke_autogun_p1_reload_speed_on_slide = {
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
templates.weapon_trait_bespoke_autogun_p1_allow_flanking_and_increased_damage_when_flanking = {
	weapon_trait_bespoke_autogun_p1_allow_flanking_and_increased_damage_when_flanking = {
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
templates.weapon_trait_bespoke_autogun_p1_increased_sprint_speed = {
	weapon_trait_bespoke_autogun_p1_increased_sprint_speed = {
		{
			stat_buffs = {
				[stat_buffs.sprint_movement_speed] = 1.03
			}
		},
		{
			stat_buffs = {
				[stat_buffs.sprint_movement_speed] = 1.05
			}
		},
		{
			stat_buffs = {
				[stat_buffs.sprint_movement_speed] = 1.07
			}
		},
		{
			stat_buffs = {
				[stat_buffs.sprint_movement_speed] = 1.09
			}
		}
	}
}
templates.weapon_trait_bespoke_autogun_p1_followup_shots_ranged_damage = {
	weapon_trait_bespoke_autogun_p1_followup_shots_ranged_damage = {
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
templates.weapon_trait_bespoke_autogun_p1_followup_shots_ranged_weakspot_damage = {
	weapon_trait_bespoke_autogun_p1_followup_shots_ranged_weakspot_damage = {
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_weakspot_damage] = 0.05
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_weakspot_damage] = 0.1
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_weakspot_damage] = 0.15
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_weakspot_damage] = 0.2
			}
		}
	}
}
templates.weapon_trait_bespoke_autogun_p1_improved_sprint_dodge = {
	weapon_trait_bespoke_autogun_p1_improved_sprint_dodge = {
		{
			proc_stat_buffs = {
				[stat_buffs.sprint_movement_speed] = 1.1
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.sprint_movement_speed] = 1.125
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.sprint_movement_speed] = 1.15
			},
			conditional_stat_buffs = {
				[stat_buffs.sprint_dodge_reduce_angle_threshold_rad] = _degrees_to_radians(10)
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.sprint_movement_speed] = 1.15
			},
			conditional_stat_buffs = {
				[stat_buffs.sprint_dodge_reduce_angle_threshold_rad] = _degrees_to_radians(10)
			}
		}
	}
}

return templates
