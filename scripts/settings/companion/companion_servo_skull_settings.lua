-- chunkname: @scripts/settings/companion/companion_servo_skull_settings.lua

local CompanionServoSkullMovementSettings = require("scripts/settings/companion/companion_servo_skull_movement_settings")
local CompanionServoSkullHubMovementSettings = require("scripts/settings/companion/companion_servo_skull_hub_movement_settings")
local TWO_PI = math.pi * 2
local companion_servo_skull_settings = {}

companion_servo_skull_settings.STATES = table.index_lookup_table("following", "following_shooting", "following_shooting_ability", "hacking", "inject_ally", "flamethrower", "flamethrower_shooting")
companion_servo_skull_settings.MOVEMENT_STATE = table.enum("in_combat", "out_of_combat", "rest")
companion_servo_skull_settings.FLAMETHROWER_TYPES = table.index_lookup_table("circle", "cone")
companion_servo_skull_settings.z_randomize_movement_cone_flamethrower_xy = {
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
companion_servo_skull_settings.z_randomize_movement_cone_flamethrower_z = {
	base_amp = {
		0.04,
		0.06,
	},
	base_freq = {
		0.15,
		0.3,
	},
	noise_amp = {
		0.015,
		0.04,
	},
	noise_freq = {
		0.05,
		0.1,
	},
	phase = {
		0,
		TWO_PI,
	},
}
companion_servo_skull_settings.collision_radius = {
	cast_radius = 0.35,
	near_radius = 0.25,
}
companion_servo_skull_settings.ability_charges = {
	flamethrower = 1,
	hacking = 0,
	inject_ally = 1,
}
companion_servo_skull_settings.rotation_speed = 3
companion_servo_skull_settings.max_target_distance_range = 25
companion_servo_skull_settings.initial_target_disable_cooldown = 1
companion_servo_skull_settings.buffs = {
	base_order_ability_buff_name = "cryptic_servo_skull_temporary_buff",
	base_order_ability_buff_name_player_dummy = "cryptic_servo_skull_temporary_buff_player_dummy",
	permanent_ability_buff_name = "cryptic_servo_skull_permanent_buff",
	shooting_tagging_buff_name = "cryptic_servo_skull_tagging_buff",
}
companion_servo_skull_settings.moving_template_name = "companion_servo_skull_moving_effect"
companion_servo_skull_settings.empowered_template_name = "companion_servo_skull_empowered_effect"
companion_servo_skull_settings.hacking_minigame_duration = {
	balance = 45,
	decode_search = 15,
	decode_symbols = 15,
	default = 15,
	drill = 15,
	frequency = 15,
}
companion_servo_skull_settings.distance_threshold_sq = {
	flamethrower = 0.01,
	flamethrower_shooting = 0.01,
	hacking = 0.01,
	inject_ally = 1.5,
}
companion_servo_skull_settings.in_combat_timeout = 1
companion_servo_skull_settings.movement_settings = CompanionServoSkullMovementSettings.movement_settings
companion_servo_skull_settings.hub_movement_settings = CompanionServoSkullHubMovementSettings.movement_settings

return settings("CompanionServoSkullSettings", companion_servo_skull_settings)
