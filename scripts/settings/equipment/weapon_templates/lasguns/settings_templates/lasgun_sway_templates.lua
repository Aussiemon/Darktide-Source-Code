local sway_templates = {}
local overrides = {}

table.make_unique(sway_templates)
table.make_unique(overrides)

local function default_lasgun_sway_pattern(dt, t, sway_settings, yaw, pitch)
	local horizontal_speed = sway_settings.horizontal_speed
	local rotation_speed = sway_settings.rotation_speed
	local sin_angle = t * math.pi * horizontal_speed
	local sin_wave = math.sin(sin_angle)
	local new_angle = t * math.pi * rotation_speed
	local yaw_angle = math.cos(new_angle)
	local pitch_angle = 0.25 * sin_wave * sin_wave + math.sin(3 * new_angle) * (0.5 + 0.5 * (1 - math.abs(yaw_angle * yaw_angle)))
	local yaw = math.degrees_to_radians(yaw)
	local pitch = math.degrees_to_radians(pitch)
	local intensity = sway_settings.intensity or 1
	local aim_offset_y = pitch_angle * yaw * intensity
	local aim_offset_x = yaw_angle * pitch * intensity

	return aim_offset_x, aim_offset_y
end

local function default_lasgun_crouch_sway_pattern(dt, t, sway_settings, yaw, pitch)
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
	local aim_offset_y = pitch_angle * pitch * intensity
	local aim_offset_x = yaw_angle * yaw * intensity

	return aim_offset_x, aim_offset_y
end

local function lasgun_p1_m3_sway_pattern(dt, t, sway_settings, yaw, pitch)
	local horizontal_speed = sway_settings.horizontal_speed
	local rotation_speed = sway_settings.rotation_speed
	local sin_angle = t * math.pi * horizontal_speed
	local sin_wave = math.sin(sin_angle)
	local new_angle = t * math.pi * rotation_speed
	local yaw_angle = math.cos(new_angle)
	local pitch_angle = 0.5 * sin_wave + math.sin(3 * new_angle) * (0.25 + 0.75 * (1 - math.abs(yaw_angle * yaw_angle)))
	local yaw = math.degrees_to_radians(yaw)
	local pitch = math.degrees_to_radians(pitch)
	local intensity = sway_settings.intensity or 1
	local aim_offset_y = pitch_angle * yaw * intensity
	local aim_offset_x = yaw_angle * pitch * intensity

	return aim_offset_x, aim_offset_y
end

local function lasgun_p1_m3_crouch_sway_pattern(dt, t, sway_settings, yaw, pitch)
	local horizontal_speed = sway_settings.horizontal_speed
	local rotation_speed = sway_settings.rotation_speed
	local sin_angle = t * math.pi * horizontal_speed
	local sin_wave = math.sin(sin_angle)
	local new_angle = t * math.pi * rotation_speed
	local yaw_angle = math.cos(new_angle)
	local pitch_angle = 0.5 * sin_wave + math.sin(3 * new_angle) * (0.25 + 0.75 * math.abs(yaw_angle * yaw_angle))
	local yaw = math.degrees_to_radians(yaw)
	local pitch = math.degrees_to_radians(pitch)
	local intensity = sway_settings.intensity or 1
	local aim_offset_y = pitch_angle * pitch * intensity
	local aim_offset_x = yaw_angle * yaw * intensity

	return aim_offset_x, aim_offset_y
end

