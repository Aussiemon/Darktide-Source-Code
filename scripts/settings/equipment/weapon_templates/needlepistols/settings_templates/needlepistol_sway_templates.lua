-- chunkname: @scripts/settings/equipment/weapon_templates/needlepistols/settings_templates/needlepistol_sway_templates.lua

local sway_templates = {}
local overrides = {}
local PI = math.pi

table.make_unique(sway_templates)
table.make_unique(overrides)

local function _default_needlepistol_sway_pattern(dt, t, sway_settings, yaw, pitch)
	local horizontal_speed = sway_settings.horizontal_speed
	local rotation_speed = sway_settings.rotation_speed
	local sin_angle = t * PI * horizontal_speed
	local sin_wave = math.sin(sin_angle)
	local new_angle = t * PI * rotation_speed
	local yaw_angle = math.cos(new_angle)
	local pitch_angle = 0.25 * sin_wave * sin_wave + math.sin(2 * new_angle) * (0.5 + 0.5 * (1 - math.abs(yaw_angle * yaw_angle)))
	local wanted_yaw = math.degrees_to_radians(yaw)
	local wanted_pitch = math.degrees_to_radians(pitch)
	local intensity = sway_settings.intensity or 1
	local aim_offset_y = pitch_angle * wanted_yaw * intensity
	local aim_offset_x = yaw_angle * wanted_pitch * intensity

	return aim_offset_x, aim_offset_y
end

local function _default_needlepistol_crouch_sway_pattern(dt, t, sway_settings, yaw, pitch)
	local horizontal_speed = sway_settings.horizontal_speed
	local rotation_speed = sway_settings.rotation_speed
	local sin_angle = t * PI * horizontal_speed
	local sin_wave = math.sin(sin_angle)
	local new_angle = t * PI * rotation_speed
	local yaw_angle = math.cos(new_angle)
	local pitch_angle = 0.25 * sin_wave * sin_wave + math.sin(3 * new_angle) * (0.5 + 0.5 * math.abs(yaw_angle * yaw_angle))
	local wanted_yaw = math.degrees_to_radians(yaw)
	local wanted_pitch = math.degrees_to_radians(pitch)
	local intensity = sway_settings.intensity or 1
	local aim_offset_y = pitch_angle * wanted_yaw * intensity
	local aim_offset_x = yaw_angle * wanted_pitch * intensity

	return aim_offset_x, aim_offset_y
end

sway_templates.default_needlepistol_killshot = {
	still = {
		horizontal_speed = 1,
		intensity = 1.2,
		rotation_speed = 0.75,
		visual_pitch_impact_mod = 3.3,
		visual_yaw_impact_mod = 3.3,
		max_sway = {
			pitch = {
				lerp_basic = 0.11,
				lerp_perfect = 0.0002,
			},
			yaw = {
				lerp_basic = 0.11,
				lerp_perfect = 0.0002,
			},
		},
		decay = {
			crouch_transition_grace_time = 0.5,
			suppression = 0.2,
			shooting = {
				pitch = {
					lerp_basic = 0.1,
					lerp_perfect = 0.5,
				},
				yaw = {
					lerp_basic = 0.1,
					lerp_perfect = 0.5,
				},
			},
			idle = {
				pitch = {
					lerp_basic = 0.75,
					lerp_perfect = 2,
				},
				yaw = {
					lerp_basic = 0.75,
					lerp_perfect = 2,
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
				lerp_perfect = 0.02,
			},
			yaw = {
				lerp_basic = 0.2,
				lerp_perfect = 0.02,
			},
		},
		immediate_sway = {
			num_shots_clear_time = 2,
			crouch_transition = {
				{
					cap = true,
					pitch = {
						lerp_basic = 0.1,
						lerp_perfect = 0.025,
					},
					yaw = {
						lerp_basic = 0.1,
						lerp_perfect = 0.025,
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
			damage_hit = {
				{
					pitch = {
						lerp_basic = 1.2,
						lerp_perfect = 0.6,
					},
					yaw = {
						lerp_basic = 1.2,
						lerp_perfect = 0.6,
					},
				},
			},
			shooting = {
				{
					pitch = {
						lerp_basic = 0.001,
						lerp_perfect = 0,
					},
					yaw = {
						lerp_basic = 0.001,
						lerp_perfect = 0,
					},
				},
				{
					pitch = {
						lerp_basic = 0.001,
						lerp_perfect = 0,
					},
					yaw = {
						lerp_basic = 0.001,
						lerp_perfect = 0,
					},
				},
				{
					pitch = {
						lerp_basic = 0.001,
						lerp_perfect = 0,
					},
					yaw = {
						lerp_basic = 0.001,
						lerp_perfect = 0,
					},
				},
				{
					pitch = {
						lerp_basic = 0.002,
						lerp_perfect = 0.001,
					},
					yaw = {
						lerp_basic = 0.002,
						lerp_perfect = 0.001,
					},
				},
				{
					pitch = {
						lerp_basic = 0.003,
						lerp_perfect = 0.0015,
					},
					yaw = {
						lerp_basic = 0.003,
						lerp_perfect = 0.0015,
					},
				},
				{
					pitch = {
						lerp_basic = 0.004,
						lerp_perfect = 0.002,
					},
					yaw = {
						lerp_basic = 0.004,
						lerp_perfect = 0.002,
					},
				},
				{
					pitch = {
						lerp_basic = 0.006,
						lerp_perfect = 0.003,
					},
					yaw = {
						lerp_basic = 0.006,
						lerp_perfect = 0.003,
					},
				},
			},
		},
		sway_pattern = _default_needlepistol_sway_pattern,
	},
	moving = {
		inherits = {
			"default_needlepistol_killshot",
			"still",
		},
		continuous_sway = {
			pitch = {
				lerp_basic = 0.45,
				lerp_perfect = 0.1,
			},
			yaw = {
				lerp_basic = 0.45,
				lerp_perfect = 0.1,
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
		inherits = {
			"default_needlepistol_killshot",
			"still",
		},
		continuous_sway = {
			pitch = {
				lerp_basic = 0.1,
				lerp_perfect = 0.01,
			},
			yaw = {
				lerp_basic = 0.1,
				lerp_perfect = 0.01,
			},
		},
		decay = {
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.3,
			suppression = 0.2,
			shooting = {
				pitch = {
					lerp_basic = 0.001,
					lerp_perfect = 0.001,
				},
				yaw = {
					lerp_basic = 0.001,
					lerp_perfect = 0.001,
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
		sway_pattern = _default_needlepistol_crouch_sway_pattern,
	},
	crouch_moving = {
		inherits = {
			"default_needlepistol_killshot",
			"still",
		},
		continuous_sway = {
			pitch = {
				lerp_basic = 0.12,
				lerp_perfect = 0.0125,
			},
			yaw = {
				lerp_basic = 0.12,
				lerp_perfect = 0.0125,
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
		sway_pattern = _default_needlepistol_crouch_sway_pattern,
	},
}

return {
	base_templates = sway_templates,
	overrides = overrides,
}
