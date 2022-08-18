local sway_templates = {}
local overrides = {}

table.make_unique(sway_templates)
table.make_unique(overrides)

sway_templates.default_laspistol_killshot = {
	still = {
		intensity = 0.4,
		sway_impact = 3,
		horizontal_speed = 0.4,
		rotation_speed = 0.2,
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
				yaw = 1,
				pitch = 1
			}
		},
		continuous_sway = {
			yaw = 0.25,
			pitch = 0.125
		},
		immediate_sway = {
			num_shots_clear_time = 0.8,
			crouch_transition = {
				{
					yaw = 2.25,
					pitch = 2.25
				}
			},
			alternate_fire_start = {
				{
					yaw = 2,
					pitch = 2,
					cap = true
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
						lerp_perfect = 0,
						lerp_basic = 0.05
					},
					yaw = {
						lerp_perfect = 0,
						lerp_basic = 0
					}
				},
				{
					pitch = {
						lerp_perfect = 0.01,
						lerp_basic = 0.02
					},
					yaw = {
						lerp_perfect = 0.01,
						lerp_basic = 0.01
					}
				},
				{
					pitch = {
						lerp_perfect = 0.02,
						lerp_basic = 0.03
					},
					yaw = {
						lerp_perfect = 0.02,
						lerp_basic = 0.02
					}
				},
				{
					pitch = {
						lerp_perfect = 0.03,
						lerp_basic = 0.04
					},
					yaw = {
						lerp_perfect = 0.03,
						lerp_basic = 0.03
					}
				},
				{
					pitch = {
						lerp_perfect = 0.04,
						lerp_basic = 0.05
					},
					yaw = {
						lerp_perfect = 0.04,
						lerp_basic = 0.04
					}
				},
				{
					pitch = {
						lerp_perfect = 0.05,
						lerp_basic = 0.07
					},
					yaw = {
						lerp_perfect = 0.06,
						lerp_basic = 0.06
					}
				},
				{
					pitch = {
						lerp_perfect = 0.06,
						lerp_basic = 0.08
					},
					yaw = {
						lerp_perfect = 0.07,
						lerp_basic = 0.06
					}
				},
				{
					pitch = {
						lerp_perfect = 0.07,
						lerp_basic = 0.1
					},
					yaw = {
						lerp_perfect = 0.05,
						lerp_basic = 0.07
					}
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
			local pitch_angle = 0.25 * sin_wave * sin_wave + math.sin(3 * new_angle) * (0.5 + 0.5 * (1 - math.abs(yaw_angle * yaw_angle)))
			local aim_offset_y = pitch_angle * pitch_scalar * intensity
			local aim_offset_x = yaw_angle * yaw_scalar * intensity

			return aim_offset_x, aim_offset_y
		end
	},
	moving = {
		rotation_speed = 0.75,
		inherits = {
			"default_laspistol_killshot",
			"still"
		},
		continuous_sway = {
			yaw = 0.75,
			pitch = 0.5
		},
		decay = {
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.5,
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
		rotation_speed = 0.5,
		inherits = {
			"default_laspistol_killshot",
			"still"
		},
		continuous_sway = {
			yaw = 0.3,
			pitch = 0.15
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
		rotation_speed = 0.85,
		inherits = {
			"default_laspistol_killshot",
			"still"
		},
		continuous_sway = {
			yaw = 1,
			pitch = 1
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
	}
}

return {
	base_templates = sway_templates,
	overrides = overrides
}
