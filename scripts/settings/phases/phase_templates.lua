local phase_templates = {}

local function _extract_phase_templates(path)
	local templates = require(path)

	for name, data in pairs(templates) do
		fassert(phase_templates[name] == nil, "Duplicate phase templates with name: %q", name)

		phase_templates[name] = data
	end
end

_extract_phase_templates("scripts/settings/phases/templates/renegade_captain_phase_templates")

for template_name, template_data in pairs(phase_templates) do
	for combat_range, phase_data in pairs(template_data) do
		local entry_phase = phase_data.entry_phase

		fassert(entry_phase, "No entry_phase specified in combat_range: %q for template: %q", combat_range, template_name)

		local phases = phase_data.phases

		if type(entry_phase) == "table" then
			for _, entry_phase_name in ipairs(entry_phase) do
				fassert(phases[entry_phase_name], "No entry_phase: %q found in combat_range: %q for template: %q", entry_phase_name, combat_range, template_name)
			end
		else
			fassert(phases[entry_phase], "No entry_phase: %q found in combat_range: %q for template: %q", entry_phase, combat_range, template_name)
		end
	end
end

return settings("PhaseTemplates", phase_templates)
