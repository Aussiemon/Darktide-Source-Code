-- chunkname: @scripts/settings/buff/boon_buff_templates.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local meta_stat_buffs = BuffSettings.meta_stat_buffs
local templates = {}

table.make_unique(templates)

templates.boon_mission_xp_increase = {
	meta_buff = true,
	predicted = false,
	meta_stat_buffs = {
		[meta_stat_buffs.mission_reward_xp_modifier] = 0.2,
	},
}
templates.boon_mission_credits_increase = {
	meta_buff = true,
	predicted = false,
	meta_stat_buffs = {
		[meta_stat_buffs.mission_reward_credit_modifier] = 0.2,
	},
}
templates.boon_mission_drop_chance_increase = {
	meta_buff = true,
	predicted = false,
	meta_stat_buffs = {
		[meta_stat_buffs.mission_reward_drop_chance_modifier] = 0.2,
	},
}
templates.boon_mission_weapon_drop_rarity_increase = {
	meta_buff = true,
	predicted = false,
	meta_stat_buffs = {
		[meta_stat_buffs.mission_reward_weapon_drop_rarity_modifier] = 0.2,
	},
}
templates.boon_increase_max_grenades = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.extra_max_amount_of_grenades] = 2,
	},
}
templates.boon_increase_wounds = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.extra_max_amount_of_wounds] = 1,
	},
}

return templates
