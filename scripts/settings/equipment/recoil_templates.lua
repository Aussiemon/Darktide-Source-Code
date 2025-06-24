-- chunkname: @scripts/settings/equipment/recoil_templates.lua

local RecoilTemplate = require("scripts/utilities/recoil_template")
local WeaponMovementStateSettings = require("scripts/settings/equipment/weapon_movement_state_settings")
local WeaponTweaks = require("scripts/utilities/weapon_tweaks")
local AIM_ASSIST_MULTIPLIER_FUNCTIONS = RecoilTemplate.AIM_ASSIST_MULTIPLIER_FUNCTIONS
local weapon_movement_states = WeaponMovementStateSettings.weapon_movement_states
local recoil_templates = {}
local loaded_template_files = {}

WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/autoguns/settings_templates/autogun_recoil_templates", recoil_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/autopistols/settings_templates/autopistol_recoil_templates", recoil_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/bolt_pistols/settings_templates/boltpistol_recoil_templates", recoil_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/bolters/settings_templates/bolter_recoil_templates", recoil_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/flamers/settings_templates/flamer_recoil_templates", recoil_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/grenadier_gauntlets/settings_templates/grenadier_gauntlet_recoil_templates", recoil_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/lasguns/settings_templates/lasgun_recoil_templates", recoil_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/laspistols/settings_templates/laspistol_recoil_templates", recoil_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/ogryn_heavystubbers/settings_templates/ogryn_heavystubber_recoil_templates", recoil_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/plasma_rifles/settings_templates/plasma_rifle_recoil_templates", recoil_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/ripperguns/settings_templates/rippergun_recoil_templates", recoil_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/shotguns/settings_templates/shotgun_recoil_templates", recoil_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/shotpistol_shield/settings_templates/shotpistol_shield_recoil_templates", recoil_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/stub_pistols/settings_templates/stub_pistol_recoil_templates", recoil_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/thumpers/settings_templates/thumper_recoil_templates", recoil_templates, loaded_template_files)

recoil_templates.lasgun = {
	[weapon_movement_states.still] = {
		new_influence_percent = 0.25,
		rise_duration = 0.05,
		rise = {
			0.15,
			0.15,
			0.175,
			0.2,
			0.175,
			0.15,
			0.1,
			0.05,
		},
		decay = {
			idle = 2,
			shooting = 1,
		},
		offset_range = {
			{
				pitch = {
					0.06,
					0.06,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.06,
					0.06,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.06,
					0.06,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.05,
					0.05,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.06,
					0.07,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.07,
					0.08,
				},
				yaw = {
					-0.03,
					0.02,
				},
			},
			{
				pitch = {
					0.06,
					0.08,
				},
				yaw = {
					-0.04,
					0.02,
				},
			},
			{
				pitch = {
					0.05,
					0.07,
				},
				yaw = {
					-0.07,
					0.01,
				},
			},
			{
				pitch = {
					0.03,
					0.05,
				},
				yaw = {
					-0.06,
					0.01,
				},
			},
			{
				pitch = {
					0.015,
					0.03,
				},
				yaw = {
					-0.05,
					0.01,
				},
			},
		},
		offset_limit = {
			pitch = 2,
			yaw = 2,
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness,
		},
	},
	[weapon_movement_states.moving] = {
		new_influence_percent = 0.1,
		inherits = {
			"lasgun",
			"still",
		},
	},
	[weapon_movement_states.crouch_still] = {
		new_influence_percent = 0.04,
		inherits = {
			"lasgun",
			"still",
		},
	},
	[weapon_movement_states.crouch_moving] = {
		new_influence_percent = 0.08,
		inherits = {
			"lasgun",
			"still",
		},
	},
}
recoil_templates.autogun = {
	[weapon_movement_states.still] = {
		decay_grace = 0.05,
		new_influence_percent = 0.5,
		rise_duration = 0.05,
		rise = {
			0.25,
			0.135,
			0.135,
			0.05,
			0.15,
			0.15,
			0.165,
			0.175,
			0.175,
			0.2,
			0.2,
			0.2,
		},
		decay = {
			idle = 4,
			shooting = 1,
		},
		offset_range = {
			{
				pitch = {
					0.05,
					0.06,
				},
				yaw = {
					-0.025,
					0.025,
				},
			},
			{
				pitch = {
					0.05,
					0.07,
				},
				yaw = {
					-0.0225,
					0.0225,
				},
			},
			{
				pitch = {
					0.05,
					0.08,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.06,
					0.07,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.06,
					0.06,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.06,
					0.07,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.05,
					0.07,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.05,
					0.07,
				},
				yaw = {
					-0.03,
					0.02,
				},
			},
			{
				pitch = {
					0.05,
					0.07,
				},
				yaw = {
					-0.04,
					0.02,
				},
			},
			{
				pitch = {
					0.05,
					0.07,
				},
				yaw = {
					-0.04,
					0.02,
				},
			},
		},
		offset_limit = {
			pitch = 2,
			yaw = 2,
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness,
		},
	},
	[weapon_movement_states.moving] = {
		new_influence_percent = 0.55,
		inherits = {
			"autogun",
			"still",
		},
	},
	[weapon_movement_states.crouch_still] = {
		new_influence_percent = 0.25,
		inherits = {
			"autogun",
			"still",
		},
	},
	[weapon_movement_states.crouch_moving] = {
		new_influence_percent = 0.4,
		inherits = {
			"autogun",
			"still",
		},
	},
}

local pitch_default = 0.02

