-- chunkname: @scripts/settings/buff/training_grounds_buff_templates.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local keywords = BuffSettings.keywords
local buff_proc_events = BuffSettings.proc_events
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

templates.tg_player_unperceivable = {
	class_name = "buff",
	predicted = false,
	keywords = {
		keywords.unperceivable,
	},
}
templates.tg_health_station_scenario_corruption = {
	class_name = "buff",
	predicted = false,
}
templates.tg_player_resist_death = {
	class_name = "buff",
	predicted = false,
	keywords = {
		keywords.resist_death,
	},
}
templates.tg_player_nerfed_damage = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.damage] = -0.95,
	},
}
templates.tg_player_on_dodge_tutorial = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[buff_proc_events.on_successful_dodge] = 1,
	},
	proc_func = function (params, template_data, template_context)
		Managers.event:trigger("tg_on_successful_dodge")
	end,
}
templates.tg_on_combat_ability_hook = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[buff_proc_events.on_combat_ability] = 1,
	},
	proc_func = function (params, template_data, template_context)
		Managers.event:trigger("tg_on_combat_ability", params)
	end,
}
templates.tg_on_ammo_consumed_hook = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[buff_proc_events.on_ammo_consumed] = 1,
	},
	proc_func = function (params, template_data, template_context)
		Managers.event:trigger("tg_on_ammo_consumed", params)
	end,
}
templates.tg_player_short_ability_cooldown = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.ability_cooldown_modifier] = -0.6,
	},
}
templates.tg_increased_coherency_veteran = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness_regen_rate_modifier] = 25,
	},
}
templates.tg_increased_coherency_ogryn = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness_regen_rate_modifier] = 12,
	},
}
templates.tg_increased_coherency_zealot = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness_regen_rate_modifier] = 7,
	},
}
templates.tg_increased_coherency_psyker = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness_regen_rate_modifier] = 7,
	},
}
templates.tg_increased_coherency = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness_regen_rate_modifier] = 10,
	},
}
templates.tg_no_coherency = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness_regen_rate_modifier] = 0,
	},
}
templates.tg_no_overcharge = {
	class_name = "buff",
	predicted = false,
	keywords = {
		keywords.psychic_fortress,
	},
}

return templates
