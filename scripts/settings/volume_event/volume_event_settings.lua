-- chunkname: @scripts/settings/volume_event/volume_event_settings.lua

local VolumeEventFilters = require("scripts/settings/volume_event/volume_event_filters")
local VolumeEventFunctions = require("scripts/settings/volume_event/volume_event_functions")
local extension_aliases = {
	level_prop = "TriggerVolumeEventExtension",
	minion = "MinionVolumeEventExtension",
	player = "PlayerVolumeEventExtension",
}
local PLAYER = extension_aliases.player
local MINION = extension_aliases.minion
local LEVEL_PROP = extension_aliases.level_prop
local updates_per_frame = {
	[PLAYER] = 4,
	[MINION] = 10,
	[LEVEL_PROP] = 10,
}
local volume_type_events = {
	["content/volume_types/minion_trigger"] = {
		[MINION] = {
			invert_volume = false,
			func = VolumeEventFunctions.trigger,
		},
	},
	["content/volume_types/minion_instakill_no_cost"] = {
		[MINION] = {
			invert_volume = false,
			func = VolumeEventFunctions.minion_instakill,
		},
	},
	["content/volume_types/minion_instakill_gibbing_no_cost"] = {
		[MINION] = {
			invert_volume = false,
			func = VolumeEventFunctions.minion_instakill_with_gibbing,
		},
	},
	["content/volume_types/nav_tag_volumes/minion_instakill_high_cost"] = {
		[MINION] = {
			invert_volume = false,
			traversal_cost = 100,
			func = VolumeEventFunctions.minion_instakill,
		},
	},
	["content/volume_types/nav_tag_volumes/bot_impassable"] = {
		[PLAYER] = {
			invert_volume = false,
			traversal_cost = 0,
		},
	},
	["content/volume_types/player_trigger"] = {
		[PLAYER] = {
			invert_volume = false,
			func = VolumeEventFunctions.trigger,
			filter = VolumeEventFilters.trigger,
		},
	},
	["content/volume_types/player_instakill"] = {
		[PLAYER] = {
			invert_volume = false,
			func = VolumeEventFunctions.player_instakill,
		},
	},
	["content/volume_types/level_prop_trigger"] = {
		[LEVEL_PROP] = {
			invert_volume = false,
			func = VolumeEventFunctions.trigger,
		},
	},
	["content/volume_types/end_zone"] = {
		[PLAYER] = {
			invert_volume = false,
			func = VolumeEventFunctions.end_zone,
			filter = VolumeEventFilters.end_zone,
		},
	},
}
local volume_event_settings = {
	updates_per_frame = updates_per_frame,
	volume_type_events = volume_type_events,
	extension_aliases = extension_aliases,
}

return settings("VolumeEventSettings", volume_event_settings)
