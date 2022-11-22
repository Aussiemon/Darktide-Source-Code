local BuffSettings = require("scripts/settings/buff/buff_settings")
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local templates = {}

local function linear_lerp_t_func(t, start_time, duration, template_data, template_context)
	return math.lerp(start_time, start_time + duration, t)
end

local function smoothstep_lerp_t_func(t, start_time, duration, template_data, template_context)
	return math.smoothstep(t, start_time, start_time + duration)
end

templates.light_stun_movement_slow = {
	unique_buff_id = "hit_reaction_movement_slow",
	unique_buff_priority = 3,
	duration = 0.75,
	class_name = "buff",
	lerped_stat_buffs = {
		[buff_stat_buffs.movement_speed] = {
			max = 0.75,
			min = 0.5
		}
	},
	lerp_t_func = smoothstep_lerp_t_func
}
templates.medium_stun_movement_slow = {
	unique_buff_id = "hit_reaction_movement_slow",
	unique_buff_priority = 3,
	duration = 0.75,
	class_name = "buff",
	lerped_stat_buffs = {
		[buff_stat_buffs.movement_speed] = {
			max = 0.75,
			min = 0.5
		}
	},
	lerp_t_func = smoothstep_lerp_t_func
}
templates.heavy_stun_movement_slow = {
	unique_buff_id = "hit_reaction_movement_slow",
	unique_buff_priority = 2,
	duration = 0.75,
	class_name = "buff",
	lerped_stat_buffs = {
		[buff_stat_buffs.movement_speed] = {
			max = 0.65,
			min = 0.5
		}
	},
	lerp_t_func = smoothstep_lerp_t_func
}
templates.ogryn_stun_movement_seed_up = {
	unique_buff_id = "hit_reaction_movement_slow",
	unique_buff_priority = 2,
	duration = 0.5,
	class_name = "buff",
	lerped_stat_buffs = {
		[buff_stat_buffs.movement_speed] = {
			max = 1.05,
			min = 1
		}
	},
	lerp_t_func = smoothstep_lerp_t_func
}
templates.fumbled_stun_movement_slow = {
	unique_buff_id = "hit_reaction_movement_slow",
	unique_buff_priority = 2,
	duration = 1,
	class_name = "buff",
	lerped_stat_buffs = {
		[buff_stat_buffs.movement_speed] = {
			max = 0.7,
			min = 0.5
		}
	},
	lerp_t_func = smoothstep_lerp_t_func
}
templates.grenadier_stun_movement_slow = {
	unique_buff_id = "hit_reaction_movement_slow",
	unique_buff_priority = 1,
	duration = 1,
	class_name = "buff",
	lerped_stat_buffs = {
		[buff_stat_buffs.movement_speed] = {
			max = 0.75,
			min = 0.5
		}
	},
	lerp_t_func = smoothstep_lerp_t_func
}
templates.fortitude_broken_stun_movement_slow = {
	unique_buff_id = "hit_reaction_movement_slow",
	unique_buff_priority = 2,
	duration = 0.4,
	class_name = "buff",
	lerped_stat_buffs = {
		[buff_stat_buffs.movement_speed] = {
			max = 0.75,
			min = 0.25
		}
	},
	lerp_t_func = smoothstep_lerp_t_func
}
templates.sniper_stun_movement_slow = {
	unique_buff_id = "hit_reaction_movement_slow",
	unique_buff_priority = 1,
	duration = 2,
	class_name = "buff",
	lerped_stat_buffs = {
		[buff_stat_buffs.movement_speed] = {
			max = 0.4,
			min = 0.01
		}
	},
	lerp_t_func = smoothstep_lerp_t_func
}
templates.toughness_stun_movement_slow = {
	unique_buff_id = "hit_reaction_movement_slow",
	unique_buff_priority = 4,
	duration = 0.2,
	class_name = "buff",
	lerped_stat_buffs = {
		[buff_stat_buffs.movement_speed] = {
			max = 0.95,
			min = 0.8
		}
	},
	lerp_t_func = smoothstep_lerp_t_func
}
templates.ranged_stun_movement_slow = {
	unique_buff_id = "hit_reaction_movement_slow",
	unique_buff_priority = 3,
	duration = 0.3,
	class_name = "buff",
	lerped_stat_buffs = {
		[buff_stat_buffs.movement_speed] = {
			max = 0.85,
			min = 0.75
		}
	},
	lerp_t_func = smoothstep_lerp_t_func
}
templates.ranged_sprinting_stun_movement_slow = {
	unique_buff_id = "hit_reaction_movement_slow",
	unique_buff_priority = 3,
	duration = 0.5,
	class_name = "buff",
	lerped_stat_buffs = {
		[buff_stat_buffs.movement_speed] = {
			max = 1,
			min = 1.25
		}
	},
	lerp_t_func = smoothstep_lerp_t_func
}
templates.ogryn_powermaul_stun_movement_slow = {
	unique_buff_id = "hit_reaction_movement_slow",
	unique_buff_priority = 1,
	duration = 2,
	class_name = "buff",
	lerped_stat_buffs = {
		[buff_stat_buffs.movement_speed] = {
			max = 0.8,
			min = 0.01
		}
	},
	lerp_t_func = smoothstep_lerp_t_func
}
templates.stun_immune_ultra_short = {
	unique_buff_id = "stun_immunity",
	duration = 0.4,
	class_name = "buff",
	keywords = {
		buff_keywords.stun_immune
	},
	stat_buffs = {}
}
templates.stun_immune_short = {
	unique_buff_id = "stun_immunity",
	duration = 0.7,
	class_name = "buff",
	keywords = {
		buff_keywords.stun_immune
	},
	stat_buffs = {}
}
templates.stun_immune_medium = {
	unique_buff_id = "stun_immunity",
	duration = 1.25,
	class_name = "buff",
	keywords = {
		buff_keywords.stun_immune
	},
	stat_buffs = {}
}
templates.stun_immune_long = {
	unique_buff_id = "stun_immunity",
	duration = 1.75,
	class_name = "buff",
	keywords = {
		buff_keywords.stun_immune
	},
	stat_buffs = {}
}
templates.stun_immune_very_long = {
	unique_buff_id = "stun_immunity",
	duration = 1.5,
	class_name = "buff",
	keywords = {
		buff_keywords.stun_immune
	},
	stat_buffs = {}
}

return templates
