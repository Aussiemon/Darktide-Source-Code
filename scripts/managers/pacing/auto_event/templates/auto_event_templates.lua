-- chunkname: @scripts/managers/pacing/auto_event/templates/auto_event_templates.lua

local auto_event_templates = {}

local function _create_auto_event_entry(path)
	local auto_event_template = require(path)

	for name, template in pairs(auto_event_template) do
		auto_event_templates[template.name] = template
	end
end

_create_auto_event_entry("scripts/managers/pacing/auto_event/templates/live_event_saints_auto_event_template")
_create_auto_event_entry("scripts/managers/pacing/auto_event/templates/dummy_auto_event_template")

return settings("AutoEventTemplates", auto_event_templates)
