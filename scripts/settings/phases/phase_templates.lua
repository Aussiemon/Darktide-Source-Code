local phase_templates = {}

local function _extract_phase_templates(path)
	local templates = require(path)

	for name, data in pairs(templates) do
		phase_templates[name] = data
	end
end

_extract_phase_templates("scripts/settings/phases/templates/renegade_captain_phase_templates")

for template_name, template_data in pairs(phase_templates) do
	for combat_range, phase_data in pairs(template_data) do
		local entry_phase = phase_data.entry_phase
		local phases = phase_data.phases

		if type(entry_phase) == "table" then
			for _, entry_phase_name in ipairs(entry_phase) do
				-- Nothing
			end
		end
	end
end

return settings("PhaseTemplates", phase_templates)
