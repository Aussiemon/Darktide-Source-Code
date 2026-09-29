-- chunkname: @dialogues/generated/mission_briefing_boon_vendor_s.lua

local mission_briefing_boon_vendor_s = {
	mission_resurgence_brief_b = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_boon_vendor_s__priority_mission_resurgence_brief_e_01",
		},
		sound_events_duration = {
			[1] = 6.272667,
		},
		randomize_indexes = {},
	},
	mission_resurgence_brief_pre_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_boon_vendor_s__priority_mission_resurgence_brief_a_01",
		},
		sound_events_duration = {
			[1] = 7.033,
		},
		randomize_indexes = {},
	},
}

return settings("mission_briefing_boon_vendor_s", mission_briefing_boon_vendor_s)
