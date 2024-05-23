-- chunkname: @scripts/settings/live_event/live_events.lua

local LiveEvents = {}

local function _add_live_event(event_name)
	local event_config = require("scripts/settings/live_event/" .. event_name)
	local id = event_config.id

	LiveEvents[id] = event_config
end

_add_live_event("skulls")

return settings("LiveEvents", LiveEvents)
