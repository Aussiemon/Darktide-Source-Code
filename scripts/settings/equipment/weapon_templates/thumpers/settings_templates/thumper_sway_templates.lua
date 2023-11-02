local sway_templates = {}
local overrides = {}

table.make_unique(sway_templates)
table.make_unique(overrides)

local function default_thumper_sway_pattern(dt, t, sway_settings, yaw, pitch)
	local horizontal_speed = sway_settings.horizontal_speed
	local rotation_speed = sway_settings.rotation_speed
	local sin_angle = t * math.pi * horizontal_speed
	local sin_wave = math.sin(sin_angle)
	local new_angle = t * math.pi * rotation_speed
	local yaw_angle = math.cos(new_angle)
	local pitch_angle = 0.25 * sin_wave * sin_wave + math.sin(5 * new_angle) * (0.5 + 0.5 * (1 - math.abs(yaw_angle * yaw_angle)))
	local yaw = math.degrees_to_radians(yaw)
	local pitch = math.degrees_to_radians(pitch)
	local intensity = sway_settings.intensity or 1
	local aim_offset_y = pitch_angle * yaw * intensity
	local aim_offset_x = yaw_angle * pitch * intensity

	return aim_offset_x, aim_offset_y
end

sway_templates.default_thumper_killshot = {
	still = {
		intensity = 1,
		horizontal_speed = 0.2,
		visual_pitch_impact_mod = 10,
		rotation_speed = 0.125,
		visual_yaw_impact_mod = 10,
		max_sway = {
			yaw = 0.1,
			pitch = 0.1
		},
		decay = {
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.5,
			shooting = {
				yaw = 0.15,
				pitch = 0.15
			},
			idle = {
				yaw = 0.5,
				pitch = 0.5
			},
			player_event = {
				yaw = 1.5,
				pitch = 1.5
			}
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.1,
				lerp_basic = 0.5
			},
			yaw = {
				lerp_perfect = 0.1,
				lerp_basic = 0.2
			}
		},
		immediate_sway = {
			num_shots_clear_time = 0.6,
			crouch_transition = {
				{
					yaw = 0.25,
					pitch = 0.25
				}
			},
			alternate_fire_start = {
				{
					yaw = 0.5,
					pitch = 0.5
				}
			},
			suppression_hit = {
				{
					yaw = 0.2,
					pitch = 0.2
				}
			},
			damage_hit = {
				{
					yaw = 0.25,
					pitch = 0.25
				}
			},
			shooting = {
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1.9
					},
					yaw = {
						lerp_perfect = 0.4,
						lerp_basic = 2
					}
				}
			}
		},
		sway_pattern = default_thumper_sway_pattern
	},
	moving = {
		inherits = {
			"default_thumper_killshot",
			"still"
		}
	},
	crouch_still = {
		rotation_speed = 0.2,
		inherits = {
			"default_thumper_killshot",
			"still"
		},
		continuous_sway = {
			yaw = 0.15,
			pitch = 0.4
		},
		decay = {
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.3,
			shooting = {
				yaw = 0.15,
				pitch = 0.15
			},
			idle = {
				yaw = 0.75,
				pitch = 0.5
			},
			player_event = {
				yaw = 3,
				pitch = 3
			}
		}
	},
	crouch_moving = {
		rotation_speed = 0.5,
		inherits = {
			"default_thumper_killshot",
			"still"
		},
		continuous_sway = {
			yaw = 1,
			pitch = 1.75
		},
		decay = {
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.3,
			shooting = {
				yaw = 0.15,
				pitch = 0.15
			},
			idle = {
				yaw = 0.75,
				pitch = 0.5
			},
			player_event = {
				yaw = 3,
				pitch = 3
			}
		}
	}
}
sway_templates.default_thumper_assault = {
	still = {
		intensity = 0.2,
		horizontal_speed = 0.2,
		visual_pitch_impact_mod = 10,
		rotation_speed = 0.125,
		visual_yaw_impact_mod = 10,
		max_sway = {
			yaw = 1,
			pitch = 1
		},
		decay = {
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.5,
			shooting = {
				yaw = 0.15,
				pitch = 0.15
			},
			idle = {
				yaw = 0.5,
				pitch = 0.5
			},
			player_event = {
				yaw = 1.5,
				pitch = 1.5
			}
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.4,
				lerp_basic = 1.5
			},
			yaw = {
				lerp_perfect = 0.3,
				lerp_basic = 1.2
			}
		},
		immediate_sway = {
			num_shots_clear_time = 0.6,
			crouch_transition = {
				{
					yaw = 0.25,
					pitch = 0.25
				}
			},
			alternate_fire_start = {
				{
					yaw = 0.5,
					pitch = 0.5
				}
			},
			suppression_hit = {
				{
					yaw = 0.2,
					pitch = 0.2
				}
			},
			damage_hit = {
				{
					yaw = 0.25,
					pitch = 0.25
				}
			},
			shooting = {
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1.9
					},
					yaw = {
						lerp_perfect = 0.4,
						lerp_basic = 2
					}
				}
			}
		},
		sway_pattern = default_thumper_sway_pattern
	},
	moving = {
		inherits = {
			"default_thumper_assault",
			"still"
		}
	},
	crouch_still = {
		rotation_speed = 0.2,
		inherits = {
			"default_thumper_assault",
			"still"
		},
		continuous_sway = {
			yaw = 0.15,
			pitch = 0.4
		},
		decay = {
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.3,
			shooting = {
				yaw = 0.15,
				pitch = 0.15
			},
			idle = {
				yaw = 0.75,
				pitch = 0.5
			},
			player_event = {
				yaw = 3,
				pitch = 3
			}
		}
	},
	crouch_moving = {
		rotation_speed = 0.5,
		inherits = {
			"default_thumper_assault",
			"still"
		},
		continuous_sway = {
			yaw = 1,
			pitch = 1.75
		},
		decay = {
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.3,
			shooting = {
				yaw = 0.15,
				pitch = 0.15
			},
			idle = {
				yaw = 0.75,
				pitch = 0.5
			},
			player_event = {
				yaw = 3,
				pitch = 3
			}
		}
	}
}

return {
	base_templates = sway_templates,
	overrides = overrides
}
