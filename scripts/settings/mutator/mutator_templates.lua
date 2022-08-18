local mutator_templates = {}

local function _extract_mutator_templates(path)
	local mutators = require(path)

	for name, mutator_data in pairs(mutators) do
		fassert(mutator_templates[name] == nil, "Found mutator with the same name %q", name)

		mutator_templates[name] = mutator_data
	end
end

_extract_mutator_templates("scripts/settings/mutator/templates/mutator_minion_nurgle_blessing_templates")
_extract_mutator_templates("scripts/settings/mutator/templates/mutator_extra_trickle_templates")
_extract_mutator_templates("scripts/settings/mutator/templates/mutator_modify_pacing_templates")

for name, mutator_data in pairs(mutator_templates) do
	mutator_data.name = name
end

return settings("MutatorTemplates", mutator_templates)
