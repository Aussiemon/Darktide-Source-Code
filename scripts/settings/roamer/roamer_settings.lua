local RoamerPacks = require("scripts/settings/roamer/roamer_packs")
local RoamerLimits = require("scripts/settings/roamer/roamer_limits")
local HordeCompositions = require("scripts/managers/pacing/horde_pacing/horde_compositions")
local roamer_settings = {
	density_types = {
		"none",
		"high",
		"low"
	},
	faction_types = {
		"renegade",
		"cultist"
	},
	encampment_types = {
		"poxwalkers"
	}
}
local default_packs = {
	melee_low = {
		renegade = RoamerPacks.renegade_melee_low,
		cultist = RoamerPacks.cultist_melee_low
	},
	melee_high = {
		renegade = RoamerPacks.renegade_melee_high,
		cultist = RoamerPacks.cultist_melee_high
	},
	close_low = {
		renegade = RoamerPacks.renegade_close_low,
		cultist = RoamerPacks.cultist_close_low
	},
	close_high = {
		renegade = RoamerPacks.renegade_close_high,
		cultist = RoamerPacks.cultist_close_high
	},
	far_low = {
		renegade = RoamerPacks.renegade_far_low,
		cultist = RoamerPacks.cultist_far_low
	},
	far_high = {
		renegade = RoamerPacks.renegade_far_high,
		cultist = RoamerPacks.cultist_far_high
	},
	none = {
		renegade = RoamerPacks.renegade_traitor_mix_none,
		cultist = RoamerPacks.cultist_infected_mix_none
	},
	encampment = {
		renegade = RoamerPacks.chaos_poxwalker_encampment,
		cultist = RoamerPacks.chaos_poxwalker_encampment
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
				renegade = {
					2,
					3
				},
				cultist = {
					3,
					4
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
				renegade = {
					4,
					5
				},
				cultist = {
					5,
					6
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
				renegade = {
					1,
					1
				},
				cultist = {
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
				renegade = {
					30,
					40
				},
				cultist = {
					30,
					40
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
				renegade = {
					2,
					3
				},
				cultist = {
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
				renegade = {
					4,
					6
				},
				cultist = {
					5,
					7
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
				renegade = {
					1,
					1
				},
				cultist = {
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
				renegade = {
					40,
					50
				},
				cultist = {
					40,
					50
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
				renegade = {
					2,
					4
				},
				cultist = {
					3,
					4
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
				renegade = {
					7,
					9
				},
				cultist = {
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
				renegade = {
					1,
					1
				},
				cultist = {
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
			},
			limits = RoamerLimits.none
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
				renegade = {
					40,
					50
				},
				cultist = {
					40,
					50
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
				3,
				4
			},
			num_roamers_range = {
				renegade = {
					3,
					5
				},
				cultist = {
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
				3,
				4
			},
			num_roamers_range = {
				renegade = {
					8,
					10
				},
				cultist = {
					10,
					12
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
				renegade = {
					1,
					1
				},
				cultist = {
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
			},
			limits = RoamerLimits.none
		},
		poxwalkers = {
			try_fill_one_sub_zone = true,
			shared_aggro_trigger = true,
			empty_zone_range = {
				1,
				1
			},
			zone_range = {
				1,
				1
			},
			num_roamers_range = {
				renegade = {
					45,
					55
				},
				cultist = {
					45,
					55
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
				5
			},
			num_roamers_range = {
				renegade = {
					4,
					6
				},
				cultist = {
					5,
					7
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
				renegade = {
					9,
					11
				},
				cultist = {
					11,
					13
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
				renegade = {
					1,
					1
				},
				cultist = {
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
			},
			limits = RoamerLimits.none
		},
		poxwalkers = {
			try_fill_one_sub_zone = true,
			shared_aggro_trigger = true,
			empty_zone_range = {
				1,
				1
			},
			zone_range = {
				1,
				1
			},
			num_roamers_range = {
				renegade = {
					45,
					55
				},
				cultist = {
					45,
					55
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
	}
}
local density_types = roamer_settings.density_types

for i = 1, #density_types do
	local density_type = density_types[i]

	for j = 1, #roamer_settings.density_settings do
	end
end

local encampment_types = roamer_settings.encampment_types

for i = 1, #encampment_types do
	local encampment_type = encampment_types[i]

	for j = 1, #roamer_settings.density_settings do
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
	{
		3000,
		3000
	},
	{
		3000,
		3000
	},
	{
		20,
		40
	},
	{
		15,
		30
	},
	{
		15,
		30
	}
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
			100,
			80,
			60,
			30,
			20
		}
	}
}
roamer_settings.trigger_horde_when_aggroed = {
	poxwalkers = {
		horde_template_name = "flood_horde",
		composition = HordeCompositions.renegade_flood
	}
}

return settings("RoamerSettings", roamer_settings)
