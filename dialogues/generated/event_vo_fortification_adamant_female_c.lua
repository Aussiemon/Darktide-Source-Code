-- chunkname: @dialogues/generated/event_vo_fortification_adamant_female_c.lua

local event_vo_fortification_adamant_female_c = {
	event_fortification_beacon_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_female_c__event_fortification_beacon_deployed_01",
			"loc_adamant_female_c__event_fortification_beacon_deployed_02",
			"loc_adamant_female_c__event_fortification_beacon_deployed_03",
			"loc_adamant_female_c__event_fortification_beacon_deployed_04",
		},
		sound_events_duration = {
			1.299948,
			1.723906,
			1.166479,
			1.670552,
		},
		randomize_indexes = {},
	},
	event_fortification_skyfire_disabled = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_female_c__event_fortification_skyfire_disabled_01",
			"loc_adamant_female_c__event_fortification_skyfire_disabled_02",
			"loc_adamant_female_c__event_fortification_skyfire_disabled_03",
			"loc_adamant_female_c__event_fortification_skyfire_disabled_04",
		},
		sound_events_duration = {
			1.723208,
			1.573313,
			1.924927,
			2.382125,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_fortification_adamant_female_c", event_vo_fortification_adamant_female_c)
