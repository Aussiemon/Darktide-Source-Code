local BuffSettings = require("scripts/settings/buff/buff_settings")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
templates.weapon_trait_bespoke_combatsword_p3_chained_hits_increases_crit_chance = {
	weapon_trait_bespoke_combatsword_p3_chained_hits_increases_crit_chance_parent = {
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.02
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.035
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
templates.weapon_trait_bespoke_combatsword_p3_stacking_rending_on_weakspot = {
	weapon_trait_bespoke_combatsword_p3_stacking_rending_on_weakspot_parent = {
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.rending_multiplier] = 0.06
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.rending_multiplier] = 0.12
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.rending_multiplier] = 0.17
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.rending_multiplier] = 0.2
			}
		}
	}
}
templates.weapon_trait_bespoke_combatsword_p3_dodge_grants_finesse_bonus = {
	weapon_trait_bespoke_combatsword_p3_dodge_grants_finesse_bonus = {
		{
			proc_stat_buffs = {
				[stat_buffs.finesse_modifier_bonus] = 0.02
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.finesse_modifier_bonus] = 0.035
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.finesse_modifier_bonus] = 0.045
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.finesse_modifier_bonus] = 0.05
			}
		}
	}
}
templates.weapon_trait_bespoke_combatsword_p3_dodge_grants_critical_strike_chance = {
	weapon_trait_bespoke_combatsword_p3_dodge_grants_critical_strike_chance = {
		{
			proc_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.02
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.035
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.045
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.05
			}
		}
	}
}
templates.weapon_trait_bespoke_combatsword_p3_increased_melee_damage_on_multiple_hits = {
	weapon_trait_bespoke_combatsword_p3_increased_melee_damage_on_multiple_hits = {
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

return templates
