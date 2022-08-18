local sway_templates = {}
local overrides = {}

table.make_unique(sway_templates)
table.make_unique(overrides)

sway_templates.default_stubpistol_killshot = {
	still = {
		intensity = 0.8,
		sway_impact = 5,
		horizontal_speed = 0.6,
		rotation_speed = 0.42,
		max_sway = {
			pitch = {
				lerp_perfect = 2.5,
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
						lerp_perfect = 0,
						lerp_basic = 0.25
					},
					yaw = {
						lerp_perfect = 0,
						lerp_basic = 0.25
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
						lerp_perfect = 0.1,
						lerp_basic = 0.6
					},
					yaw = {
						lerp_perfect = 0.1,
						lerp_basic = 0.6
					}
				}
			},
			shooting = {
				{
					pitch = {
						lerp_perfect = 0.04,
						lerp_basic = 0.1
					},
					yaw = {
						lerp_perfect = 0.03,
						lerp_basic = 0.1
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
		intensity = 0.8,
		rotation_speed = 0.4,
		inherits = {
			"default_stubpistol_killshot",
			"still"
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
			"default_stubpistol_killshot",
			"still"
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
			"default_stubpistol_killshot",
			"still"
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
		}
	}
}

return {
	base_templates = sway_templates,
	overrides = overrides
}
