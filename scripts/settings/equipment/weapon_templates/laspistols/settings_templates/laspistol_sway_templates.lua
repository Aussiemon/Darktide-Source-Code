local sway_templates = {}
local overrides = {}

table.make_unique(sway_templates)
table.make_unique(overrides)

local function default_laspistol_sway_pattern(dt, t, sway_settings, yaw, pitch)
	local horizontal_speed = sway_settings.horizontal_speed
	local rotation_speed = sway_settings.rotation_speed
	local sin_angle = t * math.pi * horizontal_speed
	local sin_wave = math.sin(sin_angle)
	local new_angle = t * math.pi * rotation_speed
	local yaw_angle = math.cos(new_angle)
	local pitch_angle = 0.25 * sin_wave * sin_wave + math.sin(2 * new_angle) * (0.5 + 0.5 * (1 - math.abs(yaw_angle * yaw_angle)))
	local yaw = math.degrees_to_radians(yaw)
	local pitch = math.degrees_to_radians(pitch)
	local intensity = sway_settings.intensity or 1
	local aim_offset_y = pitch_angle * yaw * intensity
	local aim_offset_x = yaw_angle * pitch * intensity

	return aim_offset_x, aim_offset_y
end

local function default_laspistol_crouch_sway_pattern(dt, t, sway_settings, yaw, pitch)
	local horizontal_speed = sway_settings.horizontal_speed
	local rotation_speed = sway_settings.rotation_speed
	local sin_angle = t * math.pi * horizontal_speed
	local sin_wave = math.sin(sin_angle)
	local new_angle = t * math.pi * rotation_speed
	local yaw_angle = math.cos(new_angle)
	local pitch_angle = 0.25 * sin_wave * sin_wave + math.sin(3 * new_angle) * (0.5 + 0.5 * math.abs(yaw_angle * yaw_angle))
	local yaw = math.degrees_to_radians(yaw)
	local pitch = math.degrees_to_radians(pitch)
	local intensity = sway_settings.intensity or 1
	local aim_offset_y = pitch_angle * yaw * intensity
	local aim_offset_x = yaw_angle * pitch * intensity

	return aim_offset_x, aim_offset_y
end

