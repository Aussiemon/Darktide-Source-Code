local RoamerPacks = require("scripts/settings/roamer/roamer_packs")
local RoamerLimits = require("scripts/settings/roamer/roamer_limits")
local roamer_settings = {
	density_types = {
		"none",
		"high",
		"low"
	},
	faction_types = {
		"traitor_guards"
	},
	encampment_types = {
		"poxwalkers"
	}
}
local default_packs = {
	melee_low = {
		traitor_guards = RoamerPacks.renegade_melee_low,
		cultists = RoamerPacks.cultist_melee_low
	},
	melee_high = {
		traitor_guards = RoamerPacks.renegade_melee_high,
		cultists = RoamerPacks.cultist_melee_high
	},
	close_low = {
		traitor_guards = RoamerPacks.renegade_close_low,
		cultists = RoamerPacks.cultist_close_low
	},
	close_high = {
		traitor_guards = RoamerPacks.renegade_close_high,
		cultists = RoamerPacks.cultist_close_high
	},
	far_low = {
		traitor_guards = RoamerPacks.renegade_far_low,
		cultists = RoamerPacks.cultist_far_low
	},
	far_high = {
		traitor_guards = RoamerPacks.renegade_far_high,
		cultists = RoamerPacks.cultist_far_high
	},
	none = {
		traitor_guards = RoamerPacks.renegade_traitor_mix_none,
		cultists = RoamerPacks.cultist_infected_mix_none
	},
	encampment = {
		traitor_guards = RoamerPacks.chaos_poxwalker_encampment,
		cultists = RoamerPacks.chaos_poxwalker_encampment
	}
}
roamer_settings.density_settings = {
	{
		low = {
			zone_range = {
				5,
				6
			},
			num_roamers_range = {
				traitor_guards = {
					2,
					2
				},
				cultists = {
					2,
					2
				}
			},
			roamer_slot_placement_functions = {
				"circle_placement"
			},
			roamer_slot_placement_settings = {
				circle_placement = {
					num_slots = 2,
					position_offset = 1
				}
			},
			packs = {
				default_packs.melee_low,
				default_packs.close_low,
				default_packs.far_low,
				default_packs.none,
				default_packs.none,
				default_packs.none
			},
			limits = RoamerLimits.low
		},
		high = {
			zone_range = {
				2,
				2
			},
			num_roamers_range = {
				traitor_guards = {
					4,
					5
				},
				cultists = {
					4,
					5
				}
			},
			roamer_slot_placement_functions = {
				"circle_placement"
			},
			roamer_slot_placement_settings = {
				circle_placement = {
					num_slots = 5,
					position_offset = 1.1
				}
			},
			packs = {
				default_packs.melee_high,
				default_packs.close_high,
				default_packs.far_high,
				default_packs.melee_high,
				default_packs.close_high,
				default_packs.far_high
			},
			limits = RoamerLimits.high
		},
		none = {
			zone_range = {
				4,
				6
			},
			num_roamers_range = {
				traitor_guards = {
					1,
					1
				},
				cultists = {
					1,
					1
				}
			},
			roamer_slot_placement_functions = {
				"circle_placement"
			},
			roamer_slot_placement_settings = {
				circle_placement = {
					num_slots = 1,
					position_offset = 1.1
				}
			},
			packs = {
				default_packs.none,
				default_packs.none,
				default_packs.none,
				default_packs.none,
				default_packs.none,
				default_packs.none
			}
		},
		poxwalkers = {
			try_fill_one_sub_zone = true,
			shared_aggro_trigger = true,
			empty_zone_range = {
				2,
				3
			},
			zone_range = {
				1,
				1
			},
			num_roamers_range = {
				traitor_guards = {
					40,
					50
				},
				cultists = {
					40,
					50
				}
			},
			roamer_slot_placement_functions = {
				"flood_fill"
			},
			roamer_slot_placement_settings = {
				flood_fill = {
					num_slots = 50
				}
			},
			packs = {
				default_packs.encampment,
				default_packs.encampment,
				default_packs.encampment,
				default_packs.encampment,
				default_packs.encampment,
				default_packs.encampment
			}
		}
	},
	{
		low = {
			zone_range = {
				3,
				4
			},
			num_roamers_range = {
				traitor_guards = {
					2,
					3
				},
				cultists = {
					3,
					4
				}
			},
			roamer_slot_placement_functions = {
				"circle_placement"
			},
			roamer_slot_placement_settings = {
				circle_placement = {
					num_slots = 5,
					position_offset = 1
				}
			},
			packs = {
				default_packs.melee_low,
				default_packs.close_low,
				default_packs.far_low,
				default_packs.melee_low,
				default_packs.close_low,
				default_packs.far_low
			},
			limits = RoamerLimits.low
		},
		high = {
			zone_range = {
				2,
				3
			},
			num_roamers_range = {
				traitor_guards = {
					4,
					6
				},
				cultists = {
					6,
					8
				}
			},
			roamer_slot_placement_functions = {
				"circle_placement"
			},
			roamer_slot_placement_settings = {
				circle_placement = {
					num_slots = 6,
					position_offset = 1.1
				}
			},
			packs = {
				default_packs.melee_high,
				default_packs.close_high,
				default_packs.far_high,
				default_packs.melee_high,
				default_packs.close_high,
				default_packs.far_high
			},
			limits = RoamerLimits.high
		},
		none = {
			zone_range = {
				3,
				6
			},
			num_roamers_range = {
				traitor_guards = {
					1,
					1
				},
				cultists = {
					1,
					2
				}
			},
			roamer_slot_placement_functions = {
				"circle_placement"
			},
			roamer_slot_placement_settings = {
				circle_placement = {
					num_slots = 1,
					position_offset = 1.1
				}
			},
			packs = {
				default_packs.none,
				default_packs.none,
				default_packs.none,
				default_packs.none,
				default_packs.none,
				default_packs.none
			}
		},
		poxwalkers = {
			try_fill_one_sub_zone = true,
			shared_aggro_trigger = true,
			empty_zone_range = {
				2,
				3
			},
			zone_range = {
				1,
				1
			},
			num_roamers_range = {
				traitor_guards = {
					50,
					60
				},
				cultists = {
					50,
					60
				}
			},
			roamer_slot_placement_functions = {
				"flood_fill"
			},
			roamer_slot_placement_settings = {
				flood_fill = {
					num_slots = 60
				}
			},
			packs = {
				default_packs.encampment,
				default_packs.encampment,
				default_packs.encampment,
				default_packs.encampment,
				default_packs.encampment,
				default_packs.encampment
			}
		}
	},
	{
		low = {
			zone_range = {
				4,
				5
			},
			num_roamers_range = {
				traitor_guards = {
					2,
					4
				},
				cultists = {
					3,
					5
				}
			},
			roamer_slot_placement_functions = {
				"circle_placement"
			},
			roamer_slot_placement_settings = {
				circle_placement = {
					num_slots = 4,
					position_offset = 1
				}
			},
			packs = {
				default_packs.melee_low,
				default_packs.close_low,
				default_packs.far_low,
				default_packs.melee_low,
				default_packs.close_low,
				default_packs.far_low
			},
			limits = RoamerLimits.low
		},
		high = {
			zone_range = {
				3,
				4
			},
			num_roamers_range = {
				traitor_guards = {
					7,
					9
				},
				cultists = {
					9,
					11
				}
			},
			roamer_slot_placement_functions = {
				"circle_placement"
			},
			roamer_slot_placement_settings = {
				circle_placement = {
					num_slots = 6,
					position_offset = 1.1
				}
			},
			packs = {
				default_packs.melee_high,
				default_packs.close_high,
				default_packs.far_high,
				default_packs.melee_high,
				default_packs.close_high,
				default_packs.far_high
			},
			limits = RoamerLimits.high
		},
		none = {
			zone_range = {
				2,
				5
			},
			num_roamers_range = {
				traitor_guards = {
					1,
					1
				},
				cultists = {
					1,
					2
				}
			},
			roamer_slot_placement_functions = {
				"circle_placement"
			},
			roamer_slot_placement_settings = {
				circle_placement = {
					num_slots = 1,
					position_offset = 1.1
				}
			},
			packs = {
				default_packs.melee_low,
				default_packs.melee_low,
				default_packs.melee_low,
				default_packs.none,
				default_packs.none,
				default_packs.none
			}
		},
		poxwalkers = {
			try_fill_one_sub_zone = true,
			shared_aggro_trigger = true,
			empty_zone_range = {
				2,
				3
			},
			zone_range = {
				1,
				1
			},
			num_roamers_range = {
				traitor_guards = {
					60,
					70
				},
				cultists = {
					60,
					70
				}
			},
			roamer_slot_placement_functions = {
				"flood_fill"
			},
			roamer_slot_placement_settings = {
				flood_fill = {
					num_slots = 70
				}
			},
			packs = {
				default_packs.encampment,
				default_packs.encampment,
				default_packs.encampment,
				default_packs.encampment,
				default_packs.encampment,
				default_packs.encampment
			}
		}
	},
	{
		low = {
			zone_range = {
				3,
				4
			},
			num_roamers_range = {
				traitor_guards = {
					3,
					5
				},
				cultists = {
					3,
					5
				}
			},
			roamer_slot_placement_functions = {
				"circle_placement"
			},
			roamer_slot_placement_settings = {
				circle_placement = {
					num_slots = 4,
					position_offset = 1
				}
			},
			packs = {
				default_packs.melee_low,
				default_packs.close_low,
				default_packs.far_low,
				default_packs.melee_low,
				default_packs.close_low,
				default_packs.far_low
			},
			limits = RoamerLimits.low
		},
		high = {
			zone_range = {
				3,
				4
			},
			num_roamers_range = {
				traitor_guards = {
					8,
					10
				},
				cultists = {
					8,
					10
				}
			},
			roamer_slot_placement_functions = {
				"circle_placement"
			},
			roamer_slot_placement_settings = {
				circle_placement = {
					num_slots = 6,
					position_offset = 1.1
				}
			},
			packs = {
				default_packs.melee_high,
				default_packs.close_high,
				default_packs.far_high,
				default_packs.melee_high,
				default_packs.close_high,
				default_packs.far_high
			},
			limits = RoamerLimits.high
		},
		none = {
			zone_range = {
				2,
				4
			},
			num_roamers_range = {
				traitor_guards = {
					1,
					1
				},
				cultists = {
					1,
					1
				}
			},
			roamer_slot_placement_functions = {
				"circle_placement"
			},
			roamer_slot_placement_settings = {
				circle_placement = {
					num_slots = 1,
					position_offset = 1.1
				}
			},
			packs = {
				default_packs.melee_low,
				default_packs.melee_low,
				default_packs.melee_low,
				default_packs.none,
				default_packs.none,
				default_packs.none
			}
		},
		poxwalkers = {
			try_fill_one_sub_zone = true,
			shared_aggro_trigger = true,
			empty_zone_range = {
				2,
				2
			},
			zone_range = {
				1,
				1
			},
			num_roamers_range = {
				traitor_guards = {
					70,
					80
				},
				cultists = {
					70,
					80
				}
			},
			roamer_slot_placement_functions = {
				"flood_fill"
			},
			roamer_slot_placement_settings = {
				flood_fill = {
					num_slots = 80
				}
			},
			packs = {
				default_packs.encampment,
				default_packs.encampment,
				default_packs.encampment,
				default_packs.encampment,
				default_packs.encampment,
				default_packs.encampment
			}
		}
	},
	{
		low = {
			zone_range = {
				3,
				5
			},
			num_roamers_range = {
				traitor_guards = {
					4,
					6
				},
				cultists = {
					4,
					6
				}
			},
			roamer_slot_placement_functions = {
				"circle_placement"
			},
			roamer_slot_placement_settings = {
				circle_placement = {
					num_slots = 4,
					position_offset = 1
				}
			},
			packs = {
				default_packs.melee_low,
				default_packs.close_low,
				default_packs.far_low,
				default_packs.melee_low,
				default_packs.close_low,
				default_packs.far_low
			},
			limits = RoamerLimits.low
		},
		high = {
			zone_range = {
				4,
				5
			},
			num_roamers_range = {
				traitor_guards = {
					9,
					11
				},
				cultists = {
					9,
					11
				}
			},
			roamer_slot_placement_functions = {
				"circle_placement"
			},
			roamer_slot_placement_settings = {
				circle_placement = {
					num_slots = 7,
					position_offset = 1.15
				}
			},
			packs = {
				default_packs.melee_high,
				default_packs.close_high,
				default_packs.far_high,
				default_packs.melee_high,
				default_packs.close_high,
				default_packs.far_high
			},
			limits = RoamerLimits.high
		},
		none = {
			zone_range = {
				2,
				3
			},
			num_roamers_range = {
				traitor_guards = {
					1,
					1
				},
				cultists = {
					1,
					1
				}
			},
			roamer_slot_placement_functions = {
				"circle_placement"
			},
			roamer_slot_placement_settings = {
				circle_placement = {
					num_slots = 1,
					position_offset = 1.1
				}
			},
			packs = {
				default_packs.melee_low,
				default_packs.melee_low,
				default_packs.melee_low,
				default_packs.none,
				default_packs.none,
				default_packs.none
			}
		},
		poxwalkers = {
			try_fill_one_sub_zone = true,
			shared_aggro_trigger = true,
			empty_zone_range = {
				2,
				2
			},
			zone_range = {
				1,
				1
			},
			num_roamers_range = {
				traitor_guards = {
					80,
					90
				},
				cultists = {
					80,
					90
				}
			},
			roamer_slot_placement_functions = {
				"flood_fill"
			},
			roamer_slot_placement_settings = {
				flood_fill = {
					num_slots = 90
				}
			},
			packs = {
				default_packs.encampment,
				default_packs.encampment,
				default_packs.encampment,
				default_packs.encampment,
				default_packs.encampment,
				default_packs.encampment
			}
		}
	}
}
local density_types = roamer_settings.density_types

