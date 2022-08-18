local terror_trickle_templates = {}

local function _create_terror_trickle_template_entry(path)
	local terror_trickle_template = require(path)

	for name, template in pairs(terror_trickle_template) do
		terror_trickle_templates[name] = template
		template.name = name
	end
end

_create_terror_trickle_template_entry("scripts/managers/terror_event/terror_trickle_templates/default_terror_trickle_templates")

return settings("TerrorTrickleTemplates", terror_trickle_templates)
