-- chunkname: @scripts/settings/expeditions/expedition_templates.lua

local expedition_templates = {}

local function _create_expedition_template_entry(path)
	local settings_template = require(path)
	local name = settings_template.name

	expedition_templates[name] = settings_template
end

_create_expedition_template_entry("scripts/settings/expeditions/settings_templates/wastes_expedition_template")
_create_expedition_template_entry("scripts/settings/expeditions/settings_templates/oil_expedition_template")

return settings("ExpeditionTemplates", expedition_templates)