for i = 1, #density_types, 1 do
	local density_type = density_types[i]

	for j = 1, #roamer_settings.density_settings, 1 do
		fassert(roamer_settings.density_settings[j][density_type], "Missing density settings for density type %s with resistance %d in roamer_settings.lua", density_type, j)
	end
end

local encampment_types = roamer_settings.encampment_types

for i = 1, #encampment_types, 1 do
	local encampment_type = encampment_types[i]

	for j = 1, #roamer_settings.density_settings, 1 do
		fassert(roamer_settings.density_settings[j][encampment_type], "Missing density settings for encampment_type %s with resistance %d in roamer_settings.lua", encampment_type, j)
	end
end

roamer_settings.spawn_distance = 75
roamer_settings.zone_length = 10
roamer_settings.num_encampments = {
	1,
	2
}
roamer_settings.chance_of_encampment = 0.1
roamer_settings.num_encampment_blocked_zones = 30
roamer_settings.faction_zone_length = {
	15,
	30
}
roamer_settings.ambience_sfx = {
	poxwalkers = {
		min_members = 5,
		start = "wwise/events/minions/play_minion_horde_poxwalker_encampment",
		stop = "wwise/events/minions/stop_minion_horde_poxwalker_encampment"
	}
}
roamer_settings.aggro_sfx = {
	poxwalkers = {
		stop = "wwise/events/minions/stop_horde_group_sfx_poxwalkers",
		start = "wwise/events/minions/play_minion_horde_poxwalker_encampment_aggro"
	}
}
roamer_settings.pause_spawn_type_when_aggroed = {
	poxwalkers = {
		hordes = {
			120,
			100,
			80,
			60,
			40
		}
	}
}

return settings("RoamerSettings", roamer_settings)
