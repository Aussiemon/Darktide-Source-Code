local BuffSettings = require("scripts/settings/buff/buff_settings")
local buff_stat_buffs = BuffSettings.stat_buffs
local templates = {
	grimoire_pickup = {
		max_stacks = 4,
		predicted = true,
		class_name = "stepped_stat_buff",
		keywords = {},
		stepped_stat_buffs = {
			{
				[buff_stat_buffs.permanent_damage_converter] = 0.1
			},
			{
				[buff_stat_buffs.permanent_damage_converter] = 0.25
			},
			{
				[buff_stat_buffs.permanent_damage_converter] = 0.5
			},
			{
				[buff_stat_buffs.permanent_damage_converter] = 0.75
			}
		}
	}
}

return templates