sway_templates.default_laspistol_killshot = {
	still = {
		intensity = 1.2,
		horizontal_speed = 1,
		visual_pitch_impact_mod = 3.3,
		rotation_speed = 0.75,
		visual_yaw_impact_mod = 3.3,
		max_sway = {
			pitch = {
				lerp_perfect = 0.0002,
				lerp_basic = 0.11
			},
			yaw = {
				lerp_perfect = 0.0002,
				lerp_basic = 0.11
			}
		},
		decay = {
			suppression = 0.2,
			crouch_transition_grace_time = 0.5,
			shooting = {
				pitch = {
					lerp_perfect = 0.5,
					lerp_basic = 0.1
				},
				yaw = {
					lerp_perfect = 0.5,
					lerp_basic = 0.1
				}
			},
			idle = {
				pitch = {
					lerp_perfect = 2,
					lerp_basic = 0.75
				},
				yaw = {
					lerp_perfect = 2,
					lerp_basic = 0.75
				}
			},
			player_event = {
				pitch = {
					lerp_perfect = 0.5,
					lerp_basic = 0.25
				},
				yaw = {
					lerp_perfect = 0.5,
					lerp_basic = 0.25
				}
			},
			enter_alternate_fire_grace_time = {
				lerp_perfect = 0,
				lerp_basic = 0.45
			},
			from_shooting_grace_time = {
				lerp_perfect = 0,
				lerp_basic = 1
			}
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.02,
				lerp_basic = 0.2
			},
			yaw = {
				lerp_perfect = 0.02,
				lerp_basic = 0.2
			}
		},
		immediate_sway = {
			num_shots_clear_time = 2,
			crouch_transition = {
				{
					cap = true,
					pitch = {
						lerp_perfect = 0.025,
						lerp_basic = 0.1
					},
					yaw = {
						lerp_perfect = 0.025,
						lerp_basic = 0.1
					}
				}
			},
			alternate_fire_start = {
				{
					cap = true,
					pitch = {
						lerp_perfect = 0,
						lerp_basic = 0.5
					},
					yaw = {
						lerp_perfect = 0,
						lerp_basic = 0.5
					}
				}
			},
			suppression_hit = {
				{
					pitch = {
						lerp_perfect = 0.03,
						lerp_basic = 0.05
					},
					yaw = {
						lerp_perfect = 0.05,
						lerp_basic = 0.1
					}
				},
				{
					pitch = {
						lerp_perfect = 0.05,
						lerp_basic = 0.15
					},
					yaw = {
						lerp_perfect = 0.1,
						lerp_basic = 0.25
					}
				},
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 0.4
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 0.5
					}
				},
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 0.35
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 0.35
					}
				},
				{
					pitch = {
						lerp_perfect = 0.1,
						lerp_basic = 0.25
					},
					yaw = {
						lerp_perfect = 0.1,
						lerp_basic = 0.25
					}
				}
			},
			damage_hit = {
				{
					pitch = {
						lerp_perfect = 0.6,
						lerp_basic = 1.2
					},
					yaw = {
						lerp_perfect = 0.6,
						lerp_basic = 1.2
					}
				}
			},
			shooting = {
				{
					pitch = {
						lerp_perfect = 0,
						lerp_basic = 0.001
					},
					yaw = {
						lerp_perfect = 0,
						lerp_basic = 0.001
					}
				},
				{
					pitch = {
						lerp_perfect = 0,
						lerp_basic = 0.001
					},
					yaw = {
						lerp_perfect = 0,
						lerp_basic = 0.001
					}
				},
				{
					pitch = {
						lerp_perfect = 0,
						lerp_basic = 0.001
					},
					yaw = {
						lerp_perfect = 0,
						lerp_basic = 0.001
					}
				},
				{
					pitch = {
						lerp_perfect = 0.001,
						lerp_basic = 0.002
					},
					yaw = {
						lerp_perfect = 0.001,
						lerp_basic = 0.002
					}
				},
				{
					pitch = {
						lerp_perfect = 0.0015,
						lerp_basic = 0.003
					},
					yaw = {
						lerp_perfect = 0.0015,
						lerp_basic = 0.003
					}
				},
				{
					pitch = {
						lerp_perfect = 0.002,
						lerp_basic = 0.004
					},
					yaw = {
						lerp_perfect = 0.002,
						lerp_basic = 0.004
					}
				},
				{
					pitch = {
						lerp_perfect = 0.003,
						lerp_basic = 0.006
					},
					yaw = {
						lerp_perfect = 0.003,
						lerp_basic = 0.006
					}
				}
			}
		},
		sway_pattern = default_laspistol_sway_pattern
	},
	moving = {
		inherits = {
			"default_laspistol_killshot",
			"still"
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.1,
				lerp_basic = 0.45
			},
			yaw = {
				lerp_perfect = 0.1,
				lerp_basic = 0.45
			}
		},
		decay = {
			suppression = 0.2,
			crouch_transition_grace_time = 0.5,
			shooting = {
				pitch = {
					lerp_perfect = 0.25,
					lerp_basic = 0.1
				},
				yaw = {
					lerp_perfect = 0.25,
					lerp_basic = 0.1
				}
			},
			idle = {
				pitch = {
					lerp_perfect = 1,
					lerp_basic = 0.75
				},
				yaw = {
					lerp_perfect = 1,
					lerp_basic = 0.75
				}
			},
			player_event = {
				pitch = {
					lerp_perfect = 0.5,
					lerp_basic = 0.25
				},
				yaw = {
					lerp_perfect = 0.5,
					lerp_basic = 0.25
				}
			},
			enter_alternate_fire_grace_time = {
				lerp_perfect = 0,
				lerp_basic = 0.45
			},
			from_shooting_grace_time = {
				lerp_perfect = 0,
				lerp_basic = 1
			}
		}
	},
	crouch_still = {
		inherits = {
			"default_laspistol_killshot",
			"still"
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.01,
				lerp_basic = 0.1
			},
			yaw = {
				lerp_perfect = 0.01,
				lerp_basic = 0.1
			}
		},
		decay = {
			suppression = 0.2,
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.3,
			shooting = {
				pitch = {
					lerp_perfect = 0.001,
					lerp_basic = 0.001
				},
				yaw = {
					lerp_perfect = 0.001,
					lerp_basic = 0.001
				}
			},
			idle = {
				pitch = {
					lerp_perfect = 3.5,
					lerp_basic = 1.5
				},
				yaw = {
					lerp_perfect = 3.5,
					lerp_basic = 1.5
				}
			},
			player_event = {
				pitch = {
					lerp_perfect = 0.1,
					lerp_basic = 0.1
				},
				yaw = {
					lerp_perfect = 0.1,
					lerp_basic = 0.1
				}
			},
			from_shooting_grace_time = {
				lerp_perfect = 0,
				lerp_basic = 1
			}
		},
		sway_pattern = default_laspistol_crouch_sway_pattern
	},
	crouch_moving = {
		inherits = {
			"default_laspistol_killshot",
			"still"
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.0125,
				lerp_basic = 0.12
			},
			yaw = {
				lerp_perfect = 0.0125,
				lerp_basic = 0.12
			}
		},
		decay = {
			suppression = 0.2,
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.3,
			shooting = {
				pitch = {
					lerp_perfect = 0.1,
					lerp_basic = 0.1
				},
				yaw = {
					lerp_perfect = 0.1,
					lerp_basic = 0.1
				}
			},
			idle = {
				pitch = {
					lerp_perfect = 3,
					lerp_basic = 1.25
				},
				yaw = {
					lerp_perfect = 3,
					lerp_basic = 1.25
				}
			},
			player_event = {
				pitch = {
					lerp_perfect = 0.1,
					lerp_basic = 0.1
				},
				yaw = {
					lerp_perfect = 0.1,
					lerp_basic = 0.1
				}
			},
			from_shooting_grace_time = {
				lerp_perfect = 0,
				lerp_basic = 1
			}
		},
		sway_pattern = default_laspistol_crouch_sway_pattern
	}
}

return {
	base_templates = sway_templates,
	overrides = overrides
}
