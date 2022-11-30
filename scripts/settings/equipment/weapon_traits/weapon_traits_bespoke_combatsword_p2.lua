local BuffSettings = require("scripts/settings/buff/buff_settings")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
templates.weapon_trait_bespoke_combatsword_p2_increased_attack_cleave_on_multiple_hits = {
	weapon_trait_bespoke_combatsword_p2_increased_attack_cleave_on_multiple_hits = {
		{
			buff_data = {
				required_num_hits = 3
			},
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 1
			}
		},
		{
			buff_data = {
				required_num_hits = 3
			},
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 1.5
			}
		},
		{
			buff_data = {
				required_num_hits = 3
			},
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 1.75
			}
		},
		{
			buff_data = {
				required_num_hits = 3
			},
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 2
			}
		}
	}
}
templates.weapon_trait_bespoke_combatsword_p2_increased_melee_damage_on_multiple_hits = {
	weapon_trait_bespoke_combatsword_p2_increased_melee_damage_on_multiple_hits = {
		{
			buff_data = {
				required_num_hits = 3
			},
			stat_buffs = {
				[stat_buffs.melee_damage] = 0.125
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
templates.weapon_trait_bespoke_combatsword_p2_chained_hits_increases_melee_cleave = {
	weapon_trait_bespoke_combatsword_p2_chained_hits_increases_melee_cleave_parent = {
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.125
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
templates.weapon_trait_bespoke_combatsword_p2_increase_power_on_hit = {
	weapon_trait_bespoke_combatsword_p2_increase_power_on_hit_parent = {
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.075
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.1
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.125
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.15
			}
		}
	}
}
templates.weapon_trait_bespoke_combatsword_p2_infinite_melee_cleave_on_weakspot_kill = {
	weapon_trait_bespoke_combatsword_p2_infinite_melee_cleave_on_weakspot_kill = {
		{
			active_duration = 1.5
		},
		{
			active_duration = 2.5
		},
		{
			active_duration = 3.5
		},
		{
			active_duration = 4.5
		}
	}
}
templates.weapon_trait_bespoke_combatsword_p2_pass_past_armor_on_crit = {
	weapon_trait_bespoke_combatsword_p2_pass_past_armor_on_crit = {
		{}
	}
}

return templates
