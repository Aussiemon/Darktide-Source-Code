local Missions = require("scripts/settings/mission/mission_templates")
local TEMPLATE_DIR = "scripts/settings/terror_event/terror_event_templates/"
local terror_event_templates = {}

for mission_name, mission in pairs(Missions) do
	local mission_template_files = mission.terror_event_templates

	if mission_template_files then
		for i = 1, #mission_template_files do
			local template_file = mission_template_files[i]

			if not terror_event_templates[template_file] then
				local file_path = TEMPLATE_DIR .. template_file

				fassert(Application.can_get_resource("lua", file_path), "[TerrorEventTemplates] Non-existing terror event template %q defined in mission %q", file_path, mission_name)

				local file_data = require(file_path)
				terror_event_templates[template_file] = file_data
			end
		end
	end
end

return settings("TerrorEventTemplates", terror_event_templates)
