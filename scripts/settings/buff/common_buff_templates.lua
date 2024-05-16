﻿-- chunkname: @scripts/settings/buff/common_buff_templates.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

local function linear_lerp_t_func(t, start_time, duration, template_data, template_context)
	return math.lerp(start_time, start_time + duration, t)
end

local function smoothstep_lerp_t_func(t, start_time, duration, template_data, template_context)
	return math.smoothstep(t, start_time, start_time + duration)
end

templates.light_stun_movement_slow = {
	class_name = "buff",
	duration = 0.3,
	unique_buff_id = "hit_reaction_movement_slow",
	unique_buff_priority = 3,
	lerped_stat_buffs = {
		[buff_stat_buffs.movement_speed] = {
			max = -0.25,
			min = -0.5,
		},
	},
	lerp_t_func = smoothstep_lerp_t_func,
}
templates.medium_stun_movement_slow = {
	class_name = "buff",
	duration = 0.4,
	unique_buff_id = "hit_reaction_movement_slow",
	unique_buff_priority = 3,
	lerped_stat_buffs = {
		[buff_stat_buffs.movement_speed] = {
			max = -0.25,
			min = -0.5,
		},
	},
	lerp_t_func = smoothstep_lerp_t_func,
}
templates.heavy_stun_movement_slow = {
	class_name = "buff",
	duration = 0.6,
	unique_buff_id = "hit_reaction_movement_slow",
	unique_buff_priority = 2,
	lerped_stat_buffs = {
		[buff_stat_buffs.movement_speed] = {
			max = -0.35,
			min = -0.5,
		},
	},
	lerp_t_func = smoothstep_lerp_t_func,
}
templates.ogryn_stun_movement_speed_up = {
	class_name = "buff",
	duration = 0.5,
	unique_buff_id = "hit_reaction_movement_slow",
	unique_buff_priority = 2,
	lerped_stat_buffs = {
		[buff_stat_buffs.movement_speed] = {
			max = 0.050000000000000044,
			min = 0,
		},
	},
	lerp_t_func = smoothstep_lerp_t_func,
}
templates.fumbled_stun_movement_slow = {
	class_name = "buff",
	duration = 1,
	unique_buff_id = "hit_reaction_movement_slow",
	unique_buff_priority = 2,
	lerped_stat_buffs = {
		[buff_stat_buffs.movement_speed] = {
			max = -0.30000000000000004,
			min = -0.5,
		},
	},
	lerp_t_func = smoothstep_lerp_t_func,
}
templates.grenadier_stun_movement_slow = {
	class_name = "buff",
	duration = 1,
	unique_buff_id = "hit_reaction_movement_slow",
	unique_buff_priority = 1,
	lerped_stat_buffs = {
		[buff_stat_buffs.movement_speed] = {
			max = -0.25,
			min = -0.5,
		},
	},
	lerp_t_func = smoothstep_lerp_t_func,
}
templates.fortitude_broken_stun_movement_slow = {
	class_name = "buff",
	duration = 0.4,
	unique_buff_id = "hit_reaction_movement_slow",
	unique_buff_priority = 2,
	lerped_stat_buffs = {
		[buff_stat_buffs.movement_speed] = {
			max = -0.25,
			min = -0.75,
		},
	},
	lerp_t_func = smoothstep_lerp_t_func,
}
templates.sniper_stun_movement_slow = {
	class_name = "buff",
	duration = 2,
	unique_buff_id = "hit_reaction_movement_slow",
	unique_buff_priority = 1,
	lerped_stat_buffs = {
		[buff_stat_buffs.movement_speed] = {
			max = -0.6,
			min = -0.99,
		},
	},
	lerp_t_func = smoothstep_lerp_t_func,
}
templates.toughness_stun_movement_slow = {
	class_name = "buff",
	duration = 0.2,
	unique_buff_id = "hit_reaction_movement_slow",
	unique_buff_priority = 4,
	lerped_stat_buffs = {
		[buff_stat_buffs.movement_speed] = {
			max = -0.050000000000000044,
			min = -0.19999999999999996,
		},
	},
	lerp_t_func = smoothstep_lerp_t_func,
}
templates.ranged_stun_movement_slow = {
	class_name = "buff",
	duration = 0.3,
	unique_buff_id = "hit_reaction_movement_slow",
	unique_buff_priority = 3,
	lerped_stat_buffs = {
		[buff_stat_buffs.movement_speed] = {
			max = -0.15000000000000002,
			min = -0.25,
		},
	},
	lerp_t_func = smoothstep_lerp_t_func,
}
templates.ranged_sprinting_stun_movement_slow = {
	class_name = "buff",
	duration = 0.5,
	unique_buff_id = "hit_reaction_movement_slow",
	unique_buff_priority = 3,
	lerped_stat_buffs = {
		[buff_stat_buffs.movement_speed] = {
			max = 0,
			min = 0.25,
		},
	},
	lerp_t_func = smoothstep_lerp_t_func,
}
templates.ogryn_powermaul_stun_movement_slow = {
	class_name = "buff",
	duration = 2,
	unique_buff_id = "hit_reaction_movement_slow",
	unique_buff_priority = 1,
	lerped_stat_buffs = {
		[buff_stat_buffs.movement_speed] = {
			max = -0.19999999999999996,
			min = -0.99,
		},
	},
	lerp_t_func = smoothstep_lerp_t_func,
}
templates.stun_immune_ultra_short = {
	class_name = "buff",
	duration = 0.4,
	unique_buff_id = "stun_immunity",
	keywords = {
		buff_keywords.stun_immune,
	},
	stat_buffs = {},
}
templates.stun_immune_short = {
	class_name = "buff",
	duration = 1,
	unique_buff_id = "stun_immunity",
	keywords = {
		buff_keywords.stun_immune,
	},
	stat_buffs = {},
}
templates.stun_immune_medium = {
	class_name = "buff",
	duration = 1.5,
	unique_buff_id = "stun_immunity",
	keywords = {
		buff_keywords.stun_immune,
	},
	stat_buffs = {},
}
templates.stun_immune_long = {
	class_name = "buff",
	duration = 1.75,
	unique_buff_id = "stun_immunity",
	keywords = {
		buff_keywords.stun_immune,
	},
	stat_buffs = {},
}
templates.stun_immune_very_long = {
	class_name = "buff",
	duration = 2,
	unique_buff_id = "stun_immunity",
	keywords = {
		buff_keywords.stun_immune,
	},
	stat_buffs = {},
}

return templates
