-- chunkname: @scripts/settings/equipment/weapon_templates/ripperguns/settings_templates/rippergun_sway_templates.lua

local sway_templates = {}
local overrides = {}

table.make_unique(sway_templates)
table.make_unique(overrides)

local function default_rippergun_sway_pattern(dt, t, sway_settings, yaw, pitch)
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

sway_templates.default_rippergun_braced = {
	still = {
		horizontal_speed = 0.5,
		intensity = 0.5,
		rotation_speed = 0.25,
		visual_pitch_impact_mod = 10,
		visual_yaw_impact_mod = 10,
		max_sway = {
			pitch = 2.5,
			yaw = 2.5,
		},
		decay = {
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.5,
			shooting = {
				pitch = 0.15,
				yaw = 0.15,
			},
			idle = {
				pitch = 0.5,
				yaw = 0.5,
			},
			player_event = {
				pitch = 1.5,
				yaw = 1.5,
			},
		},
		continuous_sway = {
			pitch = 0.3,
			yaw = 0.2,
		},
		immediate_sway = {
			num_shots_clear_time = 0.6,
			crouch_transition = {
				{
					pitch = 0.25,
					yaw = 0.25,
				},
			},
			alternate_fire_start = {
				{
					pitch = 1,
					yaw = 1,
				},
			},
			suppression_hit = {
				{
					pitch = 0.2,
					yaw = 0.2,
				},
			},
			damage_hit = {
				{
					pitch = 0.25,
					yaw = 0.25,
				},
			},
			shooting = {
				{
					pitch = 0.15,
					yaw = 0.1,
				},
				{
					pitch = 0.25,
					yaw = 0.1,
				},
				{
					pitch = 0.275,
					yaw = 0.125,
				},
				{
					pitch = 0.2,
					yaw = 0.125,
				},
				{
					pitch = 0.15,
					yaw = 0.1,
				},
				{
					pitch = 0.1,
					yaw = 0.1,
				},
				{
					pitch = 0.05,
					yaw = 0.05,
				},
				{
					pitch = 0.025,
					yaw = 0.025,
				},
			},
		},
		sway_pattern = default_rippergun_sway_pattern,
	},
	moving = {
		rotation_speed = 0.4,
		inherits = {
			"default_rippergun_braced",
			"still",
		},
		continuous_sway = {
			pitch = 0.5,
			yaw = 0.4,
		},
		decay = {
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.3,
			shooting = {
				pitch = 0.15,
				yaw = 0.15,
			},
			idle = {
				pitch = 0.5,
				yaw = 0.75,
			},
			player_event = {
				pitch = 3,
				yaw = 3,
			},
		},
	},
	crouch_still = {
		rotation_speed = 0.2,
		inherits = {
			"default_rippergun_braced",
			"still",
		},
		continuous_sway = {
			pitch = 0.4,
			yaw = 0.15,
		},
		decay = {
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.3,
			shooting = {
				pitch = 0.15,
				yaw = 0.15,
			},
			idle = {
				pitch = 0.5,
				yaw = 0.75,
			},
			player_event = {
				pitch = 3,
				yaw = 3,
			},
		},
	},
	crouch_moving = {
		rotation_speed = 0.5,
		inherits = {
			"default_rippergun_braced",
			"still",
		},
		continuous_sway = {
			pitch = 1.75,
			yaw = 1,
		},
		decay = {
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.3,
			shooting = {
				pitch = 0.15,
				yaw = 0.15,
			},
			idle = {
				pitch = 0.5,
				yaw = 0.75,
			},
			player_event = {
				pitch = 3,
				yaw = 3,
			},
		},
	},
}
sway_templates.default_rippergun_assault = {
	still = {
		horizontal_speed = 0.5,
		intensity = 0.5,
		rotation_speed = 0.25,
		visual_pitch_impact_mod = 1,
		visual_yaw_impact_mod = 1,
		max_sway = {
			pitch = 2.5,
			yaw = 2.5,
		},
		decay = {
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.5,
			shooting = {
				pitch = 0.15,
				yaw = 0.15,
			},
			idle = {
				pitch = 0.5,
				yaw = 0.5,
			},
			player_event = {
				pitch = 1.5,
				yaw = 1.5,
			},
		},
		continuous_sway = {
			pitch = 0.3,
			yaw = 0.2,
		},
		immediate_sway = {
			num_shots_clear_time = 0.6,
			crouch_transition = {
				{
					pitch = 0.25,
					yaw = 0.25,
				},
			},
			alternate_fire_start = {
				{
					pitch = 1,
					yaw = 1,
				},
			},
			suppression_hit = {
				{
					pitch = 0.2,
					yaw = 0.2,
				},
			},
			damage_hit = {
				{
					pitch = 0.25,
					yaw = 0.25,
				},
			},
			shooting = {
				{
					pitch = 0.15,
					yaw = 0.1,
				},
				{
					pitch = 0.25,
					yaw = 0.1,
				},
				{
					pitch = 0.275,
					yaw = 0.125,
				},
				{
					pitch = 0.3,
					yaw = 0.15,
				},
				{
					pitch = 0.35,
					yaw = 0.175,
				},
			},
		},
		sway_pattern = default_rippergun_sway_pattern,
	},
	moving = {
		rotation_speed = 0.4,
		inherits = {
			"default_shotgun_killshot",
			"still",
		},
		continuous_sway = {
			pitch = 0.5,
			yaw = 0.4,
		},
		decay = {
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.3,
			shooting = {
				pitch = 0.15,
				yaw = 0.15,
			},
			idle = {
				pitch = 0.5,
				yaw = 0.75,
			},
			player_event = {
				pitch = 3,
				yaw = 3,
			},
		},
	},
	crouch_still = {
		rotation_speed = 0.2,
		inherits = {
			"default_shotgun_killshot",
			"still",
		},
		continuous_sway = {
			pitch = 0.4,
			yaw = 0.15,
		},
		decay = {
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.3,
			shooting = {
				pitch = 0.15,
				yaw = 0.15,
			},
			idle = {
				pitch = 0.5,
				yaw = 0.75,
			},
			player_event = {
				pitch = 3,
				yaw = 3,
			},
		},
	},
	crouch_moving = {
		inherits = {
			"default_shotgun_killshot",
			"still",
		},
		decay = {
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.3,
			shooting = {
				pitch = 0.15,
				yaw = 0.15,
			},
			idle = {
				pitch = 0.5,
				yaw = 0.75,
			},
			player_event = {
				pitch = 3,
				yaw = 3,
			},
		},
	},
}

return {
	base_templates = sway_templates,
	overrides = overrides,
}
