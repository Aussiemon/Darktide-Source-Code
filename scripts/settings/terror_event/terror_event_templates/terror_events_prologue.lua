-- chunkname: @scripts/settings/terror_event/terror_event_templates/terror_events_prologue.lua

local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	events = {
		event_pacing_off = {
			{
				"set_pacing_enabled",
				enabled = false
			}
		},
		event_pacing_on = {
			{
				"set_pacing_enabled",
				enabled = true
			}
		},
		event_prologue_melee_sewer_tutorial_a = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_poxwalker",
				limit_spawners = 1,
				spawner_group = "spawner_melee_sewer_tutorial_a"
			},
			{
				"delay",
				duration = 1
			},
			{
				"continue_when",
				duration = 8,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"flow_event",
				flow_event_name = "event_prologue_melee_sewer_tutorial_a_completed"
			}
		},
		event_prologue_melee_sewer_tutorial_b = {
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_poxwalker",
				limit_spawners = 2,
				spawner_group = "spawner_melee_sewer_tutorial_b"
			},
			{
				"delay",
				duration = 1
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"flow_event",
				flow_event_name = "event_prologue_melee_sewer_tutorial_b_completed"
			}
		},
		event_prologue_melee_sewer_tutorial_c = {
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "chaos_poxwalker",
				limit_spawners = 3,
				spawner_group = "spawner_melee_sewer_tutorial_c"
			},
			{
				"delay",
				duration = 1
			},
			{
				"continue_when",
				duration = 30,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"flow_event",
				flow_event_name = "event_prologue_melee_sewer_tutorial_c_completed"
			}
		},
		event_prologue_heavy_melee_tutorial = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_melee",
				limit_spawners = 2,
				spawner_group = "spawner_heavy_melee_tutorial"
			},
			{
				"delay",
				duration = 3
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"flow_event",
				flow_event_name = "event_prologue_heavy_melee_tutorial_completed"
			}
		},
		event_prologue_melee_guardhouse_a = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_melee",
				limit_spawners = 1,
				spawner_group = "spawner_melee_guardhouse_a"
			},
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_melee",
				limit_spawners = 1,
				spawner_group = "spawner_melee_guardhouse_a"
			},
			{
				"delay",
				duration = 3
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_melee",
				limit_spawners = 1,
				spawner_group = "spawner_melee_guardhouse_a"
			},
			{
				"delay",
				duration = 1
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"flow_event",
				flow_event_name = "event_prologue_melee_guardhouse_a_completed"
			}
		},
		event_prologue_melee_guardhouse_b = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_melee",
				limit_spawners = 1,
				spawner_group = "spawner_melee_guardhouse_b"
			},
			{
				"delay",
				duration = 1
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"flow_event",
				flow_event_name = "event_prologue_melee_guardhouse_b_completed"
			}
		},
		event_prologue_melee_section_a = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_melee",
				limit_spawners = 2,
				spawner_group = "spawner_melee_section_a"
			},
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_melee",
				limit_spawners = 2,
				spawner_group = "spawner_melee_section_a"
			},
			{
				"delay",
				duration = 1
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"flow_event",
				flow_event_name = "event_prologue_melee_section_one_third"
			}
		},
		event_prologue_melee_section_b = {
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "chaos_poxwalker",
				limit_spawners = 2,
				spawner_group = "spawner_melee_section_b"
			},
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "chaos_poxwalker",
				limit_spawners = 2,
				spawner_group = "spawner_melee_section_b"
			},
			{
				"delay",
				duration = 2
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end
			},
			{
				"flow_event",
				flow_event_name = "event_prologue_melee_section_two_thirds"
			},
			{
				"flow_event",
				flow_event_name = "event_prologue_melee_section_completed"
			}
		},
		event_prologue_cs03 = {
			{
				"spawn_by_breed_name",
				breed_amount = 3,
				breed_name = "renegade_melee",
				limit_spawners = 2,
				spawner_group = "spawner_cs03_a"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"flow_event",
				flow_event_name = "event_prologue_cs03_completed"
			}
		},
		event_prologue_ranged_section_a = {
			{
				"spawn_by_breed_name",
				breed_amount = 3,
				breed_name = "renegade_rifleman",
				limit_spawners = 1,
				spawner_group = "spawner_ranged_port_a"
			},
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_melee",
				limit_spawners = 1,
				spawner_group = "spawner_ranged_port_a"
			},
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_assault",
				limit_spawners = 1,
				spawner_group = "spawner_ranged_port_a"
			},
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_melee",
				limit_spawners = 1,
				spawner_group = "spawner_ranged_port_a"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"delay",
				duration = 3
			},
			{
				"flow_event",
				flow_event_name = "event_prologue_ranged_section_a_completed"
			}
		},
		event_prologue_ranged_section_b = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_assault",
				limit_spawners = 2,
				spawner_group = "spawner_ranged_port_b"
			},
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_melee",
				limit_spawners = 2,
				spawner_group = "spawner_ranged_port_b"
			},
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_assault",
				limit_spawners = 2,
				spawner_group = "spawner_ranged_port_b2"
			},
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_melee",
				limit_spawners = 2,
				spawner_group = "spawner_ranged_port_b2"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"delay",
				duration = 3
			},
			{
				"flow_event",
				flow_event_name = "event_prologue_ranged_section_b_completed"
			}
		},
		event_prologue_ranged_c = {
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "renegade_assault",
				limit_spawners = 2,
				spawner_group = "spawner_ranged_port_c"
			},
			{
				"delay",
				duration = 3
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "renegade_melee",
				limit_spawners = 2,
				spawner_group = "spawner_ranged_port_c"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"delay",
				duration = 3
			},
			{
				"flow_event",
				flow_event_name = "event_prologue_ranged_section_c_completed"
			}
		},
		event_prologue_hangar_enter = {
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "renegade_assault",
				limit_spawners = 3,
				spawner_group = "spawner_hangar_enter"
			},
			{
				"spawn_by_breed_name",
				breed_amount = 3,
				breed_name = "renegade_melee",
				limit_spawners = 3,
				spawner_group = "spawner_hangar_enter"
			},
			{
				"delay",
				duration = 1
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			}
		},
		event_prologue_hangar_survive_a = {
			{
				"flow_event",
				flow_event_name = "sfx_enemy_wave"
			},
			{
				"spawn_by_breed_name",
				breed_amount = 4,
				breed_name = "renegade_melee",
				limit_spawners = 3,
				spawner_group = "spawner_hangar_balcony"
			},
			{
				"flow_event",
				flow_event_name = "sfx_enemy_wave"
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "renegade_melee",
				limit_spawners = 3,
				spawner_group = "spawner_hangar_ranged"
			},
			{
				"delay",
				duration = 3
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 7
				end
			},
			{
				"flow_event",
				flow_event_name = "sfx_enemy_pox_wave"
			},
			{
				"flow_event",
				flow_event_name = "event_prologue_hangar_survive_a_before_poxwalkers"
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 1,
				spawner_group = "spawner_hangar_horde_left"
			},
			{
				"flow_event",
				flow_event_name = "sfx_enemy_wave"
			},
			{
				"spawn_by_breed_name",
				breed_amount = 5,
				breed_name = "renegade_melee",
				limit_spawners = 1,
				spawner_group = "spawner_hangar_horde_left"
			},
			{
				"flow_event",
				flow_event_name = "sfx_enemy_wave"
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 1,
				spawner_group = "spawner_hangar_horde_right"
			},
			{
				"spawn_by_breed_name",
				breed_amount = 5,
				breed_name = "renegade_melee",
				limit_spawners = 1,
				spawner_group = "spawner_hangar_horde_right"
			},
			{
				"delay",
				duration = 3
			},
			{
				"continue_when",
				duration = 120,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end
			},
			{
				"flow_event",
				flow_event_name = "sfx_enemy_wave"
			},
			{
				"spawn_by_breed_name",
				breed_amount = 40,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_hangar_melee"
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "renegade_melee",
				limit_spawners = 5,
				spawner_group = "spawner_hangar_melee"
			},
			{
				"delay",
				duration = 3
			},
			{
				"continue_when",
				duration = 90,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"flow_event",
				flow_event_name = "event_prologue_hangar_survive_a_completed"
			}
		}
	}
}

return template
