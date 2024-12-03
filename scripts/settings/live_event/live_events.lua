-- chunkname: @scripts/settings/live_event/live_events.lua

local live_events = {}

local function _add_live_event(event_name)
	local event_config = require("scripts/settings/live_event/" .. event_name)
	local id = event_config.id

	live_events[id] = event_config
end

_add_live_event("skulls")
_add_live_event("mechanicus")
_add_live_event("darkness")
_add_live_event("moebian_21")
_add_live_event("nurgle_explosion")
_add_live_event("get_em_in_shape")

return settings("LiveEvents", live_events)
