-- chunkname: @scripts/managers/pacing/roamer_pacing/templates/expedition_roamer_pacing_template.lua

local RoamerLimits = require("scripts/settings/roamer/roamer_limits")
local RoamerPacks = require("scripts/settings/roamer/roamer_packs")
local default_packs = {
	melee_high = {
		renegade = RoamerPacks.expeditions_renegade_melee_high,
		cultist = RoamerPacks.expeditions_cultist_melee_high,
	},
	close_high = {
		renegade = RoamerPacks.expeditions_renegade_close_high,
		cultist = RoamerPacks.expeditions_cultist_close_high,
	},
	far_high = {
		renegade = RoamerPacks.expeditions_renegade_far_high,
		cultist = RoamerPacks.expeditions_cultist_far_high,
	},
	mixed_high = {
		renegade = RoamerPacks.expeditions_renegade_mixed_high,
		cultist = RoamerPacks.expeditions_cultist_mixed_high,
	},
	melee_low = {
		renegade = RoamerPacks.expeditions_renegade_melee_low,
		cultist = RoamerPacks.expeditions_cultist_melee_low,
	},
	close_low = {
		renegade = RoamerPacks.expeditions_renegade_close_low,
		cultist = RoamerPacks.expeditions_cultist_close_low,
	},
	far_low = {
		renegade = RoamerPacks.expeditions_renegade_far_low,
		cultist = RoamerPacks.expeditions_cultist_far_low,
	},
	mixed_low = {
		renegade = RoamerPacks.expeditions_renegade_mixed_low,
		cultist = RoamerPacks.expeditions_cultist_mixed_low,
	},
	encampment = {
		renegade = RoamerPacks.chaos_poxwalker_encampment,
		cultist = RoamerPacks.chaos_poxwalker_encampment,
	},
}
local empty_density_type = {
	zone_range = {
		1,
		1,
	},
	num_roamers_range = {
		renegade = {
			0,
			0,
		},
		cultist = {
			0,
			0,
		},
	},
	roamer_slot_placement_functions = {
		"circle_placement",
	},
	roamer_slot_placement_settings = {
		circle_placement = {
			num_slots = 1,
			position_offset = 1.1,
		},
	},
	packs = {},
}
local roamer_pacing_template = {
	chance_of_encampment = 0,
	name = "expedition_roamers",
	num_encampment_blocked_zones = 30,
	spawn_distance = 75,
	start_zone_index = 1,
	use_weighted_sub_zone_positions = true,
	zone_length = 10,
	use_num_patrols_override = function ()
		local heat = Managers.state.pacing:heat()

		if heat > 0 then
			return Managers.state.pacing:get_table_entry_by_heat_stage({
				3,
				2,
				1,
				1,
				1,
			})
		end

		return 3
	end,
	density_types = {
		"none",
		"low",
		"high",
	},
	density_order = {
		default = "none",
		high = "none",
		low = "high",
		none = "low",
	},
	sub_faction_types = {
		"cultist",
		"renegade",
	},
	encampment_types = {},
	density_settings = {
		{
			none = empty_density_type,
			low = {
				chance_to_skip_limits = 1,
				zone_range = {
					1,
					2,
				},
				num_roamers_range = {
					renegade = {
						1,
						3,
					},
					cultist = {
						2,
						4,
					},
				},
				roamer_slot_placement_functions = {
					"circle_placement",
				},
				roamer_slot_placement_settings = {
					circle_placement = {
						num_slots = 11,
						position_offset = 1.6,
					},
				},
				packs = {
					default_packs.melee_low,
					default_packs.close_low,
					default_packs.far_low,
					default_packs.melee_low,
					default_packs.close_low,
					default_packs.far_low,
					default_packs.mixed_low,
				},
				limits = RoamerLimits.low,
			},
			high = {
				zone_range = {
					2,
					3,
				},
				num_roamers_range = {
					renegade = {
						5,
						6,
					},
					cultist = {
						6,
						7,
					},
				},
				roamer_slot_placement_functions = {
					"circle_placement",
				},
				roamer_slot_placement_settings = {
					circle_placement = {
						num_slots = 7,
						position_offset = 1.6,
					},
				},
				packs = {
					default_packs.melee_high,
					default_packs.close_high,
					default_packs.far_high,
					default_packs.melee_high,
					default_packs.close_high,
					default_packs.far_high,
					default_packs.mixed_high,
				},
				limits = RoamerLimits.high,
			},
		},
		{
			none = empty_density_type,
			low = {
				chance_to_skip_limits = 1,
				zone_range = {
					1,
					2,
				},
				num_roamers_range = {
					renegade = {
						1,
						3,
					},
					cultist = {
						2,
						4,
					},
				},
				roamer_slot_placement_functions = {
					"circle_placement",
				},
				roamer_slot_placement_settings = {
					circle_placement = {
						num_slots = 11,
						position_offset = 1.6,
					},
				},
				packs = {
					default_packs.melee_low,
					default_packs.close_low,
					default_packs.far_low,
					default_packs.melee_low,
					default_packs.close_low,
					default_packs.far_low,
					default_packs.mixed_low,
				},
				limits = RoamerLimits.low,
			},
			high = {
				zone_range = {
					2,
					3,
				},
				num_roamers_range = {
					renegade = {
						5,
						7,
					},
					cultist = {
						8,
						9,
					},
				},
				roamer_slot_placement_functions = {
					"circle_placement",
				},
				roamer_slot_placement_settings = {
					circle_placement = {
						num_slots = 9,
						position_offset = 1.6,
					},
				},
				packs = {
					default_packs.melee_high,
					default_packs.close_high,
					default_packs.far_high,
					default_packs.melee_high,
					default_packs.close_high,
					default_packs.far_high,
					default_packs.mixed_high,
				},
				limits = RoamerLimits.high,
			},
		},
		{
			none = empty_density_type,
			low = {
				chance_to_skip_limits = 1,
				zone_range = {
					1,
					2,
				},
				num_roamers_range = {
					renegade = {
						1,
						3,
					},
					cultist = {
						2,
						4,
					},
				},
				roamer_slot_placement_functions = {
					"circle_placement",
				},
				roamer_slot_placement_settings = {
					circle_placement = {
						num_slots = 11,
						position_offset = 1.6,
					},
				},
				packs = {
					default_packs.melee_low,
					default_packs.close_low,
					default_packs.far_low,
					default_packs.melee_low,
					default_packs.close_low,
					default_packs.far_low,
					default_packs.mixed_low,
				},
				limits = RoamerLimits.low,
			},
			high = {
				chance_to_skip_limits = 1,
				zone_range = {
					2,
					3,
				},
				num_roamers_range = {
					renegade = {
						8,
						10,
					},
					cultist = {
						9,
						11,
					},
				},
				roamer_slot_placement_functions = {
					"circle_placement",
				},
				roamer_slot_placement_settings = {
					circle_placement = {
						num_slots = 11,
						position_offset = 1.6,
					},
				},
				packs = {
					default_packs.melee_high,
					default_packs.close_high,
					default_packs.far_high,
					default_packs.melee_high,
					default_packs.close_high,
					default_packs.far_high,
					default_packs.mixed_high,
				},
				limits = RoamerLimits.high,
			},
		},
		{
			none = empty_density_type,
			low = {
				chance_to_skip_limits = 1,
				zone_range = {
					1,
					2,
				},
				num_roamers_range = {
					renegade = {
						1,
						3,
					},
					cultist = {
						2,
						4,
					},
				},
				roamer_slot_placement_functions = {
					"circle_placement",
				},
				roamer_slot_placement_settings = {
					circle_placement = {
						num_slots = 11,
						position_offset = 1.6,
					},
				},
				packs = {
					default_packs.melee_low,
					default_packs.close_low,
					default_packs.far_low,
					default_packs.melee_low,
					default_packs.close_low,
					default_packs.far_low,
					default_packs.mixed_low,
				},
				limits = RoamerLimits.low,
			},
			high = {
				chance_to_skip_limits = 1,
				zone_range = {
					2,
					3,
				},
				num_roamers_range = {
					renegade = {
						8,
						10,
					},
					cultist = {
						9,
						11,
					},
				},
				roamer_slot_placement_functions = {
					"circle_placement",
				},
				roamer_slot_placement_settings = {
					circle_placement = {
						num_slots = 11,
						position_offset = 1.6,
					},
				},
				packs = {
					default_packs.melee_high,
					default_packs.close_high,
					default_packs.far_high,
					default_packs.melee_high,
					default_packs.close_high,
					default_packs.far_high,
					default_packs.mixed_high,
				},
				limits = RoamerLimits.high,
			},
		},
		{
			none = empty_density_type,
			low = {
				chance_to_skip_limits = 1,
				zone_range = {
					1,
					1,
				},
				num_roamers_range = {
					renegade = {
						2,
						4,
					},
					cultist = {
						3,
						5,
					},
				},
				roamer_slot_placement_functions = {
					"circle_placement",
				},
				roamer_slot_placement_settings = {
					circle_placement = {
						num_slots = 11,
						position_offset = 1.6,
					},
				},
				packs = {
					default_packs.melee_low,
					default_packs.close_low,
					default_packs.far_low,
					default_packs.melee_low,
					default_packs.close_low,
					default_packs.far_low,
					default_packs.mixed_low,
				},
				limits = RoamerLimits.low,
			},
			high = {
				chance_to_skip_limits = 1,
				zone_range = {
					2,
					3,
				},
				num_roamers_range = {
					renegade = {
						9,
						11,
					},
					cultist = {
						10,
						12,
					},
				},
				roamer_slot_placement_functions = {
					"circle_placement",
				},
				roamer_slot_placement_settings = {
					circle_placement = {
						num_slots = 11,
						position_offset = 1.6,
					},
				},
				packs = {
					default_packs.melee_high,
					default_packs.close_high,
					default_packs.far_high,
					default_packs.melee_high,
					default_packs.close_high,
					default_packs.far_high,
					default_packs.mixed_high,
				},
				limits = RoamerLimits.high,
			},
		},
	},
	num_encampments = {
		1,
		2,
	},
	faction_zone_length = {
		{
			3000,
			3000,
		},
		{
			3000,
			3000,
		},
		{
			3000,
			3000,
		},
		{
			3000,
			3000,
		},
		{
			3000,
			3000,
		},
	},
	ambience_sfx = {
		poxwalkers = {
			min_members = 5,
			start = "wwise/events/minions/play_minion_horde_poxwalker_encampment",
			stop = "wwise/events/minions/stop_minion_horde_poxwalker_encampment",
		},
	},
	aggro_sfx = {
		poxwalkers = {
			start = "wwise/events/minions/play_minion_horde_poxwalker_encampment_aggro",
			stop = "wwise/events/minions/stop_horde_group_sfx_poxwalkers",
		},
	},
	pause_spawn_type_when_aggroed = {
		poxwalkers = {
			hordes = {
				100,
				80,
				60,
				30,
				20,
			},
		},
	},
	trigger_horde_when_aggroed = {},
}
local density_types = roamer_pacing_template.density_types

for i = 1, #density_types do
	local density_type = density_types[i]

	for j = 1, #roamer_pacing_template.density_settings do
		-- Nothing
	end
end

local encampment_types = roamer_pacing_template.encampment_types

for i = 1, #encampment_types do
	local encampment_type = encampment_types[i]

	for j = 1, #roamer_pacing_template.density_settings do
		-- Nothing
	end
end

return roamer_pacing_template
