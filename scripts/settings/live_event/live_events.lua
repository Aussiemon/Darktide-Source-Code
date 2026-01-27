-- chunkname: @scripts/settings/live_event/live_events.lua

local live_events = {}

local function _add_live_event(event_name)
	local event_config = require("scripts/settings/live_event/" .. event_name)
	local id = event_config.id

	live_events[id] = event_config
end

_add_live_event("abhuman")
_add_live_event("barrel_grounds")
_add_live_event("communication_hack")
_add_live_event("darkness")
_add_live_event("ember")
_add_live_event("get_em_in_shape")
_add_live_event("mechanicus")
_add_live_event("moebian_21")
_add_live_event("nurgle_explosion")
_add_live_event("plasma_smugglers")
_add_live_event("rotten_armor")
_add_live_event("skulls")
_add_live_event("stolen_rations")
_add_live_event("saints")
_add_live_event("broker_stimms")
_add_live_event("survival")

return settings("LiveEvents", live_events)
