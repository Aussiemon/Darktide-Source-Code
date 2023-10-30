local BuffSettings = require("scripts/settings/buff/buff_settings")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local templates = {}

function _degrees_to_radians(degrees)
	return degrees * 0.0174532925
end

local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
templates.weapon_trait_bespoke_autopistol_p1_stacking_crit_bonus_on_continuous_fire = {
	weapon_trait_bespoke_autopistol_p1_stacking_crit_bonus_on_continuous_fire = {
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.035
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.04
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.045
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.05
			}
		}
	}
}
templates.weapon_trait_bespoke_autopistol_p1_toughness_on_continuous_fire = {
	weapon_trait_bespoke_autopistol_p1_toughness_on_continuous_fire = {
		{
			toughness_fixed_percentage = 0.04
		},
		{
			toughness_fixed_percentage = 0.04
		},
		{
			toughness_fixed_percentage = 0.04
		},
		{
			toughness_fixed_percentage = 0.04
		}
	}
}
templates.weapon_trait_bespoke_autopistol_p1_power_bonus_on_continuous_fire = {
	weapon_trait_bespoke_autopistol_p1_power_bonus_on_continuous_fire = {
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.08
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.08
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.08
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.08
			}
		}
	}
}
templates.weapon_trait_bespoke_autopistol_p1_reload_speed_on_slide = {
	weapon_trait_bespoke_autopistol_p1_reload_speed_on_slide_parent = {
		{
			child_duration = 2,
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.07
			}
		},
		{
			child_duration = 2,
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.08
			}
		},
		{
			child_duration = 2,
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.09
			}
		},
		{
			child_duration = 2,
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.1
			}
		}
	}
}
templates.weapon_trait_bespoke_autopistol_p1_suppression_on_close_kill = {
	weapon_trait_bespoke_autopistol_p1_suppression_on_close_kill = {
		{
			suppression_settings = {
				suppression_falloff = false,
				instant_aggro = true,
				distance = 12,
				suppression_value = 15
			}
		},
		{
			suppression_settings = {
				suppression_falloff = false,
				instant_aggro = true,
				distance = 12,
				suppression_value = 20
			}
		},
		{
			suppression_settings = {
				suppression_falloff = false,
				instant_aggro = true,
				distance = 12,
				suppression_value = 25
			}
		},
		{
			suppression_settings = {
				suppression_falloff = false,
				instant_aggro = true,
				distance = 12,
				suppression_value = 30
			}
		}
	}
}
templates.weapon_trait_bespoke_autopistol_p1_allow_flanking_and_increased_damage_when_flanking = {
	weapon_trait_bespoke_autopistol_p1_allow_flanking_and_increased_damage_when_flanking = {
		{
			stat_buffs = {
				[stat_buffs.flanking_damage] = 0.325
			}
		},
		{
			stat_buffs = {
				[stat_buffs.flanking_damage] = 0.35
			}
		},
		{
			stat_buffs = {
				[stat_buffs.flanking_damage] = 0.375
			}
		},
		{
			stat_buffs = {
				[stat_buffs.flanking_damage] = 0.4
			}
		}
	}
}
templates.weapon_trait_bespoke_autopistol_p1_followup_shots_ranged_damage = {
	weapon_trait_bespoke_autopistol_p1_followup_shots_ranged_damage = {
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_damage] = 0.14
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_damage] = 0.16
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_damage] = 0.18
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_damage] = 0.2
			}
		}
	}
}
templates.weapon_trait_bespoke_autopistol_p1_recoil_reduction_and_suppression_increase_on_close_kills = {
	weapon_trait_bespoke_autopistol_p1_recoil_reduction_and_suppression_increase_on_close_kills = {
		{
			proc_stat_buffs = {
				[stat_buffs.recoil_modifier] = -0.05,
				[stat_buffs.suppression_dealt] = 0.05,
				[stat_buffs.recoil_modifier] = -0.28,
				[stat_buffs.suppression_dealt] = 0.28,
				[stat_buffs.damage_vs_suppressed] = 0.14
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.recoil_modifier] = -0.1,
				[stat_buffs.suppression_dealt] = 0.1,
				[stat_buffs.recoil_modifier] = -0.32,
				[stat_buffs.suppression_dealt] = 0.32,
				[stat_buffs.damage_vs_suppressed] = 0.16
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.recoil_modifier] = -0.15,
				[stat_buffs.suppression_dealt] = 0.15,
				[stat_buffs.recoil_modifier] = -0.36,
				[stat_buffs.suppression_dealt] = 0.36,
				[stat_buffs.damage_vs_suppressed] = 0.18
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.recoil_modifier] = -0.2,
				[stat_buffs.suppression_dealt] = 0.2,
				[stat_buffs.recoil_modifier] = -0.4,
				[stat_buffs.suppression_dealt] = 0.4,
				[stat_buffs.damage_vs_suppressed] = 0.2
			}
		}
	}
}
templates.weapon_trait_bespoke_autopistol_p1_stacking_power_bonus_on_staggering_enemies = {
	weapon_trait_bespoke_autopistol_p1_stacking_power_bonus_on_staggering_enemies_parent = {
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.0425
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.045
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.0475
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.05
			}
		}
	}
}

return templates
