-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_combatsword_p3.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events

templates.weapon_trait_bespoke_combatsword_p3_chained_hits_increases_crit_chance = {
	weapon_trait_bespoke_combatsword_p3_chained_hits_increases_crit_chance_parent = {
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.025
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.03
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.035
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.04
			}
		}
	}
}
templates.weapon_trait_bespoke_combatsword_p3_stacking_rending_on_weakspot = {
	weapon_trait_bespoke_combatsword_p3_stacking_rending_on_weakspot_parent = {
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.rending_multiplier] = 0.12
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.rending_multiplier] = 0.16
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.rending_multiplier] = 0.2
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.rending_multiplier] = 0.24
			}
		}
	}
}
templates.weapon_trait_bespoke_combatsword_p3_dodge_grants_finesse_bonus = {
	weapon_trait_bespoke_combatsword_p3_dodge_grants_finesse_bonus = {
		{
			active_duration = 2,
			proc_stat_buffs = {
				[stat_buffs.finesse_modifier_bonus] = 0.45
			}
		},
		{
			active_duration = 2,
			proc_stat_buffs = {
				[stat_buffs.finesse_modifier_bonus] = 0.5
			}
		},
		{
			active_duration = 2,
			proc_stat_buffs = {
				[stat_buffs.finesse_modifier_bonus] = 0.55
			}
		},
		{
			active_duration = 2,
			proc_stat_buffs = {
				[stat_buffs.finesse_modifier_bonus] = 0.6
			}
		}
	}
}
templates.weapon_trait_bespoke_combatsword_p3_dodge_grants_critical_strike_chance = {
	weapon_trait_bespoke_combatsword_p3_dodge_grants_critical_strike_chance = {
		{
			proc_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.125
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.15
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.175
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.2
			}
		}
	}
}
templates.weapon_trait_bespoke_combatsword_p3_increased_melee_damage_on_multiple_hits = {
	weapon_trait_bespoke_combatsword_p3_increased_melee_damage_on_multiple_hits = {
		{
			active_duration = 3.5,
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.24
			}
		},
		{
			active_duration = 3.5,
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.28
			}
		},
		{
			active_duration = 3.5,
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.32
			}
		},
		{
			active_duration = 3.5,
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.36
			}
		}
	}
}
templates.weapon_trait_bespoke_combatsword_p3_windup_increases_power = {
	weapon_trait_bespoke_combatsword_p3_windup_increases_power_parent = {
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
templates.weapon_trait_bespoke_combatsword_p3_consecutive_melee_hits_increases_melee_power = {
	weapon_trait_bespoke_combatsword_p3_consecutive_melee_hits_increases_melee_power_parent = {
		{
			child_duration = 2,
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.04
			}
		},
		{
			child_duration = 2,
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.06
			}
		},
		{
			child_duration = 2,
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.08
			}
		},
		{
			child_duration = 2,
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.1
			}
		}
	}
}
templates.weapon_trait_bespoke_combatsword_p3_weakspot_hit_resets_dodge_count = {
	weapon_trait_bespoke_combatsword_p3_weakspot_hit_resets_dodge_count = {
		{}
	}
}

return templates
