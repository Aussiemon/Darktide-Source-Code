-- chunkname: @scripts/managers/horde/horde_templates.lua

local horde_templates = {}

local function _create_horde_template_entry(path)
	local horde_template = require(path)
	local name = horde_template.name

	horde_templates[name] = horde_template
end

_create_horde_template_entry("scripts/managers/horde/templates/ambush_horde_template")
_create_horde_template_entry("scripts/managers/horde/templates/far_vector_horde_template")
_create_horde_template_entry("scripts/managers/horde/templates/flood_horde_template")
_create_horde_template_entry("scripts/managers/horde/templates/trickle_horde_template")

return settings("HordeTemplates", horde_templates)
