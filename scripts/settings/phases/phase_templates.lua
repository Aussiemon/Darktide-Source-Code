-- chunkname: @scripts/settings/phases/phase_templates.lua

local phase_templates = {}

local function _extract_phase_templates(path)
	local templates = require(path)

	for name, data in pairs(templates) do
		phase_templates[name] = data
	end
end

_extract_phase_templates("scripts/settings/phases/templates/renegade_captain_phase_templates")
_extract_phase_templates("scripts/settings/phases/templates/cultist_captain_phase_templates")

return settings("PhaseTemplates", phase_templates)
