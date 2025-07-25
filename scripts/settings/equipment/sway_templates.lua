﻿-- chunkname: @scripts/settings/equipment/sway_templates.lua

local WeaponMovementStateSettings = require("scripts/settings/equipment/weapon_movement_state_settings")
local WeaponTweaks = require("scripts/utilities/weapon_tweaks")
local weapon_movement_states = WeaponMovementStateSettings.weapon_movement_states
local PI = math.pi
local sway_templates = {}
local loaded_template_files = {}

WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/autoguns/settings_templates/autogun_sway_templates", sway_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/bolt_pistols/settings_templates/boltpistol_sway_templates", sway_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/bolters/settings_templates/bolter_sway_templates", sway_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/lasguns/settings_templates/lasgun_sway_templates", sway_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/laspistols/settings_templates/laspistol_sway_templates", sway_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/ogryn_heavystubbers/settings_templates/ogryn_heavystubber_sway_templates", sway_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/ripperguns/settings_templates/rippergun_sway_templates", sway_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/shotguns/settings_templates/shotgun_sway_templates", sway_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/shotpistol_shield/settings_templates/shotpistol_shield_sway_templates", sway_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/stub_pistols/settings_templates/stub_pistol_sway_templates", sway_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/thumpers/settings_templates/thumper_sway_templates", sway_templates, loaded_template_files)

