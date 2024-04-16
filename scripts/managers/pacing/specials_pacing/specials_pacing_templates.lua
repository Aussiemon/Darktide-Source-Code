local specials_pacing_templates = {}

local function _create_specials_pacing_template_entry(path)
	local specials_template = require(path)
	local name = specials_template.name
	specials_pacing_templates[name] = specials_template
end

_create_specials_pacing_template_entry("scripts/managers/pacing/specials_pacing/templates/default_specials_pacing_template")

return settings("SpecialsPacingTemplates", specials_pacing_templates)
