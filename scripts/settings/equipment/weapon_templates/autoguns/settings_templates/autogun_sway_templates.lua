-- chunkname: @scripts/settings/equipment/weapon_templates/autoguns/settings_templates/autogun_sway_templates.lua

local sway_templates = {}
local overrides = {}

table.make_unique(sway_templates)
table.make_unique(overrides)

local function default_autogun_sway_pattern(dt, t, sway_settings, yaw, pitch)
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
	local aim_offset_y = pitch_angle * pitch * intensity
	local aim_offset_x = yaw_angle * yaw * intensity

	return aim_offset_x, aim_offset_y
end

local function default_autogun_crouch_sway_pattern(dt, t, sway_settings, yaw, pitch)
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

sway_templates.default_autogun_killshot = {
	still = {
		intensity = 0.15,
		horizontal_speed = 1.3,
		visual_pitch_impact_mod = 5,
		rotation_speed = 0.5,
		visual_yaw_impact_mod = 7,
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
		sway_pattern = default_autogun_sway_pattern
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
		sway_pattern = default_autogun_crouch_sway_pattern
	}
}
sway_templates.fullauto_autogun_killshot = {
	still = {
		intensity = 0.2,
		horizontal_speed = 0.5,
		visual_pitch_impact_mod = 5,
		rotation_speed = 0.35,
		visual_yaw_impact_mod = 7,
		max_sway = {
			pitch = {
				lerp_perfect = 1,
				lerp_basic = 8
			},
			yaw = {
				lerp_perfect = 1,
				lerp_basic = 8
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
				lerp_perfect = 0.5,
				lerp_basic = 2
			},
			yaw = {
				lerp_perfect = 0.5,
				lerp_basic = 2
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
					yaw = 1.52,
					pitch = 1.52
				}
			},
			damage_hit = {
				{
					yaw = 2.25,
					pitch = 2.25
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
		sway_pattern = default_autogun_sway_pattern
	},
	moving = {
		inherits = {
			"fullauto_autogun_killshot",
			"still"
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.75,
				lerp_basic = 3
			},
			yaw = {
				lerp_perfect = 0.75,
				lerp_basic = 3
			}
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
		inherits = {
			"fullauto_autogun_killshot",
			"still"
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.5,
				lerp_basic = 2
			},
			yaw = {
				lerp_perfect = 0.5,
				lerp_basic = 2
			}
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
			"fullauto_autogun_killshot",
			"still"
		},
		continuous_sway = {
			pitch = {
				lerp_perfect = 0.5,
				lerp_basic = 2
			},
			yaw = {
				lerp_perfect = 0.5,
				lerp_basic = 2
			}
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
		sway_pattern = default_autogun_crouch_sway_pattern
	}
}
overrides.fullauto_p3_autogun_killshot = {
	parent_template_name = "fullauto_autogun_killshot",
	overrides = {
		{
			"still",
			"visual_yaw_impact_mod",
			5
		},
		{
			"still",
			"visual_pitch_impact_mod",
			5
		}
	}
}
overrides.fullauto_p3_m3_autogun_killshot = {
	parent_template_name = "fullauto_autogun_killshot",
	overrides = {
		{
			"still",
			"visual_yaw_impact_mod",
			5
		},
		{
			"still",
			"visual_pitch_impact_mod",
			5
		}
	}
}

return {
	base_templates = sway_templates,
	overrides = overrides
}