sway_templates.lasgun_zoomed = {
	[weapon_movement_states.still] = {
		horizontal_speed = 1.3,
		intensity = 0.4,
		rotation_speed = 0.5,
		sway_impact = 1.5,
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
				pitch = 1,
				yaw = 1,
			},
		},
		continuous_sway = {
			pitch = 0.125,
			yaw = 0.25,
		},
		immediate_sway = {
			num_shots_clear_time = 0.6,
			crouch_transition = {
				{
					pitch = 2.25,
					yaw = 2.25,
				},
			},
			alternate_fire_start = {
				{
					cap = true,
					pitch = 2,
					yaw = 2,
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
					pitch = 1,
					yaw = 0.75,
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
		sway_pattern = function (dt, t, sway_settings, yaw, pitch)
			local horizontal_speed = sway_settings.horizontal_speed
			local rotation_speed = sway_settings.rotation_speed
			local intensity = sway_settings.intensity
			local max_sway = sway_settings.max_sway
			local pitch_scalar = pitch / max_sway.pitch
			local yaw_scalar = yaw / max_sway.yaw
			local sin_angle = t * PI * horizontal_speed
			local sin_wave = math.sin(sin_angle)
			local new_angle = t * PI * rotation_speed
			local yaw_angle = math.cos(new_angle)
			local pitch_angle = 0.25 * sin_wave * sin_wave + math.sin(3 * new_angle) * (0.5 + 0.5 * (1 - math.abs(yaw_angle * yaw_angle)))
			local aim_offset_y = pitch_angle * pitch_scalar * intensity
			local aim_offset_x = yaw_angle * yaw_scalar * intensity

			return aim_offset_x, aim_offset_y
		end,
	},
	[weapon_movement_states.moving] = {
		rotation_speed = 0.75,
		inherits = {
			"lasgun_zoomed",
			"still",
		},
		continuous_sway = {
			pitch = 0.5,
			yaw = 0.75,
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
				yaw = 0.75,
			},
			player_event = {
				pitch = 3,
				yaw = 3,
			},
		},
	},
	[weapon_movement_states.crouch_still] = {
		rotation_speed = 0.5,
		inherits = {
			"lasgun_zoomed",
			"still",
		},
		continuous_sway = {
			pitch = 0.15,
			yaw = 0.3,
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
	[weapon_movement_states.crouch_moving] = {
		rotation_speed = 0.85,
		inherits = {
			"lasgun_zoomed",
			"still",
		},
		continuous_sway = {
			pitch = 1,
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
		sway_pattern = function (dt, t, sway_settings, yaw, pitch)
			local horizontal_speed = sway_settings.horizontal_speed
			local rotation_speed = sway_settings.rotation_speed
			local intensity = sway_settings.intensity
			local max_sway = sway_settings.max_sway
			local pitch_scalar = pitch / max_sway.pitch
			local yaw_scalar = yaw / max_sway.yaw
			local sin_angle = t * PI * horizontal_speed
			local sin_wave = math.sin(sin_angle)
			local new_angle = t * PI * rotation_speed
			local yaw_angle = math.cos(new_angle)
			local pitch_angle = 0.25 * sin_wave * sin_wave + math.sin(3 * new_angle) * (0.5 + 0.5 * math.abs(yaw_angle * yaw_angle))
			local aim_offset_y = pitch_angle * pitch_scalar * intensity
			local aim_offset_x = yaw_angle * yaw_scalar * intensity

			return aim_offset_x, aim_offset_y
		end,
	},
}
sway_templates.autogun_zoomed = {
	still = {
		horizontal_speed = 1.3,
		intensity = 0.15,
		rotation_speed = 0.5,
		sway_impact = 1.5,
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
				pitch = 1,
				yaw = 1,
			},
		},
		continuous_sway = {
			pitch = 0.125,
			yaw = 0.25,
		},
		immediate_sway = {
			num_shots_clear_time = 0.6,
			crouch_transition = {
				{
					pitch = 2.25,
					yaw = 2.25,
				},
			},
			alternate_fire_start = {
				{
					cap = true,
					pitch = 2,
					yaw = 2,
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
					pitch = 1,
					yaw = 0.75,
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
		sway_pattern = function (dt, t, sway_settings, yaw, pitch)
			local horizontal_speed = sway_settings.horizontal_speed
			local rotation_speed = sway_settings.rotation_speed
			local intensity = sway_settings.intensity
			local max_sway = sway_settings.max_sway
			local pitch_scalar = pitch / max_sway.pitch
			local yaw_scalar = yaw / max_sway.yaw
			local sin_angle = t * PI * horizontal_speed
			local sin_wave = math.sin(sin_angle)
			local new_angle = t * PI * rotation_speed
			local yaw_angle = math.cos(new_angle)
			local pitch_angle = 0.25 * sin_wave * sin_wave + math.sin(3 * new_angle) * (0.5 + 0.5 * (1 - math.abs(yaw_angle * yaw_angle)))
			local aim_offset_y = pitch_angle * pitch_scalar * intensity
			local aim_offset_x = yaw_angle * yaw_scalar * intensity

			return aim_offset_x, aim_offset_y
		end,
	},
	moving = {
		rotation_speed = 0.75,
		inherits = {
			"autogun_zoomed",
			"still",
		},
		continuous_sway = {
			pitch = 0.5,
			yaw = 0.75,
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
				yaw = 0.75,
			},
			player_event = {
				pitch = 3,
				yaw = 3,
			},
		},
	},
	crouch_still = {
		rotation_speed = 0.5,
		inherits = {
			"autogun_zoomed",
			"still",
		},
		continuous_sway = {
			pitch = 0.15,
			yaw = 0.3,
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
		rotation_speed = 0.85,
		inherits = {
			"autogun_zoomed",
			"still",
		},
		continuous_sway = {
			pitch = 1,
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
		sway_pattern = function (dt, t, sway_settings, yaw, pitch)
			local horizontal_speed = sway_settings.horizontal_speed
			local rotation_speed = sway_settings.rotation_speed
			local intensity = sway_settings.intensity
			local max_sway = sway_settings.max_sway
			local pitch_scalar = pitch / max_sway.pitch
			local yaw_scalar = yaw / max_sway.yaw
			local sin_angle = t * PI * horizontal_speed
			local sin_wave = math.sin(sin_angle)
			local new_angle = t * PI * rotation_speed
			local yaw_angle = math.cos(new_angle)
			local pitch_angle = 0.25 * sin_wave * sin_wave + math.sin(3 * new_angle) * (0.5 + 0.5 * math.abs(yaw_angle * yaw_angle))
			local aim_offset_y = pitch_angle * pitch_scalar * intensity
			local aim_offset_x = yaw_angle * yaw_scalar * intensity

			return aim_offset_x, aim_offset_y
		end,
	},
}
sway_templates.autogun_fullauto_zoomed = {
	still = {
		horizontal_speed = 0,
		intensity = 0,
		rotation_speed = 0,
		sway_impact = 0,
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
				pitch = 1,
				yaw = 1,
			},
		},
		continuous_sway = {
			pitch = 0.125,
			yaw = 0.25,
		},
		immediate_sway = {
			num_shots_clear_time = 0.6,
			crouch_transition = {
				{
					pitch = 2.25,
					yaw = 2.25,
				},
			},
			alternate_fire_start = {
				{
					cap = true,
					pitch = 2,
					yaw = 2,
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
					pitch = 1,
					yaw = 0.75,
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
		sway_pattern = function (dt, t, sway_settings, yaw, pitch)
			local horizontal_speed = sway_settings.horizontal_speed
			local rotation_speed = sway_settings.rotation_speed
			local intensity = sway_settings.intensity
			local max_sway = sway_settings.max_sway
			local pitch_scalar = pitch / max_sway.pitch
			local yaw_scalar = yaw / max_sway.yaw
			local sin_angle = t * PI * horizontal_speed
			local sin_wave = math.sin(sin_angle)
			local new_angle = t * PI * rotation_speed
			local yaw_angle = math.cos(new_angle)
			local pitch_angle = 0.25 * sin_wave * sin_wave + math.sin(3 * new_angle) * (0.5 + 0.5 * (1 - math.abs(yaw_angle * yaw_angle)))
			local aim_offset_y = pitch_angle * pitch_scalar * intensity
			local aim_offset_x = yaw_angle * yaw_scalar * intensity

			return aim_offset_x, aim_offset_y
		end,
	},
	moving = {
		rotation_speed = 0.75,
		inherits = {
			"autogun_fullauto_zoomed",
			"still",
		},
		continuous_sway = {
			pitch = 0.5,
			yaw = 0.75,
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
				yaw = 0.75,
			},
			player_event = {
				pitch = 3,
				yaw = 3,
			},
		},
	},
	crouch_still = {
		rotation_speed = 0.5,
		inherits = {
			"autogun_fullauto_zoomed",
			"still",
		},
		continuous_sway = {
			pitch = 0.15,
			yaw = 0.3,
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
		rotation_speed = 0.85,
		inherits = {
			"autogun_fullauto_zoomed",
			"still",
		},
		continuous_sway = {
			pitch = 1,
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
		sway_pattern = function (dt, t, sway_settings, yaw, pitch)
			local horizontal_speed = sway_settings.horizontal_speed
			local rotation_speed = sway_settings.rotation_speed
			local intensity = sway_settings.intensity
			local max_sway = sway_settings.max_sway
			local pitch_scalar = pitch / max_sway.pitch
			local yaw_scalar = yaw / max_sway.yaw
			local sin_angle = t * PI * horizontal_speed
			local sin_wave = math.sin(sin_angle)
			local new_angle = t * PI * rotation_speed
			local yaw_angle = math.cos(new_angle)
			local pitch_angle = 0.25 * sin_wave * sin_wave + math.sin(3 * new_angle) * (0.5 + 0.5 * math.abs(yaw_angle * yaw_angle))
			local aim_offset_y = pitch_angle * pitch_scalar * intensity
			local aim_offset_x = yaw_angle * yaw_scalar * intensity

			return aim_offset_x, aim_offset_y
		end,
	},
}
sway_templates.bolter_alternate_fire = {
	[weapon_movement_states.still] = {
		horizontal_speed = 0.5,
		intensity = 0.4,
		rotation_speed = 0.25,
		sway_impact = 2,
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
		sway_pattern = function (dt, t, sway_settings, yaw, pitch)
			local horizontal_speed = sway_settings.horizontal_speed
			local rotation_speed = sway_settings.rotation_speed
			local intensity = sway_settings.intensity
			local max_sway = sway_settings.max_sway
			local pitch_scalar = pitch / max_sway.pitch
			local yaw_scalar = yaw / max_sway.yaw
			local sin_angle = t * PI * horizontal_speed
			local sin_wave = math.sin(sin_angle)
			local new_angle = t * PI * rotation_speed
			local yaw_angle = math.cos(new_angle)
			local pitch_angle = 0.25 * sin_wave * sin_wave + math.sin(3 * new_angle) * (0.5 + 0.5 * math.abs(yaw_angle * yaw_angle))
			local aim_offset_y = pitch_angle * pitch_scalar * intensity
			local aim_offset_x = yaw_angle * yaw_scalar * intensity

			return aim_offset_x, aim_offset_y
		end,
	},
	[weapon_movement_states.moving] = {
		rotation_speed = 0.4,
		inherits = {
			"bolter_alternate_fire",
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
	[weapon_movement_states.crouch_still] = {
		rotation_speed = 0.2,
		inherits = {
			"bolter_alternate_fire",
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
	[weapon_movement_states.crouch_moving] = {
		rotation_speed = 0.5,
		inherits = {
			"bolter_alternate_fire",
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
sway_templates.shotgun_alternate_fire = {
	[weapon_movement_states.still] = {
		horizontal_speed = 0.5,
		intensity = 0.5,
		rotation_speed = 0.25,
		sway_impact = 2,
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
		sway_pattern = function (dt, t, sway_settings, yaw, pitch)
			local horizontal_speed = sway_settings.horizontal_speed
			local rotation_speed = sway_settings.rotation_speed
			local intensity = sway_settings.intensity
			local max_sway = sway_settings.max_sway
			local pitch_scalar = pitch / max_sway.pitch
			local yaw_scalar = yaw / max_sway.yaw
			local sin_angle = t * PI * horizontal_speed
			local sin_wave = math.sin(sin_angle)
			local new_angle = t * PI * rotation_speed
			local yaw_angle = math.cos(new_angle)
			local pitch_angle = 0.25 * sin_wave * sin_wave + math.sin(3 * new_angle) * (0.5 + 0.5 * math.abs(yaw_angle * yaw_angle))
			local aim_offset_y = pitch_angle * pitch_scalar * intensity
			local aim_offset_x = yaw_angle * yaw_scalar * intensity

			return aim_offset_x, aim_offset_y
		end,
	},
	[weapon_movement_states.moving] = {
		rotation_speed = 0.4,
		inherits = {
			"bolter_alternate_fire",
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
	[weapon_movement_states.crouch_still] = {
		rotation_speed = 0.2,
		inherits = {
			"bolter_alternate_fire",
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
	[weapon_movement_states.crouch_moving] = {
		rotation_speed = 0.5,
		inherits = {
			"bolter_alternate_fire",
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

local function _inherit(move_state_settings, inheritance_settings)
	local new_move_state_settings = table.clone(sway_templates[inheritance_settings[1]][inheritance_settings[2]])

	if new_move_state_settings.inherits then
		new_move_state_settings = _inherit(new_move_state_settings, new_move_state_settings.inherits)
	end

	for key, override_data in pairs(move_state_settings) do
		new_move_state_settings[key] = override_data
	end

	new_move_state_settings.inherits = nil

	return new_move_state_settings
end

local _immediate_sway_types = {
	"suppression_hit",
	"damage_hit",
	"shooting",
	"alternate_fire_start",
	"crouch_transition",
}

for name, template in pairs(sway_templates) do
	for _, movement_state in pairs(weapon_movement_states) do
		local move_state_settings = template[movement_state]
		local inheritance_settings = move_state_settings.inherits

		if inheritance_settings then
			local new_move_state_settings = _inherit(move_state_settings, inheritance_settings)

			sway_templates[name][movement_state] = new_move_state_settings
			move_state_settings = new_move_state_settings
		end

		for _, immediate_sway_type in ipairs(_immediate_sway_types) do
			local immediate_sway_settings = move_state_settings.immediate_sway[immediate_sway_type]

			if immediate_sway_settings then
				for i, entry in ipairs(immediate_sway_settings) do
					move_state_settings.immediate_sway[immediate_sway_type].num_sway_values = #move_state_settings.immediate_sway[immediate_sway_type]
				end
			end
		end
	end
end

return settings("SwayTemplates", sway_templates)
