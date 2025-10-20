-- chunkname: @scripts/settings/components/enemy_event_spawner_settings.lua

local enemy_event_spawner_compositions = {
	nurgle_totem = {
		renegade = {
			{
				{
					breeds = {
						{
							name = "chaos_spawn",
							amount = {
								1,
								1,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "chaos_spawn",
							amount = {
								1,
								1,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "chaos_spawn",
							amount = {
								1,
								1,
							},
						},
						{
							name = "renegade_melee",
							amount = {
								1,
								2,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "chaos_spawn",
							amount = {
								1,
								1,
							},
						},
						{
							name = "renegade_flamer",
							amount = {
								1,
								3,
							},
						},
						{
							name = "renegade_grenadier",
							amount = {
								1,
								3,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "chaos_spawn",
							amount = {
								1,
								1,
							},
						},
						{
							name = "renegade_flamer",
							amount = {
								1,
								4,
							},
						},
						{
							name = "renegade_grenadier",
							amount = {
								1,
								3,
							},
						},
					},
				},
			},
			{
				{
					breeds = {
						{
							name = "chaos_spawn",
							amount = {
								1,
								1,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "chaos_spawn",
							amount = {
								1,
								1,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "chaos_spawn",
							amount = {
								1,
								1,
							},
						},
						{
							name = "renegade_melee",
							amount = {
								1,
								2,
							},
						},
						{
							name = "renegade_berzerker",
							amount = {
								1,
								2,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "chaos_spawn",
							amount = {
								1,
								1,
							},
						},
						{
							name = "renegade_executor",
							amount = {
								1,
								3,
							},
						},
						{
							name = "renegade_berzerker",
							amount = {
								1,
								3,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "chaos_spawn",
							amount = {
								1,
								1,
							},
						},
						{
							name = "renegade_executor",
							amount = {
								1,
								4,
							},
						},
						{
							name = "renegade_berzerker",
							amount = {
								1,
								3,
							},
						},
					},
				},
			},
		},
		cultist = {
			{
				{
					breeds = {
						{
							name = "chaos_spawn",
							amount = {
								1,
								1,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "chaos_spawn",
							amount = {
								1,
								1,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "chaos_spawn",
							amount = {
								1,
								1,
							},
						},
						{
							name = "cultist_melee",
							amount = {
								1,
								2,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "chaos_spawn",
							amount = {
								1,
								1,
							},
						},
						{
							name = "cultist_flamer",
							amount = {
								1,
								3,
							},
						},
						{
							name = "cultist_grenadier",
							amount = {
								1,
								3,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "chaos_spawn",
							amount = {
								1,
								1,
							},
						},
						{
							name = "cultist_flamer",
							amount = {
								1,
								4,
							},
						},
						{
							name = "cultist_grenadier",
							amount = {
								1,
								3,
							},
						},
					},
				},
			},
			{
				{
					breeds = {
						{
							name = "chaos_spawn",
							amount = {
								1,
								1,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "chaos_spawn",
							amount = {
								1,
								1,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "chaos_spawn",
							amount = {
								1,
								1,
							},
						},
						{
							name = "cultist_flamer",
							amount = {
								1,
								2,
							},
						},
						{
							name = "cultist_berzerker",
							amount = {
								1,
								2,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "chaos_spawn",
							amount = {
								1,
								1,
							},
						},
						{
							name = "cultist_flamer",
							amount = {
								1,
								3,
							},
						},
						{
							name = "cultist_berzerker",
							amount = {
								1,
								3,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "chaos_spawn",
							amount = {
								1,
								1,
							},
						},
						{
							name = "cultist_flamer",
							amount = {
								1,
								4,
							},
						},
						{
							name = "cultist_berzerker",
							amount = {
								1,
								3,
							},
						},
					},
				},
			},
		},
	},
	live_event_skull_totem_guards = {
		renegade = {
			{
				{
					breeds = {
						{
							name = "renegade_melee",
							amount = {
								3,
								5,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "renegade_melee",
							amount = {
								4,
								8,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "renegade_melee",
							amount = {
								2,
								4,
							},
						},
						{
							name = "renegade_berzerker",
							amount = {
								1,
								2,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "renegade_melee",
							amount = {
								2,
								4,
							},
						},
						{
							name = "renegade_berzerker",
							amount = {
								2,
								4,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "renegade_melee",
							amount = {
								2,
								4,
							},
						},
						{
							name = "renegade_berzerker",
							amount = {
								2,
								4,
							},
						},
						{
							name = "renegade_captain",
							amount = {
								1,
								1,
							},
						},
					},
				},
			},
		},
		cultist = {
			{
				{
					breeds = {
						{
							name = "cultist_melee",
							amount = {
								3,
								5,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "cultist_melee",
							amount = {
								4,
								8,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "cultist_melee",
							amount = {
								2,
								4,
							},
						},
						{
							name = "cultist_berzerker",
							amount = {
								1,
								2,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "cultist_melee",
							amount = {
								2,
								4,
							},
						},
						{
							name = "cultist_berzerker",
							amount = {
								2,
								4,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "cultist_melee",
							amount = {
								2,
								4,
							},
						},
						{
							name = "cultist_berzerker",
							amount = {
								2,
								4,
							},
						},
						{
							name = "cultist_captain",
							amount = {
								1,
								1,
							},
						},
					},
				},
			},
		},
	},
	live_event_plasma_smugglers = {
		renegade = {
			{
				{
					breeds = {
						{
							name = "renegade_captain",
							amount = {
								1,
								1,
							},
						},
						{
							name = "renegade_plasma_gunner",
							amount = {
								2,
								3,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "renegade_captain",
							amount = {
								1,
								1,
							},
						},
						{
							name = "renegade_plasma_gunner",
							amount = {
								2,
								4,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "renegade_captain",
							amount = {
								1,
								1,
							},
						},
						{
							name = "renegade_plasma_gunner",
							amount = {
								3,
								4,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "renegade_captain",
							amount = {
								1,
								1,
							},
						},
						{
							name = "renegade_plasma_gunner",
							amount = {
								3,
								5,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "renegade_captain",
							amount = {
								1,
								1,
							},
						},
						{
							name = "renegade_plasma_gunner",
							amount = {
								4,
								6,
							},
						},
					},
				},
			},
		},
	},
	live_event_stolen_rations_stat_recover_spawns = {
		renegade = {
			{
				{
					breeds = {
						{
							name = "renegade_captain",
							amount = {
								1,
								1,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "renegade_captain",
							amount = {
								1,
								1,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "renegade_captain",
							amount = {
								1,
								1,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "renegade_captain",
							amount = {
								1,
								2,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "renegade_captain",
							amount = {
								2,
								2,
							},
						},
					},
				},
			},
		},
	},
	live_event_stolen_rations_stat_destroy_spawns = {
		renegade = {
			{
				{
					breeds = {
						{
							name = "chaos_plague_ogryn",
							amount = {
								1,
								1,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "chaos_plague_ogryn",
							amount = {
								1,
								1,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "chaos_plague_ogryn",
							amount = {
								1,
								1,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "chaos_plague_ogryn",
							amount = {
								1,
								2,
							},
						},
					},
				},
				{
					breeds = {
						{
							name = "chaos_plague_ogryn",
							amount = {
								2,
								2,
							},
						},
					},
				},
			},
		},
	},
}

return enemy_event_spawner_compositions
