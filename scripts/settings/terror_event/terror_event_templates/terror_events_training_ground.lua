-- chunkname: @scripts/settings/terror_event/terror_event_templates/terror_events_training_ground.lua

local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	events = {
		event_pacing_off = {
			{
				"set_pacing_enabled",
				enabled = false,
			},
		},
	},
}

return template
