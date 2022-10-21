local minion_attack_selection_templates = {}

local function _extract_templates(path)
	local templates = require(path)

	for name, template in pairs(templates) do
		minion_attack_selection_templates[name] = template
		template.name = name
	end
end

_extract_templates("scripts/settings/minion_attack_selection/templates/renegade_captain_attack_selection_templates")

return settings("MinionAttackSelectionTemplates", minion_attack_selection_templates)
