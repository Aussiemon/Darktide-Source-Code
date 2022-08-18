local mission_templates = {}

local function _extract_mission_templates(path)
	local missions = require(path)

	for name, mission in pairs(missions) do
		fassert(mission_templates[name] == nil, "Found mission with the same name %q", name)

		mission.name = name
		mission_templates[name] = mission
	end
end

_extract_mission_templates("scripts/settings/mission/templates/hub_mission_templates")
_extract_mission_templates("scripts/settings/mission/templates/onboarding_mission_templates")
_extract_mission_templates("scripts/settings/mission/templates/tank_foundry_mission_templates")
_extract_mission_templates("scripts/settings/mission/templates/testify_mission_templates")
_extract_mission_templates("scripts/settings/mission/templates/transit_mission_templates")

return settings("MissionTemplates", mission_templates)
