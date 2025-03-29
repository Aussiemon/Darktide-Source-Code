-- chunkname: @scripts/managers/pacing/roamer_pacing/roamer_pacing_templates.lua

local roamer_pacing_templates = {}

local function _create_roamer_pacing_template_entry(path)
	local roamer_template = require(path)
	local name = roamer_template.name

	roamer_pacing_templates[name] = roamer_template
end

_create_roamer_pacing_template_entry("scripts/managers/pacing/roamer_pacing/templates/default_roamer_pacing_template")
_create_roamer_pacing_template_entry("scripts/managers/pacing/roamer_pacing/templates/havoc_roamer_pacing_template")

return settings("RoamerPacingTemplates", roamer_pacing_templates)
