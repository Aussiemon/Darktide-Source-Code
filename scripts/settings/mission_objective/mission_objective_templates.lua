﻿-- chunkname: @scripts/settings/mission_objective/mission_objective_templates.lua

local mission_objective_templates = {}

local function _create_mission_objective_template_entry(path)
	local objective_templates = require(path)
	local default_icon = "content/ui/materials/icons/objectives/main"
	local default_category = "default"

	for template_name, objective_template in pairs(objective_templates) do
		local objectives = objective_template.objectives

		for objective_name, objective in pairs(objectives) do
			objective.name = objective_name
			objective.icon = objective.icon or default_icon
			objective.objective_category = objective.objective_category or default_category

			if objective.objective_category == "side_mission" and objective.side_objective_type == "pickup" and not objective.collect_amount then
				-- Nothing
			end
		end

		mission_objective_templates[template_name] = objective_template
	end
end

_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/cm_archives_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/cm_habs_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/cm_raid_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/common_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/core_research_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/dm_forge_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/dm_propaganda_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/dm_rise_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/dm_stockpile_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/op_train_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/fm_armoury_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/fm_cargo_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/fm_resurgence_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/hm_cartel_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/hm_complex_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/hm_strain_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/hub_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/km_enforcer_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/km_station_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/lm_cooling_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/lm_rails_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/lm_scavenge_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/onboarding_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/prologue_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/side_mission_objective_template")
_create_mission_objective_template_entry("scripts/settings/mission_objective/templates/training_grounds_objective_template")

return settings("MissionObjectiveTemplates", mission_objective_templates)
