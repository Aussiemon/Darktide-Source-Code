-- chunkname: @scripts/settings/companion/companion_servo_skull_movement_settings.lua

local TWO_PI = math.pi * 2
local companion_servo_skull_movement_settings = {}

companion_servo_skull_movement_settings.z_randomize_movement = {
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
companion_servo_skull_movement_settings.movement_settings = {
	cryptic_servo_skull_hack = {
		first_person = {
			max_pitch = 15,
			position = {
				in_combat = Vector3Box(1.25, 1.3, 0.375),
				out_of_combat = Vector3Box(0.65, 0.45, 0.15),
				rest = Vector3Box(0.65, 0.65, 0.2),
			},
			position_lerp_multiplier = {
				in_combat = {
					out_of_combat = 5,
					rest = 5,
				},
				out_of_combat = {
					in_combat = 1,
					rest = 2,
				},
				rest = {
					in_combat = 1,
					out_of_combat = 2,
				},
			},
			side_responsiveness = {
				in_combat = 15,
				out_of_combat = 6,
				rest = 4,
			},
			rotation_responsiveness = {
				in_combat = 7,
				out_of_combat = 4,
				rest = 4,
			},
			pitch_rotation_responsiveness = {
				in_combat = 2,
				out_of_combat = 2,
				rest = 2,
			},
			tilt = {
				responsiveness = 8,
				roll_sensitivity = 30,
				max_roll = math.degrees_to_radians(25),
			},
			z_oscillation = table.clone(companion_servo_skull_movement_settings.z_randomize_movement),
		},
		third_person = {
			max_pitch = 15,
			position = {
				in_combat = Vector3Box(0.55, 0.3, 0.15),
				out_of_combat = Vector3Box(0.55, -0.1, 0.1),
				rest = Vector3Box(0.45, 0.25, 0),
			},
			position_lerp_multiplier = {
				in_combat = {
					out_of_combat = 2,
					rest = 1,
				},
				out_of_combat = {
					in_combat = 2,
					rest = 1,
				},
				rest = {
					in_combat = 1,
					out_of_combat = 1,
				},
			},
			side_responsiveness = {
				in_combat = 9,
				out_of_combat = 6,
				rest = 12,
			},
			rotation_responsiveness = {
				in_combat = 6,
				out_of_combat = 6,
				rest = 12,
			},
			pitch_rotation_responsiveness = {
				in_combat = 2,
				out_of_combat = 2,
				rest = 2,
			},
			tilt = {
				responsiveness = 7,
				roll_sensitivity = 15,
				max_roll = math.degrees_to_radians(30),
			},
			z_oscillation = table.clone(companion_servo_skull_movement_settings.z_randomize_movement),
		},
	},
	cryptic_servo_skull_flamethrower = {
		first_person = {
			max_pitch = 15,
			position = {
				in_combat = Vector3Box(-0.25, -0.15, 0.15),
				out_of_combat = Vector3Box(-0.25, -0.15, 0.15),
				rest = Vector3Box(-0.25, -0.15, 0.15),
			},
			position_lerp_multiplier = {
				in_combat = {
					out_of_combat = 2,
					rest = 0.5,
				},
				out_of_combat = {
					in_combat = 2,
					rest = 0.5,
				},
				rest = {
					in_combat = 0.5,
					out_of_combat = 0.5,
				},
			},
			tilt = {
				responsiveness = 2,
				roll_sensitivity = 7.5,
				max_roll = math.degrees_to_radians(25),
			},
			side_responsiveness = {
				in_combat = 100,
				out_of_combat = 100,
				rest = 100,
			},
			rotation_responsiveness = {
				in_combat = 6,
				out_of_combat = 4,
				rest = 4,
			},
			pitch_rotation_responsiveness = {
				in_combat = 2,
				out_of_combat = 2,
				rest = 2,
			},
			z_oscillation = table.clone(companion_servo_skull_movement_settings.z_randomize_movement),
		},
		third_person = {
			max_pitch = 15,
			position = {
				in_combat = Vector3Box(-0.65, -0.15, -0.25),
				out_of_combat = Vector3Box(-0.65, -0.2, -0.15),
				rest = Vector3Box(-0.55, 0.15, -0.25),
			},
			position_lerp_multiplier = {
				in_combat = {
					out_of_combat = 2,
					rest = 1,
				},
				out_of_combat = {
					in_combat = 2,
					rest = 1,
				},
				rest = {
					in_combat = 1,
					out_of_combat = 1,
				},
			},
			tilt = {
				responsiveness = 7,
				roll_sensitivity = 15,
				max_roll = math.degrees_to_radians(30),
			},
			side_responsiveness = {
				in_combat = 9,
				out_of_combat = 6,
				rest = 12,
			},
			rotation_responsiveness = {
				in_combat = 6,
				out_of_combat = 6,
				rest = 12,
			},
			pitch_rotation_responsiveness = {
				in_combat = 2,
				out_of_combat = 2,
				rest = 2,
			},
			z_oscillation = table.clone(companion_servo_skull_movement_settings.z_randomize_movement),
		},
	},
	cryptic_servo_skull_inject_ally = {
		first_person = {
			max_pitch = 15,
			position = {
				in_combat = Vector3Box(0.25, -0.15, 0.15),
				out_of_combat = Vector3Box(0.25, -0.15, 0.15),
				rest = Vector3Box(0.25, -0.15, 0.15),
			},
			position_lerp_multiplier = {
				in_combat = {
					out_of_combat = 2,
					rest = 0.5,
				},
				out_of_combat = {
					in_combat = 2,
					rest = 0.5,
				},
				rest = {
					in_combat = 0.5,
					out_of_combat = 0.5,
				},
			},
			tilt = {
				responsiveness = 2,
				roll_sensitivity = 7.5,
				max_roll = math.degrees_to_radians(25),
			},
			side_responsiveness = {
				in_combat = 100,
				out_of_combat = 100,
				rest = 100,
			},
			rotation_responsiveness = {
				in_combat = 6,
				out_of_combat = 4,
				rest = 4,
			},
			pitch_rotation_responsiveness = {
				in_combat = 2,
				out_of_combat = 2,
				rest = 2,
			},
			z_oscillation = table.clone(companion_servo_skull_movement_settings.z_randomize_movement),
		},
		third_person = {
			max_pitch = 15,
			position = {
				in_combat = Vector3Box(0.65, -0.05, -0.55),
				out_of_combat = Vector3Box(0.65, -0.25, -0.35),
				rest = Vector3Box(0.55, 0.15, -0.45),
			},
			position_lerp_multiplier = {
				in_combat = {
					out_of_combat = 2,
					rest = 1,
				},
				out_of_combat = {
					in_combat = 2,
					rest = 0.5,
				},
				rest = {
					in_combat = 1,
					out_of_combat = 0.5,
				},
			},
			tilt = {
				responsiveness = 7,
				roll_sensitivity = 15,
				max_roll = math.degrees_to_radians(30),
			},
			side_responsiveness = {
				in_combat = 9,
				out_of_combat = 6,
				rest = 12,
			},
			rotation_responsiveness = {
				in_combat = 6,
				out_of_combat = 6,
				rest = 12,
			},
			pitch_rotation_responsiveness = {
				in_combat = 2,
				out_of_combat = 2,
				rest = 2,
			},
			z_oscillation = table.clone(companion_servo_skull_movement_settings.z_randomize_movement),
		},
	},
}

return settings("CompanionServoSkullMovementSettings", companion_servo_skull_movement_settings)
