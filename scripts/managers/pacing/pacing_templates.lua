local pacing_templates = {}

local function _create_pacing_template_entry(path)
	local pacing_template = require(path)
	local name = pacing_template.name

	fassert(name, "[PacingTemplates] Missing name field in %q.", path)

	pacing_templates[name] = pacing_template
end

_create_pacing_template_entry("scripts/managers/pacing/templates/default_pacing_template")

return settings("PacingTemplates", pacing_templates)
