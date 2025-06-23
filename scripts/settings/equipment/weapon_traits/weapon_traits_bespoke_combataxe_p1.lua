﻿-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_combataxe_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_combataxe_p1_chained_hits_increases_power = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combataxe_p1_chained_hits_increases_power_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_power_level_modifier
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combataxe_p1_chained_hits_increases_power_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_combataxe_p1_chained_hits_increases_power_parent = {
			{
				max_stacks = 10,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.02
				}
			},
			{
				max_stacks = 10,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.03
				}
			},
			{
				max_stacks = 10,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.04
				}
			},
			{
				max_stacks = 10,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.05
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_combataxe_p1_chained_hits_increases_crit_chance = {
	format_values = {
		crit_chance = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combataxe_p1_chained_hits_increases_crit_chance_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.critical_strike_chance
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combataxe_p1_chained_hits_increases_crit_chance_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_combataxe_p1_chained_hits_increases_crit_chance_parent = {
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
}
templates.weapon_trait_bespoke_combataxe_p1_infinite_melee_cleave_on_weakspot_kill = {
	format_values = {
		weakspot_damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combataxe_p1_infinite_melee_cleave_on_weakspot_kill",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_weakspot_damage
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_combataxe_p1_infinite_melee_cleave_on_weakspot_kill = {
			{
				stat_buffs = {
					[stat_buffs.melee_weakspot_damage] = 0.075
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_weakspot_damage] = 0.1
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_weakspot_damage] = 0.125
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_weakspot_damage] = 0.15
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_combataxe_p1_windup_increases_power = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combataxe_p1_windup_increases_power_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_power_level_modifier
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combataxe_p1_windup_increases_power_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_combataxe_p1_windup_increases_power_parent = {
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
}
templates.weapon_trait_bespoke_combataxe_p1_targets_receive_rending_debuff = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combataxe_p1_targets_receive_rending_debuff",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"num_stacks_on_proc"
				}
			}
		},
		rending = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "rending_debuff",
				find_value_type = "buff_template",
				path = {
					"stat_buffs",
					stat_buffs.rending_multiplier
				}
			}
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "rending_debuff",
				find_value_type = "buff_template",
				path = {
					"duration"
				}
			}
		},
		max_stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "rending_debuff",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_combataxe_p1_targets_receive_rending_debuff = {
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
}
templates.weapon_trait_bespoke_combataxe_p1_stacking_rending_on_one_hit_kill = {
	format_values = {
		finesse = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combataxe_p1_stacking_rending_on_one_hit_kill_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_finesse_modifier_bonus
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combataxe_p1_stacking_rending_on_one_hit_kill_parent",
				find_value_type = "trait_override",
				path = {
					"max_stacks"
				}
			}
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combataxe_p1_stacking_rending_on_one_hit_kill_parent",
				find_value_type = "buff_template",
				path = {
					"child_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_combataxe_p1_stacking_rending_on_one_hit_kill_parent = {
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.melee_finesse_modifier_bonus] = 0.18
				}
			},
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.melee_finesse_modifier_bonus] = 0.2
				}
			},
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.melee_finesse_modifier_bonus] = 0.22
				}
			},
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.melee_finesse_modifier_bonus] = 0.24
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_combataxe_p1_power_bonus_on_first_attack = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combataxe_p1_power_bonus_on_first_attack",
				find_value_type = "trait_override",
				path = {
					"conditional_switch_stat_buffs",
					1,
					stat_buffs.melee_power_level_modifier
				}
			}
		},
		cooldown = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combataxe_p1_power_bonus_on_first_attack",
				find_value_type = "trait_override",
				path = {
					"no_power_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_combataxe_p1_power_bonus_on_first_attack = {
			{
				no_power_duration = 5,
				conditional_switch_stat_buffs = {
					{
						[stat_buffs.melee_power_level_modifier] = 0.6
					}
				}
			},
			{
				no_power_duration = 4.5,
				conditional_switch_stat_buffs = {
					{
						[stat_buffs.melee_power_level_modifier] = 0.6
					}
				}
			},
			{
				no_power_duration = 4,
				conditional_switch_stat_buffs = {
					{
						[stat_buffs.melee_power_level_modifier] = 0.6
					}
				}
			},
			{
				no_power_duration = 3.5,
				conditional_switch_stat_buffs = {
					{
						[stat_buffs.melee_power_level_modifier] = 0.6
					}
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_combataxe_p1_increase_power_on_hit = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combataxe_p1_increase_power_on_hit_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_power_level_modifier
				}
			}
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combataxe_p1_increase_power_on_hit_parent",
				find_value_type = "buff_template",
				path = {
					"child_duration"
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combataxe_p1_increase_power_on_hit_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_combataxe_p1_increase_power_on_hit_parent = {
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.035
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.04
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.045
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.05
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_combataxe_p1_power_bonus_scaled_on_stamina = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combataxe_p1_power_bonus_scaled_on_stamina",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.melee_power_level_modifier
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_combataxe_p1_power_bonus_scaled_on_stamina = {
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.05
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.06
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.07
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.08
				}
			}
		}
	}
}

return templates
