local AbilityTemplates = require("scripts/settings/ability/ability_templates/ability_templates")
local AbilityTemplate = {
	current_ability_template = function (ability_action_component)
		local template_name = ability_action_component.template_name
		local ability_template = template_name and template_name ~= "none" and AbilityTemplates[template_name]

		return ability_template
	end
}

return AbilityTemplate
