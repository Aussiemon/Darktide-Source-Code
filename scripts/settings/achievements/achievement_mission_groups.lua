local AchievementMissionGroups = {}
local path = "content/ui/textures/icons/achievements/"
AchievementMissionGroups.missions = {
	{
		name = "km_station",
		local_variable = "loc_mission_name_km_station",
		category = {
			default = "endeavours_transit",
			puzzle = "exploration_transit"
		},
		icon = {
			mission_default = path .. "mission_achievements/missions_achievement_difficulty_0003",
			collectible = path .. "mission_achievements/missions_achievement_puzzle_0003",
			auric = path .. "mission_achievements/missions_achievement_difficulty_0004",
			challange = path .. "default"
		}
	},
	{
		name = "lm_rails",
		local_variable = "loc_mission_name_lm_rails",
		category = {
			default = "endeavours_transit",
			puzzle = "exploration_transit"
		},
		icon = {
			mission_default = path .. "mission_achievements/missions_achievement_difficulty_0001",
			collectible = path .. "mission_achievements/missions_achievement_puzzle_0001",
			auric = path .. "mission_achievements/missions_achievement_difficulty_0002",
			challange = path .. "default"
		}
	},
	{
		name = "cm_habs",
		local_variable = "loc_mission_name_cm_habs",
		category = {
			default = "endeavours_transit",
			puzzle = "exploration_transit"
		},
		icon = {
			mission_default = path .. "mission_achievements/missions_achievement_difficulty_0005",
			collectible = path .. "mission_achievements/missions_achievement_puzzle_0002",
			auric = path .. "mission_achievements/missions_achievement_difficulty_0006",
			challange = path .. "default"
		}
	},
	{
		name = "dm_rise",
		local_variable = "loc_mission_name_dm_rise",
		category = {
			default = "endeavours_transit",
			puzzle = "exploration_transit"
		},
		icon = {
			mission_default = path .. "mission_achievements/missions_achievement_difficulty_0007",
			collectible = path .. "mission_achievements/missions_achievement_puzzle_0004",
			auric = path .. "mission_achievements/missions_achievement_difficulty_0008",
			challange = path .. "default"
		}
	},
	{
		name = "dm_stockpile",
		local_variable = "loc_mission_name_dm_stockpile",
		category = {
			default = "endeavours_watertown",
			puzzle = "exploration_watertown"
		},
		icon = {
			mission_default = path .. "mission_achievements/missions_achievement_difficulty_0015",
			collectible = path .. "mission_achievements/missions_achievement_puzzle_0012",
			auric = path .. "mission_achievements/missions_achievement_difficulty_0016",
			challange = path .. "default"
		}
	},
	{
		name = "hm_cartel",
		local_variable = "loc_mission_name_hm_cartel",
		category = {
			default = "endeavours_watertown",
			puzzle = "exploration_watertown"
		},
		icon = {
			mission_default = path .. "mission_achievements/missions_achievement_difficulty_0017",
			collectible = path .. "mission_achievements/missions_achievement_puzzle_0011",
			auric = path .. "mission_achievements/missions_achievement_difficulty_0018",
			challange = path .. "default"
		}
	},
	{
		name = "km_enforcer",
		local_variable = "loc_mission_name_km_enforcer",
		category = {
			default = "endeavours_watertown",
			puzzle = "exploration_watertown"
		},
		icon = {
			mission_default = path .. "mission_achievements/missions_achievement_difficulty_0019",
			collectible = path .. "mission_achievements/missions_achievement_puzzle_0013",
			auric = path .. "mission_achievements/missions_achievement_difficulty_0020",
			challange = path .. "default"
		}
	},
	{
		name = "lm_cooling",
		local_variable = "loc_mission_name_lm_cooling",
		category = {
			default = "endeavours_foundry",
			puzzle = "exploration_foundry"
		},
		icon = {
			mission_default = path .. "mission_achievements/missions_achievement_difficulty_0013",
			collectible = path .. "mission_achievements/missions_achievement_puzzle_0006",
			auric = path .. "mission_achievements/missions_achievement_difficulty_0014",
			challange = path .. "default"
		}
	},
	{
		name = "fm_cargo",
		local_variable = "loc_mission_name_fm_cargo",
		category = {
			default = "endeavours_foundry",
			puzzle = "exploration_foundry"
		},
		icon = {
			mission_default = path .. "mission_achievements/missions_achievement_difficulty_0009",
			collectible = path .. "mission_achievements/missions_achievement_puzzle_0007",
			auric = path .. "mission_achievements/missions_achievement_difficulty_0010",
			challange = path .. "default"
		}
	},
	{
		name = "dm_forge",
		local_variable = "loc_mission_name_dm_forge",
		category = {
			default = "endeavours_foundry",
			puzzle = "exploration_foundry"
		},
		icon = {
			mission_default = path .. "mission_achievements/missions_achievement_difficulty_0011",
			collectible = path .. "mission_achievements/missions_achievement_puzzle_0005",
			auric = path .. "mission_achievements/missions_achievement_difficulty_0012",
			challange = path .. "default"
		}
	},
	{
		name = "lm_scavenge",
		local_variable = "loc_mission_name_lm_scavenge",
		category = {
			default = "endeavours_dust",
			puzzle = "exploration_dust"
		},
		icon = {
			mission_default = path .. "mission_achievements/missions_achievement_difficulty_0021",
			collectible = path .. "mission_achievements/missions_achievement_puzzle_0010",
			auric = path .. "mission_achievements/missions_achievement_difficulty_0022",
			challange = path .. "default"
		}
	},
	{
		name = "hm_strain",
		local_variable = "loc_mission_name_hm_strain",
		category = {
			default = "endeavours_dust",
			puzzle = "exploration_dust"
		},
		icon = {
			mission_default = path .. "mission_achievements/missions_achievement_difficulty_0025",
			collectible = path .. "mission_achievements/missions_achievement_puzzle_0009",
			auric = path .. "mission_achievements/missions_achievement_difficulty_0026",
			challange = path .. "default"
		}
	},
	{
		name = "dm_propaganda",
		local_variable = "loc_mission_name_dm_propaganda",
		category = {
			default = "endeavours_dust",
			puzzle = "exploration_dust"
		},
		icon = {
			mission_default = path .. "mission_achievements/missions_achievement_difficulty_0023",
			collectible = path .. "mission_achievements/missions_achievement_puzzle_0008",
			auric = path .. "mission_achievements/missions_achievement_difficulty_0024",
			challange = path .. "default"
		}
	},
	{
		name = "fm_resurgence",
		local_variable = "loc_mission_name_fm_resurgence",
		category = {
			default = "endeavours_throneside",
			puzzle = "exploration_throneside"
		},
		icon = {
			mission_default = path .. "mission_achievements/missions_achievement_difficulty_0027",
			collectible = path .. "mission_achievements/missions_achievement_puzzle_0014",
			auric = path .. "mission_achievements/missions_achievement_difficulty_0028",
			challange = path .. "default"
		}
	},
	{
		name = "cm_archives",
		local_variable = "loc_mission_name_cm_archives",
		category = {
			default = "endeavours_throneside",
			puzzle = "exploration_throneside"
		},
		icon = {
			mission_default = path .. "mission_achievements/missions_achievement_difficulty_0031",
			collectible = path .. "mission_achievements/missions_achievement_puzzle_0016",
			auric = path .. "mission_achievements/missions_achievement_difficulty_0032",
			challange = path .. "default"
		}
	},
	{
		name = "hm_complex",
		local_variable = "loc_mission_name_hm_complex",
		category = {
			default = "endeavours_throneside",
			puzzle = "exploration_throneside"
		},
		icon = {
			mission_default = path .. "mission_achievements/missions_achievement_difficulty_0029",
			collectible = path .. "mission_achievements/missions_achievement_puzzle_0015",
			auric = path .. "mission_achievements/missions_achievement_difficulty_0030",
			challange = path .. "default"
		}
	},
	{
		name = "fm_armoury",
		local_variable = "loc_mission_name_fm_armoury",
		category = {
			default = "endeavours_entertainment",
			puzzle = "exploration_entertainment"
		},
		icon = {
			mission_default = path .. "mission_achievements/missions_achievement_difficulty_0033",
			collectible = path .. "mission_achievements/missions_achievement_puzzle_0017",
			auric = path .. "mission_achievements/missions_achievement_difficulty_0034",
			challange = path .. "default"
		}
	},
	{
		name = "cm_raid",
		local_variable = "loc_mission_name_cm_raid",
		category = {
			default = "endeavours_entertainment",
			puzzle = "exploration_entertainment"
		},
		icon = {
			mission_default = path .. "mission_achievements/missions_achievement_difficulty_0035",
			collectible = path .. "mission_achievements/missions_achievement_puzzle_0018",
			auric = path .. "mission_achievements/missions_achievement_difficulty_0036",
			challange = path .. "default"
		}
	}
}
AchievementMissionGroups.level_overview_meta = {
	{
		name = "transit",
		local_variable = "loc_zone_name_transit_short",
		category = "endeavours",
		icon = path .. "default",
		meta_tables = {
			lookup_table_01 = {
				"level_km_station_mission_1",
				"level_lm_rails_mission_1",
				"level_cm_habs_mission_1",
				"level_dm_rise_mission_1"
			},
			lookup_table_02 = {
				"level_km_station_mission_2",
				"level_lm_rails_mission_2",
				"level_cm_habs_mission_2",
				"level_dm_rise_mission_2"
			},
			lookup_table_03 = {
				"level_km_station_mission_3",
				"level_lm_rails_mission_3",
				"level_cm_habs_mission_3",
				"level_dm_rise_mission_3"
			},
			lookup_table_04 = {
				"level_km_station_mission_4",
				"level_lm_rails_mission_4",
				"level_cm_habs_mission_4",
				"level_dm_rise_mission_4"
			},
			lookup_table_05 = {
				"level_km_station_mission_5",
				"level_lm_rails_mission_5",
				"level_cm_habs_mission_5",
				"level_dm_rise_mission_5"
			}
		}
	},
	{
		name = "watertown",
		local_variable = "loc_zone_name_watertown_short",
		category = "endeavours",
		icon = path .. "default",
		meta_tables = {
			lookup_table_01 = {
				"level_dm_stockpile_mission_1",
				"level_hm_cartel_mission_1",
				"level_km_enforcer_mission_1"
			},
			lookup_table_02 = {
				"level_dm_stockpile_mission_2",
				"level_hm_cartel_mission_2",
				"level_km_enforcer_mission_2"
			},
			lookup_table_03 = {
				"level_dm_stockpile_mission_3",
				"level_hm_cartel_mission_3",
				"level_km_enforcer_mission_3"
			},
			lookup_table_04 = {
				"level_dm_stockpile_mission_4",
				"level_hm_cartel_mission_4",
				"level_km_enforcer_mission_4"
			},
			lookup_table_05 = {
				"level_dm_stockpile_mission_5",
				"level_hm_cartel_mission_5",
				"level_km_enforcer_mission_5"
			}
		}
	},
	{
		name = "tank_foundry",
		local_variable = "loc_zone_name_tank_foundry_short",
		category = "endeavours",
		icon = path .. "default",
		meta_tables = {
			lookup_table_01 = {
				"level_lm_cooling_mission_1",
				"level_fm_cargo_mission_1",
				"level_dm_forge_mission_1"
			},
			lookup_table_02 = {
				"level_lm_cooling_mission_2",
				"level_fm_cargo_mission_2",
				"level_dm_forge_mission_2"
			},
			lookup_table_03 = {
				"level_lm_cooling_mission_3",
				"level_fm_cargo_mission_3",
				"level_dm_forge_mission_3"
			},
			lookup_table_04 = {
				"level_lm_cooling_mission_4",
				"level_fm_cargo_mission_4",
				"level_dm_forge_mission_4"
			},
			lookup_table_05 = {
				"level_lm_cooling_mission_5",
				"level_fm_cargo_mission_5",
				"level_dm_forge_mission_5"
			}
		}
	},
	{
		name = "dust",
		local_variable = "loc_zone_name_hourglass_short",
		category = "endeavours",
		icon = path .. "default",
		meta_tables = {
			lookup_table_01 = {
				"level_lm_scavenge_mission_1",
				"level_hm_strain_mission_1",
				"level_dm_propaganda_mission_1"
			},
			lookup_table_02 = {
				"level_lm_scavenge_mission_2",
				"level_hm_strain_mission_2",
				"level_dm_propaganda_mission_2"
			},
			lookup_table_03 = {
				"level_lm_scavenge_mission_3",
				"level_hm_strain_mission_3",
				"level_dm_propaganda_mission_3"
			},
			lookup_table_04 = {
				"level_lm_scavenge_mission_4",
				"level_hm_strain_mission_4",
				"level_dm_propaganda_mission_4"
			},
			lookup_table_05 = {
				"level_lm_scavenge_mission_5",
				"level_hm_strain_mission_5",
				"level_dm_propaganda_mission_5"
			}
		}
	},
	{
		name = "throneside",
		local_variable = "loc_zone_name_throneside_short",
		category = "endeavours",
		icon = path .. "default",
		meta_tables = {
			lookup_table_01 = {
				"level_fm_resurgence_mission_1",
				"level_cm_archives_mission_1",
				"level_hm_complex_mission_1"
			},
			lookup_table_02 = {
				"level_fm_resurgence_mission_2",
				"level_cm_archives_mission_2",
				"level_hm_complex_mission_2"
			},
			lookup_table_03 = {
				"level_fm_resurgence_mission_3",
				"level_cm_archives_mission_3",
				"level_hm_complex_mission_3"
			},
			lookup_table_04 = {
				"level_fm_resurgence_mission_4",
				"level_cm_archives_mission_4",
				"level_hm_complex_mission_4"
			},
			lookup_table_05 = {
				"level_fm_resurgence_mission_5",
				"level_cm_archives_mission_5",
				"level_hm_complex_mission_5"
			}
		}
	},
	{
		name = "entertainment",
		local_variable = "loc_zone_name_carnival_short",
		category = "endeavours",
		icon = path .. "default",
		meta_tables = {
			lookup_table_01 = {
				"level_fm_armoury_mission_1",
				"level_cm_raid_mission_1"
			},
			lookup_table_02 = {
				"level_fm_armoury_mission_2",
				"level_cm_raid_mission_2"
			},
			lookup_table_03 = {
				"level_fm_armoury_mission_3",
				"level_cm_raid_mission_3"
			},
			lookup_table_04 = {
				"level_fm_armoury_mission_4",
				"level_cm_raid_mission_4"
			},
			lookup_table_05 = {
				"level_fm_armoury_mission_5",
				"level_cm_raid_mission_5"
			}
		}
	}
}
AchievementMissionGroups.zones = {
	{
		name = "transit",
		local_variable = "loc_zone_name_transit_short",
		category = "exploration_transit",
		icon = {
			zone_default = path .. "mission_achievements/missions_achievement_0001",
			destructible = path .. "mission_achievements/missions_achievement_0002"
		}
	},
	{
		name = "watertown",
		local_variable = "loc_zone_name_watertown_short",
		category = "exploration_watertown",
		icon = {
			zone_default = path .. "mission_achievements/missions_achievement_0007",
			destructible = path .. "mission_achievements/missions_achievement_0008"
		}
	},
	{
		name = "tank_foundry",
		local_variable = "loc_zone_name_tank_foundry_short",
		category = "exploration_foundry",
		icon = {
			zone_default = path .. "mission_achievements/missions_achievement_0003",
			destructible = path .. "mission_achievements/missions_achievement_0004"
		}
	},
	{
		name = "dust",
		local_variable = "loc_zone_name_hourglass_short",
		category = "exploration_dust",
		icon = {
			zone_default = path .. "mission_achievements/missions_achievement_0005",
			destructible = path .. "mission_achievements/missions_achievement_0006"
		}
	},
	{
		name = "throneside",
		local_variable = "loc_zone_name_throneside_short",
		category = "exploration_throneside",
		icon = {
			zone_default = path .. "mission_achievements/missions_achievement_0009",
			destructible = path .. "mission_achievements/missions_achievement_0010"
		}
	},
	{
		name = "entertainment",
		local_variable = "loc_zone_name_carnival_short",
		category = "exploration_entertainment",
		icon = {
			zone_default = path .. "mission_achievements/missions_achievement_0011",
			destructible = path .. "mission_achievements/missions_achievement_0016"
		}
	}
}
AchievementMissionGroups.zone_meta = {
	{
		name = "transit",
		local_variable = "loc_zone_name_transit_short",
		category = "exploration_transit",
		icon = path .. "mission_achievements/missions_achievement_0017",
		achievements = {
			"mission_zone_km_station_mission_collectible_1",
			"mission_zone_lm_rails_mission_collectible_1",
			"mission_zone_cm_habs_mission_collectible_1",
			"mission_zone_dm_rise_mission_collectible_1",
			"mission_zone_transit_destructible_3",
			"mission_zone_transit_3"
		}
	},
	{
		name = "watertown",
		local_variable = "loc_zone_name_watertown_short",
		category = "exploration_watertown",
		icon = path .. "mission_achievements/missions_achievement_0020",
		achievements = {
			"mission_zone_dm_stockpile_mission_collectible_1",
			"mission_zone_hm_cartel_mission_collectible_1",
			"mission_zone_km_enforcer_mission_collectible_1",
			"mission_zone_watertown_destructible_3",
			"mission_zone_watertown_3"
		}
	},
	{
		name = "tank_foundry",
		local_variable = "loc_zone_name_tank_foundry_short",
		category = "exploration_foundry",
		icon = path .. "mission_achievements/missions_achievement_0018",
		achievements = {
			"mission_zone_lm_cooling_mission_collectible_1",
			"mission_zone_fm_cargo_mission_collectible_1",
			"mission_zone_dm_forge_mission_collectible_1",
			"mission_zone_tank_foundry_destructible_3",
			"mission_zone_tank_foundry_3"
		}
	},
	{
		name = "dust",
		local_variable = "loc_zone_name_hourglass_short",
		category = "exploration_dust",
		icon = path .. "mission_achievements/missions_achievement_0019",
		achievements = {
			"mission_zone_lm_scavenge_mission_collectible_1",
			"mission_zone_hm_strain_mission_collectible_1",
			"mission_zone_dm_propaganda_mission_collectible_1",
			"mission_zone_dust_destructible_3",
			"mission_zone_dust_3"
		}
	},
	{
		name = "throneside",
		local_variable = "loc_zone_name_throneside_short",
		category = "exploration_throneside",
		icon = path .. "mission_achievements/missions_achievement_0021",
		achievements = {
			"mission_zone_fm_resurgence_mission_collectible_1",
			"mission_zone_cm_archives_mission_collectible_1",
			"mission_zone_hm_complex_mission_collectible_1",
			"mission_zone_throneside_destructible_3",
			"mission_zone_throneside_3"
		}
	},
	{
		name = "entertainment",
		local_variable = "loc_zone_name_carnival_short",
		category = "exploration_entertainment",
		icon = path .. "mission_achievements/missions_achievement_0022",
		achievements = {
			"mission_zone_fm_armoury_mission_collectible_1",
			"mission_zone_cm_raid_mission_collectible_1",
			"mission_zone_entertainment_destructible_3",
			"mission_zone_entertainment_3"
		}
	}
}

return AchievementMissionGroups
