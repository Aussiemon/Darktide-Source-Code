-- chunkname: @scripts/settings/equipment/weapon_templates/stub_pistols/settings_templates/stub_pistol_sway_templates.lua

local sway_templates = {}
local overrides = {}
local PI = math.pi

table.make_unique(sway_templates)
table.make_unique(overrides)

local function _default_stubpistol_sway_pattern(dt, t, sway_settings, yaw, pitch)
	local horizontal_speed = sway_settings.horizontal_speed
	local rotation_speed = sway_settings.rotation_speed
	local sin_angle = t * PI * horizontal_speed
	local sin_wave = math.sin(sin_angle)
	local new_angle = t * PI * rotation_speed
	local yaw_angle = math.cos(new_angle)
	local pitch_angle = 0.25 * sin_wave * sin_wave + math.sin(3 * new_angle) * (0.5 + 0.5 * (1 - math.abs(yaw_angle * yaw_angle)))
	local wanted_yaw = math.degrees_to_radians(yaw)
	local wanted_pitch = math.degrees_to_radians(pitch)
	local intensity = sway_settings.intensity or 1
	local aim_offset_y = pitch_angle * wanted_pitch * intensity
	local aim_offset_x = yaw_angle * wanted_yaw * intensity

	return aim_offset_x, aim_offset_y
end

sway_templates.default_stubpistol_killshot = {
	still = {
		intensity = 0.8,
		horizontal_speed = 0.6,
		visual_pitch_impact_mod = 4.75,
		rotation_speed = 0.42,
		visual_yaw_impact_mod = 4.75,
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
		sway_pattern = _default_stubpistol_sway_pattern
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
overrides.stubpistol_p1_m2 = {
	parent_template_name = "default_stubpistol_killshot",
	overrides = {}
}
overrides.stubpistol_p1_m3 = {
	parent_template_name = "default_stubpistol_killshot",
	overrides = {}
}

return {
	base_templates = sway_templates,
	overrides = overrides
}
