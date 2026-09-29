-- chunkname: @scripts/managers/pacing/bosses/boss_templates.lua

local boss_handler_templates = {}

local function _create_boss_template_entry(path)
	local boss_template = require(path)
	local name = boss_template.name

	boss_handler_templates[name] = boss_template
end

_create_boss_template_entry("scripts/managers/pacing/bosses/spillway_wizard")

return settings("BossHandlerTemplates", boss_handler_templates)
