local sway_templates = {}
local overrides = {}

table.make_unique(sway_templates)
table.make_unique(overrides)

sway_templates.default_autogun_killshot = {
	still = {
		intensity = 0.15,
		sway_impact = 1.5,
		horizontal_speed = 1.3,
		rotation_speed = 0.5,
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
			num_shots_clear_time = 0.6,
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
						lerp_perfect = 0.1,
						lerp_basic = 0.15
					},
					yaw = {
						lerp_perfect = 0.05,
						lerp_basic = 0.1
					}
				},
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 0.75
					}
				},
				{
					pitch = {
						lerp_perfect = 0.15,
						lerp_basic = 0.25
					},
					yaw = {
						lerp_perfect = 0.15,
						lerp_basic = 0.1
					}
				},
				{
					pitch = {
						lerp_perfect = 0.15,
						lerp_basic = 0.275
					},
					yaw = {
						lerp_perfect = 0.15,
						lerp_basic = 0.15
					}
				},
				{
					pitch = {
						lerp_perfect = 0.2,
						lerp_basic = 0.3
					},
					yaw = {
						lerp_perfect = 0.2,
						lerp_basic = 0.15
					}
				},
				{
					pitch = {
						lerp_perfect = 0.2,
						lerp_basic = 0.35
					},
					yaw = {
						lerp_perfect = 0.2,
						lerp_basic = 0.175
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
			"default_autogun_killshot",
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
			"default_autogun_killshot",
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
			"default_autogun_killshot",
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
sway_templates.fullauto_autogun_killshot = {
	still = {
		intensity = 0.2,
		sway_impact = 10,
		horizontal_speed = 0.5,
		rotation_speed = 0.35,
		max_sway = {
			pitch = {
				lerp_perfect = 0.5,
				lerp_basic = 1.5
			},
			yaw = {
				lerp_perfect = 0.5,
				lerp_basic = 1.5
			}
		},
		decay = {
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.3,
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
					lerp_perfect = 1.5,
					lerp_basic = 1
				},
				yaw = {
					lerp_perfect = 1.5,
					lerp_basic = 1
				}
			},
			player_event = {
				pitch = {
					lerp_perfect = 5.25,
					lerp_basic = 2.25
				},
				yaw = {
					lerp_perfect = 5.5,
					lerp_basic = 2.5
				}
			}
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
		immediate_sway = {
			num_shots_clear_time = 0.6,
			crouch_transition = {
				{
					yaw = 1.25,
					pitch = 1.25
				}
			},
			alternate_fire_start = {
				{
					yaw = 1,
					pitch = 1,
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
						lerp_perfect = 0.01,
						lerp_basic = 0.03
					},
					yaw = {
						lerp_perfect = 0.01,
						lerp_basic = 0.03
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
		rotation_speed = 0.55,
		inherits = {
			"fullauto_autogun_killshot",
			"still"
		},
		continuous_sway = {
			yaw = 0.4,
			pitch = 0.3
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
		rotation_speed = 0.45,
		inherits = {
			"fullauto_autogun_killshot",
			"still"
		},
		continuous_sway = {
			yaw = 0.05,
			pitch = 0.05
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
		rotation_speed = 0.55,
		inherits = {
			"fullauto_autogun_killshot",
			"still"
		},
		continuous_sway = {
			yaw = 0.6,
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