sway_templates.default_lasgun_killshot = {
	still = {
		intensity = 0.6,
		horizontal_speed = 0.7,
		visual_pitch_impact_mod = 6,
		rotation_speed = 0.5,
		visual_yaw_impact_mod = 4,
		max_sway = {
			pitch = {
				lerp_perfect = 1.5,
				lerp_basic = 2.5
			},
			yaw = {
				lerp_perfect = 2.5,
				lerp_basic = 2.5
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
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.025,
				lerp_basic = 0.2
			},
			yaw = {
				lerp_perfect = 0.025,
				lerp_basic = 0.25
			}
		},
		immediate_sway = {
			num_shots_clear_time = 0.5,
			crouch_transition = {
				{
					cap = true,
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 1
					},
					yaw = {
						lerp_perfect = 0,
						lerp_basic = 1
					}
				}
			},
			alternate_fire_start = {
				{
					cap = true,
					pitch = {
						lerp_perfect = 0,
						lerp_basic = 1
					},
					yaw = {
						lerp_perfect = 0,
						lerp_basic = 1
					}
				}
			},
			suppression_hit = {
				{
					pitch = {
						lerp_perfect = 0.3,
						lerp_basic = 0.5
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1
					}
				},
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 0.45
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 0.75
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
						lerp_perfect = 0.15,
						lerp_basic = 0.3
					},
					yaw = {
						lerp_perfect = 0.15,
						lerp_basic = 0.3
					}
				},
				{
					pitch = {
						lerp_perfect = 0,
						lerp_basic = 0
					},
					yaw = {
						lerp_perfect = 0,
						lerp_basic = 0
					}
				},
				{
					pitch = {
						lerp_perfect = 0.01,
						lerp_basic = 0.01
					},
					yaw = {
						lerp_perfect = 0.01,
						lerp_basic = 0.01
					}
				},
				{
					pitch = {
						lerp_perfect = 0.02,
						lerp_basic = 0.02
					},
					yaw = {
						lerp_perfect = 0.02,
						lerp_basic = 0.02
					}
				},
				{
					pitch = {
						lerp_perfect = 0.03,
						lerp_basic = 0.03
					},
					yaw = {
						lerp_perfect = 0.03,
						lerp_basic = 0.03
					}
				},
				{
					pitch = {
						lerp_perfect = 0.04,
						lerp_basic = 0.04
					},
					yaw = {
						lerp_perfect = 0.04,
						lerp_basic = 0.04
					}
				},
				{
					pitch = {
						lerp_perfect = 0.06,
						lerp_basic = 0.06
					},
					yaw = {
						lerp_perfect = 0.06,
						lerp_basic = 0.06
					}
				}
			}
		},
		sway_pattern = default_lasgun_sway_pattern
	},
	moving = {
		rotation_speed = 1,
		inherits = {
			"default_lasgun_killshot",
			"still"
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.1,
				lerp_basic = 0.4
			},
			yaw = {
				lerp_perfect = 0.1,
				lerp_basic = 0.4
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
		rotation_speed = 0.5,
		inherits = {
			"default_lasgun_killshot",
			"still"
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.05,
				lerp_basic = 0.15
			},
			yaw = {
				lerp_perfect = 0.05,
				lerp_basic = 0.15
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
					lerp_basic = 0.01
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
		}
	},
	crouch_moving = {
		rotation_speed = 0.85,
		inherits = {
			"default_lasgun_killshot",
			"still"
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.05,
				lerp_basic = 0.2
			},
			yaw = {
				lerp_perfect = 0.05,
				lerp_basic = 0.2
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
		sway_pattern = default_lasgun_crouch_sway_pattern
	}
}
sway_templates.lasgun_p1_m1_killshot = {
	still = {
		intensity = 0.6,
		horizontal_speed = 0.7,
		visual_pitch_impact_mod = 6,
		rotation_speed = 0.5,
		visual_yaw_impact_mod = 4,
		max_sway = {
			yaw = 4,
			pitch = 4
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
					lerp_perfect = 0.75,
					lerp_basic = 0.25
				},
				yaw = {
					lerp_perfect = 0.75,
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
				lerp_perfect = 0.05,
				lerp_basic = 0.6
			},
			yaw = {
				lerp_perfect = 0.05,
				lerp_basic = 0.6
			}
		},
		immediate_sway = {
			num_shots_clear_time = 2,
			crouch_transition = {
				{
					cap = true,
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1
					}
				}
			},
			alternate_fire_start = {
				{
					cap = true,
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1.5
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1.5
					}
				}
			},
			suppression_hit = {
				{
					pitch = {
						lerp_perfect = 0.15,
						lerp_basic = 1.05
					},
					yaw = {
						lerp_perfect = 0.1,
						lerp_basic = 1.1
					}
				},
				{
					pitch = {
						lerp_perfect = 0.1,
						lerp_basic = 0.7
					},
					yaw = {
						lerp_perfect = 0.2,
						lerp_basic = 0.7
					}
				},
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 0.8
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 1
					}
				},
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 1
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 0.7
					}
				},
				{
					pitch = {
						lerp_perfect = 0.3,
						lerp_basic = 1
					},
					yaw = {
						lerp_perfect = 0.3,
						lerp_basic = 0.85
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
						lerp_perfect = 0.0025,
						lerp_basic = 0.01
					},
					yaw = {
						lerp_perfect = 0.025,
						lerp_basic = 0.01
					}
				},
				{
					pitch = {
						lerp_perfect = 0.0025,
						lerp_basic = 0.01
					},
					yaw = {
						lerp_perfect = 0.025,
						lerp_basic = 0.01
					}
				},
				{
					pitch = {
						lerp_perfect = 0.025,
						lerp_basic = 0.075
					},
					yaw = {
						lerp_perfect = 0.025,
						lerp_basic = 0.075
					}
				},
				{
					pitch = {
						lerp_perfect = 0.02,
						lerp_basic = 0.02
					},
					yaw = {
						lerp_perfect = 0.02,
						lerp_basic = 0.02
					}
				},
				{
					pitch = {
						lerp_perfect = 0.03,
						lerp_basic = 0.03
					},
					yaw = {
						lerp_perfect = 0.03,
						lerp_basic = 0.03
					}
				},
				{
					pitch = {
						lerp_perfect = 0.04,
						lerp_basic = 0.04
					},
					yaw = {
						lerp_perfect = 0.04,
						lerp_basic = 0.04
					}
				},
				{
					pitch = {
						lerp_perfect = 0.06,
						lerp_basic = 0.06
					},
					yaw = {
						lerp_perfect = 0.06,
						lerp_basic = 0.06
					}
				}
			}
		},
		sway_pattern = default_lasgun_sway_pattern
	},
	moving = {
		rotation_speed = 0.4,
		inherits = {
			"lasgun_p1_m1_killshot",
			"still"
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.1,
				lerp_basic = 0.8
			},
			yaw = {
				lerp_perfect = 0.1,
				lerp_basic = 0.8
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
		}
	},
	crouch_still = {
		rotation_speed = 0.5,
		inherits = {
			"lasgun_p1_m1_killshot",
			"still"
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.05,
				lerp_basic = 0.5
			},
			yaw = {
				lerp_perfect = 0.05,
				lerp_basic = 0.5
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
					lerp_basic = 0.01
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
		}
	},
	crouch_moving = {
		rotation_speed = 0.85,
		inherits = {
			"lasgun_p1_m1_killshot",
			"still"
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.15,
				lerp_basic = 0.9
			},
			yaw = {
				lerp_perfect = 0.15,
				lerp_basic = 0.9
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
		sway_pattern = default_lasgun_crouch_sway_pattern
	}
}
sway_templates.lasgun_p1_m2_killshot = {
	still = {
		intensity = 0.6,
		horizontal_speed = 0.7,
		visual_pitch_impact_mod = 6,
		rotation_speed = 0.5,
		visual_yaw_impact_mod = 4,
		max_sway = {
			pitch = {
				lerp_perfect = 4,
				lerp_basic = 4
			},
			yaw = {
				lerp_perfect = 4,
				lerp_basic = 4
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
				lerp_perfect = 0.075,
				lerp_basic = 0.5
			},
			yaw = {
				lerp_perfect = 0.075,
				lerp_basic = 0.5
			}
		},
		immediate_sway = {
			num_shots_clear_time = 2,
			crouch_transition = {
				{
					cap = true,
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 1
					},
					yaw = {
						lerp_perfect = 0,
						lerp_basic = 1
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
						lerp_basic = 0.01
					},
					yaw = {
						lerp_perfect = 0,
						lerp_basic = 0.01
					}
				},
				{
					pitch = {
						lerp_perfect = 0,
						lerp_basic = 0.01
					},
					yaw = {
						lerp_perfect = 0,
						lerp_basic = 0.01
					}
				},
				{
					pitch = {
						lerp_perfect = 0,
						lerp_basic = 0.01
					},
					yaw = {
						lerp_perfect = 0,
						lerp_basic = 0.01
					}
				},
				{
					pitch = {
						lerp_perfect = 0.01,
						lerp_basic = 0.02
					},
					yaw = {
						lerp_perfect = 0.01,
						lerp_basic = 0.02
					}
				},
				{
					pitch = {
						lerp_perfect = 0.015,
						lerp_basic = 0.03
					},
					yaw = {
						lerp_perfect = 0.015,
						lerp_basic = 0.03
					}
				},
				{
					pitch = {
						lerp_perfect = 0.02,
						lerp_basic = 0.04
					},
					yaw = {
						lerp_perfect = 0.02,
						lerp_basic = 0.04
					}
				},
				{
					pitch = {
						lerp_perfect = 0.03,
						lerp_basic = 0.06
					},
					yaw = {
						lerp_perfect = 0.03,
						lerp_basic = 0.06
					}
				}
			}
		},
		sway_pattern = default_lasgun_sway_pattern
	},
	moving = {
		rotation_speed = 0.4,
		inherits = {
			"lasgun_p1_m2_killshot",
			"still"
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.1,
				lerp_basic = 0.75
			},
			yaw = {
				lerp_perfect = 0.1,
				lerp_basic = 0.75
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
		rotation_speed = 0.5,
		inherits = {
			"lasgun_p1_m2_killshot",
			"still"
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.075,
				lerp_basic = 0.45
			},
			yaw = {
				lerp_perfect = 0.075,
				lerp_basic = 0.45
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
					lerp_basic = 0.01
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
		}
	},
	crouch_moving = {
		rotation_speed = 0.85,
		inherits = {
			"lasgun_p1_m2_killshot",
			"still"
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.15,
				lerp_basic = 0.8
			},
			yaw = {
				lerp_perfect = 0.15,
				lerp_basic = 0.8
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
		sway_pattern = default_lasgun_crouch_sway_pattern
	}
}
sway_templates.lasgun_p1_m3_killshot = {
	still = {
		intensity = 0.7,
		horizontal_speed = 0.6,
		visual_pitch_impact_mod = 6,
		rotation_speed = 0.4,
		visual_yaw_impact_mod = 4,
		max_sway = {
			yaw = 4,
			pitch = 4
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
				lerp_perfect = 0.1,
				lerp_basic = 0.9
			},
			yaw = {
				lerp_perfect = 0.1,
				lerp_basic = 0.9
			}
		},
		immediate_sway = {
			num_shots_clear_time = 2,
			crouch_transition = {
				{
					cap = true,
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 1
					},
					yaw = {
						lerp_perfect = 0,
						lerp_basic = 1
					}
				}
			},
			alternate_fire_start = {
				{
					cap = true,
					pitch = {
						lerp_perfect = 0,
						lerp_basic = 1
					},
					yaw = {
						lerp_perfect = 0,
						lerp_basic = 1
					}
				}
			},
			suppression_hit = {
				{
					pitch = {
						lerp_perfect = 0.3,
						lerp_basic = 0.5
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1
					}
				},
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 0.45
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 0.75
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
						lerp_perfect = 0.05,
						lerp_basic = 0.1
					},
					yaw = {
						lerp_perfect = 0.05,
						lerp_basic = 0.1
					}
				},
				{
					pitch = {
						lerp_perfect = 0.05,
						lerp_basic = 0.1
					},
					yaw = {
						lerp_perfect = 0.05,
						lerp_basic = 0.1
					}
				},
				{
					pitch = {
						lerp_perfect = 0.04,
						lerp_basic = 0.15
					},
					yaw = {
						lerp_perfect = 0.04,
						lerp_basic = 0.15
					}
				},
				{
					pitch = {
						lerp_perfect = 0.03,
						lerp_basic = 0.1
					},
					yaw = {
						lerp_perfect = 0.03,
						lerp_basic = 0.1
					}
				}
			}
		},
		sway_pattern = lasgun_p1_m3_sway_pattern
	},
	moving = {
		rotation_speed = 0.4,
		inherits = {
			"lasgun_p1_m3_killshot",
			"still"
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.1,
				lerp_basic = 1
			},
			yaw = {
				lerp_perfect = 0.1,
				lerp_basic = 1
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
		}
	},
	crouch_still = {
		rotation_speed = 0.5,
		inherits = {
			"lasgun_p1_m3_killshot",
			"still"
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.075,
				lerp_basic = 0.6
			},
			yaw = {
				lerp_perfect = 0.075,
				lerp_basic = 0.6
			}
		},
		decay = {
			suppression = 0.2,
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.3,
			shooting = {
				pitch = {
					lerp_perfect = 0.5,
					lerp_basic = 0.1
				},
				yaw = {
					lerp_perfect = 0.5,
					lerp_basic = 0.01
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
		}
	},
	crouch_moving = {
		rotation_speed = 0.85,
		inherits = {
			"lasgun_p1_m3_killshot",
			"still"
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.1,
				lerp_basic = 1.05
			},
			yaw = {
				lerp_perfect = 0.1,
				lerp_basic = 1.05
			}
		},
		decay = {
			suppression = 0.2,
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.3,
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
		sway_pattern = lasgun_p1_m3_crouch_sway_pattern
	}
}
sway_templates.lasgun_p2_m1_killshot = {
	charge_scale = {
		max_yaw = 0.8,
		max_pitch = 0.8
	},
	still = {
		intensity = 1,
		horizontal_speed = 0.44999999999999996,
		visual_pitch_impact_mod = 6,
		rotation_speed = 0.30000000000000004,
		visual_yaw_impact_mod = 7,
		max_sway = {
			yaw = 4,
			pitch = 4
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
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.3,
				lerp_basic = 1.1
			},
			yaw = {
				lerp_perfect = 0.3,
				lerp_basic = 1.1
			}
		},
		immediate_sway = {
			num_shots_clear_time = 2,
			crouch_transition = {
				{
					cap = true,
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 1
					},
					yaw = {
						lerp_perfect = 0,
						lerp_basic = 1
					}
				}
			},
			alternate_fire_start = {
				{
					cap = true,
					pitch = {
						lerp_perfect = 0,
						lerp_basic = 1
					},
					yaw = {
						lerp_perfect = 0,
						lerp_basic = 1
					}
				}
			},
			suppression_hit = {
				{
					pitch = {
						lerp_perfect = 0.3,
						lerp_basic = 0.5
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1
					}
				},
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 0.45
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 0.75
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
						lerp_perfect = 0.05,
						lerp_basic = 0.5
					},
					yaw = {
						lerp_perfect = 0.05,
						lerp_basic = 0.5
					}
				},
				{
					pitch = {
						lerp_perfect = 0.05,
						lerp_basic = 0.1
					},
					yaw = {
						lerp_perfect = 0.05,
						lerp_basic = 0.1
					}
				},
				{
					pitch = {
						lerp_perfect = 0.04,
						lerp_basic = 0.15
					},
					yaw = {
						lerp_perfect = 0.04,
						lerp_basic = 0.15
					}
				},
				{
					pitch = {
						lerp_perfect = 0.03,
						lerp_basic = 0.1
					},
					yaw = {
						lerp_perfect = 0.03,
						lerp_basic = 0.1
					}
				}
			}
		},
		sway_pattern = lasgun_p1_m3_sway_pattern
	},
	moving = {
		rotation_speed = 0.30000000000000004,
		inherits = {
			"lasgun_p2_m1_killshot",
			"still"
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.4,
				lerp_basic = 1.2
			},
			yaw = {
				lerp_perfect = 0.4,
				lerp_basic = 1.2
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
		}
	},
	crouch_still = {
		rotation_speed = 0.375,
		inherits = {
			"lasgun_p2_m1_killshot",
			"still"
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.225,
				lerp_basic = 0.8
			},
			yaw = {
				lerp_perfect = 0.225,
				lerp_basic = 0.8
			}
		},
		decay = {
			suppression = 0.2,
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.3,
			shooting = {
				pitch = {
					lerp_perfect = 0.5,
					lerp_basic = 0.1
				},
				yaw = {
					lerp_perfect = 0.5,
					lerp_basic = 0.01
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
		}
	},
	crouch_moving = {
		rotation_speed = 0.48750000000000004,
		inherits = {
			"lasgun_p2_m1_killshot",
			"still"
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.1,
				lerp_basic = 1.05
			},
			yaw = {
				lerp_perfect = 0.1,
				lerp_basic = 1.05
			}
		},
		decay = {
			suppression = 0.2,
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.3,
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
		sway_pattern = lasgun_p1_m3_crouch_sway_pattern
	}
}
sway_templates.lasgun_p2_m2_killshot = {
	charge_scale = {
		max_yaw = 0.6,
		max_pitch = 0.6
	},
	still = {
		intensity = 1,
		horizontal_speed = 0.51,
		visual_pitch_impact_mod = 6,
		rotation_speed = 0.34,
		visual_yaw_impact_mod = 7,
		max_sway = {
			yaw = 4,
			pitch = 4
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
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.3,
				lerp_basic = 0.9
			},
			yaw = {
				lerp_perfect = 0.3,
				lerp_basic = 0.9
			}
		},
		immediate_sway = {
			num_shots_clear_time = 2,
			crouch_transition = {
				{
					cap = true,
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 0.5
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 0.5
					}
				}
			},
			alternate_fire_start = {
				{
					cap = true,
					pitch = {
						lerp_perfect = 0,
						lerp_basic = 1
					},
					yaw = {
						lerp_perfect = 0,
						lerp_basic = 1
					}
				}
			},
			suppression_hit = {
				{
					pitch = {
						lerp_perfect = 0.3,
						lerp_basic = 0.5
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1
					}
				},
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 0.45
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 0.75
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
						lerp_perfect = 0.05,
						lerp_basic = 0.3
					},
					yaw = {
						lerp_perfect = 0.05,
						lerp_basic = 0.3
					}
				},
				{
					pitch = {
						lerp_perfect = 0.05,
						lerp_basic = 0.1
					},
					yaw = {
						lerp_perfect = 0.05,
						lerp_basic = 0.1
					}
				},
				{
					pitch = {
						lerp_perfect = 0.04,
						lerp_basic = 0.15
					},
					yaw = {
						lerp_perfect = 0.04,
						lerp_basic = 0.15
					}
				},
				{
					pitch = {
						lerp_perfect = 0.03,
						lerp_basic = 0.1
					},
					yaw = {
						lerp_perfect = 0.03,
						lerp_basic = 0.1
					}
				}
			}
		},
		sway_pattern = lasgun_p1_m3_sway_pattern
	},
	moving = {
		rotation_speed = 0.34,
		inherits = {
			"lasgun_p2_m2_killshot",
			"still"
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.1,
				lerp_basic = 1
			},
			yaw = {
				lerp_perfect = 0.1,
				lerp_basic = 1
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
		}
	},
	crouch_still = {
		rotation_speed = 0.34,
		inherits = {
			"lasgun_p2_m2_killshot",
			"still"
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.225,
				lerp_basic = 0.7
			},
			yaw = {
				lerp_perfect = 0.225,
				lerp_basic = 0.7
			}
		},
		decay = {
			suppression = 0.2,
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.3,
			shooting = {
				pitch = {
					lerp_perfect = 0.5,
					lerp_basic = 0.1
				},
				yaw = {
					lerp_perfect = 0.5,
					lerp_basic = 0.01
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
		}
	},
	crouch_moving = {
		rotation_speed = 0.5525,
		inherits = {
			"lasgun_p2_m2_killshot",
			"still"
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.1,
				lerp_basic = 1.05
			},
			yaw = {
				lerp_perfect = 0.1,
				lerp_basic = 1.05
			}
		},
		decay = {
			suppression = 0.2,
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.3,
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
		sway_pattern = lasgun_p1_m3_crouch_sway_pattern
	}
}
sway_templates.lasgun_p3_m1_sway = {
	still = {
		intensity = 0.2,
		horizontal_speed = 0.7,
		visual_pitch_impact_mod = 6,
		rotation_speed = 0.5,
		visual_yaw_impact_mod = 4,
		max_sway = {
			yaw = 2,
			pitch = 2
		},
		decay = {
			suppression = 0.2,
			crouch_transition_grace_time = 0.5,
			shooting = {
				pitch = {
					lerp_perfect = 0.5,
					lerp_basic = 0.25
				},
				yaw = {
					lerp_perfect = 0.5,
					lerp_basic = 0.25
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
					lerp_perfect = 0.75,
					lerp_basic = 0.25
				},
				yaw = {
					lerp_perfect = 0.75,
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
				lerp_basic = 0.03
			},
			yaw = {
				lerp_perfect = 0.02,
				lerp_basic = 0.3
			}
		},
		immediate_sway = {
			num_shots_clear_time = 1,
			crouch_transition = {
				{
					cap = true,
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1
					}
				}
			},
			alternate_fire_start = {
				{
					cap = true,
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1.5
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1.5
					}
				}
			},
			suppression_hit = {
				{
					pitch = {
						lerp_perfect = 0.15,
						lerp_basic = 1.05
					},
					yaw = {
						lerp_perfect = 0.1,
						lerp_basic = 1.1
					}
				},
				{
					pitch = {
						lerp_perfect = 0.1,
						lerp_basic = 0.7
					},
					yaw = {
						lerp_perfect = 0.2,
						lerp_basic = 0.7
					}
				},
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 0.8
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 1
					}
				},
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 1
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 0.7
					}
				},
				{
					pitch = {
						lerp_perfect = 0.3,
						lerp_basic = 1
					},
					yaw = {
						lerp_perfect = 0.3,
						lerp_basic = 0.85
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
					yaw = 0.005,
					pitch = 0.005
				}
			}
		},
		sway_pattern = default_lasgun_sway_pattern
	},
	moving = {
		inherits = {
			"lasgun_p3_m1_sway",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"lasgun_p3_m1_sway",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"lasgun_p3_m1_sway",
			"still"
		}
	}
}

return {
	base_templates = sway_templates,
	overrides = overrides
}
