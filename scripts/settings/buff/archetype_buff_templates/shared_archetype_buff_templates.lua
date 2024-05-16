-- chunkname: @scripts/settings/buff/archetype_buff_templates/shared_archetype_buff_templates.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

templates.coherency_aura_lingers = {
	class_name = "buff",
	predicted = false,
	keywords = {
		keywords.no_coherency_stickiness_limit,
	},
	stat_buffs = {
		[stat_buffs.coherency_stickiness_time_value] = 5,
	},
}

return templates