recoil_templates.autogun_zoomed = {
	still = {
		camera_recoil_percentage = 0.5,
		new_influence_percent = 0.5,
		rise_duration = 0.075,
		rise = {
			1,
			0.7,
		},
		decay = {
			idle = 1.5,
			shooting = 0,
		},
		offset_range = {
			{
				pitch = {
					pitch_default * 0.95,
					pitch_default * 1.05,
				},
				yaw = {
					-0.0075,
					0.0075,
				},
			},
			{
				pitch = {
					pitch_default * 0.85,
					pitch_default * 1.15,
				},
				yaw = {
					-0.0085,
					0.0085,
				},
			},
			{
				pitch = {
					pitch_default * 0.75,
					pitch_default * 1.25,
				},
				yaw = {
					-0.01,
					0.01,
				},
			},
			{
				pitch = {
					pitch_default * 0.75,
					pitch_default * 1.25,
				},
				yaw = {
					-0.01,
					0.01,
				},
			},
			{
				pitch = {
					pitch_default * 0.75,
					pitch_default * 1.25,
				},
				yaw = {
					-0.01,
					0.01,
				},
			},
			{
				pitch = {
					pitch_default * 0.75,
					pitch_default * 1.25,
				},
				yaw = {
					-0.015,
					0.015,
				},
			},
			{
				pitch = {
					pitch_default * 0.75,
					pitch_default * 1.25,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					pitch_default * 0.75,
					pitch_default * 1.25,
				},
				yaw = {
					-0.025,
					0.025,
				},
			},
		},
		offset_limit = {
			pitch = 0.15,
			yaw = 0.5,
		},
		aim_assist = {
			reduction_per_shot = 0.25,
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.flat_reduction_per_shot,
		},
		visual_recoil_settings = {
			intensity = 5,
			lerp_scalar = 1,
		},
	},
	moving = {
		new_influence_percent = 0.4,
		inherits = {
			"autogun_zoomed",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"autogun_zoomed",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"autogun_zoomed",
			"still",
		},
	},
}
pitch_default = 0.075
recoil_templates.autogun_killshot_zoomed = {
	still = {
		camera_recoil_percentage = 0.5,
		new_influence_percent = 0.5,
		rise_duration = 0.05,
		rise = {
			1,
			0.7,
		},
		decay = {
			idle = 2,
			shooting = 1,
		},
		offset_range = {
			{
				pitch = {
					pitch_default * 0.95,
					pitch_default * 1.05,
				},
				yaw = {
					-0.0075,
					0.0075,
				},
			},
			{
				pitch = {
					pitch_default * 0.85,
					pitch_default * 1.15,
				},
				yaw = {
					-0.0085,
					0.0085,
				},
			},
			{
				pitch = {
					pitch_default * 0.75,
					pitch_default * 1.25,
				},
				yaw = {
					-0.01,
					0.01,
				},
			},
			{
				pitch = {
					pitch_default * 0.75,
					pitch_default * 1.25,
				},
				yaw = {
					-0.01,
					0.01,
				},
			},
			{
				pitch = {
					pitch_default * 0.75,
					pitch_default * 1.25,
				},
				yaw = {
					-0.01,
					0.01,
				},
			},
			{
				pitch = {
					pitch_default * 0.75,
					pitch_default * 1.25,
				},
				yaw = {
					-0.015,
					0.015,
				},
			},
			{
				pitch = {
					pitch_default * 0.75,
					pitch_default * 1.25,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					pitch_default * 0.75,
					pitch_default * 1.25,
				},
				yaw = {
					-0.025,
					0.025,
				},
			},
		},
		offset_limit = {
			pitch = 0.15,
			yaw = 0.5,
		},
		aim_assist = {
			reduction_per_shot = 0.25,
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.flat_reduction_per_shot,
		},
		visual_recoil_settings = {
			intensity = 3,
			lerp_scalar = 1,
		},
	},
	moving = {
		new_influence_percent = 0.4,
		inherits = {
			"autogun_killshot_zoomed",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"autogun_killshot_zoomed",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"autogun_killshot_zoomed",
			"still",
		},
	},
}
pitch_default = 0.15
recoil_templates.autogun_killshot_hip = {
	still = {
		camera_recoil_percentage = 0.85,
		new_influence_percent = 0.5,
		rise_duration = 0.05,
		rise = {
			0.5,
			0.7,
		},
		decay = {
			idle = 2,
			shooting = 1,
		},
		offset_range = {
			{
				pitch = {
					pitch_default * 0.95,
					pitch_default * 1.05,
				},
				yaw = {
					-0.15,
					0.15,
				},
			},
			{
				pitch = {
					pitch_default * 0.85,
					pitch_default * 1.15,
				},
				yaw = {
					-0.13,
					0.13,
				},
			},
			{
				pitch = {
					pitch_default * 0.75,
					pitch_default * 1.25,
				},
				yaw = {
					-0.01,
					0.01,
				},
			},
			{
				pitch = {
					pitch_default * 0.75,
					pitch_default * 1.25,
				},
				yaw = {
					-0.01,
					0.01,
				},
			},
			{
				pitch = {
					pitch_default * 0.75,
					pitch_default * 1.25,
				},
				yaw = {
					-0.01,
					0.01,
				},
			},
			{
				pitch = {
					pitch_default * 0.75,
					pitch_default * 1.25,
				},
				yaw = {
					-0.015,
					0.015,
				},
			},
			{
				pitch = {
					pitch_default * 0.75,
					pitch_default * 1.25,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					pitch_default * 0.75,
					pitch_default * 1.25,
				},
				yaw = {
					-0.025,
					0.025,
				},
			},
		},
		offset_limit = {
			pitch = 0.15,
			yaw = 0.5,
		},
		aim_assist = {
			reduction_per_shot = 0.25,
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.flat_reduction_per_shot,
		},
		visual_recoil_settings = {
			intensity = 1,
			lerp_scalar = 1,
		},
	},
	moving = {
		new_influence_percent = 0.4,
		inherits = {
			"autogun_killshot_hip",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"autogun_killshot_hip",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"autogun_killshot_hip",
			"still",
		},
	},
}
recoil_templates.autopistol = {
	[weapon_movement_states.still] = {
		decay_grace = 0,
		new_influence_percent = 0.5,
		rise_duration = 0.05,
		rise = {
			0.4,
			0.05,
			0.05,
			0.075,
			0.1,
			0.075,
			0.05,
			0.025,
			0.01,
		},
		decay = {
			idle = 4,
			shooting = 1.5,
		},
		offset_range = {
			{
				pitch = {
					0.05,
					0.06,
				},
				yaw = {
					-0.025,
					0.025,
				},
			},
			{
				pitch = {
					0.05,
					0.07,
				},
				yaw = {
					-0.0225,
					0.0225,
				},
			},
			{
				pitch = {
					0.05,
					0.08,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.06,
					0.07,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.06,
					0.06,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.06,
					0.07,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.05,
					0.07,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.05,
					0.07,
				},
				yaw = {
					-0.03,
					0.02,
				},
			},
			{
				pitch = {
					0.05,
					0.07,
				},
				yaw = {
					-0.04,
					0.02,
				},
			},
			{
				pitch = {
					0.05,
					0.07,
				},
				yaw = {
					-0.04,
					0.02,
				},
			},
		},
		offset_limit = {
			pitch = 0.75,
			yaw = 0.75,
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness,
		},
	},
	[weapon_movement_states.moving] = {
		new_influence_percent = 0.55,
		inherits = {
			"autopistol",
			"still",
		},
	},
	[weapon_movement_states.crouch_still] = {
		new_influence_percent = 0.25,
		inherits = {
			"autopistol",
			"still",
		},
	},
	[weapon_movement_states.crouch_moving] = {
		new_influence_percent = 0.4,
		inherits = {
			"autopistol",
			"still",
		},
	},
}
recoil_templates.laspistol_assault = {
	[weapon_movement_states.still] = {
		decay_grace = 0.05,
		new_influence_percent = 0.6,
		rise_duration = 0.1,
		rise = {
			0.35,
			0.3,
			0.4,
			0.5,
		},
		decay = {
			idle = 2,
			shooting = 0.5,
		},
		offset_range = {
			{
				pitch = {
					0.075,
					0.075,
				},
				yaw = {
					-0,
					0,
				},
			},
			{
				pitch = {
					0.075,
					0.075,
				},
				yaw = {
					-0.01,
					0.01,
				},
			},
			{
				pitch = {
					0.065,
					0.085,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.05,
					0.075,
				},
				yaw = {
					-0.03,
					0.03,
				},
			},
		},
		offset_limit = {
			pitch = 1,
			yaw = 1,
		},
	},
	[weapon_movement_states.moving] = {
		new_influence_percent = 0.65,
		inherits = {
			"laspistol_assault",
			"still",
		},
	},
	[weapon_movement_states.crouch_still] = {
		new_influence_percent = 0.5,
		inherits = {
			"laspistol_assault",
			"still",
		},
	},
	[weapon_movement_states.crouch_moving] = {
		new_influence_percent = 0.5,
		inherits = {
			"laspistol_assault",
			"still",
		},
	},
}
recoil_templates.laspistol_aim_killshot = {
	[weapon_movement_states.still] = {
		decay_grace = 0.05,
		new_influence_percent = 0.75,
		rise_duration = 0.05,
		rise = {
			0.6,
			0.55,
			0.5,
			0.45,
			0.4,
			0.35,
		},
		decay = {
			idle = 2.5,
			shooting = 0.5,
		},
		offset_range = {
			{
				pitch = {
					0.075,
					0.075,
				},
				yaw = {
					-0,
					0,
				},
			},
			{
				pitch = {
					0.08,
					0.08,
				},
				yaw = {
					-0.01,
					0.01,
				},
			},
			{
				pitch = {
					0.075,
					0.085,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.06,
					0.09,
				},
				yaw = {
					-0.03,
					0.03,
				},
			},
		},
		offset_limit = {
			pitch = 2,
			yaw = 2,
		},
	},
	[weapon_movement_states.moving] = {
		new_influence_percent = 0.75,
		inherits = {
			"laspistol_aim_killshot",
			"still",
		},
	},
	[weapon_movement_states.crouch_still] = {
		new_influence_percent = 0.6,
		inherits = {
			"laspistol_aim_killshot",
			"still",
		},
	},
	[weapon_movement_states.crouch_moving] = {
		new_influence_percent = 0.8,
		inherits = {
			"laspistol_aim_killshot",
			"still",
		},
	},
}
recoil_templates.lasgun_brace = {
	[weapon_movement_states.still] = {
		new_influence_percent = 0.1,
		rise_duration = 0.075,
		rise = {
			0.5,
			0.35,
			0.275,
			0.2,
			0.1,
		},
		decay = {
			idle = 1.75,
			shooting = 1,
		},
		offset_range = {
			{
				pitch = {
					0.1,
					0.125,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.075,
					0.1,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.05,
					0.075,
				},
				yaw = {
					-0.03,
					0.03,
				},
			},
			{
				pitch = {
					0.02,
					0.04,
				},
				yaw = {
					-0.03,
					0.03,
				},
			},
		},
		offset_limit = {
			pitch = 2,
			yaw = 2,
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness,
		},
	},
	[weapon_movement_states.moving] = {
		new_influence_percent = 0.05,
		inherits = {
			"lasgun_brace",
			"still",
		},
		rise = {
			0.5,
			0.35,
			0.275,
			0.2,
		},
	},
	[weapon_movement_states.crouch_still] = {
		new_influence_percent = 0.04,
		inherits = {
			"lasgun_brace",
			"still",
		},
	},
	[weapon_movement_states.crouch_moving] = {
		new_influence_percent = 0.08,
		inherits = {
			"lasgun_brace",
			"still",
		},
	},
}
recoil_templates.rippergun_hip = {
	[weapon_movement_states.still] = {
		camera_recoil_percentage = 0.5,
		new_influence_percent = 0.75,
		rise_duration = 0.075,
		rise = {
			0.75,
		},
		decay = {
			idle = 1.75,
			shooting = 0.25,
		},
		offset_range = {
			{
				pitch = {
					0.1,
					0.125,
				},
				yaw = {
					-0.1,
					0.1,
				},
			},
		},
		offset_limit = {
			pitch = 2,
			yaw = 1,
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness,
		},
		visual_recoil_settings = {
			intensity = 1,
			lerp_scalar = 1,
		},
	},
	[weapon_movement_states.moving] = {
		new_influence_percent = 1,
		inherits = {
			"rippergun_hip",
			"still",
		},
	},
	[weapon_movement_states.crouch_still] = {
		new_influence_percent = 0.75,
		inherits = {
			"rippergun_hip",
			"still",
		},
	},
	[weapon_movement_states.crouch_moving] = {
		new_influence_percent = 0.85,
		inherits = {
			"rippergun_hip",
			"still",
		},
	},
}
recoil_templates.rippergun_braced = {
	[weapon_movement_states.still] = {
		camera_recoil_percentage = 0.25,
		new_influence_percent = 0.35,
		rise_duration = 0.125,
		rise = {
			0.75,
			0.35,
			0.275,
			0.225,
			0.2,
			0.15,
			0.1,
		},
		decay = {
			idle = 1.75,
			shooting = 1,
		},
		offset_range = {
			{
				pitch = {
					0.02,
					0.022,
				},
				yaw = {
					-0.005,
					0.01,
				},
			},
		},
		offset_limit = {
			pitch = 2,
			yaw = 2,
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness,
		},
		visual_recoil_settings = {
			intensity = 0.25,
			lerp_scalar = 1,
		},
	},
	[weapon_movement_states.moving] = {
		new_influence_percent = 0.35,
		inherits = {
			"rippergun_braced",
			"still",
		},
		rise = {
			0.5,
			0.35,
			0.275,
			0.2,
		},
	},
	[weapon_movement_states.crouch_still] = {
		new_influence_percent = 0.3,
		inherits = {
			"rippergun_braced",
			"still",
		},
	},
	[weapon_movement_states.crouch_moving] = {
		new_influence_percent = 0.35,
		inherits = {
			"rippergun_braced",
			"still",
		},
	},
}
recoil_templates.lasgun_brace_light = {
	[weapon_movement_states.still] = {
		camera_recoil_percentage = 0.4,
		new_influence_percent = 0.15,
		rise_duration = 0.075,
		rise = {
			0.5,
			0.2,
			0.15,
		},
		decay = {
			idle = 1.25,
			shooting = 1,
		},
		offset_range = {
			{
				pitch = {
					0.1,
					0.125,
				},
				yaw = {
					-0.01,
					0.01,
				},
			},
			{
				pitch = {
					0.075,
					0.1,
				},
				yaw = {
					-0.011,
					0.011,
				},
			},
			{
				pitch = {
					0.05,
					0.075,
				},
				yaw = {
					-0.015,
					0.015,
				},
			},
			{
				pitch = {
					0.02,
					0.04,
				},
				yaw = {
					-0.0175,
					0.0175,
				},
			},
			{
				pitch = {
					0.015,
					0.03,
				},
				yaw = {
					-0.0175,
					0.0175,
				},
			},
			{
				pitch = {
					0.0125,
					0.025,
				},
				yaw = {
					-0.0175,
					0.0175,
				},
			},
			{
				pitch = {
					0.01,
					0.02,
				},
				yaw = {
					-0.0175,
					0.0175,
				},
			},
			{
				pitch = {
					0.0075,
					0.0125,
				},
				yaw = {
					-0.0175,
					0.0175,
				},
			},
		},
		offset_limit = {
			pitch = 1,
			yaw = 1,
		},
		visual_recoil_settings = {
			intensity = 20,
			lerp_scalar = 0.1,
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness,
		},
	},
	[weapon_movement_states.moving] = {
		new_influence_percent = 0.25,
		inherits = {
			"lasgun_brace_light",
			"still",
		},
		rise = {
			0.5,
			0.35,
			0.275,
			0.2,
			0.15,
			0.075,
		},
	},
	[weapon_movement_states.crouch_still] = {
		new_influence_percent = 0.1,
		inherits = {
			"lasgun_brace_light",
			"still",
		},
	},
	[weapon_movement_states.crouch_moving] = {
		new_influence_percent = 0.2,
		inherits = {
			"lasgun_brace_light",
			"still",
		},
	},
}
recoil_templates.autogun_brace = {
	[weapon_movement_states.still] = {
		decay_grace = 0.05,
		new_influence_percent = 0.25,
		rise_duration = 0.05,
		rise = {
			0.4,
			0.1,
			0.1,
			0.1,
			0.2,
		},
		decay = {
			idle = 2.5,
			shooting = 1,
		},
		offset_range = {
			{
				pitch = {
					0.05,
					0.05,
				},
				yaw = {
					-0.01,
					0.01,
				},
			},
			{
				pitch = {
					0.065,
					0.065,
				},
				yaw = {
					-0.0125,
					0.0125,
				},
			},
			{
				pitch = {
					0.05,
					0.075,
				},
				yaw = {
					-0.015,
					0.015,
				},
			},
			{
				pitch = {
					0.05,
					0.075,
				},
				yaw = {
					-0.0175,
					0.0175,
				},
			},
			{
				pitch = {
					0.02,
					0.03,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.01,
					0.02,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.01,
					0.02,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.01,
					0.02,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0,
					0.02,
				},
				yaw = {
					-0.0225,
					0.0225,
				},
			},
		},
		offset_limit = {
			pitch = 2,
			yaw = 2,
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness,
		},
	},
	[weapon_movement_states.moving] = {
		new_influence_percent = 0.25,
		inherits = {
			"autogun_brace",
			"still",
		},
	},
	[weapon_movement_states.crouch_still] = {
		new_influence_percent = 0.25,
		inherits = {
			"autogun_brace",
			"still",
		},
	},
	[weapon_movement_states.crouch_moving] = {
		new_influence_percent = 0.25,
		inherits = {
			"autogun_brace",
			"still",
		},
	},
}
recoil_templates.shotgun_hip_assault = {
	[weapon_movement_states.still] = {
		camera_recoil_percentage = 0.65,
		new_influence_percent = 0.6,
		rise_duration = 0.05,
		rise = {
			0.75,
		},
		decay = {
			idle = 1,
			shooting = 0.25,
		},
		offset_range = {
			{
				pitch = {
					0.2,
					0.2,
				},
				yaw = {
					-0,
					0,
				},
			},
			{
				pitch = {
					0.175,
					0.175,
				},
				yaw = {
					-0,
					0,
				},
			},
			{
				pitch = {
					0.25,
					0.3,
				},
				yaw = {
					-0.01,
					0.02,
				},
			},
			{
				pitch = {
					0.15,
					0.175,
				},
				yaw = {
					-0.03,
					0.03,
				},
			},
			{
				pitch = {
					0.125,
					0.15,
				},
				yaw = {
					-0.04,
					0.04,
				},
			},
			{
				pitch = {
					0.1,
					0.125,
				},
				yaw = {
					-0.04,
					0.04,
				},
			},
		},
		offset_limit = {
			pitch = 2,
			yaw = 2,
		},
		visual_recoil_settings = {
			intensity = 12,
			lerp_scalar = 1,
		},
	},
	[weapon_movement_states.moving] = {
		new_influence_percent = 0.7,
		inherits = {
			"shotgun_hip_assault",
			"still",
		},
	},
	[weapon_movement_states.crouch_still] = {
		new_influence_percent = 0.4,
		inherits = {
			"shotgun_hip_assault",
			"still",
		},
	},
	[weapon_movement_states.crouch_moving] = {
		new_influence_percent = 0.45,
		inherits = {
			"shotgun_hip_assault",
			"still",
		},
	},
}
recoil_templates.lasgun_hip_killshot = {
	[weapon_movement_states.still] = {
		new_influence_percent = 0.3,
		rise_duration = 0.075,
		rise = {
			0.3,
			0.3,
			0.25,
		},
		decay = {
			idle = 1.75,
			shooting = 0.75,
		},
		offset_range = {
			{
				pitch = {
					0.2,
					0.2,
				},
				yaw = {
					-0,
					0,
				},
			},
			{
				pitch = {
					0.175,
					0.175,
				},
				yaw = {
					-0,
					0,
				},
			},
			{
				pitch = {
					0.25,
					0.3,
				},
				yaw = {
					-0.01,
					0.02,
				},
			},
			{
				pitch = {
					0.15,
					0.175,
				},
				yaw = {
					-0.03,
					0.03,
				},
			},
			{
				pitch = {
					0.125,
					0.15,
				},
				yaw = {
					-0.04,
					0.04,
				},
			},
			{
				pitch = {
					0.1,
					0.125,
				},
				yaw = {
					-0.04,
					0.04,
				},
			},
		},
		offset_limit = {
			pitch = 2,
			yaw = 2,
		},
	},
	[weapon_movement_states.moving] = {
		new_influence_percent = 0.6,
		inherits = {
			"lasgun_hip_killshot",
			"still",
		},
	},
	[weapon_movement_states.crouch_still] = {
		new_influence_percent = 0.4,
		inherits = {
			"lasgun_hip_killshot",
			"still",
		},
	},
	[weapon_movement_states.crouch_moving] = {
		new_influence_percent = 0.45,
		inherits = {
			"lasgun_hip_killshot",
			"still",
		},
	},
}

