local horde_pacing_templates = {}

local function _create_horde_pacing_template_entry(path)
	local horde_template = require(path)
	local name = horde_template.name
	horde_pacing_templates[name] = horde_template
end

_create_horde_pacing_template_entry("scripts/managers/pacing/horde_pacing/templates/renegade_horde_pacing_template")

return settings("HordePacingTemplates", horde_pacing_templates)
