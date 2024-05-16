﻿-- chunkname: @scripts/settings/equipment/weapon_templates/stub_pistols/settings_templates/stub_pistol_sway_templates.lua

local sway_templates = {}
local overrides = {}

table.make_unique(sway_templates)
table.make_unique(overrides)

local function default_stubpistol_sway_pattern(dt, t, sway_settings, yaw, pitch)
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

sway_templates.default_stubpistol_killshot = {
	still = {
		horizontal_speed = 0.6,
		intensity = 0.8,
		rotation_speed = 0.42,
		visual_pitch_impact_mod = 4.75,
		visual_yaw_impact_mod = 4.75,
		max_sway = {
			pitch = {
				lerp_basic = 2.5,
				lerp_perfect = 2.5,
			},
			yaw = {
				lerp_basic = 2.5,
				lerp_perfect = 2.5,
			},
		},
		decay = {
			crouch_transition_grace_time = 0.5,
			suppression = 0.2,
			shooting = {
				pitch = {
					lerp_basic = 0.1,
					lerp_perfect = 0.25,
				},
				yaw = {
					lerp_basic = 0.1,
					lerp_perfect = 0.25,
				},
			},
			idle = {
				pitch = {
					lerp_basic = 0.75,
					lerp_perfect = 1,
				},
				yaw = {
					lerp_basic = 0.75,
					lerp_perfect = 1,
				},
			},
			player_event = {
				pitch = {
					lerp_basic = 0.25,
					lerp_perfect = 0.5,
				},
				yaw = {
					lerp_basic = 0.25,
					lerp_perfect = 0.5,
				},
			},
			enter_alternate_fire_grace_time = {
				lerp_basic = 0.45,
				lerp_perfect = 0,
			},
			from_shooting_grace_time = {
				lerp_basic = 1,
				lerp_perfect = 0,
			},
		},
		continuous_sway = {
			pitch = {
				lerp_basic = 0.2,
				lerp_perfect = 0.025,
			},
			yaw = {
				lerp_basic = 0.25,
				lerp_perfect = 0.025,
			},
		},
		immediate_sway = {
			num_shots_clear_time = 0.5,
			crouch_transition = {
				{
					cap = true,
					pitch = {
						lerp_basic = 0.25,
						lerp_perfect = 0,
					},
					yaw = {
						lerp_basic = 0.25,
						lerp_perfect = 0,
					},
				},
			},
			alternate_fire_start = {
				{
					cap = true,
					pitch = {
						lerp_basic = 0.5,
						lerp_perfect = 0,
					},
					yaw = {
						lerp_basic = 0.5,
						lerp_perfect = 0,
					},
				},
			},
			suppression_hit = {
				{
					pitch = {
						lerp_basic = 0.25,
						lerp_perfect = 0.1,
					},
					yaw = {
						lerp_basic = 0.25,
						lerp_perfect = 0.1,
					},
				},
			},
			damage_hit = {
				{
					pitch = {
						lerp_basic = 0.6,
						lerp_perfect = 0.1,
					},
					yaw = {
						lerp_basic = 0.6,
						lerp_perfect = 0.1,
					},
				},
			},
			shooting = {
				{
					pitch = {
						lerp_basic = 0.1,
						lerp_perfect = 0.04,
					},
					yaw = {
						lerp_basic = 0.1,
						lerp_perfect = 0.03,
					},
				},
			},
		},
		sway_pattern = default_stubpistol_sway_pattern,
	},
	moving = {
		intensity = 0.8,
		rotation_speed = 0.4,
		inherits = {
			"default_stubpistol_killshot",
			"still",
		},
		continuous_sway = {
			pitch = {
				lerp_basic = 0.2,
				lerp_perfect = 0.025,
			},
			yaw = {
				lerp_basic = 0.25,
				lerp_perfect = 0.025,
			},
		},
		decay = {
			crouch_transition_grace_time = 0.5,
			suppression = 0.2,
			shooting = {
				pitch = {
					lerp_basic = 0.1,
					lerp_perfect = 0.25,
				},
				yaw = {
					lerp_basic = 0.1,
					lerp_perfect = 0.25,
				},
			},
			idle = {
				pitch = {
					lerp_basic = 0.75,
					lerp_perfect = 1,
				},
				yaw = {
					lerp_basic = 0.75,
					lerp_perfect = 1,
				},
			},
			player_event = {
				pitch = {
					lerp_basic = 0.25,
					lerp_perfect = 0.5,
				},
				yaw = {
					lerp_basic = 0.25,
					lerp_perfect = 0.5,
				},
			},
			enter_alternate_fire_grace_time = {
				lerp_basic = 0.45,
				lerp_perfect = 0,
			},
			from_shooting_grace_time = {
				lerp_basic = 1,
				lerp_perfect = 0,
			},
		},
	},
	crouch_still = {
		rotation_speed = 0.5,
		inherits = {
			"default_stubpistol_killshot",
			"still",
		},
		continuous_sway = {
			pitch = {
				lerp_basic = 0.2,
				lerp_perfect = 0.025,
			},
			yaw = {
				lerp_basic = 0.25,
				lerp_perfect = 0.025,
			},
		},
		decay = {
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.3,
			suppression = 0.2,
			shooting = {
				pitch = {
					lerp_basic = 0.1,
					lerp_perfect = 0.1,
				},
				yaw = {
					lerp_basic = 0.01,
					lerp_perfect = 0.1,
				},
			},
			idle = {
				pitch = {
					lerp_basic = 1.5,
					lerp_perfect = 3.5,
				},
				yaw = {
					lerp_basic = 1.5,
					lerp_perfect = 3.5,
				},
			},
			player_event = {
				pitch = {
					lerp_basic = 0.1,
					lerp_perfect = 0.1,
				},
				yaw = {
					lerp_basic = 0.1,
					lerp_perfect = 0.1,
				},
			},
			from_shooting_grace_time = {
				lerp_basic = 1,
				lerp_perfect = 0,
			},
		},
	},
	crouch_moving = {
		rotation_speed = 0.85,
		inherits = {
			"default_stubpistol_killshot",
			"still",
		},
		continuous_sway = {
			pitch = {
				lerp_basic = 0.2,
				lerp_perfect = 0.025,
			},
			yaw = {
				lerp_basic = 0.25,
				lerp_perfect = 0.025,
			},
		},
		decay = {
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.3,
			suppression = 0.2,
			shooting = {
				pitch = {
					lerp_basic = 0.1,
					lerp_perfect = 0.1,
				},
				yaw = {
					lerp_basic = 0.1,
					lerp_perfect = 0.1,
				},
			},
			idle = {
				pitch = {
					lerp_basic = 1.25,
					lerp_perfect = 3,
				},
				yaw = {
					lerp_basic = 1.25,
					lerp_perfect = 3,
				},
			},
			player_event = {
				pitch = {
					lerp_basic = 0.1,
					lerp_perfect = 0.1,
				},
				yaw = {
					lerp_basic = 0.1,
					lerp_perfect = 0.1,
				},
			},
			from_shooting_grace_time = {
				lerp_basic = 1,
				lerp_perfect = 0,
			},
		},
	},
}
overrides.stubpistol_p1_m2 = {
	parent_template_name = "default_stubpistol_killshot",
	overrides = {},
}
overrides.stubpistol_p1_m3 = {
	parent_template_name = "default_stubpistol_killshot",
	overrides = {},
}

return {
	base_templates = sway_templates,
	overrides = overrides,
}
