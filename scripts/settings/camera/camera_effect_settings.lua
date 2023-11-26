-- chunkname: @scripts/settings/camera/camera_effect_settings.lua

local CameraEffectSettings = {
	sequence = {
		landed_soft = {
			time_to_recuperate_to = 20,
			values = {
				roll = {
					{
						value = 0,
						time_stamp = 0
					},
					{
						value = -0.56,
						time_stamp = 0.06
					},
					{
						value = 0.11,
						time_stamp = 0.14
					},
					{
						value = 0,
						time_stamp = 0.38
					},
					{
						value = 0,
						time_stamp = 0.65
					}
				},
				pitch = {
					{
						value = 0,
						time_stamp = 0
					},
					{
						value = 2.5633333333333335,
						time_stamp = 0.06
					},
					{
						value = -0.4466666666666667,
						time_stamp = 0.14
					},
					{
						value = 0,
						time_stamp = 0.38
					},
					{
						value = 0,
						time_stamp = 0.65
					}
				},
				yaw = {
					{
						value = 0,
						time_stamp = 0
					},
					{
						value = 0.5783333333333334,
						time_stamp = 0.06
					},
					{
						value = -0.09833333333333333,
						time_stamp = 0.14
					},
					{
						value = 0,
						time_stamp = 0.38
					},
					{
						value = 0,
						time_stamp = 0.65
					}
				},
				x = {
					{
						value = 0,
						time_stamp = 0
					},
					{
						value = 0.015700000000000002,
						time_stamp = 0.06
					},
					{
						value = 0.0023166666666666665,
						time_stamp = 0.14
					},
					{
						value = 0,
						time_stamp = 0.38
					},
					{
						value = 0,
						time_stamp = 0.46
					},
					{
						value = 0,
						time_stamp = 0.65
					}
				},
				y = {
					{
						value = 0,
						time_stamp = 0
					},
					{
						value = -0.05983333333333333,
						time_stamp = 0.06
					},
					{
						value = 0.003533333333333333,
						time_stamp = 0.14
					},
					{
						value = 0,
						time_stamp = 0.38
					},
					{
						value = 0,
						time_stamp = 0.46
					},
					{
						value = 0,
						time_stamp = 0.65
					}
				},
				z = {
					{
						value = 0,
						time_stamp = 0
					},
					{
						value = -0.0988,
						time_stamp = 0.06
					},
					{
						value = 0.024833333333333332,
						time_stamp = 0.14
					},
					{
						value = 0,
						time_stamp = 0.38
					},
					{
						value = 0,
						time_stamp = 0.46
					},
					{
						value = 0,
						time_stamp = 0.65
					}
				}
			}
		},
		landed_hard = {
			time_to_recuperate_to = 20,
			values = {
				roll = {
					{
						value = 0,
						time_stamp = 0
					},
					{
						value = -0.56,
						time_stamp = 0.06
					},
					{
						value = 0.11,
						time_stamp = 0.14
					},
					{
						value = 0.94,
						time_stamp = 0.24
					},
					{
						value = 0,
						time_stamp = 0.38
					},
					{
						value = 0.05,
						time_stamp = 0.46
					},
					{
						value = 0,
						time_stamp = 0.65
					}
				},
				pitch = {
					{
						value = 0,
						time_stamp = 0
					},
					{
						value = 15.095,
						time_stamp = 0.06
					},
					{
						value = -7.67,
						time_stamp = 0.14
					},
					{
						value = 9.09,
						time_stamp = 0.24
					},
					{
						value = 0,
						time_stamp = 0.38
					},
					{
						value = -1.89,
						time_stamp = 0.46
					},
					{
						value = 0,
						time_stamp = 0.65
					}
				},
				yaw = {
					{
						value = 0,
						time_stamp = 0
					},
					{
						value = 0.8675,
						time_stamp = 0.06
					},
					{
						value = -0.1475,
						time_stamp = 0.14
					},
					{
						value = -7.83,
						time_stamp = 0.24
					},
					{
						value = 0,
						time_stamp = 0.38
					},
					{
						value = -1.16,
						time_stamp = 0.46
					},
					{
						value = 0,
						time_stamp = 0.65
					}
				},
				x = {
					{
						value = 0,
						time_stamp = 0
					},
					{
						value = 0.02355,
						time_stamp = 0.06
					},
					{
						value = 0.003475,
						time_stamp = 0.14
					},
					{
						value = -0.0206,
						time_stamp = 0.24
					},
					{
						value = 0,
						time_stamp = 0.38
					},
					{
						value = 0,
						time_stamp = 0.46
					},
					{
						value = 0,
						time_stamp = 0.65
					}
				},
				y = {
					{
						value = 0,
						time_stamp = 0
					},
					{
						value = -0.08975,
						time_stamp = 0.06
					},
					{
						value = 0.0053,
						time_stamp = 0.14
					},
					{
						value = 0.0596,
						time_stamp = 0.24
					},
					{
						value = 0,
						time_stamp = 0.38
					},
					{
						value = 0,
						time_stamp = 0.46
					},
					{
						value = 0,
						time_stamp = 0.65
					}
				},
				z = {
					{
						value = 0,
						time_stamp = 0
					},
					{
						value = -0.1482,
						time_stamp = 0.06
					},
					{
						value = 0.03725,
						time_stamp = 0.14
					},
					{
						value = 0.189,
						time_stamp = 0.24
					},
					{
						value = 0,
						time_stamp = 0.38
					},
					{
						value = 0,
						time_stamp = 0.46
					},
					{
						value = 0,
						time_stamp = 0.65
					}
				}
			}
		},
		landed = {
			time_to_recuperate_to = 20,
			values = {
				roll = {
					{
						value = 0,
						time_stamp = 0
					},
					{
						value = -0.15,
						time_stamp = 0.06
					},
					{
						value = 0.02,
						time_stamp = 0.14
					},
					{
						value = 0,
						time_stamp = 0.38
					},
					{
						value = 0,
						time_stamp = 0.65
					}
				},
				pitch = {
					{
						value = 0,
						time_stamp = 0
					},
					{
						value = 1.0416666666666667,
						time_stamp = 0.06
					},
					{
						value = -0.17,
						time_stamp = 0.14
					},
					{
						value = 0,
						time_stamp = 0.38
					},
					{
						value = 0,
						time_stamp = 0.65
					}
				},
				yaw = {
					{
						value = 0,
						time_stamp = 0
					},
					{
						value = 0.3066666666666667,
						time_stamp = 0.06
					},
					{
						value = -0.04833333333333333,
						time_stamp = 0.14
					},
					{
						value = 0,
						time_stamp = 0.38
					},
					{
						value = 0,
						time_stamp = 0.65
					}
				},
				x = {
					{
						value = 0,
						time_stamp = 0
					},
					{
						value = 0.006883333333333334,
						time_stamp = 0.06
					},
					{
						value = 0.00145,
						time_stamp = 0.14
					},
					{
						value = 0,
						time_stamp = 0.38
					},
					{
						value = 0,
						time_stamp = 0.46
					},
					{
						value = 0,
						time_stamp = 0.65
					}
				},
				y = {
					{
						value = 0,
						time_stamp = 0
					},
					{
						value = -0.020233333333333332,
						time_stamp = 0.06
					},
					{
						value = 0.00107,
						time_stamp = 0.14
					},
					{
						value = 0,
						time_stamp = 0.38
					},
					{
						value = 0,
						time_stamp = 0.46
					},
					{
						value = 0,
						time_stamp = 0.65
					}
				},
				z = {
					{
						value = 0,
						time_stamp = 0
					},
					{
						value = -0.022066666666666665,
						time_stamp = 0.06
					},
					{
						value = 0.0036333333333333335,
						time_stamp = 0.14
					},
					{
						value = 0,
						time_stamp = 0.38
					},
					{
						value = 0,
						time_stamp = 0.46
					},
					{
						value = 0,
						time_stamp = 0.65
					}
				}
			}
		},
		jump = {
			time_to_recuperate_to = 20,
			values = {
				roll = {
					{
						value = 0,
						time_stamp = 0
					},
					{
						value = -0.14,
						time_stamp = 0.16
					},
					{
						value = 0.0275,
						time_stamp = 0.34
					},
					{
						value = 0,
						time_stamp = 0.38
					},
					{
						value = 0,
						time_stamp = 0.65
					}
				},
				pitch = {
					{
						value = 0,
						time_stamp = 0
					},
					{
						value = -0.73,
						time_stamp = 0.16
					},
					{
						value = -0.27999999999999997,
						time_stamp = 0.34
					},
					{
						value = 0,
						time_stamp = 0.38
					},
					{
						value = 0,
						time_stamp = 0.65
					}
				},
				yaw = {
					{
						value = 0,
						time_stamp = 0
					},
					{
						value = -0.245,
						time_stamp = 0.16
					},
					{
						value = -0.09833333333333333,
						time_stamp = 0.34
					},
					{
						value = 0,
						time_stamp = 0.38
					},
					{
						value = 0,
						time_stamp = 0.65
					}
				}
			}
		},
		kerillian_shade_active_ability = {
			time_to_recuperate_to = 20,
			values = {
				roll = {
					{
						value = 0,
						time_stamp = 0
					},
					{
						value = -0.56,
						time_stamp = 0.16
					},
					{
						value = 0.11,
						time_stamp = 0.34
					},
					{
						value = 0,
						time_stamp = 0.38
					}
				},
				pitch = {
					{
						value = 0,
						time_stamp = 0
					},
					{
						value = -1.7300000000000002,
						time_stamp = 0.16
					},
					{
						value = -0.4466666666666667,
						time_stamp = 0.34
					},
					{
						value = 0,
						time_stamp = 0.38
					}
				},
				yaw = {
					{
						value = 0,
						time_stamp = 0
					},
					{
						value = -0.245,
						time_stamp = 0.16
					},
					{
						value = -0.09833333333333333,
						time_stamp = 0.34
					},
					{
						value = 0,
						time_stamp = 0.38
					}
				},
				x = {
					{
						value = 0,
						time_stamp = 0
					},
					{
						value = 0.009420000000000001,
						time_stamp = 0.16
					},
					{
						value = 0.00139,
						time_stamp = 0.34
					},
					{
						value = -0.00515,
						time_stamp = 0.38
					},
					{
						value = 0,
						time_stamp = 0.65
					}
				},
				y = {
					{
						value = 0,
						time_stamp = 0
					},
					{
						value = 0.07,
						time_stamp = 0.15
					},
					{
						value = 0.09,
						time_stamp = 0.2
					},
					{
						value = 0.07,
						time_stamp = 0.25
					},
					{
						value = 0.05,
						time_stamp = 0.6
					},
					{
						value = 0,
						time_stamp = 1.5
					}
				},
				z = {
					{
						value = 0,
						time_stamp = 0
					},
					{
						value = -0.12,
						time_stamp = 0.15
					},
					{
						value = -0.13,
						time_stamp = 0.2
					},
					{
						value = -0.12,
						time_stamp = 0.25
					},
					{
						value = -0.1,
						time_stamp = 0.6
					},
					{
						value = 0,
						time_stamp = 1.5
					}
				}
			}
		}
	},
	shake = {
		landed_soft = {
			persistance = 0,
			amplitude = 0,
			duration = 0,
			seed = 0,
			octaves = 0
		},
		landed_hard = {
			persistance = 1,
			duration = 0.23,
			amplitude = 0.4,
			octaves = 6
		},
		jumped = {
			persistance = 0,
			duration = 0,
			amplitude = 0,
			octaves = 0
		},
		stunned = {
			persistance = 0,
			duration = 0,
			amplitude = 0,
			octaves = 0
		},
		rushing = {
			persistance = 1,
			fade_out = 1,
			amplitude = 0.3,
			duration = 10,
			fade_in = 0.1,
			octaves = 4
		},
		charging = {
			persistance = 0,
			duration = 0,
			amplitude = 0,
			octaves = 0
		},
		travel_mode_footstep = {
			persistance = 1.1,
			amplitude = 0.15,
			duration = 0.15,
			seed = 4711,
			octaves = 6
		},
		knocked_down = {
			persistance = 0.5,
			duration = 0,
			amplitude = 1,
			octaves = 2
		},
		died = {
			persistance = 0.05,
			duration = 0.05,
			amplitude = 0.4,
			octaves = 12
		},
		damaged = {
			persistance = 1,
			duration = 0.13,
			amplitude = 0.4,
			octaves = 6
		},
		damaged_front_up = {
			persistance = 0,
			duration = 0,
			amplitude = 0,
			octaves = 0
		},
		damaged_front_down = {
			persistance = 0,
			duration = 0,
			amplitude = 0,
			octaves = 0
		},
		damaged_front_left = {
			persistance = 0,
			duration = 0,
			amplitude = 0,
			octaves = 0
		},
		damaged_front_right = {
			persistance = 0,
			duration = 0,
			amplitude = 0,
			octaves = 0
		},
		damaged_back_up = {
			persistance = 0,
			duration = 0,
			amplitude = 0,
			octaves = 0
		},
		damaged_back_down = {
			persistance = 0,
			duration = 0,
			amplitude = 0,
			octaves = 0
		},
		damaged_back_left = {
			persistance = 0,
			duration = 0,
			amplitude = 0,
			octaves = 0
		},
		damaged_back_right = {
			persistance = 0,
			duration = 0,
			amplitude = 0,
			octaves = 0
		},
		last_stand_activated = {
			persistance = 0.5,
			fade_out = 1,
			amplitude = 1,
			duration = 20,
			fade_in = 0.5,
			octaves = 1
		},
		rat_ogre_run = {
			persistance = 1,
			amplitude = 0.2,
			duration = 0.23,
			fade_out = 0.1,
			octaves = 8
		},
		rat_ogre_slam = {
			persistance = 1,
			amplitude = 0.4,
			duration = 0.23,
			fade_out = 0.1,
			octaves = 6
		},
		heavy_wind_sound = {
			persistance = 1,
			fade_out = 1,
			amplitude = 0.5,
			duration = 5,
			fade_in = 0.5,
			octaves = 5
		},
		chaos_spawn_grabbed = {
			persistance = 1,
			fade_out = 0.35,
			amplitude = 0.6,
			duration = 0.5,
			fade_in = 0,
			octaves = 8
		},
		chaos_spawn_roar = {
			persistance = 1,
			amplitude = 0.2,
			duration = 0.7,
			fade_out = 0.1,
			octaves = 8
		},
		chaos_spawn_slam = {
			persistance = 1,
			amplitude = 0.5,
			duration = 0.1,
			fade_out = 0.1,
			octaves = 7
		},
		bell_shake = {
			persistance = 1,
			fade_out = 0.5,
			amplitude = 0.4,
			duration = 1,
			fade_in = 0.3,
			octaves = 6
		},
		bell_shake_end = {
			persistance = 1,
			fade_out = 1,
			amplitude = 0.4,
			duration = 3,
			fade_in = 0.5,
			octaves = 8
		},
		magnus_horn_blow_01 = {
			persistance = 1,
			fade_out = 2,
			amplitude = 0.4,
			duration = 5,
			fade_in = 0.5,
			octaves = 8
		},
		cauldron_destroyed = {
			persistance = 1,
			fade_out = 3,
			amplitude = 0.9,
			duration = 4,
			fade_in = 0.1,
			octaves = 8
		},
		cauldron_break = {
			persistance = 0.9,
			fade_out = 1,
			amplitude = 0.4,
			duration = 3,
			fade_in = 0.5,
			octaves = 8
		},
		pillar_destroyed = {
			persistance = 1,
			fade_out = 1,
			amplitude = 0.4,
			duration = 2,
			fade_in = 0.5,
			octaves = 8
		},
		warehouse_destroyed = {
			persistance = 1,
			fade_out = 2,
			amplitude = 0.7,
			duration = 2,
			fade_in = 1,
			octaves = 8
		},
		storm_ambience = {
			persistance = 0.5,
			fade_out = 2,
			amplitude = 0.5,
			fade_in = 2,
			octaves = 6
		},
		warp_lightning_strike = {
			persistance = 1,
			fade_out = 0.5,
			amplitude = 0.5,
			duration = 1.5,
			fade_in = 0.2,
			octaves = 6
		},
		walls_falling_tower = {
			persistance = 0.8,
			fade_out = 2,
			amplitude = 0.3,
			duration = 8,
			fade_in = 1,
			octaves = 6
		},
		docks_building_creaking = {
			persistance = 0.7,
			fade_out = 0.5,
			amplitude = 0.6,
			duration = 3,
			fade_in = 1,
			octaves = 6
		},
		docks_building_build_up_destruction = {
			persistance = 0.7,
			fade_out = 2,
			amplitude = 0.6,
			duration = 3,
			fade_in = 2,
			octaves = 6
		},
		tunnels_escape_short_shake = {
			persistance = 0.7,
			fade_out = 1,
			amplitude = 0.6,
			duration = 2,
			fade_in = 0.5,
			octaves = 6
		},
		elevator_ride = {
			persistance = 0.7,
			fade_out = 0.1,
			amplitude = 0.6,
			duration = 1,
			fade_in = 0.1,
			octaves = 6
		},
		fade_test = {
			persistance = 1,
			fade_out = 0.5,
			amplitude = 1,
			duration = 5,
			fade_in = 0.5,
			octaves = 8
		},
		wizard_build_up_illusion = {
			persistance = 0.9,
			fade_out = 1,
			amplitude = 0.9,
			duration = 6,
			fade_in = 4,
			octaves = 7
		},
		wizard_completed_illusion = {
			persistance = 1,
			fade_out = 2,
			amplitude = 1,
			duration = 3,
			fade_in = 0.5,
			octaves = 10
		},
		tunnel_escape_loop_01 = {
			persistance = 1,
			fade_out = 2,
			amplitude = 0.3,
			duration = 5,
			fade_in = 0.5,
			octaves = 8
		},
		docks_escape_loop_01 = {
			persistance = 1,
			fade_out = 2,
			amplitude = 0.3,
			duration = 5,
			fade_in = 0.5,
			octaves = 6
		},
		end_boss_bell_strike = {
			persistance = 0.8,
			fade_out = 3,
			amplitude = 1,
			duration = 3,
			fade_in = 0.1,
			octaves = 7
		},
		end_boss_bell_destroyed_buildup = {
			persistance = 0.7,
			fade_out = 1,
			amplitude = 0.3,
			duration = 6,
			fade_in = 5,
			octaves = 8
		},
		end_boss_bell_destroyed = {
			persistance = 0.7,
			fade_out = 5,
			amplitude = 0.3,
			duration = 9,
			fade_in = 1,
			octaves = 8
		},
		end_boss_bell_strike_far = {
			persistance = 0.7,
			fade_out = 4,
			amplitude = 0.9,
			duration = 6,
			fade_in = 0.8,
			octaves = 8
		},
		distant_thunder = {
			persistance = 0.7,
			fade_out = 2,
			amplitude = 0.4,
			duration = 3,
			fade_in = 0.5,
			octaves = 8
		},
		castle_statue = {
			persistance = 0.9,
			fade_out = 2,
			amplitude = 1,
			duration = 6,
			fade_in = 1,
			octaves = 8
		},
		dwarf_exterior_ramp = {
			persistance = 0.8,
			fade_out = 3,
			amplitude = 1,
			duration = 7,
			fade_in = 1,
			octaves = 8
		},
		great_windup = {
			persistance = 0.85,
			fade_out = 1,
			amplitude = 0.3,
			duration = 3,
			fade_in = 2,
			octaves = 7
		},
		dwarf_exterior_pickup_artifact = {
			persistance = 0.8,
			fade_out = 3,
			amplitude = 1,
			duration = 7,
			fade_in = 1,
			octaves = 8
		},
		castle_laugh = {
			persistance = 0.75,
			fade_out = 1,
			amplitude = 1,
			duration = 2.5,
			fade_in = 0.5,
			octaves = 8
		},
		quarry_escape = {
			persistance = 0.5,
			fade_out = 2,
			amplitude = 0.65,
			duration = 1000,
			fade_in = 2,
			octaves = 6
		},
		quarry_random_shake = {
			persistance = 0.7,
			fade_out = 3,
			amplitude = 0.9,
			duration = 4,
			fade_in = 1,
			octaves = 8
		},
		castle_escape = {
			persistance = 0.5,
			fade_out = 2,
			amplitude = 0.7,
			duration = 1000,
			fade_in = 2,
			octaves = 6
		},
		castle_rumble = {
			persistance = 0.7,
			fade_out = 3,
			amplitude = 0.9,
			duration = 5,
			fade_in = 1,
			octaves = 8
		},
		castle_end_rumble = {
			persistance = 0.7,
			fade_out = 3,
			amplitude = 0.9,
			duration = 12,
			fade_in = 1,
			octaves = 8
		},
		tutorial_thunder = {
			persistance = 1,
			fade_out = 0.5,
			amplitude = 0.25,
			duration = 1,
			fade_in = 0.3,
			octaves = 6
		},
		tutorial_storm_ambience = {
			persistance = 0.5,
			fade_out = 2,
			amplitude = 0.4,
			no_rumble = true,
			duration = 1000,
			fade_in = 2,
			octaves = 6
		},
		dwarf_int_brewery_loop = {
			persistance = 0.85,
			fade_out = 2,
			amplitude = 0.3,
			duration = 5,
			fade_in = 2,
			octaves = 7
		},
		frag_grenade_explosion = {
			persistance = 1,
			amplitude = 0.8,
			duration = 0.18,
			fade_out = 0.15,
			octaves = 6
		},
		ogryn_frag_01 = {
			persistance = 0.8,
			fade_out = 0.5,
			amplitude = 3.5,
			seed = 0,
			duration = 0.2,
			fade_in = 0.1,
			octaves = 5.8
		},
		bell_thunder_01 = {
			persistance = 0.9,
			fade_out = 0.3,
			amplitude = 1,
			duration = 0.3,
			fade_in = 0.1,
			octaves = 5.5
		},
		skittergate_escape = {
			persistance = 0.5,
			fade_out = 2,
			amplitude = 0.6,
			duration = 5000,
			fade_in = 2,
			octaves = 6
		},
		falling_rock_large_impact = {
			persistance = 0.9,
			fade_out = 3,
			amplitude = 3,
			duration = 0.5,
			fade_in = 0.1,
			octaves = 6
		},
		fort_backdrop_explosion_01 = {
			persistance = 0.9,
			fade_out = 0.3,
			amplitude = 0.3,
			duration = 0.3,
			fade_in = 0.1,
			octaves = 5.5
		},
		ground_zero_mud_slide_01 = {
			persistance = 0.7,
			fade_out = 4,
			amplitude = 0.9,
			duration = 5,
			fade_in = 3,
			octaves = 8
		},
		elven_ruins_ending = {
			persistance = 0.8,
			fade_out = 1,
			amplitude = 1.2,
			duration = 9,
			fade_in = 20,
			octaves = 4.5
		},
		elven_ruins_ending_explosion = {
			persistance = 0.9,
			fade_out = 0.3,
			amplitude = 0.7,
			duration = 1,
			fade_in = 0.1,
			octaves = 6
		},
		nurgle_ending = {
			persistance = 1,
			fade_out = 1,
			amplitude = 0.4,
			duration = 10,
			fade_in = 0.5,
			octaves = 4
		},
		military_ending = {
			persistance = 0.8,
			fade_out = 0.5,
			amplitude = 1.2,
			duration = 3,
			fade_in = 0.5,
			octaves = 4
		},
		military_ending_boom = {
			persistance = 1,
			fade_out = 0.5,
			amplitude = 0.9,
			duration = 1,
			fade_in = 0.5,
			octaves = 5
		},
		military_raise_statue_01 = {
			persistance = 0.7,
			fade_out = 4,
			amplitude = 0.9,
			duration = 15,
			fade_in = 3,
			octaves = 8
		},
		military_end_buildup_01 = {
			persistance = 0.75,
			fade_out = 1,
			amplitude = 1,
			duration = 4.5,
			fade_in = 7,
			octaves = 8
		},
		catacombs_ball_blast = {
			persistance = 1,
			fade_out = 0.5,
			amplitude = 0.9,
			duration = 1,
			fade_in = 0.5,
			octaves = 5
		},
		skittergate_block_fall_01 = {
			persistance = 0.75,
			fade_out = 1,
			amplitude = 1,
			duration = 8,
			fade_in = 4,
			octaves = 8
		},
		ogryn_charge_impact = {
			persistance = 1,
			duration = 0.1,
			amplitude = 0.4,
			octaves = 6
		},
		ogryn_charge_end = {
			persistance = 1.2,
			amplitude = 0.3,
			duration = 0.28,
			fade_out = 0.1,
			octaves = 7
		},
		spiral_staircase_shake = {
			persistance = 1,
			fade_out = 1,
			amplitude = 0.1,
			duration = 4,
			fade_in = 1,
			octaves = 6
		},
		fm_armoury_roof_open_start = {
			persistance = 0.8,
			fade_out = 2,
			amplitude = 0.4,
			duration = 10,
			fade_in = 3,
			octaves = 8
		},
		fm_armoury_roof_open_end = {
			persistance = 0.8,
			fade_out = 1,
			amplitude = 0.6,
			duration = 2.5,
			fade_in = 2.5,
			octaves = 8
		},
		fm_armoury_roof_open_end_01 = {
			persistance = 1,
			fade_out = 0,
			amplitude = 0.6,
			duration = 3,
			fade_in = 0,
			octaves = 8
		},
		breach_charge_explosion = {
			persistance = 1,
			fade_out = 0.1,
			amplitude = 0.7,
			duration = 0.5,
			fade_in = 0,
			octaves = 6
		}
	}
}
local swing_impact_shake = {
	persistance = 0,
	duration = 0,
	amplitude = 0,
	octaves = 0
}
local swing_impact_no_damage_shake = {
	persistance = 1,
	duration = 0.2,
	amplitude = 0.03,
	octaves = 12
}

