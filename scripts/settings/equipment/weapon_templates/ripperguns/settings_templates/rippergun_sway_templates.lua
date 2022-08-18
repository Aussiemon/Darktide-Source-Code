local sway_templates = {}
local overrides = {}

table.make_unique(sway_templates)
table.make_unique(overrides)

sway_templates.default_rippergun_braced = {
	still = {
		intensity = 0.5,
		sway_impact = 2,
		horizontal_speed = 0.5,
		rotation_speed = 0.25,
		max_sway = {
			yaw = 2.5,
			pitch = 2.5
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
			yaw = 0.2,
			pitch = 0.3
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
					yaw = 1,
					pitch = 1
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
					yaw = 0.1,
					pitch = 0.15
				},
				{
					yaw = 0.1,
					pitch = 0.25
				},
				{
					yaw = 0.125,
					pitch = 0.275
				},
				{
					yaw = 0.125,
					pitch = 0.2
				},
				{
					yaw = 0.1,
					pitch = 0.15
				},
				{
					yaw = 0.1,
					pitch = 0.1
				},
				{
					yaw = 0.05,
					pitch = 0.05
				},
				{
					yaw = 0.025,
					pitch = 0.025
				}
			}
		},
		sway_pattern = function (dt, t, sway_settings, yaw, pitch)
			local horizontal_speed = sway_settings.horizontal_speed
			local rotation_speed = sway_settings.rotation_speed
			local intensity = sway_settings.intensity
			local max_sway = sway_settings.max_sway
			local pitch_scalar = pitch / max_sway.pitch
			local yaw_scalar = yaw / max_sway.yaw
			local sin_angle = t * math.pi * horizontal_speed
			local sin_wave = math.sin(sin_angle)
			local new_angle = t * math.pi * rotation_speed
			local yaw_angle = math.cos(new_angle)
			local pitch_angle = 0.25 * sin_wave * sin_wave + math.sin(3 * new_angle) * (0.5 + 0.5 * math.abs(yaw_angle * yaw_angle))
			local aim_offset_y = pitch_angle * pitch_scalar * intensity
			local aim_offset_x = yaw_angle * yaw_scalar * intensity

			return aim_offset_x, aim_offset_y
		end
	},
	moving = {
		rotation_speed = 0.4,
		inherits = {
			"default_rippergun_braced",
			"still"
		},
		continuous_sway = {
			yaw = 0.4,
			pitch = 0.5
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
	crouch_still = {
		rotation_speed = 0.2,
		inherits = {
			"default_rippergun_braced",
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
			"default_rippergun_braced",
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
sway_templates.default_rippergun_assault = {
	still = {
		intensity = 0.5,
		sway_impact = 2,
		horizontal_speed = 0.5,
		rotation_speed = 0.25,
		max_sway = {
			yaw = 2.5,
			pitch = 2.5
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
			yaw = 0.2,
			pitch = 0.3
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
					yaw = 1,
					pitch = 1
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
					yaw = 0.1,
					pitch = 0.15
				},
				{
					yaw = 0.1,
					pitch = 0.25
				},
				{
					yaw = 0.125,
					pitch = 0.275
				},
				{
					yaw = 0.15,
					pitch = 0.3
				},
				{
					yaw = 0.175,
					pitch = 0.35
				}
			}
		},
		sway_pattern = function (dt, t, sway_settings, yaw, pitch)
			local horizontal_speed = sway_settings.horizontal_speed
			local rotation_speed = sway_settings.rotation_speed
			local intensity = sway_settings.intensity
			local max_sway = sway_settings.max_sway
			local pitch_scalar = pitch / max_sway.pitch
			local yaw_scalar = yaw / max_sway.yaw
			local sin_angle = t * math.pi * horizontal_speed
			local sin_wave = math.sin(sin_angle)
			local new_angle = t * math.pi * rotation_speed
			local yaw_angle = math.cos(new_angle)
			local pitch_angle = 0.25 * sin_wave * sin_wave + math.sin(3 * new_angle) * (0.5 + 0.5 * math.abs(yaw_angle * yaw_angle))
			local aim_offset_y = pitch_angle * pitch_scalar * intensity
			local aim_offset_x = yaw_angle * yaw_scalar * intensity

			return aim_offset_x, aim_offset_y
		end
	},
	moving = {
		rotation_speed = 0.4,
		inherits = {
			"default_shotgun_killshot",
			"still"
		},
		continuous_sway = {
			yaw = 0.4,
			pitch = 0.5
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
	crouch_still = {
		rotation_speed = 0.2,
		inherits = {
			"default_shotgun_killshot",
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
		inherits = {
			"default_shotgun_killshot",
			"still"
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