local pitch_default = 0.1

recoil_templates.lasgun_hip_assault = {
	[weapon_movement_states.still] = {
		new_influence_percent = 0.75,
		rise_duration = 0.1,
		rise = {
			0.4,
			0.2,
		},
		decay = {
			idle = 2,
			shooting = 0,
		},
		offset_range = {
			{
				pitch = {
					pitch_default,
					pitch_default,
				},
				yaw = {
					0,
					0,
				},
			},
			{
				pitch = {
					pitch_default,
					pitch_default,
				},
				yaw = {
					0,
					0,
				},
			},
			{
				pitch = {
					pitch_default,
					pitch_default,
				},
				yaw = {
					0,
					0,
				},
			},
			{
				pitch = {
					pitch_default * 0.9,
					pitch_default * 1.1,
				},
				yaw = {
					-0.01,
					0.01,
				},
			},
			{
				pitch = {
					pitch_default * 0.8,
					pitch_default * 1.2,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					pitch_default * 0.7,
					pitch_default * 1.2,
				},
				yaw = {
					-0.03,
					0.03,
				},
			},
			{
				pitch = {
					pitch_default * 0.6,
					pitch_default * 1.3,
				},
				yaw = {
					-0.04,
					0.04,
				},
			},
			{
				pitch = {
					pitch_default * 0.5,
					pitch_default * 1.5,
				},
				yaw = {
					-0.05,
					0.05,
				},
			},
		},
		hit_offset_multiplier = {
			afro_hit = 1.05,
			damage_hit = 1.8,
			fortitude_hit = 1.2,
			grace_hit = 1.1,
		},
		offset_limit = {
			pitch = 0.4,
			profile = "linear",
			yaw = 0.4,
		},
	},
	[weapon_movement_states.moving] = {
		new_influence_percent = 0.85,
		inherits = {
			"lasgun_hip_assault",
			"still",
		},
	},
	[weapon_movement_states.crouch_still] = {
		new_influence_percent = 0.4,
		inherits = {
			"lasgun_hip_assault",
			"still",
		},
	},
	[weapon_movement_states.crouch_moving] = {
		new_influence_percent = 0.45,
		inherits = {
			"lasgun_hip_assault",
			"still",
		},
	},
}
pitch_default = 0.02
recoil_templates.lasgun_zoomed = {
	[weapon_movement_states.still] = {
		camera_recoil_percentage = 1,
		new_influence_percent = 0.5,
		rise_duration = 0.125,
		rise = {
			1,
			0.7,
		},
		decay = {
			idle = 1.5,
			shooting = 0,
		},
		offset_range = {
			{
				pitch = {
					pitch_default * 0.95,
					pitch_default * 1.05,
				},
				yaw = {
					-0.0075,
					0.0075,
				},
			},
			{
				pitch = {
					pitch_default * 0.85,
					pitch_default * 1.15,
				},
				yaw = {
					-0.0085,
					0.0085,
				},
			},
			{
				pitch = {
					pitch_default * 0.75,
					pitch_default * 1.25,
				},
				yaw = {
					-0.01,
					0.01,
				},
			},
		},
		offset_limit = {
			pitch = 0.15,
			yaw = 0.15,
		},
		aim_assist = {
			reduction_per_shot = 0.25,
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.flat_reduction_per_shot,
		},
		visual_recoil_settings = {
			intensity = 12,
			lerp_scalar = 1,
		},
	},
	[weapon_movement_states.moving] = {
		new_influence_percent = 0.4,
		inherits = {
			"lasgun_zoomed",
			"still",
		},
	},
	[weapon_movement_states.crouch_still] = {
		inherits = {
			"lasgun_zoomed",
			"still",
		},
	},
	[weapon_movement_states.crouch_moving] = {
		inherits = {
			"lasgun_zoomed",
			"still",
		},
	},
}
recoil_templates.lasgun_zoomed_2 = table.clone(recoil_templates.lasgun_zoomed)
recoil_templates.lasgun_zoomed_2.still.offset_range = {
	{
		pitch = {
			pitch_default,
			pitch_default,
		},
		yaw = {
			0,
			0,
		},
	},
	{
		pitch = {
			pitch_default,
			pitch_default,
		},
		yaw = {
			0,
			0,
		},
	},
	{
		pitch = {
			pitch_default * 0.95,
			pitch_default * 1.05,
		},
		yaw = {
			-0.01,
			0.01,
		},
	},
	{
		pitch = {
			pitch_default * 0.85,
			pitch_default * 1.15,
		},
		yaw = {
			-0.0125,
			0.0125,
		},
	},
	{
		pitch = {
			pitch_default * 0.75,
			pitch_default * 1.25,
		},
		yaw = {
			-0.015,
			0.015,
		},
	},
}
recoil_templates.lasgun_zoomed_1 = table.clone(recoil_templates.lasgun_zoomed)
recoil_templates.lasgun_zoomed_1.still.rise = {
	0.75,
	0.5,
}
recoil_templates.lasgun_zoomed_1.still.new_influence_percent = 0.175
recoil_templates.lasgun_zoomed_1.moving.new_influence_percent = 0.35
recoil_templates.lasgun_zoomed_medium = {
	[weapon_movement_states.still] = {
		new_influence_percent = 0.65,
		rise_duration = 0.095,
		rise = {
			0.3,
			0.25,
		},
		decay = {
			idle = 0.8,
			shooting = 0,
		},
		offset_range = {
			{
				pitch = {
					0.15,
					0.15,
				},
				yaw = {
					-0,
					0,
				},
			},
			{
				pitch = {
					0.15,
					0.15,
				},
				yaw = {
					-0,
					0,
				},
			},
			{
				pitch = {
					0.125,
					0.125,
				},
				yaw = {
					-0.01,
					0.01,
				},
			},
			{
				pitch = {
					0.125,
					0.15,
				},
				yaw = {
					-0.01,
					0.03,
				},
			},
			{
				pitch = {
					0.125,
					0.15,
				},
				yaw = {
					-0.01,
					0.03,
				},
			},
			{
				pitch = {
					0.125,
					0.15,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.1,
					0.15,
				},
				yaw = {
					-0.03,
					0.03,
				},
			},
		},
		offset_limit = {
			pitch = 50,
			yaw = 50,
		},
		visual_recoil_settings = {
			intensity = 10,
			lerp_scalar = 0.2,
		},
	},
	[weapon_movement_states.moving] = {
		new_influence_percent = 1,
		inherits = {
			"lasgun_zoomed_medium",
			"still",
		},
	},
	[weapon_movement_states.crouch_still] = {
		inherits = {
			"lasgun_zoomed_medium",
			"still",
		},
	},
	[weapon_movement_states.crouch_moving] = {
		inherits = {
			"lasgun_zoomed_medium",
			"still",
		},
	},
}
recoil_templates.bolter_alternate_fire_medium = {
	[weapon_movement_states.still] = {
		camera_recoil_percentage = 0.4,
		new_influence_percent = 0.65,
		rise_duration = 0.05,
		rise = {
			0.5,
		},
		decay = {
			idle = 1.8,
			shooting = 0.25,
		},
		offset_range = {
			{
				pitch = {
					0.25,
					0.3,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.125,
					0.15,
				},
				yaw = {
					-0.01,
					0.03,
				},
			},
			{
				pitch = {
					0.125,
					0.15,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.1,
					0.15,
				},
				yaw = {
					-0.03,
					0.03,
				},
			},
		},
		offset_limit = {
			pitch = 50,
			yaw = 50,
		},
		visual_recoil_settings = {
			intensity = 10,
			lerp_scalar = 1,
		},
	},
	[weapon_movement_states.moving] = {
		new_influence_percent = 1,
		inherits = {
			"bolter_alternate_fire_medium",
			"still",
		},
	},
	[weapon_movement_states.crouch_still] = {
		inherits = {
			"bolter_alternate_fire_medium",
			"still",
		},
	},
	[weapon_movement_states.crouch_moving] = {
		inherits = {
			"bolter_alternate_fire_medium",
			"still",
		},
	},
}
recoil_templates.shotgun_alternate_fire_medium = {
	still = {
		camera_recoil_percentage = 0.25,
		new_influence_percent = 0.65,
		rise_duration = 0.05,
		rise = {
			0.01,
		},
		decay = {
			idle = 4.25,
			shooting = 1.25,
		},
		offset_range = {
			{
				pitch = {
					0.5,
					0.75,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
		},
		offset_limit = {
			pitch = 50,
			yaw = 50,
		},
		visual_recoil_settings = {
			intensity = 5,
			lerp_scalar = 2,
		},
	},
	moving = {
		new_influence_percent = 1,
		inherits = {
			"bolter_alternate_fire_medium",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"bolter_alternate_fire_medium",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"bolter_alternate_fire_medium",
			"still",
		},
	},
}
recoil_templates.boltpistol_alternate_fire_medium = {
	[weapon_movement_states.still] = {
		camera_recoil_percentage = 0.4,
		new_influence_percent = 0.65,
		rise_duration = 0.05,
		rise = {
			0.5,
		},
		decay = {
			idle = 1.8,
			shooting = 0.25,
		},
		offset_range = {
			{
				pitch = {
					0.25,
					0.3,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.125,
					0.15,
				},
				yaw = {
					-0.01,
					0.03,
				},
			},
			{
				pitch = {
					0.125,
					0.15,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.1,
					0.15,
				},
				yaw = {
					-0.03,
					0.03,
				},
			},
		},
		offset_limit = {
			pitch = 50,
			yaw = 50,
		},
		visual_recoil_settings = {
			intensity = 10,
			lerp_scalar = 1,
		},
	},
	[weapon_movement_states.moving] = {
		new_influence_percent = 1,
		inherits = {
			"boltpistol_alternate_fire_medium",
			"still",
		},
	},
	[weapon_movement_states.crouch_still] = {
		inherits = {
			"boltpistol_alternate_fire_medium",
			"still",
		},
	},
	[weapon_movement_states.crouch_moving] = {
		inherits = {
			"boltpistol_alternate_fire_medium",
			"still",
		},
	},
}
recoil_templates.shotgun_alternate_fire_medium = {
	still = {
		camera_recoil_percentage = 0.25,
		new_influence_percent = 0.65,
		rise_duration = 0.05,
		rise = {
			0.01,
		},
		decay = {
			idle = 4.25,
			shooting = 1.25,
		},
		offset_range = {
			{
				pitch = {
					0.5,
					0.75,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
		},
		offset_limit = {
			pitch = 50,
			yaw = 50,
		},
		visual_recoil_settings = {
			intensity = 5,
			lerp_scalar = 2,
		},
	},
	moving = {
		new_influence_percent = 1,
		inherits = {
			"boltpistol_alternate_fire_medium",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"boltpistol_alternate_fire_medium",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"boltpistol_alternate_fire_medium",
			"still",
		},
	},
}
recoil_templates.plasma_rifle = {
	[weapon_movement_states.still] = {
		new_influence_percent = 0.25,
		rise_duration = 0.15,
		rise = {
			0.5,
		},
		decay = {
			idle = 1.5,
			shooting = 0.8,
		},
		offset_range = {
			{
				pitch = {
					0.15,
					0.2,
				},
				yaw = {
					-0.1,
					0.1,
				},
			},
		},
		offset_limit = {
			pitch = 2,
			yaw = 2,
		},
	},
	[weapon_movement_states.moving] = {
		inherits = {
			"plasma_rifle",
			"still",
		},
	},
	[weapon_movement_states.crouch_still] = {
		inherits = {
			"plasma_rifle",
			"still",
		},
	},
	[weapon_movement_states.crouch_moving] = {
		inherits = {
			"plasma_rifle",
			"still",
		},
	},
}
recoil_templates.plasma_rifle_charged = {
	[weapon_movement_states.still] = {
		new_influence_percent = 0.75,
		rise_duration = 0.15,
		rise = {
			0.75,
		},
		decay = {
			idle = 1.5,
			shooting = 0.5,
		},
		offset_range = {
			{
				pitch = {
					0.25,
					0.3,
				},
				yaw = {
					-0.1,
					0.1,
				},
			},
		},
		offset_limit = {
			pitch = 3,
			yaw = 3,
		},
	},
	[weapon_movement_states.moving] = {
		inherits = {
			"plasma_rifle_charged",
			"still",
		},
	},
	[weapon_movement_states.crouch_still] = {
		inherits = {
			"plasma_rifle_charged",
			"still",
		},
	},
	[weapon_movement_states.crouch_moving] = {
		inherits = {
			"plasma_rifle_charged",
			"still",
		},
	},
}
recoil_templates.lasgun_aim_auto = {
	[weapon_movement_states.still] = {
		new_influence_percent = 0.2,
		rise_duration = 0.05,
		rise = {
			0.075,
			0.065,
			0.05,
			0.035,
			0.03,
			0.025,
		},
		decay = {
			idle = 2,
			shooting = 0.5,
		},
		offset_range = {
			{
				pitch = {
					0.1,
					0.1,
				},
				yaw = {
					-0.05,
					0.05,
				},
			},
			{
				pitch = {
					0.1,
					0.15,
				},
				yaw = {
					-0.05,
					0.065,
				},
			},
			{
				pitch = {
					0.1,
					0.25,
				},
				yaw = {
					-0.05,
					0.075,
				},
			},
			{
				pitch = {
					0.1,
					0.25,
				},
				yaw = {
					-0.05,
					0.1,
				},
			},
		},
		offset_limit = {
			pitch = 0.35,
			yaw = 0.25,
		},
	},
	[weapon_movement_states.moving] = {
		inherits = {
			"lasgun_aim_auto",
			"still",
		},
	},
	[weapon_movement_states.crouch_still] = {
		inherits = {
			"lasgun_aim_auto",
			"still",
		},
	},
	[weapon_movement_states.crouch_moving] = {
		inherits = {
			"lasgun_aim_auto",
			"still",
		},
	},
}
recoil_templates.boltgun_hip_spray_n_pray = {
	[weapon_movement_states.still] = {
		camera_recoil_percentage = 0.8,
		decay_grace = 0.1,
		new_influence_percent = 0.5,
		rise_duration = 0.05,
		rise = {
			0.5,
			0.35,
			0.3,
		},
		decay = {
			idle = 2.75,
			shooting = 2.25,
		},
		offset_range = {
			{
				pitch = {
					0.15,
					0.175,
				},
				yaw = {
					-0.01,
					0.01,
				},
			},
			{
				pitch = {
					0.11,
					0.125,
				},
				yaw = {
					-0.0125,
					0.0125,
				},
			},
			{
				pitch = {
					0.1,
					0.1,
				},
				yaw = {
					-0.015,
					0.015,
				},
			},
		},
		offset_limit = {
			pitch = 2,
			yaw = 2,
		},
		visual_recoil_settings = {
			intensity = 10,
			lerp_scalar = 0.1,
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness,
		},
	},
	[weapon_movement_states.moving] = {
		new_influence_percent = 0.75,
		inherits = {
			"boltgun_hip_spray_n_pray",
			"still",
		},
	},
	[weapon_movement_states.crouch_still] = {
		new_influence_percent = 0.5,
		inherits = {
			"boltgun_hip_spray_n_pray",
			"still",
		},
	},
	[weapon_movement_states.crouch_moving] = {
		new_influence_percent = 0.75,
		inherits = {
			"boltgun_hip_spray_n_pray",
			"still",
		},
	},
}

for name, template in pairs(recoil_templates) do
	for _, movement_state in pairs(weapon_movement_states) do
		local move_state_settings = template[movement_state]
		local inheritance_settings = move_state_settings.inherits

		if inheritance_settings then
			local new_move_state_settings = table.clone(recoil_templates[inheritance_settings[1]][inheritance_settings[2]])

			for key, override_data in pairs(move_state_settings) do
				new_move_state_settings[key] = override_data
			end

			new_move_state_settings.inherits = nil
			recoil_templates[name][movement_state] = new_move_state_settings
			move_state_settings = template[movement_state]
		end

		move_state_settings.num_rises = #move_state_settings.rise

		if move_state_settings.offset_range then
			move_state_settings.num_offset_ranges = #move_state_settings.offset_range
		else
			local num_offset_ranges = #move_state_settings.offset

			move_state_settings.num_offset_ranges = num_offset_ranges

			local offset_random_range = move_state_settings.offset_random_range

			for i = 1, num_offset_ranges do
				if not offset_random_range[i] then
					offset_random_range[i] = {
						pitch = 0,
						yaw = 0,
					}
				end
			end
		end
	end
end

return settings("RecoilTemplates", recoil_templates)