CameraEffectSettings.shake.swing_impact_up_no_damage = swing_impact_no_damage_shake
CameraEffectSettings.shake.swing_impact_down_no_damage = swing_impact_no_damage_shake
CameraEffectSettings.shake.swing_impact_left_no_damage = swing_impact_no_damage_shake
CameraEffectSettings.shake.swing_impact_right_no_damage = swing_impact_no_damage_shake
CameraEffectSettings.shake.swing_impact_up_light = swing_impact_shake
CameraEffectSettings.shake.swing_impact_down_light = swing_impact_shake
CameraEffectSettings.shake.swing_impact_left_light = swing_impact_shake
CameraEffectSettings.shake.swing_impact_right_light = swing_impact_shake
CameraEffectSettings.shake.swing_impact_up_medium = swing_impact_shake
CameraEffectSettings.shake.swing_impact_down_medium = swing_impact_shake
CameraEffectSettings.shake.swing_impact_left_medium = swing_impact_shake
CameraEffectSettings.shake.swing_impact_right_medium = swing_impact_shake
CameraEffectSettings.shake.swing_impact_up_heavy = swing_impact_shake
CameraEffectSettings.shake.swing_impact_down_heavy = swing_impact_shake
CameraEffectSettings.shake.swing_impact_left_heavy = swing_impact_shake
CameraEffectSettings.shake.swing_impact_right_heavy = swing_impact_shake
CameraEffectSettings.transition_functions = CameraEffectSettings.transition_functions or {}

CameraEffectSettings.transition_functions.lerp = function (current_value, next_value, progress)
	return math.lerp(current_value, next_value, progress)
end

CameraEffectSettings.empty_modifier_settings = {
	value = 0,
	time_stamp = 0
}

return CameraEffectSettings
