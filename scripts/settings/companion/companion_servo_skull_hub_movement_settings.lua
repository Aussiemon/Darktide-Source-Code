-- chunkname: @scripts/settings/companion/companion_servo_skull_hub_movement_settings.lua

local TWO_PI = math.pi * 2
local companion_servo_skull_hub_movement_settings = {}

companion_servo_skull_hub_movement_settings.z_randomize_movement = {
	base_amp = {
		0.04,
		0.03,
	},
	base_freq = {
		0.15,
		0.15,
	},
	noise_amp = {
		0.015,
		0.02,
	},
	noise_freq = {
		0.05,
		0.05,
	},
	phase = {
		0,
		TWO_PI,
	},
}
companion_servo_skull_hub_movement_settings.movement_settings = {
	cryptic_servo_skull_hack = {
		third_person = {
			max_pitch = 15,
			position = {
				out_of_combat = Vector3Box(0.55, 0.35, 0.1),
				rest = Vector3Box(0.45, 0.45, 0.1),
			},
			position_lerp_multiplier = {
				out_of_combat = {
					rest = 1,
				},
				rest = {
					out_of_combat = 1,
				},
			},
			side_responsiveness = {
				out_of_combat = 6,
				rest = 12,
			},
			rotation_responsiveness = {
				out_of_combat = 6,
				rest = 12,
			},
			pitch_rotation_responsiveness = {
				out_of_combat = 2,
				rest = 2,
			},
			tilt = {
				responsiveness = 7,
				roll_sensitivity = 15,
				max_roll = math.degrees_to_radians(30),
			},
			z_oscillation = table.clone(companion_servo_skull_hub_movement_settings.z_randomize_movement),
		},
	},
	cryptic_servo_skull_flamethrower = {
		third_person = {
			max_pitch = 15,
			position = {
				in_combat = Vector3Box(-0.65, -0.15, -0.15),
				out_of_combat = Vector3Box(-0.65, -0.15, -0.15),
				rest = Vector3Box(-0.45, -0.05, -0.25),
			},
			position_lerp_multiplier = {
				out_of_combat = {
					rest = 1,
				},
				rest = {
					out_of_combat = 1,
				},
			},
			tilt = {
				responsiveness = 7,
				roll_sensitivity = 15,
				max_roll = math.degrees_to_radians(30),
			},
			side_responsiveness = {
				out_of_combat = 6,
				rest = 12,
			},
			rotation_responsiveness = {
				out_of_combat = 6,
				rest = 12,
			},
			pitch_rotation_responsiveness = {
				out_of_combat = 2,
				rest = 2,
			},
			z_oscillation = table.clone(companion_servo_skull_hub_movement_settings.z_randomize_movement),
		},
	},
	cryptic_servo_skull_inject_ally = {
		third_person = {
			max_pitch = 15,
			position = {
				in_combat = Vector3Box(0.65, -0.15, -0.35),
				out_of_combat = Vector3Box(0.65, -0.15, -0.45),
				rest = Vector3Box(0.5, -0.05, -0.35),
			},
			position_lerp_multiplier = {
				out_of_combat = {
					rest = 1,
				},
				rest = {
					out_of_combat = 1,
				},
			},
			tilt = {
				responsiveness = 7,
				roll_sensitivity = 15,
				max_roll = math.degrees_to_radians(30),
			},
			side_responsiveness = {
				out_of_combat = 6,
				rest = 12,
			},
			rotation_responsiveness = {
				out_of_combat = 6,
				rest = 12,
			},
			pitch_rotation_responsiveness = {
				out_of_combat = 2,
				rest = 2,
			},
			z_oscillation = table.clone(companion_servo_skull_hub_movement_settings.z_randomize_movement),
		},
	},
}

return settings("CompanionServoSkullHubMovementSettings", companion_servo_skull_hub_movement_settings)
