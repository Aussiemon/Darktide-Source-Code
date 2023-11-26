-- chunkname: @scripts/settings/liquid_area/liquid_area_templates.lua

local liquid_area_templates = {}

local function _add_template_entries(path)
	local templates = require(path)

	for name, template in pairs(templates) do
		template.name = name
		liquid_area_templates[name] = template
	end
end

_add_template_entries("scripts/settings/liquid_area/liquid_area_templates/minion_liquid_area_templates")
_add_template_entries("scripts/settings/liquid_area/liquid_area_templates/player_liquid_area_templates")
_add_template_entries("scripts/settings/liquid_area/liquid_area_templates/prop_liquid_area_templates")

return settings("LiquidAreaTemplates", liquid_area_templates)
