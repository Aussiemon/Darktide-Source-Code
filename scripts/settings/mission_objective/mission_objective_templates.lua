local mission_objective_templates = {}

local function _create_mission_objective_template_entry(path)
	local objective_templates = require(path)

	for template_name, objective_template in pairs(objective_templates) do
		fassert(objective_template.objectives, "[MissionObjectiveTemplates][template:'%s'] template is missing objectives.", template_name)

		local default_icon = "content/ui/materials/icons/objectives/main"
		objective_template.main_objective_type = objective_template.main_objective_type or "default"
		local objectives = objective_template.objectives

		for objective_name, objective in pairs(objectives) do
			fassert(objective.mission_objective_type, "[MissionObjectiveTemplates][mission_objective:'%s'] 'mission_objective_type' not set.", objective_name)

			objective.name = objective_name

			if not objective.icon then
				objective.icon = default_icon
			end

			if objective.is_side_mission and objective.side_objective_type == "pickup" and not objective.collect_amount then
				fassert(false, "[MissionObjectiveTemplates][mission_objective:'%s'] is a mission_objective_type == 'collect' but 'collect_amount' is not set.", objective_name)
			end
		end

		mission_objective_templates[template_name] = objective_template
	end
end

_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/common_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/debug_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/dm_forge_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/hub_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/lm_cooling_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/lm_rails_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/onboarding_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/side_mission_objective_template")

return settings("MissionObjectiveTemplates", mission_objective_templates)
