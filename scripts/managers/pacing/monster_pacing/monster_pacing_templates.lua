-- chunkname: @scripts/managers/pacing/monster_pacing/monster_pacing_templates.lua

local monster_pacing_templates = {}

local function _create_monster_pacing_template_entry(path)
	local monster_template = require(path)
	local name = monster_template.name

	monster_pacing_templates[name] = monster_template
end

_create_monster_pacing_template_entry("scripts/managers/pacing/monster_pacing/templates/renegade_monster_pacing_template")

return settings("MonsterPacingTemplates", monster_pacing_templates)
