-- chunkname: @scripts/settings/components/door_settings.lua

local door_settings = {}

door_settings.TYPES = table.enum("none", "two_states", "three_states")
door_settings.OPEN_TYPES = table.enum("none", "open_only", "close_only")
door_settings.STATES = table.enum("none", "open", "open_fwd", "open_bwd", "closed")

local STATES = door_settings.STATES

door_settings.anim = {
	[STATES.none] = {
		duration = 0,
	},
	[STATES.open] = {
		duration = 0,
		event = "open",
	},
	[STATES.open_fwd] = {
		duration = 0,
		event = "open_fwd",
	},
	[STATES.open_bwd] = {
		duration = 0,
		event = "open_bwd",
	},
	[STATES.closed] = {
		duration = 0,
		event = "close",
	},
}

return settings("DoorSettings", door_settings)
