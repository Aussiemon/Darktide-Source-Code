-- chunkname: @dialogues/generated/gameplay_vo_archive_servitor_a.lua

local gameplay_vo_archive_servitor_a = {
	mission_archives_activate_from_hibernation_a = {
		randomize_indexes_n = 0,
		sound_events_n = 8,
		sound_events = {
			"loc_archive_servitor_a__activate_from_hibernation_a_01",
			"loc_archive_servitor_a__activate_from_hibernation_a_03",
			"loc_archive_servitor_a__activate_from_hibernation_a_04",
			"loc_archive_servitor_a__activate_from_hibernation_a_05",
			"loc_archive_servitor_a__player_interact_a_01",
			"loc_archive_servitor_a__player_interact_a_03",
			"loc_archive_servitor_a__player_interact_a_04",
			"loc_archive_servitor_a__player_interact_a_05"
		},
		sound_events_duration = {
			6.368375,
			6.968063,
			6.280719,
			6.398896,
			5.570604,
			7.93776,
			7.012552,
			5.430448
		},
		randomize_indexes = {}
	},
	mission_archives_task_complete_a = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_archive_servitor_a__task_complete_a_01",
			"loc_archive_servitor_a__task_complete_a_02",
			"loc_archive_servitor_a__task_complete_a_03",
			"loc_archive_servitor_a__task_complete_a_04",
			"loc_archive_servitor_a__task_complete_a_05"
		},
		sound_events_duration = {
			1.435031,
			2.928156,
			3.964063,
			3.28001,
			2.433292
		},
		randomize_indexes = {}
	}
}

return settings("gameplay_vo_archive_servitor_a", gameplay_vo_archive_servitor_a)
