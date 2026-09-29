-- chunkname: @dialogues/generated/event_vo_kill_tech_priest_a.lua

local event_vo_kill_tech_priest_a = {
	event_kill_kill_the_target = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_tech_priest_a__event_kill_kill_the_target_01",
			"loc_tech_priest_a__event_kill_kill_the_target_02",
			"loc_tech_priest_a__event_kill_kill_the_target_03",
			"loc_tech_priest_a__event_kill_kill_the_target_04"
		},
		sound_events_duration = {
			5.669146,
			5.068063,
			5.196271,
			4.738938
		},
		randomize_indexes = {}
	},
	event_kill_target_destroyed_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_tech_priest_a__event_kill_target_destroyed_b_01",
			"loc_tech_priest_a__event_kill_target_destroyed_b_02",
			"loc_tech_priest_a__event_kill_target_destroyed_b_03",
			"loc_tech_priest_a__event_kill_target_destroyed_b_04"
		},
		sound_events_duration = {
			3.992271,
			5.115979,
			6.790479,
			5.627979
		},
		randomize_indexes = {}
	},
	event_kill_target_heavy_damage_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_tech_priest_a__event_kill_target_heavy_damage_b_01",
			"loc_tech_priest_a__event_kill_target_heavy_damage_b_02",
			"loc_tech_priest_a__event_kill_target_heavy_damage_b_03",
			"loc_tech_priest_a__event_kill_target_heavy_damage_b_04"
		},
		sound_events_duration = {
			3.984833,
			5.365646,
			5.009854,
			4.306563
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_kill_tech_priest_a", event_vo_kill_tech_priest_a)
