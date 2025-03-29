-- chunkname: @scripts/managers/pacing/pacing_templates.lua

local pacing_templates = {}

local function _create_pacing_template_entry(path)
	local pacing_template = require(path)
	local name = pacing_template.name

	pacing_templates[name] = pacing_template
end

_create_pacing_template_entry("scripts/managers/pacing/templates/default_pacing_template")
_create_pacing_template_entry("scripts/managers/pacing/templates/havoc_pacing_template")
_create_pacing_template_entry("scripts/managers/pacing/templates/terror_events_only_template")

return settings("PacingTemplates", pacing_templates)
